# Verification and reproducibility

The submitted `.v` files are unchanged; [SHA-256 hashes](source-sha256.json) record this archive. The PDF copy removes the student ID and replaces document metadata. The technical results remain those documented in the original course report.

## What the evidence establishes

| Evidence | Scope |
| :--- | :--- |
| RTL and original testbench | Implementation and simulation setup available for inspection |
| Course report | Historical design rationale, waveforms, and synthesis results |
| [Compile check](compile-check.md) | Source files compile with ModelSim/Questa; not a functional correctness or PPA result |

## Compile

```sh
python tools/compile.py --modelsim-bin /path/to/modelsim/bin
```

On Windows, use the directory containing `vlib.exe` and `vlog.exe`. Python 3 is required. Libraries and logs are written to the ignored `build/` directory. Simulation models and synthesis-only files are kept separate. No synthesis tool or cell library is bundled.

## Repeating the original experiments

The original testbench reads `image_in_8.txt` and dumps output memory after a fixed delay. That input file, the remaining course images, and the MATLAB reconstruction/quantization/PSNR scripts are not included. The final RTL is available; earlier optimization revisions and parameter-sweep scripts are not.

The course report records results for eight images. They have not been independently reproduced for this release. The testbench itself does not calculate PSNR. Reset, frame boundaries, and stall behavior need separate testing; the counter-driven top level assumes continuous input.

## Synthesis interpretation

- Cell area and power depend on the original synthesis library and constraints, which are not bundled.
- Input/output SRAM macros are black-boxed; implemented transpose-buffer logic is included.
- 80 MHz is the reported synthesis constraint, with reported setup slack of 0.00 ns.
- These are not post-layout or silicon measurements.
- This educational 16 × 16 DCT is not a complete baseline JPEG-compatible codec.
