from PIL import Image
def kmeans(the_data,k=3,q=20):
    import random
    ks = []
    for i in range(k):
        ks += [[random.randint(0,255),random.randint(0,255),random.randint(0,255)]]
    kpixels = {}
    for qqq in range(q):
        for i in range(k):
            kpixels[i] = []
        for i in the_data:
            dist = []
            for j in range(k):
                dist += [int(((i[0] - ks[j][0])**2 + (i[1] - ks[j][1])**2 + (i[2] - ks[j][2])**2 )** 0.5)]
            minn = 0
            for a in range(len(dist)):
                if dist[a] < dist[minn]:
                    minn = a
            kpixels[minn] += [i]
        for i in range(k):
            sum0 = 0
            sum1 = 0
            sum2 = 0
            nums = len(kpixels[i])
            for j in range(nums):
                sum0 += kpixels[i][j][0]
                sum1 += kpixels[i][j][1]
                sum2 += kpixels[i][j][2]
            if nums != 0:
                ks[i][0] = sum0 // nums
                ks[i][1] = sum1 // nums
                ks[i][2] = sum2 // nums
    new_data = []
    for i in range(len(the_data)):
        for j in range(k):
            if the_data[i] in kpixels[j]:
                new_data += [tuple(ks[j])]
                break
    return new_data

name = input("enter your image name  ")
colors = int(input("how many colors do you want? "))
img = Image.open(name)
img = img.convert("RGB")
f_data = img.getdata()
the_data = []
for i in f_data:
    the_data += [i]
new_data = kmeans(the_data,colors)
img.putdata(new_data)
img.save("new_image.jpg")
