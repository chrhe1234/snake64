#!/bin/python3
from PIL import Image

filename = "spider3.png"

def png2sprite(filename):
    print("Processing " + filename)
    img = Image.open(filename)
    if img.mode != "P":
        raise ValueError(f"Image must be palette-indexed (mode P), got {img.mode}")
    if img.size != (24, 21):
        raise ValueError(f"Image must be 24x21 pixels, got {img.size}")
    sprite = []
    for y in range(21):
        for byte_x in range(3):
            value = 0
            for bit in range(8):
                x = byte_x * 8 + bit
                index = img.getpixel((x, y))
                if index > 0:
                    value |= 1 << (7 - bit)
            sprite.append(value)
    sprite.append(0x00)
    output = "\t// " + filename + "\n\t{" + ", ".join(f"0x{b:02X}" for b in sprite) + "}"
    return output

spriteN = 0
with open("sprites.c", "w") as f:
    # write header
    f.write("#include ""sprites.h""\n\n")
    f.write("#pragma data(sprites)\n\n")
    f.write("__export volatile uint8_t sprite_data[16][64] = {\n");

    # write sprites
    f.write(png2sprite("spider1.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("spider2.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("spider3.png") + ",\n\n");
    spriteN += 1

    for n in range(spriteN, 16):
        f.write("\t{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}")
        if n != 15:
            f.write(",")
        f.write("\n")

    f.write("};\n");
    f.write("#pragma data(data)\n");