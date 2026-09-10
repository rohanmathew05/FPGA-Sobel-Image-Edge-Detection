import numpy as np

def compare_raw(fpga_path, python_path):
    fpga = np.loadtxt(fpga_path, dtype=np.int64)
    python = np.loadtxt(python_path, dtype=np.int64)

    print(f"FPGA:   count={len(fpga)}, mean={fpga.mean():.2f}, max={fpga.max()}")
    print(f"Python: count={len(python)}, mean={python.mean():.2f}, max={python.max()}")

    if len(fpga) == len(python):
        diff = fpga - python
        print(f"Mean abs diff: {np.abs(diff).mean():.2f}")
        print(f"Max abs diff:  {np.abs(diff).max()}")
        print(f"Exact matches: {(diff == 0).sum()} / {len(diff)} ({100*(diff==0).mean():.1f}%)")
    else:
        print("Length mismatch — check dimensions before comparing further")

# Compare the difference between the output of the FPGA and the python model we created
compare_raw("fpga_io/output/output_from_fpga.txt", "python_model/python_output.txt")