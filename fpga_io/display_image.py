from PIL import Image
import numpy as np

IMAGE_WIDTH = 201
IMAGE_HEIGHT = 251

OUTPUT_WIDTH = IMAGE_WIDTH - 2
OUTPUT_HEIGHT = IMAGE_HEIGHT - 2

# Read Sobel output
with open("fpga_io/output/output_from_fpga.txt", "r") as f:
    values = [int(line.strip()) for line in f if line.strip()]

print(f"Read {len(values)} output pixels")
print(f"Expected {OUTPUT_WIDTH * OUTPUT_HEIGHT} output pixels")

# Check output size
if len(values) != OUTPUT_WIDTH * OUTPUT_HEIGHT:
    print("WARNING: Number of output pixels does not match expected size")

# Convert to numpy array
edge_image = np.array(values, dtype=np.uint16)

# Reshape into image
edge_image = edge_image.reshape((OUTPUT_HEIGHT, OUTPUT_WIDTH))

# Clip to 8-bit range
edge_image = np.clip(edge_image, 0, 255).astype(np.uint8)

# Display
Image.fromarray(edge_image).show()

# Save image
Image.fromarray(edge_image).save("fpga_io/sobel_output.png")

print("Saved as sobel_output.png")
