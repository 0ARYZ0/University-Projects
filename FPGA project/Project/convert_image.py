from PIL import Image

image = Image.open("2.jpg")

image = image.convert("L")

binary_image = image.point(lambda x: 0 if x < 128 else 255)

binary_array = []

for y in range(64):
    row = []
    for x in range(64):
        pixel_value = binary_image.getpixel((x, y))
        row.append(0 if pixel_value == 255 else 1)
    binary_array.append(row)

with open("data.txt", 'w') as f:
    for row in binary_array:
        f.write(''.join(map(str, row)) + '\n')
