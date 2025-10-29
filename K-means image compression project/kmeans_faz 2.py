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
                new_data += [ks[j]]
                break
    return new_data
print(kmeans([(5, 232, 160), (230, 206, 147), (237, 108, 129), (149, 114, 20), (192, 197, 122), (184, 14, 191), (92, 118, 181), (82, 173, 98), (239, 162, 26), (17, 116, 135)],3,20))
