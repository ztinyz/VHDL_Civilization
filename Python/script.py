from PIL import Image

# Load the image
image = Image.open("Sprite-0001.png").convert("RGBA")

width, height = image.size

# Ensure correct size
if width != 160 or height != 120:
    raise ValueError("Image must be 160x120 pixels!")

# Function to convert 8-bit color to 4-bit (upper 4 bits)
def to_4bit(value):
    return value >> 4  # Take the upper 4 bits

# Write the VHDL file
with open("vhdl_matrix.vhd", "w") as file:
    file.write("type image_matrix is array (0 to 119, 0 to 159) of std_logic_vector(11 downto 0);\n")
    file.write("constant image_data : image_matrix := (\n")

    for y in range(height):
        file.write("    (")
        for x in range(width):
            r, g, b = image.getpixel((x, y))  # Get 8-bit RGB values
            r_4, g_4, b_4 = to_4bit(r), to_4bit(g), to_4bit(b)  # Convert to 4-bit
            
            # Convert to 12-bit hex format
            pixel_value = (r_4 << 8) | (g_4 << 4) | b_4  
            file.write(f'X"{pixel_value:03X}"')  # Format as hex (3 digits)

            if x < width - 1:
                file.write(", ")  # Add comma except at the end
        file.write(")" + ("," if y < height - 1 else "") + "\n")  # Add comma except last row

    file.write(");\n")