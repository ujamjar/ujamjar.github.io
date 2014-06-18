---
layout: post
title: Reed-Solomon
categories: [open-source]
tags: [ocaml, error-correction-coding]
jqmath: true
extrajs: [ assets/js/rswebdemo.js ]
---

A Reed-Solomon encoder and decoder library written in OCaml.

The current version is written to help understand the algorithms and is implemented
using a polynomial library.  As such it is not very fast.

Plans are afoot to derive a faster version and at some point a hardware implementation
built with [HardCaml](https://github.com/ujamjar/hardcaml) will be added.

Get the OCaml library and demo code on [github](https://github.com/ujamjar/reedsolomon) or 
check out our [interactive demo]({% post_url 2014-06-18-reed-solomon-demo %}).
