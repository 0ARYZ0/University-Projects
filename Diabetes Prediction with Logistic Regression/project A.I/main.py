from Logestic_regression import *


fields = []
data = {}
i = 1000
with open('diabetes2.csv') as file :
    first = True
    for line in file :
        if first :
            for field in str(line).split(','):
                fields . append(field)
                first = False
        else :
            l = [float(x) for x in str(line).split(',')]
            i += 1
            
            data[i] = {fields[j] : l[j] for j in range(len(fields))}
            

fields.remove('Outcome\n')
# for complete  datas
new_data = { i : data[i] for i in data if 0 not in [data[i][f] for f in fields] }
#for i in new_data:
 #   new_data[i]['Outcome'] = data[i]['Outcome\n']

# data = new_data

metadata = {}

for field in fields :
    L = [data[i][field] for i in new_data]
    metadata [field] = {}
    metadata [field] ['max'] = max(L)
    metadata [field] ['min'] = min(L)
    metadata [field] ['avg'] = sum(L) / len ( L )
    if field == "pregnancies" :
        metadata ["pregnancies"] ['avg'] = 0
    metadata [field] ['size'] = metadata[field]['max'] - metadata[field] ['min']
for i in data:
    for f in fields:
        if data[i][f] == 0:
            data[i][f] = metadata[f]['avg']
        


defaults = { f : metadata[f]['avg'] for f in fields }
normalise = lambda x , f : (x - metadata[f]['min'])/metadata[f]['size']

normal_data = {i : {f:normalise(data[i][f],f) for f in fields} for i in data}


percent = lambda L : ( 100 * (sum(L)/len(L)) )

X = [[normal_data[i][f] for f in fields ] for i in normal_data if i%5 != 0 ]
Y = [data[i]['Outcome\n'] for i in normal_data  if i%5 != 0]
testX = [[normal_data[i][f] for f in fields ] for i in normal_data if i%5 == 0 ]
testY = [data[i]['Outcome\n'] for i in normal_data if i%5 == 0]



# a good work (for every diabete data we 3 of the same data)
new_X = []
new_Y = []
for i in range(len(X)) :
    if Y[i] :
        for _ in range(3) :
            new_X.append(X[i])
            new_Y.append(Y[i])
    else :
            new_X.append(X[i])
            new_Y.append(Y[i])
    
    
    

#print(percent(Y))
#print(percent(testY))


diagnose = Logestic_regression(new_X,new_Y,fields)

def predict(x) :
    for f in fields :
        x[f] = normalise(x[f],f)
        
    x = [x[f] for f in fields]
    return diagnose(x)


d1 = [diagnose(testX[i]) == testY[i] for i in range(len(testX)) ]
d2 = [diagnose(testX[i]) == testY[i] for i in range(len(testX)) if testY[i]]

print("percentage of all the test data: ",percent(d1))
print("percentage of the test data that patient have diabete: ",percent(d2))

