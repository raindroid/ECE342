def indent(n = 1):
    return "    " * n

def assign(A, B):
    res = "assign {} \t= {}".format(A, B)
    return res

def generateHA(name, A, B, S, Cout):
    res = "full_adder  {} (.A({}), .B({}), .Cin({}), .S({}), .Cout({}));".format(name, A, B, "1'b0", S, Cout)
    return res


def generateFA(name, A, B, Cin, S, Cout):
    res = "full_adder  {} (.A({}), .B({}), .Cin({}), .S({}), .Cout({}));".format(name, A, B, Cin, S, Cout)
    return res


def assigns(params, indent = indent()):
    res = ""
    for i in range(len(params) / 2):
        res += indent + assign(params[2 * i], params[2 * i + 1])

def generateP0() -> str:
    res = indent() + "// NOTE generated p0 (code by wtm.py)\n"

    for i in range(8):
        for j in range(8):
            res += indent() + "assign p0[{0}][{1}] \t= i_m[{0}] & i_q[{2}];\n".format(i, i+j, j)
    return res


def generateP1() -> str:
    res = indent() + "// REVIEW stage 1 generated p1 (code by wtm.py)\n"

    res += indent() + "// NOTE no adder involved\n"
    res += indent() + "assign p1[0][0] = p0[0][0];\t// p1_0_0\n"
    res += indent() + "assign p1[0][9] = p0[2][9];\t// p1_0_9\n"
    res += indent() + "assign p1[2][3] = p0[3][3];\t// p1_2_3\n"
    res += indent() + "assign p1[2][12] = p0[5][12];\t// p1_2_12\n"
    res += indent() + "assign p1[4][13:6] = p0[6][13:6];\t// p1 row 4\n"
    res += indent() + "assign p1[5][14:7] = p0[7][14:7];\t// p1 row 5\n"

    res += indent() + "// NOTE 4 HAs\n"
    res += indent() + generateHA("ha_stage1_0", "p0[0][1]", "p0[1][1]", "p1[0][1]", "p1[1][2]") + "\n"
    res += indent() + generateHA("ha_stage1_1", "p0[1][8]", "p0[2][8]", "p1[0][8]", "p1[1][9]") + "\n"
    res += indent() + generateHA("ha_stage1_2", "p0[3][4]", "p0[4][4]", "p1[2][4]", "p1[3][5]") + "\n"
    res += indent() + generateHA("ha_stage1_3", "p0[4][11]", "p0[5][11]", "p1[2][11]", "p1[3][12]") + "\n"

    res += indent() + "// NOTE 12 FAs\n"
    for i in range(2, 8):
        res += indent() + generateFA("fa_stage1_{}".format(i-2), 
                                    "p0[0][{}]".format(i), 
                                    "p0[1][{}]".format(i), 
                                    "p0[2][{}]".format(i), 
                                    "p1[0][{}]".format(i), 
                                    "p1[1][{}]".format(i+1)) + "\n"
    for i in range(5, 11):
        res += indent() + generateFA("fa_stage1_{}".format(i+1), 
                                    "p0[3][{}]".format(i), 
                                    "p0[4][{}]".format(i), 
                                    "p0[5][{}]".format(i), 
                                    "p1[2][{}]".format(i), 
                                    "p1[3][{}]".format(i+1)) + "\n"
    return res    


def generateP2() -> str:
    res = indent() + "// REVIEW stage 1 generated p1 (code by wtm.py)\n"

    res += indent() + "// NOTE no adder involved\n"
    res += indent() + "assign p2[0][1:0] = p1[0][1:0];\n"
    res += indent() + "assign p2[1][12:11] = p1[2][12:11];\n"
    res += indent() + "assign p2[0][10] = p1[2][10];\n"
    res += indent() + "assign p2[2][5] = p1[3][5];\n"
    res += indent() + "assign p2[2][14] = p1[5][14];\n"

    res += indent() + "// NOTE 3 HAs\n"
    res += indent() + generateHA("ha_stage2_0", "p1[0][2]", "p1[1][2]", "p2[0][2]", "p2[1][3]") + "\n"
    res += indent() + generateHA("ha_stage2_1", "p1[3][6]", "p1[4][6]", "p2[2][6]", "p2[3][7]") + "\n"
    res += indent() + generateHA("ha_stage2_2", "p1[4][13]", "p1[5][13]", "p2[2][13]", "p2[3][14]") + "\n"

    res += indent() + "// NOTE 13 FAs\n"
    for i in range(3, 10):
        res += indent() + generateFA("fa_stage2_{}".format(i-3), 
                                    "p1[0][{}]".format(i), 
                                    "p1[1][{}]".format(i), 
                                    "p1[2][{}]".format(i), 
                                    "p2[0][{}]".format(i), 
                                    "p2[1][{}]".format(i+1)) + "\n"
    for i in range(7, 13):
        res += indent() + generateFA("fa_stage2_{}".format(i), 
                                    "p1[3][{}]".format(i), 
                                    "p1[4][{}]".format(i), 
                                    "p1[5][{}]".format(i), 
                                    "p2[2][{}]".format(i), 
                                    "p2[3][{}]".format(i+1)) + "\n"
    return res    

def generateP3() -> str:
    res = indent() + "// REVIEW stage 3 generated p3 (code by wtm.py)\n"

    res += indent() + "// NOTE no adder involved\n"
    res += indent() + "assign p3[0][2:0] = p2[0][2:0];\n"
    res += indent() + "assign p3[0][13] = p2[2][13];\n"
    res += indent() + "assign p3[1][14] = p2[2][14];\n"
    res += indent() + "assign p3[2][14:7] = p2[3][14:7];\n"

    res += indent() + "// NOTE 4 HAs\n"
    res += indent() + generateHA("ha_stage3_0", "p2[0][3]", "p2[1][3]", "p3[0][3]", "p3[1][4]") + "\n"
    res += indent() + generateHA("ha_stage3_1", "p2[0][4]", "p2[1][4]", "p3[0][4]", "p3[1][5]") + "\n"
    res += indent() + generateHA("ha_stage3_2", "p2[1][11]", "p2[2][11]", "p3[0][11]", "p3[1][12]") + "\n"
    res += indent() + generateHA("ha_stage3_3", "p2[1][12]", "p2[2][12]", "p3[0][12]", "p3[1][13]") + "\n"

    res += indent() + "// NOTE 6 FAs\n"
    for i in range(5, 11):
        res += indent() + generateFA("fa_stage3_{}".format(i-5), 
                                    "p2[0][{}]".format(i), 
                                    "p2[1][{}]".format(i), 
                                    "p2[2][{}]".format(i), 
                                    "p3[0][{}]".format(i), 
                                    "p3[1][{}]".format(i+1)) + "\n"
    return res  


def generateP4() -> str:
    res = indent() + "// REVIEW stage 4 generated p4 (code by wtm.py)\n"

    res += indent() + "// NOTE no adder involved\n"
    res += indent() + "assign p4[0][3:0] = p3[0][3:0];\n"

    res += indent() + "// NOTE 4 HAs\n"
    for i in range(4, 7):
        res += indent() + generateHA("ha_stage4_{}".format(i-4), 
                                    "p3[0][{}]".format(i), 
                                    "p3[1][{}]".format(i), 
                                    "p4[0][{}]".format(i), 
                                    "p4[1][{}]".format(i+1)) + "\n"
    res += indent() + generateHA("ha_stage4_3", "p3[1][14]", "p3[2][14]", "p4[0][14]", "p4[1][15]") + "\n"

    res += indent() + "// NOTE 6 FAs\n"
    for i in range(7, 14):
        res += indent() + generateFA("fa_stage4_{}".format(i-7), 
                                    "p3[0][{}]".format(i), 
                                    "p3[1][{}]".format(i), 
                                    "p3[2][{}]".format(i), 
                                    "p4[0][{}]".format(i), 
                                    "p4[1][{}]".format(i+1)) + "\n"
    return res  


def cla(bit):
    res = indent() + "// REVIEW generated by WTM.py\n"

    res += indent() + "logic [{}: 0] ai, bi, gi, pi, si;\n".format(bit - 1)
    res += indent() + "logic [{}: 0] ci;\n\n".format(bit)
    res += indent() + "assign ci[0] = Cin;\n"
    res += indent() + "assign Cout = ci[N];\n\n"
    
    res += indent() + "// NOTE connect all gi, pi, si\n"
    for i in range(bit):
        res += indent() + "assign gi[{0}]\t= ai[{0}] & bi[{0}];\n".format(i)
        res += indent() + "assign pi[{0}]\t= ai[{0}] | bi[{0}];\n".format(i)
        res += indent() + "assign si[{0}]\t= ai[{0}] ^ bi[{0}] ^ ci[{0}];\n".format(i)

    res += "\n" + indent() + "// NOTE connect all ci\n"
    clist = ['ci[0]']
    for i in range(bit):
        added = 'pi[{}]'.format(i)
        clist = list(map(lambda g: g + " & " + added, clist)) + ['gi[{}]'.format(i)]
        res += indent() + "assign ci[{}] = ".format(i + 1) + " | ".join(clist) + ";\n"

    return res


if __name__=="__main__":
    # print(generateP0())
    print(generateP1())
    print(generateP2())
    print(generateP3())
    print(generateP4())
    # print(cla(11));