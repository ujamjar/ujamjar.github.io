---
layout: post
title: Reed-Solomon Interactive Demo
categories: [demo,ocaml]
tags: [ocaml, reed-solomon, error-correction-coding, demo]
jqmath: true
extrajs: [ assets/js/rswebdemo.js ]
---

An interactive demo of Reed-Solomon error correction coding.  The demo shows the workings 
of the CODEC in detail and allows the user to configure the RS code parameters and test case.

Get the OCaml library and demo code on [github](https://github.com/ujamjar/reedsolomon).

## Introduction

Reed-Solomon (RS) codes are a forward error correction technique that allows
a communications system to detect and correct transmission errors.  RS codes
are generally systematic block codes and are defined by the following 
parameters.

* symbol size in bits ($m$)
* message size in symbols ($k$)
* code word size in symbols ($n$)
* number of correctable symbols ($t$)

The following relationships exist between these parameters;

\\[ n = 2^m-1 \\]

\\[ n - k = 2t \\]

From an encoding point of view we take $m$ bits to form a symbol and $k$ 
symbols to form a message.  The encoder then calculates $2t$ symbols which are 
appended to the message to form the code word which is transmitted 
($k+2t$ = $n$ symbols, or $nm$ bits).

The decoder receives $n$ symbols and if there are $t$ or less corrupt symbols
it will correctly reproduce the initial message of $k$ symbols. 

The theory of RS codes is well explained in this [BBC whitepaper](http://www.google.com/search?q=BBC+white+paper+reed+solomon)
among various [other resources](http://en.wikipedia.org/wiki/Reed%E2%80%93Solomon_error_correction). 

## Configuration

Start by configuring the code parameters.  Set $m$, the symbol size in bits, and $t$, the error
correction capability of the code.  Optionally the initial root, $b$, of the generator polynomial
can be set.

Next configure the specific Galois field to use by providing the primitive polynomial and 
element.  These are specified in decimal form.

Finally the message and error patterns are configured.

### RS code parameters

m = <input type="number" min="3" max="10" value="4" id="jsoo_param_m" size="2"/>, 
t = <input type="number" min="1" max="256" value="2" id="jsoo_param_t" size="2"/>

<div id="jsoo_derived_params"></div>

### Galois Field configuration

Primitive polynomial = <input type="number" max="2048" min="1" value="19" id="jsoo_param_pp" />,
Primitive element = <input type="number" max="1023" min="1" value="2" id="jsoo_param_pe" />

#### Generator polynomial roots

Initial root b = <input type="number" id="jsoo_param_b" min="0" max="256" value="0"/>

### Message

<input type="button" id="jsoo_random_message" value="randomise" />
<input type="button" id="jsoo_clear_message" value="clear" />

<div id="jsoo_message_data"></div>

### Errors

<input type="button" id="jsoo_random_errors" value="randomise" />
<input type="button" id="jsoo_clear_errors" value="clear" />

<div id="jsoo_error_data"></div>

### Galois Field

<input type="button" id="jsoo_show_galois_field" value="Show/hide field" />

<div id="jsoo_show_galois_field_div" style="display: none">

Primitive polynomial

<div id="jsoo_prim_poly"></div>

Primitive element

<div id="jsoo_prim_elt"></div>

Elements of the Galois field in decimal, polynomial form and
as powers of the primitive element.

<div id = "jsoo_galois_field"></div>

</div>

## Reed-Solomon algorithm

Click *calculate* to run the Reed-Solomon CODEC.  Polynomial coefficients can be displayed
in either decimal form or as powers of the primitive element, and  may be rendered
in either ascending or descending order.

<input type="button" id="jsoo_calculate_rs" value="Calculate" />

<input id="jsoo_show_decimal" type="checkbox" checked="true"/>Decimal
<input id="jsoo_up_down" type="checkbox" checked="true"/>Descending

### Message

\\[M(x) = \\]

<div id="jsoo_message_poly"></div>

### Errors

\\[E(x) = \\]

<div id="jsoo_error_poly"></div>

### Generator

\\[G(x) = \\]

<div id="jsoo_generator_poly"></div>

### Code word

\\[T(x) = \\]

\\[M(x)x^{2t} + (M(x)x^{2t} mod G(x)) = \\]

<div id="jsoo_codeword_poly"></div>

### Received code word


<div id="jsoo_received_poly"></div>

### Syndromes

<div id="jsoo_syndromes"></div>

### Syndrome polynomial

\\[S(x) = \\]

<div id="jsoo_syndrome_poly"></div>

### Euclid

<p>The final step will generate $s_{n} = γΛ(x)$ and $r_{n} = γΩ(x)$.  To 
get normalized form divide both polynomials by the constant coefficient
of $s_{n}$.</p>

<div id="jsoo_euclid"></div>

### Berlekamp-massey

<div id="jsoo_berlekamp_massey"></div>

### Error locator polynomial

<p>$$Λ(x) = $$</p>

<div id="jsoo_error_locator_poly"></div>

### Error magnitude polynomial

<p>$$Ω(x) = $$</p>

<div id="jsoo_error_magnitude_poly"></div>

### Chein search

<div id="jsoo_chien_search"></div>

### Solving for error locations

<div id="jsoo_error_locations"></div>

### Forney

<p>$$ Y_{j} = X_{j}^{1-b}{Ω(X_{j}^{-1})} / {Λ'(X_{j}^{-1})} = $$</p>

<div id="jsoo_forney_poly"></div>

<div id="jsoo_forney_res"></div>

### Calculated error polynomial

<p>$$ E_{calc}(x) = $$</p>

<div id="jsoo_calc_error_poly"></div>

### Corrected polynomial

<p>$$ R_{calc}(x) = R(x) + E_{calc}(x) = $$</p>

<div id="jsoo_corrected_poly"></div>

