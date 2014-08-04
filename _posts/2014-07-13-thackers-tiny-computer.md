---
layout: post
title: Thackers-Tiny-Computer-3
categories: [ocaml]
tags: [ocaml, cpu]
jqmath: false
extrajs: [ assets/resources/ace/ace.js, assets/js/ttcwebdemo.js  ]
---

Thackers Tiny Computer 3 (TTC) is one in a series of simple RISC processor cores designed
by Chuck Thacker.  The implementation provided here is based on a
[design](http://www.cl.cam.ac.uk/teaching/1314/ECAD+Arch/labs/background/ttc.html) 
by [Simon Moore](http://www.cl.cam.ac.uk/~swm11/) and friends
at Cambridge University.  We give a brief description of the CPU core and assembler
and provide an online simulator for the CPU.

# Basic operation of the CPU

The core executes instuctions in 4 stages sequentially over 4 clock cycles.

1. Instruction fetch and decode
2. Register file access
3. ALU
4. Write back

The register file has 128 elements named r0 to r127.

The basic ALU operations are **ADD**, **SUB**, **INC**, **DEC**, **AND**, **OR** and **XOR** 
followed by a rotate right by **0**, **1**, **8** or **16** bits.

All instructions (except jump) may optionally skip the following instruction.  This is achieved
by incrementing the program counter by 2 rather than the default 1 if the skip condition is true.

A jump instruction stores PC+1 in the destination register.

# Assembler syntax

The basic assembler instruction formats are

~~~
[op] func rW rA rB [rot] [skip]
lc rW <integer | label>
~~~

where

* op - normal, stim, ldin, lddm, stout, stdm, jmp
* func - add, sub, inc, dec, and, or, xor
* rot - rot0, rot1, rot8, rot16
* skip - noskip, sez, sltz, sin
* rW - destination register
* rA and rB - source registers

All instructions can be expressed in these formats.  A few shortcuts are available, however.

~~~
jmp rW rA         # jump to program address rA and store PC+1 in rW
rot rW [rA] [rot] # rotate rA into rW
bgez rW rA rB     # jump to rA if rB>=0 and store PC+1 in rW
bnez rW rA rB     # jump to rA if rB<>0 and store PC+1 in rW
~~~

# Demo

<div id="editor" style="height: 400px; border: 1px solid #DDD; border-radius: 4px; border-bottom-right-radius: 0px; margin: 20px 20px 20px 20px;"># Enter assembly code here
</div>

Compile program.

<input type="button" id="jsoo_asm_compile" value="Compile"/>

<div id="jsoo_asm_result" class="table table-condensed"></div>

<input type="button" id="jsoo_step" value="Step"/>

<div id="jsoo_simulator" class="table table-condensed"></div>



