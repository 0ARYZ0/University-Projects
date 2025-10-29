import numpy as np
import pandas as pa
from minizinc import Solver, Model, Instance

def change_divisor(divisor):
    temp = open("test1.mzn", 'r')
    lines = temp.readlines()
    lines[1] = "int: N = " + str(divisor) + ';\n'
    temp = open("test1.mzn", 'w')
    temp.writelines(lines)
    temp.close()
    
IXIC = pa.read_csv("IXIC.csv")
GLD = pa.read_csv("GLD.csv")

def prediction(divisor, step, file, monthly = False):
    change_divisor(divisor)
    profit = []
    close_total = file["Close"]
    end = 0
    if monthly:
        end = 1207
    else:
        end = 1230
    for i in range(1090,end,step):
        data = open("data.dzn",'w')
            
        index = [j for j in range(i - divisor, i)]
            
        string = "X ="
        string += str(index)
        string += ';'
        
        data.write(string)
        data.write('\n')
        
        close = file['Close'][i - divisor:i]
        close = close.round(4)
        close = close.tolist()
        
        string = "Y ="
        string += str(close)
        string += ';'
        
        data.write(string)
        data.close()
        
        solver = Solver.lookup("cbc")
        model = Model("./test1.mzn")
        model.add_file("./data.dzn")
        instance = Instance(solver, model)
        result = instance.solve()
        
        diff = ( (i + step) * result["W_slope"] + result["W_intercept"]) / close_total[i]
        diff = round(diff, 4)
        if monthly:
            profit += [diff] * 4
        else:
            profit += [diff]
    if monthly:
        profit += [0] * 4
    return profit

weekly_IXIC_profit = prediction(divisor = 39, step = 7, file = IXIC)
weekly_GLD_profit = prediction(divisor = 800, step = 7, file = GLD)
monthly_IXIC_profit = prediction(divisor = 39, step = 30, file = IXIC, monthly = True)
monthly_GLD_profit = prediction(divisor = 800, step = 30, file = GLD, monthly = True)
monthly_bonds_profit = [1.0054] * 16
monthly_bonds_profit += [0] * 4

data = open("data_final.dzn",'w')

def write_to_dzn(name, the_list):
    string = name + '='
    string += str(the_list)
    string += ';\n'
    data.write(string)

write_to_dzn("stock7", weekly_IXIC_profit)
write_to_dzn("gold7", weekly_GLD_profit)
write_to_dzn("stock30", monthly_IXIC_profit)
write_to_dzn("gold30", monthly_GLD_profit)
write_to_dzn("bonds30", monthly_bonds_profit)

data.close()



close_IXIC = IXIC["Close"]
close_GLD = GLD["Close"]
close_index = 1089

day = 1
money = 50000.0
step_in_choose = 1
until = 140
total_reminder = 0

print("Do you want to give me a custom number of weeks?")
print("1. Yes\n2. No")
choice = int(input())
if choice == 1:
    print("Enter number of weeks(Max is 20): ")
    n = int(input())
    until = n * 7
print("Do you want to give me a custom amount of money?")
print("1. Yes\n2. No")
choice = int(input())
if choice == 1:
    print("Enter amount of money: ")
    money = int(input())

while day < until:
    temp = open("choosing1.mzn", 'r')
    lines = temp.readlines()
    lines[0] = "int: i = " + str(step_in_choose) + ';\n'
    lines[1] = "float: money = " + str(money) + ';\n'
    temp = open("choosing1.mzn", 'w')
    temp.writelines(lines)
    temp.close()
    
    
    solver = Solver.lookup("cbc")
    model = Model("./choosing1.mzn")
    model.add_file("./data_final.dzn")
    instance = Instance(solver, model)
    result = instance.solve()
    print("C17 = ",result["C17"],'|',"C27 = " ,result["C27"],'|',"C33 = " ,result["C33"])
    
    # buy gold or stock this week
    if result["C17"] == 1 or result["C27"] == 1:
        IXIC_amount = money / close_IXIC[close_index]
        GLD_amount = money // close_GLD[close_index]
        reminder = money % close_GLD[close_index]
        close_index += 7
        money = result["C17"] * close_IXIC[close_index] * IXIC_amount  
        money += result["C27"] * close_GLD[close_index] * GLD_amount
        money += result["C27"] * reminder
        if result["C27"] == 1:
            total_reminder += reminder
        print("Money = ", money)
        print()
        day += 7
        step_in_choose += 1

    # check if buying bonds is worth
    else:
        temp = open("choosing2.mzn", 'r')
        lines = temp.readlines()
        lines[0] = "int: i = " + str(step_in_choose) + ';\n'
        lines[1] = "float: money = " + str(money) + ';\n'
        temp = open("choosing2.mzn", 'w')
        temp.writelines(lines)
        temp.close()
        
        solver = Solver.lookup("cbc")
        model = Model("./choosing2.mzn")
        model.add_file("./data_final.dzn")
        instance = Instance(solver, model)
        result = instance.solve()
        # buy bonds
        if result["C33"] == 1:
            money = result["objective"]
            close_index += 28
            day += 28
            step_in_choose += 4
            print("C13 = ",result["C13"],'|',"C23 = " ,result["C23"],'|',"C33 = " ,result["C33"])
            print("Money = ", money)
            print()

        # bonds is not worth
        # check if gold or stock give us profit this week
        else:
            temp = open("choosing3.mzn", 'r')
            lines = temp.readlines()
            lines[0] = "int: i = " + str(step_in_choose) + ';\n'
            lines[1] = "float: money = " + str(money) + ';\n'
            temp = open("choosing3.mzn", 'w')
            temp.writelines(lines)
            temp.close()
            
            solver = Solver.lookup("cbc")
            model = Model("./choosing3.mzn")
            model.add_file("./data_final.dzn")
            instance = Instance(solver, model)
            result = instance.solve()
            print("C17 = ",result["C17"],'|',"C27 = " ,result["C27"])
            
            IXIC_amount = money / close_IXIC[close_index]
            GLD_amount = money // close_GLD[close_index]
            reminder = money % close_GLD[close_index]
            close_index += 7
            money = result["C17"] * close_IXIC[close_index] * IXIC_amount  
            money += result["C27"] * close_GLD[close_index] * GLD_amount
            money += result["C27"] * reminder
            if result["C27"] == 1:
                total_reminder += reminder
            print("Money = ", money)
            print()
            day += 7
            step_in_choose += 1
                
    
print("total money: ", money)