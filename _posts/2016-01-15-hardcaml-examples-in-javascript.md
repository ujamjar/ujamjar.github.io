---
layout: post
title: HardCaml Framework, Examples and Webapps
categories: [ocaml,hardcaml]
tags: [ocaml,hardcaml,javascript,ipwebapps]
---

[hardcaml-examples](https://github.com/ujamjar/hardcaml-examples) 
provides a small framework for creating [HardCaml](https://github.com/ujamjar/hardcaml) 
based cores and six example designs.  The framework code provides the general plumbing
required to create a console based application with features including code generation, 
simulation, and waveform viewing.  A recent update extends the framework so that cores
can be run on a webpage.

#### WebApp Examples

1. [Sorting networks](/ipwebapps/sorting.html)
2. [Linear feedback shift registers](/ipwebapps/lfsr.html)
3. [Wallace and Dadda tree multipliers](/ipwebapps/mul.html)
4. [Prefix networks](/ipwebapps/prefix.html)
5. [ROM-accumulator](/ipwebapps/rac.html)
6. [CORDIC](/ipwebapps/cordic.html)

## Plugging a design into the framework

A design compatible with the framework should implement the signature given in
`HardCamlFramework.Framework.Design`.

{% highlight ocaml %}
module My_design = struct

  let name = "design_name"
  let desc = "desdign description (in markdown)"

  (* configuration *)
  module Hw_config = struct
    include interface (* design parameters *) end
    let params = (* default parameters *) end
  end
  module Tb_config = struct
    include interface (* testbench parameters *) end
    let params = (* default parameters *) end
  end
  
  let validate hw tb = (* parameter validation *)
  
  (* design and testbench construction *)
  module Make
    (B : HardCaml.Comb.S)
    (* user provided parameters *)
    (H : Params with type 'a t = 'a Hw_config.t)
    (T : Params with type 'a t = 'a Tb_config.t) = struct
    
    module I = interface (* design inputs *) end
    module O = interface (* design outputs *) end
    
    let wave_cfg = (* configuration of waveform *)
    
    let hw i = (* design construction *)
    
    let tb sim i o n = (* testbench *)
  end
end
{% endhighlight %}

A console application can be created as follows

{% highlight ocaml %}
module A = HardCamlFrameworkConsole.App.Make(MyDesign)
{% endhighlight %}

The application should be linked with the `hardcaml-framework.console` ocamlfind
library.  The following generic options will be available

| option | description |
|-|-|
|-vlog <file> | generate verilog netlist |
|-vhdl <file> | generate vhdl netlist |
|-csim <file> | generate C simulation model |
|-tb          | run testbench |
|-llvm        | use LLVM backend to run testbench |
|-vpi         | use Icarus Verilog to run testbench |
|-checktb     | compare ocaml simulation with LLVM/VPI backend |
|-interactive | interactive text driven testbench mode |
|-vcd <file>  | generate VCD file |
|-waveterm    | integrated waveform viewer |
|-gtkwave     | gtkwave waveform viewer |

The remaining options will configure design and testbench parameters.

## Webapps

A web based application is created by building two bytecode applications 
(linked with `hardcaml-framework.js`) and compiling them with js_of_ocaml.

*user interface (ie mydesign.js)*

{% highlight ocaml %}
module A = HardCamlFrameworkJS.Appmain.Make(MyDesign)
{% endhighlight %}

*webworker (mydesign_ww.js)*

{% highlight ocaml %}
module A = HardCamlFrameworkJS.Appww.Make(MyDesign)
{% endhighlight %}

To include the application in a html page load the user interface in a script
tag and include a div with id `hardcaml-framework-webapp` and a data attribute
called `data-hcww` which points to the webworker javascript file.  The webapp will
create itself within the div.

{% highlight html %}
<div data-hcww="mydesign_ww.js" id="hardcaml-framework-webapp"></div>
<script type="text/javascript" src="mydesign.js"></script>
{% endhighlight %}

