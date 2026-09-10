import matplotlib.pyplot as plt
import numpy as np
from PIL import Image

# Tiny fake image
# image = np.array(
#     [
#         [10, 20, 30, 40, 50],
#         [10, 20, 30, 40, 50],
#         [10, 20, 30, 40, 50],
#         [10, 20, 30, 40, 50],
#         [10, 20, 30, 40, 50],
#     ]
# )

image = np.array(
    [
        [10, 21, 32, 43, 54],
        [15, 26, 37, 48, 59],
        [18, 29, 40, 51, 62],
        [23, 34, 45, 56, 67],
        [27, 38, 49, 60, 71],
    ]
)


def sobel_filter(image):
    print("Image shape size", image.shape)
    Gx = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]])

    Gy = np.array([[-1, -2, -1], [0, 0, 0], [1, 2, 1]])

    output = np.zeros((image.shape[0] - 2, image.shape[1] - 2))

    for i in range(image.shape[0] - 2):
        # print(f"image[{i}:{i + 3}")
        for j in range(image.shape[1] - 2):
            window = image[i : i + 3, j : j + 3]

            # Sum
            gx = np.sum(window * Gx)
            gy = np.sum(window * Gy)

            # magnitude = np.sqrt(gx**2 + gy**2)
            magnitude = abs(gx) + abs(gy)

            output[i, j] = magnitude

    output = output / output.max() * 255
    return output


def extract_image(file_path):
    image = Image.open(file_path).convert("L")
    width = 201
    height = int(image.height * (width / image.width))
    print(f"Width {width}")
    print(f"Height {height}")

    image = image.resize((width, height))
    return np.array(image, dtype=np.int32)


def display_result(image):
    image = np.array(image, dtype=np.uint16)      # avoid overflow before clipping
    image = np.clip(image, 0, 255).astype(np.uint8)
    Image.fromarray(image).save("python_model/output.png")


def line_buffer_logic(line_buffer, IMAGE_SIZE=600):
    column = 0
    flip = False
    row1 = [0] * IMAGE_SIZE
    row2 = [0] * IMAGE_SIZE
    for i, item in enumerate(line_buffer):
        if flip == False:
            row1[column] = item
        else:
            row2[column] = item

        if column == IMAGE_SIZE - 1:
            column = 0
            flip = not flip
        else:
            column += 1


current = [0, 0, 0]


def shift_register(current, n):
    current[0] = current[1]
    current[1] = current[2]
    current[2] = n


def three_window(row1, row2, row3):
    shift1 = [0, 0, 0]
    shift2 = [0, 0, 0]
    shift3 = [0, 0, 0]

    for i in range(len(row1) - 1):
        shift_register(shift1, row1[i])
        shift_register(shift2, row2[i])
        shift_register(shift3, row3[i])

        if i >= 2:
            print(shift1)
            print(shift2)
            print(shift3)
            print()


def get_hardware_magnitude(window):
    gx = (
        -window[0, 0]
        + window[0, 2]
        - 2 * window[1, 0]
        + 2 * window[1, 2]
        - window[2, 0]
        + window[2, 2]
    )

    gy = (
        -window[0, 0]
        - 2 * window[0, 1]
        - window[0, 2]
        + window[2, 0]
        + 2 * window[2, 1]
        + window[2, 2]
    )

    magnitude = abs(gx) + abs(gy)
    return magnitude


def stream_through(image, IMAGE_WIDTH=600):

    IMAGE_WIDTH = image.shape[1]

    shift1 = [0, 0, 0]
    shift2 = [0, 0, 0]
    shift3 = [0, 0, 0]

    line_buffer_1 = [0] * IMAGE_WIDTH
    line_buffer_2 = [0] * IMAGE_WIDTH

    mag_arr = [[0] * (image.shape[1] - 2) for _ in range(image.shape[0] - 2)]

    for n, row in enumerate(image):
        for column, pixel in enumerate(row):
            old_row1 = line_buffer_1[column]
            old_row2 = line_buffer_2[column]

            line_buffer_1[column] = old_row2
            line_buffer_2[column] = pixel

            shift_register(shift1, old_row1)
            shift_register(shift2, old_row2)
            shift_register(shift3, pixel)

            if n >= 2 and column >= 2:
                window = np.array([shift1, shift2, shift3])

                magnitude = get_hardware_magnitude(window)

                mag_arr[n - 2][column - 2] = magnitude
                # print(magnitude)

    return mag_arr


def write_output(mag_arr, file_path="python_model/python_output.txt"):
    with open(file_path, "w") as f:
        for row in mag_arr:
            f.writelines(f"{magnitude}\n" for magnitude in row)


if __name__ == "__main__":
    print("Extracting Image")
    image = extract_image("python_model/football.jpg")
    print("Modifying Image....Finding Edges....")
    # modified_image = sobel_filter(image)
    # print("Displaying Results")
    # display_result(modified_image)

    # image = np.array(
    #     [
    #         [10, 21, 32, 43, 54],
    #         [15, 26, 37, 48, 59],
    #         [18, 29, 40, 51, 62],
    #         [23, 34, 45, 56, 67],
    #         [27, 38, 49, 60, 71],
    #     ]
    # )

    modified_image = stream_through(image=image)
    write_output(modified_image)

    print("Displaying Results")
    display_result(modified_image)
