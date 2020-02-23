#REVIEW helper script

# shortcuts
sel = "SELECT"
en = "en" # set to 1
next_state = "next_state"
type_case = "case"
type_if = "if"

v1_states = {
        "type": type_case,
        "S_T0": {
            next_state: "0_WAIT",
            sel: "sel_PC",
            en: ["RD", "PC_incr"],
        },

        "S_T0_WAIT": {
            next_state: 1
        },
        
        "S_T1": {
            next_state: 2,
            en: "IR_in"
        },
        
        "S_T2": {
            next_state: 3,
            "instruction": {
                "type": type_case,
                "i_mv_": {
                    sel: "IMM_MODE ? sel_i8 : rY",
                    en: "GPR_in[rX & 3'b111]",
                    next_state: 0
                },
                "i_mvhi": {
                    sel: "sel_i8",
                    en: "GPR_hin[rX & 3'b111]",
                    next_state: 0
                },
                "i_add_": {
                    sel: "IMM_MODE ? sel_i8 : rY",
                    en: "A_in"
                },
                "i_sub_": {
                    sel: "IMM_MODE ? sel_i8 : rY",
                    en: "A_in"
                },
                "i_cmp_": {
                    sel: "IMM_MODE ? sel_i8 : rY",
                    en: "A_in"
                },
                "i_ld": {
                    sel: "rY",
                    en: ["RD"]
                },
                "i_st": {
                    sel: "rY",
                    en: []
                },
                "i_jr_": {
                    sel: "IMM_MODE ? sel_i11 : rX",
                    en: "PC_in",
                    "PC_offset": "IMM_MODE",
                    next_state: 0
                },
                "i_jzr_": {
                    sel: "IMM_MODE ? sel_i11 : rX",
                    "PC_in": "(Z_data==1)",
                    "PC_offset": "IMM_MODE",
                    next_state: 0
                },
                "i_jnr_": {
                    sel: "IMM_MODE ? sel_i11 : rX",
                    "PC_in": "(N_data==1)",
                    "PC_offset": "IMM_MODE",
                    next_state: 0
                },
                "i_callr_": {
                    sel: "sel_PC",
                    en: ["GPR_in[7]", "A_in"]
                },
                "default": {
                    next_state: 0
                }
            }
        },
        
        "S_T3": {
            next_state: 4,
            "instruction": {
                "type": type_case,
                "i_add_": {
                    sel: "rX",
                    en: "G_in"
                },
                "i_sub_": {
                    sel: "rX",
                    en: ["G_in", "ADD_SUB"]
                },
                "i_cmp_": {
                    sel: "rX",
                    en: ["G_in", "ADD_SUB"],
                    next_state: 0
                },
                "i_ld": {
                    en: ["// WAIT"]
                },
                "i_st": {
                    sel: "rX",
                    en: ["DOUT_in", "WR"]
                },
                "i_callr_": {
                    sel: "IMM_MODE ? sel_i11 : rX",
                    "PC_offset": "IMM_MODE",
                    en: ["PC_in"],
                    next_state: 0
                }
            }
            
        },
        
        "S_T4": {
            next_state: 0,
            "instruction": {
                "type": type_case,
                "i_add_": {
                    sel: "sel_G",
                    en: "GPR_in[rX & 3'b111]"
                },
                "i_sub_": {
                    sel: "sel_G",
                    en: "GPR_in[rX & 3'b111]"
                },
                "i_ld": {
                    sel: "sel_din",
                    en: "GPR_in[rX & 3'b111]"
                },
                "i_st": {
                    en: "// WAIT"
                }
            }
        },
        
        "S_T5": {
            next_state: 0
        },

        "default": {
            next_state: 0
        }
    }

def generate_cpu_comb():
    
    res = """
    always_comb begin
        next_state = state;
        {GPR_in, GPR_hin, PC_in, PC_incr, A_in, G_in, IR_in, ADDR_in, DOUT_in, RD, WR, ADD_SUB, PC_offset}  = '0;
        
"""

    states = {
        "type": type_case,
        "S_T0": {
            next_state: 1,
            sel: "sel_PC",
            en: ["RD", "PC_incr"],
        },
        
        "S_T1": {
            next_state: 2,
            en: "IR_in"
        },
        
        "S_T2": {
            next_state: 3,
            "instruction": {
                "type": type_case,
                "i_mv_": {
                    sel: "IMM_MODE ? sel_i8 : rY",
                    en: "GPR_in[rX & 3'b111]",
                    next_state: 0
                },
                "i_mvhi": {
                    sel: "sel_i8",
                    en: "GPR_hin[rX & 3'b111]",
                    next_state: 0
                },
                "i_add_": {
                    sel: "IMM_MODE ? sel_i8 : rY",
                    en: "A_in"
                },
                "i_sub_": {
                    sel: "IMM_MODE ? sel_i8 : rY",
                    en: "A_in"
                },
                "i_cmp_": {
                    sel: "IMM_MODE ? sel_i8 : rY",
                    en: "A_in"
                },
                "i_ld": {
                    sel: "rY",
                    en: ["RD"]
                },
                "i_st": {
                    sel: "rX",
                    en: ["DOUT_in"]
                },
                "i_jr_": {
                    sel: "IMM_MODE ? sel_i11 : rX",
                    en: "PC_in",
                    "PC_offset": "IMM_MODE",
                    next_state: 0
                },
                "i_jzr_": {
                    sel: "IMM_MODE ? sel_i11 : rX",
                    "PC_in": "(Z_data==1)",
                    "PC_offset": "IMM_MODE",
                    next_state: 0
                },
                "i_jnr_": {
                    sel: "IMM_MODE ? sel_i11 : rX",
                    "PC_in": "(N_data==1)",
                    "PC_offset": "IMM_MODE",
                    next_state: 0
                },
                "i_callr_": {
                    sel: "sel_PC",
                    en: ["GPR_in[7]", "A_in"]
                },
                "default": {
                    next_state: 0
                }
            }
        },
        
        "S_T3": {
            next_state: 4,
            "instruction": {
                "type": type_case,
                "i_add_": {
                    sel: "rX",
                    en: "G_in"
                },
                "i_sub_": {
                    sel: "rX",
                    en: ["G_in", "ADD_SUB"]
                },
                "i_cmp_": {
                    sel: "rX",
                    en: ["G_in", "ADD_SUB"],
                    next_state: 0
                },
                "i_ld": {
                    next_state: 0,
                    sel: "sel_din",
                    en: ["GPR_in[rX & 3'b111]"]
                },
                "i_st": {
                    next_state: 0,
                    sel: "rY",
                    en: ["WR"]
                },
                "i_callr_": {
                    sel: "IMM_MODE ? sel_i11 : rX",
                    "PC_offset": "IMM_MODE",
                    en: ["PC_in"],
                    next_state: 0
                }
            }
            
        },
        
        "S_T4": {
            next_state: 0,
            "instruction": {
                "type": type_case,
                "i_add_": {
                    sel: "sel_G",
                    en: "GPR_in[rX & 3'b111]"
                },
                "i_sub_": {
                    sel: "sel_G",
                    en: "GPR_in[rX & 3'b111]"
                },
                "i_ld": {
                    sel: "sel_din",
                    en: "GPR_in[rX & 3'b111]"
                },
                "i_st": {
                    en: "// WAIT"
                }
            }
        },
        
        "S_T5": {
            next_state: 0
        },

        "default": {
            next_state: 0
        }
    }

    res += generate_case(contents=states)

    res += "    end\n"
    return res+"\n"

def generate_case(name="state", contents={}, indent_cnt=2, indent="    "):
    res = indent*indent_cnt + "case({})\n".format(name)

    if "type" in contents: del contents["type"]

    indent2 = indent * (indent_cnt + 1)
    indent3 = indent * (indent_cnt + 2)

    for key, value in contents.items():
        res += "{0}{1}: begin // {1}\n".format(indent2, key)

        if not isinstance(value, dict):
            print(value)
            res += generate_code_block(code_block=value)
            
        else:
            for nname, block in value.items():
                if isinstance(block, dict):
                    if not "type" in block:
                        print("WARNING: unknown type code block:\n", block)
                        continue
                    elif block["type"] == type_case:
                        res += generate_case(name=nname, contents=block, indent_cnt=indent_cnt+2)
                    elif block["type"] == type_if:
                        pass
                else:
                    res += generate_code_block(code_block={nname: block}, indent_cnt=indent_cnt+2)

        res += "{0}end\n".format(indent2)

    return res + indent*indent_cnt + "endcase\n"

def generate_code_block(code_block={}, indent_cnt=2, indent="    "):
    res = ""
    select_cnt = 0
    next_cnt = 0
    indent1 = indent * indent_cnt
    for key, value in code_block.items():
        if key == sel:
            select_cnt += 1
            res += indent1 + "SELECT = {};\n".format(value);
        elif key == next_state:
            next_cnt += 1
            res += indent1 + "next_state = S_T{};\n".format(value)
        elif key == en:
            if isinstance(value, str):
                res += indent1 + "{} = 1'b1;\n".format(value)
            else:
                for v in value:
                    res += indent1 + "{} = 1'b1;\n".format(v)
        else:
            res += indent1 + "{} = {};\n".format(key, value)
    
    if select_cnt > 1: print("WARNGIN: multiple selects in:\n {}".format(res))
    if next_cnt > 1: print("WARNGIN: multiple next_states in:\n {}".format(res))
    return res

if __name__=="__main__":
    res = generate_cpu_comb()
    print(res)