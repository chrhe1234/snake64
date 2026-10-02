#!/bin/python3

#
# convert the PNGs below into C64 sprites for oscar64 C code
#

from PIL import Image
import shutil

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

def png2spriteXflip(filename):
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
                    value |= 1 << bit
            sprite.append(value)
        sprite[-3],sprite[-1] = sprite[-1],sprite[-3]
    sprite.append(0x00)
    output = "\t// " + filename + " flipped X\n\t{" + ", ".join(f"0x{b:02X}" for b in sprite) + "}"
    return output

spriteN = 0
with open("sprites.c", "w") as f:
    # write header
    f.write("#include <stdint.h>\n");
    f.write("#include \"sprites.h\"\n\n")
    f.write("#pragma data(sprites)\n\n")
    f.write("__export volatile uint8_t sprite_data[16][64] = {\n");

    # write sprites
    f.write(png2sprite("scorpion1.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("scorpion2.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("scorpion3.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("heart1.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("heart2.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("heart3.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2spriteXflip("scorpion1.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2spriteXflip("scorpion2.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2spriteXflip("scorpion3.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("barrel1.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("barrel2.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("barrel3.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("key1.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("key2.png") + ",\n\n");
    spriteN += 1

    # write sprites
    f.write(png2sprite("key3.png") + ",\n\n");
    spriteN += 1


    for n in range(spriteN, 16):
        f.write("\t{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}")
        if n != 15:
            f.write(",")
        f.write("\n")

    f.write("};\n");
    f.write("#pragma data(data)\n");

shutil.copy("sprites.c", "../src/sprites.c")