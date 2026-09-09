from PIL import Image
import numpy as np

IMAGE_WIDTH = 201

image = Image.open("fpga_io/images/football.jpg").convert("L")

# Resize while keeping the original aspect ratio
IMAGE_HEIGHT = int(image.height * (IMAGE_WIDTH / image.width))
image = image.resize((IMAGE_WIDTH, IMAGE_HEIGHT))

image = np.array(image, dtype=np.uint8)

height, width = image.shape

print(f"Image width: {width}")
print(f"Image height: {height}")
print(f"Total pixels: {width * height}")

np.savetxt(
    "fpga_io/pixels.txt",
    image.flatten(),
    fmt="%d"
)

print(f"Saved {width * height} pixels")
