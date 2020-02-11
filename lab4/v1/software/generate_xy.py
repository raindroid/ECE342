from math import *
# this sript is used to generate the sin and cos table for part 5

def generate_int_table(formula, name, size, line_range=20):
    res = "static const int {}[{}] = {}\n".format(name, size, '{')

    for i in range(int(size / line_range)):
        res += '    [{}] \t= '.format(i * line_range)
        for j in range(i * line_range, (i + 1) * line_range):
            res += "{:3}, ".format(formula(j))
        res += '\n'
    
    res += "};\n"
    return res

if __name__ == "__main__":
    print(generate_int_table(lambda x:int(20*cos(radians(x))+168), "P5_X", 360))
    print(generate_int_table(lambda y:int(20*sin(radians(y))+105), "P5_Y", 360))
    # for i in range(40):
    #     print(int(20*sin(radians(i*0.5))+105))