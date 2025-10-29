#Program description: a program that translates assembly language to machine language
#Author: Ahmadreza Yazdani(9932095)
#Creation date: 30/11/2021
#Revision: 3
#Date:  30/12/2021          Modified by: myself

print("Please enter your assembly code:")

#we open a file that is our example
with open('input.txt','r') as file:
    first_list = file.readlines()
    final_list = []
    for characters in first_list:
        final_list.append(characters[:-1])
    for count in range (len(final_list)):
        final_list[count]=final_list[count].replace(","," ").split() ##we turn the input with commas to one without them and turn it to a list by splitting with " ".
    for row in range (len(final_list)):
        for column in range(len(final_list[row])):
            final_list[row][column]=final_list[row][column].lower() #we lower the characters because assembly is not case sensetive
    final_list[-1][-1] += first_list[-1][-1] #the last char was of our file is left so I add it manully
    file.close()



byte_registers = ["al","ah","bl","bh","cl","ch","dl","dh","[al]","[ah]","[bl]","[bh]","[cl]","[ch]","[dl]","[dh]"] #list of 8bit registers with/withour memory
word_registers = ["ax","bx","cx","dx","sp","bp","si","di","[ax]","[bx]","[cx]","[dx]","[sp]","[bp]","[si]","[di]"] #list of 16bit registers with/withour memory
double_registers = ["eax","ebx","ecx","edx","esp","esi","ebp","edi","[eax]","[ebx]","[ecx]","[edx]","[esp]","[esi]","[ebp]","[edi]"] #list of 32bit registers with/withour memory
word_reg_mem_allowed = ["[bx]","[bp]","[si]","[di]"]
word_reg_mem_notallowed = ["[ax]","[cx]","[dx]","[sp]"]
instructions = ["add","and","or","sub"]
#my source for the tables and the values: http://www.c-jump.com/CIS77/CPU/x86/lecture.html
#A dictionary of registers and their values if they come second
second_register_values = {"al":0,"ax":0,"eax":0,"cl":8,"cx":8,"ecx":8,"dl":16,"dx":16,"edx":16,
                   "bl":24,"bx":24,"ebx":24,"ah":32,"sp":32,"esp":32,"ch":40,"bp":40,"ebp":40,
                   "dh":48,"si":48,"esi":48,"bh":56,"di":56,"edi":56}
#A dictionary of registers and their values if they come firs and if we have memory or not
first_register_values = {"al":0,"ax":0,"eax":0,"cl":1,"cx":1,"ecx":1,"dl":2,"dx":2,"edx":2,
                   "bl":3,"bx":3,"ebx":3,"ah":4,"sp":4,"esp":4,"ch":5,"bp":5,"ebp":5,
                   "dh":6,"si":6,"esi":6,"bh":7,"di":7,"edi":7,
                   "[al]":0,"[ax]":0,"[eax]":0,"[cl]":1,"[cx]":1,"[ecx]":1,"[dl]":2,"[dx]":2,"[edx]":2,
                   "[bl]":3,"[bx]":3,"[ebx]":3,"[ah]":4,"[sp]":4,"[esp]":4,"[ch]":5,"[bp]":5,"[ebp]":5,
                   "[dh]":6,"[si]":6,"[esi]":6,"[bh]":7,"[di]":7,"[edi]":7}
#we made this function to find the value of our jumps
def jmp_val (list,string):
    mem = 0
    place = 0
    for row in range (len(list)):
        new_string = string + ":"
        if list[row][0] in instructions or list[row][0] == "jmp":
            place += 2
        if list[row][0] == new_string :
            break
    for row in range (len(list)):
        if list[row][0] in instructions or list[row][0] == "jmp":
            mem += 2
            if list[row][1] == string:
                break
    res = place - mem
    if res<0: #if we have a backward jump we should return the 2's complement of it
        res = res * (-1)
        res = 256 - res
    res = hex(res)
    res = res[2:]
    res = r"\x" + res
    return res


#Our fuction which do the main work
def to_machine (list):
    final_res = ""
    for row in range(len(list)):
        opcode = ""
        #every possible opcode for "add" function and the size of the registers and if have memory or not
        for count in range(1):
            if list[row][0] == "add":
                for couunt in range(1):
                    if list[row][1] in byte_registers:
                        opcode = r"\x00"
                        if list[row][2][0] == "[":
                            opcode = r"\x02"
                for couunt in range(1):
                    if list[row][1] in word_registers:
                        opcode = r"\x66\x01"
                        if list[row][2][0] == "[":
                            opcode = r"\x66\x03"
                for couunt in range(1):
                    if list[row][1] in double_registers:
                        opcode = r"\x01"
                        if list[row][2][0] == "[":
                            opcode = r"\x03"
        #every possible opcode for "sub" function and the size of the registers and if have memory or not
        for count in range(1):
            if list[row][0] == "sub":
                for couunt in range(1):
                    if list[row][1] in byte_registers:
                        opcode = r"\x28"
                        if list[row][2][0] == "[":
                            opcode = r"\x2A"
                for couunt in range(1):
                    if list[row][1] in word_registers:
                        opcode = r"\x66\x29"
                        if list[row][2][0] == "[":
                            opcode = r"\x66\x2B"
                for couunt in range(1):
                    if list[row][1] in double_registers:
                        opcode = r"\x29"
                        if list[row][2][0] == "[":
                            opcode = r"\x2B"
        #every possible opcode for "or" function and the size of the registers and if have memory or not
        for count in range(1):
            if list[row][0] == "or":
                for couunt in range(1):
                    if list[row][1] in byte_registers:
                        opcode = r"\x08"
                        if list[row][2][0] == "[":
                            opcode = r"\x0A"
                for couunt in range(1):
                    if list[row][1] in word_registers:
                        opcode = r"\x66\x09"
                        if list[row][2][0] == "[":
                            opcode = r"\x66\x0B"
                for couunt in range(1):
                    if list[1] in double_registers:
                        opcode = r"\x09"
                        if list[row][2][0] == "[":
                            opcode = r"\x0B"
        #every possible opcode for "and" function and the size of the registers and if have memory or not
        for count in range(1):
            if list[row][0] == "and":
                for couunt in range(1):
                    if list[row][1] in byte_registers:
                        opcode = r"\x20"
                        if list[row][2][0] == "[":
                            opcode = r"\x22"
                for couunt in range(1):
                    if list[row][1] in word_registers:
                        opcode = r"\x66\x21"
                        if list[row][2][0] == "[" :
                            opcode = r"\x66\x23"
                for couunt in range(1):
                    if list[row][1] in double_registers:
                        opcode = r"\x21"
                        if list[row][2][0] == "[":
                            opcode = r"\x23"
        # now we check the jumps
        val = ""
        for count in range(1):
            if list[row][0] == 'jmp':
                opcode = r"\xeb"
                label = list[row][1] 
                val = jmp_val(list,label)
                
        second_field=""
        mod = 192 #if we don't use memory this will be our mod
        if list[row][0] in instructions:
            if list[row][1][0] == "[" or list[row][2][0] == "[":
                mod = 0 #if we use memory this will be our mod
            #the second part of the machine code which is a 8 bit number but i calculated each part separately
            #we check if and which part we use as our memory.
            if list[row][1][0] == "[":
                second_field = hex(mod + first_register_values.get(list[row][1]) + second_register_values.get(list[row][2]))
            elif list[row][2][0] == "[":
                second_field = hex(mod + first_register_values.get(list[row][2]) + second_register_values.get(list[row][1]))
            else:
                second_field = hex(mod + first_register_values.get(list[row][1]) + second_register_values.get(list[row][2]))
        second_field = second_field[2:] #The hex function give an unneeded 0x which we don't need
        special=""
        if list[row][0] in instructions:
            special = r"\x" #We can only use "\" seperately when we put r or R at the start of string because "\" is special
        second_part =  special +  second_field
        final_res += opcode + second_part + val # we join the opcode and the second part to make the final result
                                                #val is for when we have jumps
    return final_res
        
        

print("The Assembled code is:")
#we check if our register are of the same sizes
for row in range(len(final_list)):
    if final_list[row][0] in instructions:
        if final_list[row][1] in byte_registers and final_list[row][2] in byte_registers: 
            print(to_machine(final_list))
            break
        elif final_list[row][1] in word_registers and final_list[row][2] in word_registers:
            print(to_machine(final_list))
            break
        elif final_list[row][1] in double_registers and final_list[row][2] in double_registers:
            print(to_machine(final_list))
            break
        else:
            print("Your register sizes are different")
            break

