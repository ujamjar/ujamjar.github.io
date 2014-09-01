---
layout: post
title: OCaml and IOCaml on Android
categories: [ocaml]
tags: [ocaml, iocaml, gnuroot]
author: Martyn Riley
---

Recently I was looking for an Ocaml solution for the Nexus 7. There are a 
couple of ocaml top-levels available but neither offer the ability to open 
packages or support for [opam](http://opam.ocamlpro.com).  Enter gnuroot.

The excellent [gnuroot]( https://play.google.com/store/apps/details?id=champion.gnuroot&hl=en) 
application enables a linux image to be run alongside Android on an unrooted 
device. I determined to use this to install a full ocaml development 
environment and then to install the [iocaml]( https://github.com/andrewray/iocaml ) 
package and the [hardcaml]( https://github.com/ujamjar/hardcaml ) package to 
support hardware design. iocaml is used to serve an iocaml notebook to an Android 
web-browser providing a great graphical development environment complete with any 
opam packages that you decide to install.

The procedure to get this all running is documented below and has been tested on 
a 2nd generation Nexus 7 and a Minix Neo X7 media hub. It *should* work on any 
Android device with enough memory. A bluetooth keyboard is a very useful addition!

- Install [gnuroot]( https://play.google.com/store/apps/details?id=champion.gnuroot&hl=en) and the gnuroot debian wheezy or wheezyX image from the play store.

Open gnuroot and login using the fake root option. It is then necessary to 
install opam from sources.

~~~
$ apt-get update
$ apt-get install ca-certificates
$ cd ~
$ wget https://github.com/ocaml/opam/archive/master.zip
$ apt-get install unzip
$ unzip master.zip
$ cd opam-master
$ apt-get install build-essential
$ apt-get install ocaml ocaml-findlib 
$ make lib-ext
$ ./configure
$ make
$ make install
~~~

I then install ocaml 4.01.0

~~~
$ opam init
$ opam switch 4.01.0
~~~

Install your editor of choice e.g `apt-get install vim`

Add the line ... `deb http://http.debian.net/debian wheezy-backports main` to sources.list.  

~~~
$ vim /etc/apt/sources.list
~~~

Install library dependencies

~~~
$ apt-get install m4 zlib1g-dev libffi-dev libssl-dev libzmq3-dev
~~~

Finally install the opam packages [iocaml]( https://github.com/andrewray/iocaml ) 
and [hardcaml]( https://github.com/ujamjar/hardcaml ).

~~~
$ opam install hardcaml iocaml
~~~

Execute iocaml and then access `localhost:8888` from your Android web-browser.
