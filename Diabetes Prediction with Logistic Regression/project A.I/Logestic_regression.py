import math 
import numpy as np 
import random

# X = np.array([[0,0],[0,0.1],[0.1,0],[0.5,0.5],[0.5,0.45],[0.45,0.5]])
# Y = np.array([0,0,0,1,1,1])
def give_test() :
    X = []
    Y = []
    for i in range(1000) :
        X .append([random.randint(20,60) / 100 , random.randint(10,99) / 100])
        Y .append(0)
        
    for i in range(1000) :
        X .append([random.randint(50,80)/100, random.randint(10,99) / 100])
        Y .append(1)

    return (X , Y) 



def min_find_gradient (gradient , teta0 = None ,step0 = 1e1 ,epsilon = 1e-5 , Mt = 1e+3) :
    
    #if teta0 == None :
        #teta0 = 
    
    teta = teta0
    old_teta = teta
    
    old_gra = gradient ( teta )
    t = 0
    while True :
        t += 1
        
        gra = gradient ( teta )
        #if any ( (old_gra > epsilon) != (gra > epsilon) ) :
        #    teta = old_teta
        #    step = step / 10
        #    old_teta = teta
        #    continue
        step = step0 / (t)
        print(t , end = '                          \r')
        if all(abs(gra) < epsilon) or t > Mt :
            break
        teta = teta - gra*step
        old_gra = gra
        old_teta = teta

    return teta


def Logestic_regression(X,Y,fields) :

    X = np.array(X)
    Y = np.array(Y)
    
    g = lambda z : 1 / (1 + math.exp(-z) )

    h = lambda teta,x : g( sum(teta * np.insert(x,0,1)) )  

    gradient = lambda teta : (
        sum([np.insert(X[i],0,1)*(h(teta,X[i])-Y[i]) / len(X)
                       for i in range(len(X)) ]))

    new_teta = min_find_gradient(gradient,teta0 = np.array((len(X[0]) + 1 )*[0]))
    print()
    for i in range (len(fields)):
        print(fields[i], ":", new_teta[i+1])

    logestic = lambda x : 1 / (1 + math.exp(-sum( new_teta* np.insert(x,0,1) ) ))
    diagnose = lambda x : ( lambda a : 1 if a >= 0.5 else 0) (logestic(np.array(x)))


    # for i in range(-2,3) :
    #     for j in range(-10,11) :
    #         print (i,j,sum( new_teta* np.insert(np.array([i/10,j/10]),0,1) ) , logestic(np.array([i/10,j/10])) , diagnose([i/10,j/10]))

 #   print('start')
 #   print('victory : ' + str(100 * sum([diagnose(X[i]) == Y[i] for i in range(len(X)) ])/len(X)) + '%' )
 #   print('end')
    
    return diagnose

#Logestic_regression(*give_test())