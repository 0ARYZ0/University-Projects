file = open("ram.txt",'w')
#output reg[63:0]debug6,
string = ''
for i in range(64):
    string += 'output reg[63:0]debug' + str(i) + ',\n'
#debug1 <= ram[10];
for i in range(64):
    string += 'debug' + str(i) + ' <= ram[' + str(i) + '];\n'
file.write(string)
file.close()
    