`timescale 1ns / 10ps
// Synthesis-only port stubs for rflp memory macros.
// These are black boxes: no logic, no initial blocks, no event triggers.
// DC treats them as uncharacterized cells and excludes their area/timing.

module rflp16384x128mx16(
    output [127:0] DO,
    input  [127:0] DIN,
    input  [9:0]   RA,
    input  [3:0]   CA,
    input          NWRT,
    input          NCE,
    input          CLK
);
endmodule

module rflp16384x192mx16(
    output [191:0] DO,
    input  [191:0] DIN,
    input  [9:0]   RA,
    input  [3:0]   CA,
    input          NWRT,
    input          NCE,
    input          CLK
);
endmodule
