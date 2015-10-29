---
layout: post
title: SAT solving and HardCaml
categories: [open-source,ocaml,hardcaml]
tags: [ocaml, sat]
jqmath: true
---

Combining a SAT solver with [HardCaml](https://github.com/ujamjar/hardcaml) to prove 
circuit equivalence.

## SAT solving

Given a boolean function $f(x,y,..)$ a SAT solver will attempt to find assignment to the 
variables $x,y,..$ that make the function $f(x,y,..)=1$.  The SAT solver will provide one
of three possible answers.

1. **SAT** the solver found a solution and will return values for the input variables
2. **UNSAT** no solution exists
3. **FAILURE** the solver failed to find an answer

### Equivalence checking

An interesting application of a SAT solver is to prove that two functions are equivalent, even
if their implementations are different.  For example, consider the function $f$

<p>$$f(x,y) = (x ∧ y)′$$</p>

by Demorgans law we know the funtion $g$ is equivalent

<p>$$g(x,y) = x′ ∨ y′$$</p>

We somehow need to *connect* these functions and the obvious way would be to compare the
functions for equality.

<p>$$f=g$$</p>

This is wrong, however.  If the solver returns SAT then all it has shown is that there exists 
at least one assignment to $x$ and $y$ for which $f$ and $g$ produce the same result.  UNSAT 
would tell us there are no possible assignments to $x$ and $y$.  In fact we want to
compare the functions for inequality

<p>$$f≠g$$</p>

Now if we receive SAT we will get an assignment to $x$ and $y$ for which the functions
produce different results, while UNSAT will tell us that there is no possible assignment
to $x$ and $y$ that makes the functions differ i.e. they are functionally the same.

## HardCamlBloop

The [HardCamlBloop](https://github.com/ujamjar/hardcaml-bloop) library provides an interface 
between HardCaml designs and the [MiniSat](http://minisat.se/) solver.  Any design expressed 
with the HardCaml combinatorial API can be converted to a SAT problem.

The library has not been released to OPAM at this time as the minisat library it depends on
is not in OPAM.  If anyone is interested in using the library please start an issue on Github 
and I will provide instructions for getting it to work.

## Example; instruction trap decoding

My first proper use of a SAT solver was to show that the trap signal in a 
[RISC-V](http://riscv.org/) instruction decoder was generated correctly.

Each RISC-V instruction can be specified with a 32 bit mask and match pair.  Some parts of the 
instruction pattern, such as a register address or immediate, can take any value while others
must match a certain bit pattern.

{% highlight ocaml %}
let decode instr (mask, match_) = (instr &: mask) ==: match_
{% endhighlight %}

If we repeat this for each instruction, or them all together then not the result we have
a function indicating that no instruction was correctly decoded and a trap should be 
generated.

{% highlight ocaml %}
let trap = ~: (reduce (|:) (List.map (decode instr) mask_match_pairs))
{% endhighlight %}

This provides a [simple and understandable implementation](https://github.com/ujamjar/hardcaml-riscv/blob/c94e32ea6a00e5534f298e2f11d7c3aafc7c890a/test/instr_trap_sat.ml) for deriving the trap signal.

The [actual RTL implementation](https://github.com/ujamjar/hardcaml-riscv/blob/c94e32ea6a00e5534f298e2f11d7c3aafc7c890a/src/decoder.ml) of 
the instruction decoder is a bit more complex; it decodes
various signals to control the internal pipeline and attempts to optimise the critical
timing path and area.  None-the-less it needs to generate the trap signal correctly.  To
prove this we can use the SAT solver from HardCamlBloop.

{% highlight ocaml %}
let trap_ok = rtl_trap <>: ref_trap
let ok = HardCamlBloop.Sat.(report @@ of_signal trap_ok)
{% endhighlight %}

It is very useful that if the SAT solver finds a case where the 
implementations do not match it will report the instruction bit pattern
that causes the problem.

## Example; Comparing HardCaml and Yosys techlibs

One of my [current projects](https://github.com/ujamjar/hardcaml-yosys) is to use 
the open source synthesis tool [Yosys](http://www.clifford.at/yosys/) to convert a 
verilog design into a JSON netlist then load that into HardCaml.

The Yosys tool can represent the design at various abstraction levels from a very low level
version made up of primitive gates to a higher level roughly consistent with HardCamls
structural representation.

In the structural representation the design is made up of modules from the Yosys tech library 
called simlib.  Basically, the behavioural constructs of verilog are compiled into registers
and muxes and verilog operators are represented by simlib modules.

In order to load this into HardCaml we need a HardCaml version of simlib.  Here is an
example module from simlib.

{% highlight verilog %}
module \\$and (A, B, Y);

  parameter A_SIGNED = 0;
  parameter B_SIGNED = 0;
  parameter A_WIDTH = 0;
  parameter B_WIDTH = 0;
  parameter Y_WIDTH = 0;

  input [A_WIDTH-1:0] A;
  input [B_WIDTH-1:0] B;
  output [Y_WIDTH-1:0] Y;

  generate
    if (A_SIGNED && B_SIGNED) begin:BLOCK1
      assign Y = $signed(A) & $signed(B);
    end else begin:BLOCK2
      assign Y = A & B;
    end
  endgenerate

endmodule
{% endhighlight %}

One thing Yosys has not done for us is abstract away the fiendish details of the verilog
resizing rules; both operands and the result may be different widths and there are implicit
rules regarding how sign extension should happen.  One small mistake in the HardCaml 
implementation of these rules will lead to VERY hard to find bugs later on. 

### Enter the yosys sat solver

I decided to use SAT to prove that my simlib implementation was consistent with the yosys 
version.  To do this I generated a verilog file which takes the same arguments as the
simlib module and produces one signal called check which compares the hardcaml and yosys
implementations.  We can then run yosys as follows

~~~
yosys> read_verilog simlib.v my_sat_checking_design.v
yosys> hierarchy -top my_sat_checking_design; proc; flatten
yosys> sat -prove check 0 my_sat_checking_design

SAT proof finished - no model found: SUCCESS!
~~~

One complication is that this only proves the circuits are equivalent for some given
combination of parameters (A_WIDTH, B_SIGNED etc).  Thus I set up a bulk test which
ran about 200 different parameter combinations (a mixture of handcrafted and random tests)
for each module.  In total I ran about 6000 tests over 35 modules in about 5 minutes.



