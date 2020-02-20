#include <string>
#include <vector>
#include <unordered_map>
#include <map>
#include <iostream>
#include <fstream>
#include <cstdio>
#include <stdexcept>
#include <cstdlib>
#include <cstdint>
#include <cstring>
#include <algorithm>
#include <cassert>
#include <sstream>
#include <cctype>



// Global variables private to this file
namespace
{
	const char* IN_EXTENSION = ".s";
	const char* OUT_EXTENSION_HEX = ".hex";
	const char* OUT_EXTENSION_MIF = ".mif";
	const char* LINE_COMMENT = "//";

	// An address in processor memory
	using Address = uint16_t;
	// Source code line number
	using LineNumber = unsigned;
	// Local labels are non-unique numbers
	using LocalLabel = unsigned;

	// Error types
	using Exception = std::runtime_error;
	
	class LineException : public Exception
	{
	public:
		LineException(LineNumber l, const std::string& what)
			: Exception("line " + std::to_string(l) + ": " + what)
		{
		}
	};
	
	
	// Created for every definition, in the source code, of a local label
	// in the form   .x:  where x is a nonnegative number
	struct LocalLabelDef
	{
		LineNumber line;	// line the definition was made on
		Address addr;		// the address this label refers to
		LocalLabel label;	// a non-unique number
	};
	
	// Created for each global label definition, which are case-sensitive strings
	struct GlobalLabelDef
	{
		LineNumber line;
		Address addr;
	};
	
	// Created every time a local label is referenced
	struct LocalLabelRef
	{
		bool relative;			// absolute, or relative to 'addr'?
		unsigned lsb;			// shift by this many bits before splicing
		enum Dir {FWD, BACK} dir;	// before, or after current line?
		LineNumber line;		// line the reference was made on
		LocalLabel label;		// the local label number itself
		Address addr;			// address in code memory where to splice the label address into
	};
	
	// Created every time a global label is referenced
	struct GlobalLabelRef
	{
		bool relative;			// absolute, or relative to 'addr'?
		unsigned lsb;			// shift by this many bits before splicing
		LineNumber line;
		std::string label;
		Address addr;
	};
	
	
	// Global label definitions, keyed by label name
	std::unordered_map<std::string, GlobalLabelDef> s_global_label_defs;
	
	// Every local label definition
	std::vector<LocalLabelDef> s_local_label_defs;
	
	// Global and local label references
	std::vector<LocalLabelRef> s_local_label_refs;
	std::vector<GlobalLabelRef> s_global_label_refs;
	
	// 64k of memory, arranged as 32k x 16 bits
	// Keep track of highest address too
	uint16_t s_memory[32768];
	Address s_mem_top;
	
	// Holds comments to print out in output file.
	// It's keyed by memory address/
	std::unordered_map<Address, std::string> s_out_comments;
	
	// Parse state
	std::string s_infile_name;
	std::string s_outfile_name_hex;
	std::string s_outfile_name_mif;
	std::string s_preprocessed_file; // holds contents of file, not file name
	LineNumber s_cur_line;
	Address s_cur_addr;
}

// Writes a 16-bit word to memory at byte address 'addr'.
// It better be even!
//
void write_word(Address addr, uint16_t data)
{
	assert( (addr&1) == 0);
	
	s_memory[addr >> 1] = data;
	
	// Update highest address
	s_mem_top = std::max(s_mem_top, addr);
}

uint16_t read_word(Address addr)
{
	assert( (addr&1) == 0);
	return s_memory[addr >> 1];
}

// Parse a string to a 16-bit integer.
// Works on:
// - integer, decimal, octal, with or without negative sign
// - binary with 0b prefix (unsigned only)
// - character literal in single quotes
// If error=true, it will die if the string doesn't match one of
// the above, otherwise false will be returned.
//
//
bool parse_int(const char* str, unsigned str_len, 
	int min, int max, bool error, uint16_t* res_out)
{
	int result = 0;
	char bin_buf[16];
	unsigned char char_buf;
	int end_len = -1;
	
	// Try to get integer, decimal, or octal conversion
	if (sscanf(str, " %i%n", &result, &end_len) == 1
		&& end_len == str_len)
	{
		// Got it
	}
	else if (sscanf(str, " 0%*1[bB]%[01]%n", bin_buf, &end_len) == 1
		&& end_len == str_len)
	{
		// Binary
		for (const char* c = bin_buf; *c; c++)
		{
			result = result*2 + ((*c=='1')? 1 : 0);
		}
	}
	else if (sscanf(str, " '%c'%n", &char_buf, &end_len) == 1
		&& end_len == str_len)
	{
		// Character constant
		result = (int)char_buf;
	}
	else if (error)
	{
		throw LineException(s_cur_line, ": invalid constant " +
			std::string(str, str_len));
	}
	else
	{
		return false;
	}
	
	if (result < min || result >= max)
	{
		throw LineException(s_cur_line, "constant out of range [" +
			std::to_string(min) + "," + std::to_string(max) + ")");
	}
	
	*res_out = (uint16_t)result;	
	return true;
}

// Creates a local label definition to the current address
//
void make_local_def(LocalLabel lbl_name)
{
	LocalLabelDef ldef;
	ldef.addr = s_cur_addr;
	ldef.label = lbl_name;
	ldef.line = s_cur_line;
	s_local_label_defs.push_back(ldef);

}

// Creates a global label definition to the current address.
// It needs a label string, and the label string length.
//
void make_global_def(char* label, unsigned label_len)
{
	std:: string s_lbl(label, label_len);
	
	// Check if label has already been defined
	auto it = s_global_label_defs.find(s_lbl);
	if (it != s_global_label_defs.end())
	{
		auto& existing = it->second;
		throw LineException(s_cur_line,
			"label " + s_lbl + 
			" redefinition, previously defined on line " +
			std::to_string(existing.line));
	}
	
	GlobalLabelDef def;
	def.line = s_cur_line;
	def.addr = s_cur_addr;
	
	s_global_label_defs[s_lbl] = def;
}

// Creates a local label reference AT the current address,
// TO the given label number, even if it hasn't been defined yet.
// The reference can be absolute, or relative to the current address.
// Also needs reference direction (fwd or back), and the splice-lsb.
//
void make_local_ref(LocalLabel label, LocalLabelRef::Dir dir, 
	bool relative, unsigned lsb)
{
	LocalLabelRef ref;
	ref.line = s_cur_line;
	ref.addr = s_cur_addr;
	ref.label = label;
	ref.relative = relative;
	ref.lsb = lsb;
	ref.dir = dir;
	
	s_local_label_refs.push_back(ref);
}

// Creates a global label reference AT the current address,
// TO the given label string, even if it hasn't been defined yet.
// The reference can be absolute, or relative to the current address.
//
void make_global_ref(const char* label, unsigned label_len,
	bool relative, unsigned lsb)
{
	GlobalLabelRef ref;
	ref.line = s_cur_line;
	ref.addr = s_cur_addr;
	ref.label = std::string(label, label_len);
	ref.relative = relative;
	ref.lsb = lsb;
	
	s_global_label_refs.push_back(ref);
}

// Takes a token and tries to parse it as a local or global label reference
//
void parse_label_ref(const char* tok, unsigned tok_len, 
	bool relative, unsigned lsb)
{
	// Expects whitespace removed
	LocalLabel local;
	char local_dir_char;
	int end_len = -1;
	
	// Try local ref first:
	// .number plus 'f' or 'b'
	if (sscanf(tok, " .%u%c%n", &local, &local_dir_char, &end_len) == 2
		&& end_len == tok_len)
	{
		local_dir_char = std::tolower(local_dir_char);
		LocalLabelRef::Dir dir;
		
		if (local_dir_char == 'f') 
		{
			dir = LocalLabelRef::FWD;
		}
		else if (local_dir_char == 'b')
		{
			dir = LocalLabelRef::BACK;
		}
		else
		{
			throw LineException(s_cur_line, 
				"bad local label ref direction, expected 'f' or 'b'");
		}
		
		make_local_ref(local, dir, relative, lsb);
	}
	else
	{
		// Treat as a global ref
		make_global_ref(tok, tok_len, relative, lsb);
	}
}

// Parse a .dw directive, from null-terminated string
//
void parse_directive_dw(const char* args)
{
	// Parse a comma-separated list of items,
	// where each one will emit a 16-bit word
	
	while(true)
	{
		int tok_begin = -1;
		int tok_end = -1;
		int tok_next = -1;
		
		sscanf(args, " %n%*[^, \n\t\r]%n,%n", &tok_begin, &tok_end, &tok_next);
		if (tok_end < 0)
			break;
		
		// Non-empty token?
		if (tok_begin != tok_end)
		{
			const char* tok = args+tok_begin;
			unsigned tok_len = tok_end-tok_begin;
			uint16_t val = 0;
			
			bool is_int = parse_int(tok, tok_len, -32768, 65536, false, &val);
			if (!is_int)
			{
				// Parse as a label reference (local or global) that's absolute
				// and needs replacement at LSB 0
				parse_label_ref(tok, tok_len, false, 0);
				
				// Use placeholder value, to be spliced later
				val = 0;
			}
			
			// Emit data
			write_word(s_cur_addr, val);
			s_cur_addr += 2;
		}
		
		// Quit if there's no more tokens, otherwise
		// skip past comma and continue
		if (tok_next == -1)
			break;
		else
			args += tok_next;
	}
}

// Parse a .space directive, from null-terminated string
//
void parse_directive_space(const char* args)
{
	// Argument should be a single even number
	
	int arg;
	if (sscanf(args, " %d ", &arg) != 1)
	{
		throw LineException(s_cur_line, "expected a number for .space directive");
	}
	else if (arg < 0 || (arg & 1) != 0)
	{
		throw LineException(s_cur_line, "need a positive even number for .space directive");
	}
	
	// Emit zeroed-out space in memory
	for (int i = 0; i < arg; i += 2)
	{
		write_word(s_cur_addr, 0);
		s_cur_addr += 2;
	}
}

// Parse a .string directive, from null-terminated string.
// The generated string is null-terminated.
// Each character is padded with zeros to 16 bits.
//
void parse_directive_string(const char* args)
{
	int str_begin = -1;
	int str_end = -1;
	int quot_end = -1;
	
	sscanf(args, " \"%n%*[^\"]%n\"%n", 
		&str_begin, &str_end, &quot_end);
		
	// didn't reach ending quote
	if (quot_end < 0)
	{
		throw LineException(s_cur_line, "expected quoted string");
	}
	
	for (int i = str_begin; i < str_end; i++)
	{
		// zero-pad each character to 16 bits because
		// our processor can't read bytes
		write_word(s_cur_addr, (uint16_t)args[i]);
		s_cur_addr += 2;
	}
	
	// Null-terminate
	write_word(s_cur_addr, 0);
	s_cur_addr += 2;
}

// Main entry point for parsing directives that begin with . (except .equ)
// Needs directive string (and length), and args+length
//
void parse_directive(char* dir, unsigned dir_len, 
	const char* args, unsigned args_len)
{
	// Lowercase the directive name
	for (unsigned i = 0; i < dir_len; i++)
		dir[i] = std::tolower(dir[i]);
	
	// Check which directive
	// NOTE: .equ is handled by the preprocessor and removed
	// from the preprocessed source code. If it shows up here,
	// it will be treated as an error
	if (!memcmp(dir, "org", dir_len))
	{
		// Change the current address cursor
		parse_int(args, args_len, 0, 65536, true, &s_cur_addr);
		if (s_cur_addr & 1)
		{
			throw LineException(s_cur_line, "address must be 16-bit aligned");
		}
	}
	else if (!memcmp(dir, "dw", dir_len))
	{
		// .dw 0x123,'a',SOME_LABEL
		parse_directive_dw(args);
	}
	else if (!memcmp(dir, "string", dir_len))
	{
		// .string "asdffdsa"
		// each char is 16 BITS (upper 8 bits padded with zero)
		parse_directive_string(args);
	}
	else if (!memcmp(dir, "space", dir_len))
	{
		// .space 16
		parse_directive_space(args);
	}
	else
	{
		throw LineException(s_cur_line, "unknown directive: " + 
			std::string(dir));
	}
}

// Try to parse the given null-terminated line as a CPU instruction.
//
void parse_instruction(char* line)
{	
	// All the posible operand types.
	// We separate RX and RY instead of having a generic REG type
	// because this way we can hard-code the bit positions for RX vs RY
	// (they're always the same).
	// 1-operand instructions are going to have 2 operands where
	// the second is OP_NONE
	enum OpType
	{
		OP_NONE,
		OP_RX,
		OP_RY,
		OP_IMM8,
		OP_IMM11
	};
	
	// We'll create a table of instructions
	struct InstrDef
	{
		OpType op[2];
		uint16_t opcode;
	};
	
	static const std::unordered_map<std::string, InstrDef> instr_tab = 
	{
		{ "mv"      , {{ OP_RX    , OP_RY    }  ,   0x00 }},
		{ "add"     , {{ OP_RX    ,	OP_RY    }  ,   0x01 }},
		{ "sub"     , {{ OP_RX    ,	OP_RY    }  ,   0x02 }},
		{ "cmp"     , {{ OP_RX    ,	OP_RY    }  ,   0x03 }},
		{ "ld"      , {{ OP_RX    ,	OP_RY    }  ,   0x04 }},
		{ "st"      , {{ OP_RX    ,	OP_RY    }  ,   0x05 }},
		{ "mvi"     , {{ OP_RX    ,	OP_IMM8  }  ,   0x10 }},
		{ "addi"    , {{ OP_RX    ,	OP_IMM8  }  ,   0x11 }},
		{ "subi"    , {{ OP_RX    ,	OP_IMM8  }  ,   0x12 }},
		{ "cmpi"    , {{ OP_RX    ,	OP_IMM8  }  ,   0x13 }},
		{ "mvhi"    , {{ OP_RX    ,	OP_IMM8  }  ,   0x16 }},
		{ "jr"      , {{ OP_RX    ,	OP_NONE  }  ,   0x08 }},
		{ "jzr"     , {{ OP_RX    ,	OP_NONE  }  ,   0x09 }},
		{ "jnr"     , {{ OP_RX    ,	OP_NONE  }  ,   0x0A }},
		{ "callr"   , {{ OP_RX    ,	OP_NONE  }  ,   0x0C }},
		{ "j"       , {{ OP_IMM11 ,	OP_NONE }  ,   0x18 }},
		{ "jz"      , {{ OP_IMM11 ,	OP_NONE }  ,   0x19 }},
		{ "jn"      , {{ OP_IMM11 ,	OP_NONE }  ,   0x1A }},
		{ "call"    , {{ OP_IMM11 ,	OP_NONE }  ,   0x1C }}
	};
	
	// Extract parts of the instruction
	int instr_begin = -1;
	int instr_end = -1;
	int op_begin[2] = {-1, -1};
	int op_end[2] = {-1, -1};
	
	sscanf(line, " %n%*[^ \n\t\r]%n %n%*[^, \n\t\r]%n , %n%*[^ \n\t\r]%n ",
		&instr_begin, &instr_end, 
		&op_begin[0], &op_end[0], 
		&op_begin[1], &op_end[1]);
		
	bool has_instr = instr_end >= 0 && instr_end > instr_begin;
	bool has_op[2] = 
	{
		op_end[0] >= 0 && op_end[0] > op_begin[0],
		op_end[1] >= 0 && op_end[1] > op_begin[1]
	};

	// Unclear if this ever happens
	if (!has_instr)
	{
		throw LineException(s_cur_line, "expected instruction or directive");
	}
	
	// Lowercase the instruction
	std::string instr_name(line + instr_begin, instr_end - instr_begin);
	std::transform(instr_name.begin(), instr_name.end(), instr_name.begin(), ::tolower);
	
	// Look it up in the table
	auto tab_it = instr_tab.find(instr_name);
	
	if (tab_it == instr_tab.end())
	{
		throw LineException(s_cur_line, "unknown instruction: " + 
			std::string(line));
	}
	
	const InstrDef& instr_def = tab_it->second;
	
	// Start building the instruction word, initialized to the opcode in the LSBs	
	uint16_t instr_word = instr_def.opcode;
	
	// Apply both operands
	for (unsigned op_no = 0; op_no < 2; op_no++)
	{
		OpType op_type = instr_def.op[op_no];
		
		// Make sure we got the # of operands we expected
		if (op_type != OP_NONE && !has_op[op_no])
		{
			throw LineException(s_cur_line, "missing operand #" +
				std::to_string(op_no+1));
		}
		else if (op_type == OP_NONE && has_op[op_no])
		{
			if (has_op[op_no])
				throw LineException(s_cur_line, "too many operands");
			
			// Skip processing this operand
			continue;
		}
		
		// Get operand string
		char* op_str = line + op_begin[op_no];
		unsigned op_len = op_end[op_no] - op_begin[op_no];
		
		// Do work based on operand type
		switch (instr_def.op[op_no])
		{
			case OP_NONE: 
				continue;
				break;
			
			case OP_RX:
			case OP_RY: 
			{
				unsigned reg_no;
				int reg_no_pos = -1;
				sscanf(op_str, "%*[rR]%u%n", &reg_no, &reg_no_pos);
				
				// Make sure it's r# where # is 0-7
				if (reg_no_pos < 0)
				{
					throw LineException(s_cur_line, "expected register for operand #" +
						std::to_string(op_no+1));
				}
				else if (reg_no_pos > 2 || reg_no > 7)
				{
					throw LineException(s_cur_line, 
						"register number outside range 0-7 for operand #" +
						std::to_string(op_no+1));
				}
				
				// Rx starts at bit 5, Ry at bit 8
				unsigned reg_pos = op_type == OP_RX ? 5 : 8;
				
				// Insert into instruction word
				instr_word |= (reg_no << reg_pos);												
				break;
			}
			
			case OP_IMM8:
			case OP_IMM11:
			{
				// A label is a valid argument for an immediate, but if the user
				// uses a label name that looks like a register ("r7"), throw a warning
				// to make sure it's intentional on their part.
				{
					unsigned reg_no;
					int reg_no_pos = -1;
					
					sscanf(op_str, "%*[rR]%u%n", &reg_no, &reg_no_pos);
					if (reg_no_pos != -1)
					{
						printf("Warning: line %u: treating operand %u (%*s) as a label instead of a register\n",
						s_cur_line, op_no, op_len, op_str);
					}
				}
				
				uint16_t imm_val = 0;
				
				// Expected width, min, max of immediate value
				// Also its position in the instruction word
				unsigned imm_lsb = op_type == OP_IMM8? 8 : 5;
				unsigned imm_bits = op_type == OP_IMM8? 8 : 11;
				int imm_lo_bound = -(1 << imm_bits) / 2;
				int imm_hi_bound = 1 << imm_bits;			
				
				// First, try an integer constant
				if (parse_int(op_str, op_len, imm_lo_bound, imm_hi_bound, false, &imm_val))
				{
					// It was a constant. Splice it into the instruction word
					uint16_t mask = (1 << imm_bits) - 1;
					instr_word |= ( (imm_val & mask) << imm_lsb );
				}
				else
				{
					// Not an integer constant? Must be a label.
					// IMM11 are always PC-relative, IMM8 are absolute
					bool is_rel = op_type == OP_IMM11;
					
					// Make the ref, but leave the field as 0 in the instr word
					// right now.
					parse_label_ref(op_str, op_len, is_rel, imm_lsb);
				}
				
				break;
			}
			
			default: 
				// you forgot to update these cases
				assert(false);
				break;
		} // end switch operand type
	} // end foreach operand
	
	// Write the word
	write_word(s_cur_addr, instr_word);
	s_cur_addr += 2;
}

void parse_line(std::string& line)
{
	char* linec = (char*)line.c_str();
	unsigned line_len = line.length();
	
	// Remember the line so we can add it as a comment when writing the output
	s_out_comments[s_cur_addr] = line;
	
	// The while loop lets us re-start parsing from a different
	// part of the same line
	while(true)
	{
		LocalLabel local_lbl;
		int rest_of_line_pos = -1;
		int tok_start = -1;
		int tok_end = -1;

		// Trim whitespace to see if it's an empty line
		while (*linec && std::isspace(*linec))
		{
			linec++;
			line_len--;
		}
		
		if (! *linec)
			break;
	
		
		// There are only a few possibilities of what
		// each line can have:
		
		// Local line definition
		// .<number_label>: <rest of line, to be re-parsed>
		if (sscanf(linec, " .%u : %n ", &local_lbl, &rest_of_line_pos) == 1 &&
			rest_of_line_pos >= 0)
		{
			make_local_def(local_lbl);
			
			// Re-parse the rest of the line
			linec += rest_of_line_pos;
			line_len -= rest_of_line_pos;
			continue;
		}
		// Directive
		// .<non-whitespace> <directive args>
		else if (sscanf(linec, " .%n%*[^ \n\r\t]%n %n",
			&tok_start, &tok_end, &rest_of_line_pos) >= 0 &&
			rest_of_line_pos >= 0)
		{
			parse_directive(linec + tok_start,
				tok_end - tok_start, 
				linec + rest_of_line_pos,
				line_len - rest_of_line_pos);
		}
		// Global label
		// <non-whitespace>: <rest of line, to be re-parsed>
		else if (sscanf(linec, " %n%*[^: \n\r\t]%n : %n",
			&tok_start, &tok_end, &rest_of_line_pos) >= 0 &&
			rest_of_line_pos >= 0)
		{
			make_global_def(linec + tok_start, tok_end-tok_start);
			
			// Re-parse the rest of the line
			linec += rest_of_line_pos;
			line_len -= rest_of_line_pos;
			continue;
		}
		else
		{
			// Treat it as an instruction
			parse_instruction(linec);
		}
		
		break;
	};
}

void parse_file()
{
	// Make a file-like stream out of the giant string that is
	// the preprocessed file
	std::istringstream infile(s_preprocessed_file);
	
	// Initialize current address and line number
	s_cur_addr = 0;
	s_cur_line = 1;
	
	// Read line by line
	for (std::string line; std::getline(infile, line); s_cur_line++)
	{		
		parse_line(line);		
	}
}

void preprocess_and_read()
{
	printf("Reading file %s\n", s_infile_name.c_str());

	// Try opening file
	std::ifstream infile(s_infile_name);
	if (!infile)
		throw Exception("can't open input file");
	
	// Key,value pairs for .equ preprocessor definitions
	std::vector<std::pair<std::string, std::string>> macro_defs;
	
	// Read line by line
	s_cur_line = 0;
	for (std::string line; std::getline(infile, line); s_cur_line++)
	{
		// Strip comments first.
		// A comment chops off the rest of the line
		for (auto commpos = line.find(LINE_COMMENT); commpos != std::string::npos; )
		{
			line.resize(commpos);
			break;
		}
		
		// Remove windows line endings
		if (!line.empty() && line.back() == '\r')
			line.pop_back();
		
		// Apply preprocessor macro replacement
		// This is not the most efficient way, and time grows 
		// linearly with the number of definitions.
		for (auto& def : macro_defs)
		{
			for (size_t pos; (pos = line.find(def.first)) != std::string::npos; )
			{
				line.replace(pos, def.first.size(), def.second);
			}
		}
		
		// Search for new macro definitions
		int key_start = -1;
		int key_end = -1;
		int val_start = -1;
		int val_end = -1;
		
		sscanf(line.c_str(), " .equ %n%*[^ ,\t\n\r]%n , %n%*[^\n\r]%n",
				&key_start, &key_end, &val_start, &val_end);
		
		// Got at least past .equ?
		if (key_start >= 0)
		{
			// Missing key or value?
			if (key_start == key_end || val_start == val_end)
				throw LineException(s_cur_line, "bad macro definition: " + line);
			
			assert(key_start >= 0 && key_end >= 0 && val_start >= 0 && val_end >= 0);		
			
			// Add macro def			
			macro_defs.emplace_back
			(
				line.substr(key_start, key_end-key_start),
				line.substr(val_start, val_end-val_start)
			);
			
			// Replace line with an empty one
			// Don't remove it, or it will mess up line number counts in the real assembler
			line.resize(0);
		}
		
		s_preprocessed_file += line + "\n";
	}
	
	infile.close();
}

void init_memory()
{
	// Zero all of memory
	memset(s_memory, 0, 65536);
	s_mem_top = 0;
}

void splice_label_ref(LineNumber ref_line, uint16_t ref_addr, 
	uint16_t targ_addr, 
	bool relative, unsigned ref_lsb)
{
	// Convert to signed 32 bits until after bounds checking
	int target = targ_addr;
	
	// If it's a relative reference, adjust the target.
	// Since ref are only used for IMM11-based jumps/calls
	// so far, the target needs to be relative to PC+2.
	//
	// ALSO: relative implies imm11, and imm11 is in terms
	// of 16-bit words not bytes. Divide by 2.
	if (relative)
	{
		target -= (int)(ref_addr + 2);
		assert( (target & 1) == 0);
		target /= 2;
	}
	
	// Bounds-check the value, assuming that
	// the splicing will always happen at the end of the word.
	unsigned max_bits = 16 - ref_lsb;
	int min_range = -(1 << max_bits) / 2;
	int max_range = (1 << max_bits) / 2;
	
	if (target < min_range || target >= max_range)
	{
		throw LineException(ref_line, 
			"label reference out of range [" +
			std::to_string(min_range) + "," +
			std::to_string(max_range) + ")");
	}
	
	// Grab the word at the ref site
	uint16_t ref_word = read_word(ref_addr);
	
	// Build the data we want to splice in
	uint16_t in_word = ( (uint16_t)target ) << ref_lsb;
	
	// Do it and writeback
	ref_word |= in_word;
	write_word(ref_addr, ref_word);
}

// After the file is parsed, go through every
// global and local label reference and match it with
// a label definition.
// At each reference site address, splice the label's
// address into the word there.
//
void do_labels()
{
	// Do globals
	for (auto& ref : s_global_label_refs)
	{
		// Find the matching def
		auto def_it = s_global_label_defs.find(ref.label);
		
		// Not found? Throw an error at the ref's line number
		if (def_it == s_global_label_defs.end())
		{
			throw LineException(ref.line, "unknown label: " + ref.label);
		}
		
		auto& def = def_it->second;
		splice_label_ref(ref.line, ref.addr, def.addr, ref.relative, ref.lsb);	
	}
	
	// Do locals
	for (auto& ref : s_local_label_refs)
	{
		LocalLabelDef* found_def = nullptr;
		
		// Search through all the local defs forwards (for backward references)
		// or backwards (for forward references)
		int search_start = 0;
		int search_end = s_local_label_defs.size();
		int search_dir = 1;
		
		if (ref.dir == LocalLabelRef::FWD)
		{
			search_start = s_local_label_defs.size() - 1;
			search_end = -1;
			search_dir = -1;
		}
		
		for (int i = search_start; i != search_end; i += search_dir)
		{
			auto& def = s_local_label_defs[i];
			
			// Are we past the reference line (in the appropriate search direction)?
			// Early exit
			if ( ((int)ref.line - (int)def.line)*search_dir < 0 )
			{
				break;
			}
			else if (def.label == ref.label)
			{
				found_def = &def;								
			}
		}
		
		if (!found_def)
		{
			throw LineException(ref.line, "local label not found: " +
				std::to_string(ref.label));
		}
		else
		{
			splice_label_ref(ref.line, ref.addr, found_def->addr, 
				ref.relative, ref.lsb);
		}
	}
}

void write_output_hex()
{
	printf("Writing file %s\n", s_outfile_name_hex.c_str());
	
	FILE* fp = fopen(s_outfile_name_hex.c_str(), "w");
	if (!fp)
	{
		throw Exception("Error: couldn't open output .hex file");
	}
	
	// Just dump all of memory as 16-bit words,
	// including the source code lines that generated them, as comments
	for (unsigned addr = 0; addr <= s_mem_top; addr+= 2)
	{
		auto comment = s_out_comments[addr];
		
		fprintf(fp, "%.4x\t// %.4x: %s\n", 
			s_memory[addr >> 1], 
			addr,
			comment.c_str()
		);
	}
	
	fclose(fp);
	
	printf("Wrote %u bytes\n", s_mem_top+2);
}

void write_output_mif()
{
	printf("Writing file %s\n", s_outfile_name_mif.c_str());
	
	FILE* fp = fopen(s_outfile_name_mif.c_str(), "w");
	if (!fp)
	{
		throw Exception("Error: couldn't open output .mif file");
	}
	
	// Write the MIF header
	unsigned n_words = (s_mem_top + 2 + 1) / 2;	// round to nearest word
	fprintf(fp,
		"DEPTH = %u;\n"
		"WIDTH = 16;\n"
		"ADDRESS_RADIX = HEX;\n"
		"DATA_RADIX = HEX;\n"
		"CONTENT\n"
		"BEGIN\n",
		n_words
	);
	
	// Dump each word, with address data and comments
	for (unsigned addr = 0; addr <= s_mem_top; addr+= 2)
	{
		auto comment = s_out_comments[addr];
		
		fprintf(fp, "%.4x : %.4x;\t-- %s\n",
			addr >> 1,
			s_memory[addr >> 1],
			comment.c_str()
		);
	}
	
	// Print footer
	fprintf(fp, "END;\n");
	fclose(fp);
	
	printf("Wrote %u words\n", n_words);
}

int main(int argc, char** argv)
{
	// Show usage if insufficient args
	if (argc < 2)
	{
		printf("Usage: %s <input file> [output file]\n",
			argv[0]);
		return 1;
	}

	// Grab input file name
	s_infile_name = argv[1];
	
	// If output file name provided, use it
	if (argc > 2)
	{
		s_outfile_name_hex = argv[2];
	}
	else
	{
		// Otherwise, output file name is input file name
		// with the .s extension (if exists) replaced with .hex
		auto extpos = s_infile_name.rfind(IN_EXTENSION);
		s_outfile_name_hex = s_infile_name.substr(0, extpos);
		s_outfile_name_hex += std::string(OUT_EXTENSION_HEX);
	}
	
	// In either case: calculate the .mif file name from the output .hex file name
	{
		auto extpos = s_outfile_name_hex.rfind(OUT_EXTENSION_HEX);
		s_outfile_name_mif = s_outfile_name_hex.substr(0, extpos);
		s_outfile_name_mif += std::string(OUT_EXTENSION_MIF);
	}
	
	try
	{
		preprocess_and_read();
		init_memory();
		parse_file();
		do_labels();
		write_output_hex();
		write_output_mif();
	}
	catch (std::exception& e)
	{
		printf("Error: %s\n", e.what());
		return 1;
	}
	
	return 0;
}