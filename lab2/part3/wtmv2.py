def indent(n = 1):
    return "    " * n

def assign(A, B):
    res = "assign {} \t= {}".format(A, B)
    return res

def generateHA(name, A, B, S, Cout):
    res = "full_adder  {} (.A({}), .B({}), .Cin({}), .S({}), .Cout({}));".format(name, A, B, "1'b0", S, Cout)
    return res

def generateHA_a(name, a):
    res = "full_adder  {} (.A({}), .B({}), .Cin({}), .S({}), .Cout({}));".format(name, a[0], a[1], "1'b0", a[2], a[3])
    return res

def generateFA(name, A, B, Cin, S, Cout):
    res = "full_adder  {} (.A({}), .B({}), .Cin({}), .S({}), .Cout({}));".format(name, A, B, Cin, S, Cout)
    return res

def generateFA_a(name, a):
    res = "full_adder  {} (.A({}), .B({}), .Cin({}), .S({}), .Cout({}));".format(name, a[0], a[1], a[2], a[3], a[4])
    return res

def assigns(params, indent = indent()):
    res = ""
    for i in range(len(params) / 2):
        res += indent + assign(params[2 * i], params[2 * i + 1])

def generateP0() -> str:
    pass


def generateP1() -> str:
    half_adders = [
        # A, B, S, Cout
    ]

    adders = [
        # A, B, Cin, S, Cout
        ("p[0][1]", "p[1][0]", "s0[0]", "c0[0]"),
        ("p[0][2]", "p[1][1]", "p[2][0]", "s0[1]", "c0[1]"),
        ("p[0][3]", "p[1][2]", "p[2][1]", "s0[2]", "c0[2]"),
        ("p[0][4]", "p[1][3]", "p[2][2]", "s0[3]", "c0[3]"),
        ("p[3][1]", "p[4][0]", "s0[4]", "c0[4]"),
        ("p[0][5]", "p[1][4]", "p[2][3]", "s0[5]", "c0[5]"),
        ("p[3][2]", "p[4][1]", "p[5][0]", "s0[6]", "c0[6]"),
        ("p[0][6]", "p[1][5]", "p[2][4]", "s0[7]", "c0[7]"),
        ("p[3][3]", "p[4][2]", "p[5][1]", "s0[8]", "c0[8]"),
        ("p[0][7]", "p[1][6]", "p[2][5]", "s0[9]", "c0[9]"),
        ("p[3][4]", "p[4][3]", "p[5][2]", "s0[10]", "c0[10]"),
        ("p[6][1]", "p[7][0]", "s0[11]", "c0[11]"),
        ("p[1][7]", "p[2][6]", "p[3][5]", "s0[12]", "c0[12]"),
        ("p[4][4]", "p[5][3]", "p[6][2]", "s0[13]", "c0[13]"),
        ("p[2][7]", "p[3][6]", "p[4][5]", "s0[14]", "c0[14]"),
        ("p[5][4]", "p[6][3]", "p[7][2]", "s0[15]", "c0[15]"),
        ("p[3][7]", "p[4][6]", "p[5][5]", "s0[16]", "c0[16]"),
        ("p[6][4]", "p[7][3]", "s0[17]", "c0[17]"),
        ("p[4][7]", "p[5][6]", "p[6][5]", "s0[18]", "c0[18]"),
        ("p[5][7]", "p[6][6]", "p[7][5]", "s0[19]", "c0[19]"),
        ("p[6][7]", "p[7][6]", "s0[20]", "c0[20]"),
    ]

    res = indent() + "// REVIEW stage 0\n"

    for i in range(len(adders)):
        add = adders[i]
        if len(add) == 4:
            res += indent() + generateHA_a("Stage0_HA_{}".format(i), adders[i]) +"\n"
        else:
            res += indent() + generateFA_a("Stage0_FA_{}".format(i), adders[i]) +"\n"
    
    return res


def generateP2() -> str:
    half_adders = [
        # A, B, S, Cout
    ]

    adders = [
        # A, B, Cin, S, Cout
        ("s0[1]", "c0[0]", "s1[0]", "c1[0]"),
        ("s0[2]", "c0[1]", "p[3][0]", "s1[1]", "c1[1]"),
        ("s0[3]", "c0[2]", "s0[4]", "s1[2]", "c1[2]"),
        ("s0[5]", "c0[3]", "c0[4]", "s1[3]", "c1[3]"),
        ("s0[7]", "c0[5]", "c0[6]", "s1[4]", "c1[4]"),
        ("p[6][0]", "s0[8]", "s1[5]", "c1[5]"),
        ("s0[9]", "c0[7]", "c0[8]", "s1[6]", "c1[6]"),
        ("s0[10]", "s0[11]", "s1[7]", "c1[7]"),
        ("s0[12]", "p[7][1]", "s0[13]", "s1[8]", "c1[8]"),
        ("c0[10]", "c0[11]", "c0[9]", "s1[9]", "c1[9]"),
        ("s0[14]", "c0[12]", "c0[13]", "s1[10]", "c1[10]"),
        ("s0[16]", "c0[15]", "c0[14]", "s1[11]", "c1[11]"),
        ("s0[18]", "c0[16]", "c0[17]", "s1[12]", "c1[12]"),
    ]

    res = indent() + "// REVIEW stage 1\n"

    for i in range(len(adders)):
        add = adders[i]
        if len(add) == 4:
            res += indent() + generateHA_a("Stage1_HA_{}".format(i), adders[i]) +"\n"
        else:
            res += indent() + generateFA_a("Stage1_FA_{}".format(i), adders[i]) +"\n"
    
    return res  

def generateP3() -> str:
    adders = [
        # A, B, S, Cout
        ("s1[1]", "c1[0]", "s2[0]", "c2[0]"),
        ("s1[2]", "c1[1]", "s2[1]", "c2[1]"),
        # A, B, Cin, S, Cout
        ("s1[3]", "c1[2]", "s0[6]", "s2[2]", "c2[2]"),
        ("s1[4]", "c1[3]", "s1[5]", "s2[3]", "c2[3]"),
        ("s1[6]", "c1[4]", "c1[5]", "s2[4]", "c2[4]"),
        ("s1[8]", "c1[6]", "c1[7]", "s2[5]", "c2[5]"),
        ("s1[10]", "c1[8]", "c1[9]", "s2[6]", "c2[6]"),
        ("s1[11]", "c1[10]", "s0[17]", "s2[7]", "c2[7]"),
        ("s1[12]", "c1[11]", "p[7][4]", "s2[8]", "c2[8]"),
        ("c1[12]", "s0[19]", "c0[18]", "s2[9]", "c2[9]"),
    ]

    res = indent() + "// REVIEW stage 2\n"

    for i in range(len(adders)):
        add = adders[i]
        if len(add) == 4:
            res += indent() + generateHA_a("Stage2_HA_{}".format(i), adders[i]) +"\n"
        else:
            res += indent() + generateFA_a("Stage2_FA_{}".format(i), adders[i]) +"\n"
    
    return res  


def generateP4() -> str:
    adders = [
        ("s2[1]", "c2[0]", "s3[0]", "c3[0]"),
        ("s2[2]", "c2[1]", "s3[1]", "c3[1]"),
        ("s2[3]", "c2[2]", "s3[2]", "c3[2]"),
        # A, B, Cin, S, Cout
        ("s2[4]", "c2[3]", "s1[7]", "s3[3]", "c3[3]"),
        ("s2[5]", "c2[4]", "s1[9]", "s3[4]", "c3[4]"),
        ("s2[6]", "c2[5]", "s0[15]", "s3[5]", "c3[5]"),
        ("s2[7]", "c2[6]", "s3[6]", "c3[6]"),
        ("s2[8]", "c2[7]", "s3[7]", "c3[7]"),
        ("s2[9]", "c2[8]", "s3[8]", "c3[8]"),
        ("s0[20]", "c0[19]", "c2[9]", "s3[9]", "c3[9]"),
        ("c0[20]", "p[7][7]", "s3[10]", "c3[10]"),
    ]

    res = indent() + "// REVIEW stage 3\n"

    for i in range(len(adders)):
        add = adders[i]
        if len(add) == 4:
            res += indent() + generateHA_a("Stage3_HA_{}".format(i), adders[i]) +"\n"
        else:
            res += indent() + generateFA_a("Stage3_FA_{}".format(i), adders[i]) +"\n"
    
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