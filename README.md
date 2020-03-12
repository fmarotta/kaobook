# kaobook

A LaTeX class for books, reports or theses.

## Acknowledgements

This class is based on the work of [Ken Arroyo 
Ohori](https://3d.bk.tudelft.nl/ken/en/) for his doctoral thesis. The 
main ideas behind the layout can be found in this [blog 
post](https://3d.bk.tudelft.nl/ken/en/2016/04/17/a-1.5-column-layout-in-latex.html). 

The [Tufte-LaTeX class](https://github.com/Tufte-LaTeX/tufte-latex) has 
also been a source of ideas about the layout.

Finally my gratitude goes also to [Vel](https://www.vel.nz/) for his 
patience and his invaluable suggestions about the design.

## Description

The salient features of the class are as follows.

* Wide margin to house captions, small figures or tables, and textual 
  notes.

* Mini table of contents in the margin at the start of each chapter.

* Easily-customisable chapter headings.

* Flexible citations with references both in the margin and in the 
  bibliography at the end.

* Powered by KOMA-Script.

* Many commands have been redefined to ease the life of the user.

A better description can be found at [LaTeX 
Templates](http://www.latextemplates.com/template/kaobook). If you think 
that a PDF is worth a thousand words, have a look at [this](main.pdf).

## Repository Schema

There are two main class files: `kaobook.cls`, used for books, and 
`kaohandt.cls`, used for reports or handouts; both rely on `kao.def`, 
which contains the bulk of the definitions that are commont to both 
classes. In the future there may be another class for theses.

There are two template files for the two supported classes, and each has 
its own bibliography file. Further examples are listed in the `examples` 
directory. The book that documents the class is an example itself, but 
the pdf has been copied to the root of the repository so that it will be 
found easier.

The `styles` directory contains additional packages that are used by the 
class, but in principle they are independent of it (even though in 
practice it is still not so).

## Usage

The class is documented and exemplified in the 
[example\_and\_documentation.pdf](example_and_documentation.pdf) file. 
To actually use it you can either clone the [Git Hub 
repository](https://github.com/fmarotta/kaobook) or, much more easily, 
find the template at [LaTeX 
Templates](http://www.latextemplates.com/template/kaobook).

The easiest way to start using the class is to open the [book 
template](book-template.tex) or the [report 
template](report-template.tex) and edit them.

Check out the [instructions](instructions) directory for additional 
guidance.

## Contributing

Do you like the design, but you found a bug? Is there something you 
would have done differently? Any contribution is welcome! Moreover, even 
if you'd rather not tamper with the code it is *not* forbidden to send 
me the documents you compiled using the kaobook class.

Since the content of this repository is published at [LaTeX 
Templates](http://www.latextemplates.com/), if you wish to contribute by 
changing the code you must follow the style guidelines of the site: 
extensive commenting and clear separation of the code into nicely 
formatted blocks.

Coffee keeps me awake and helps me writing a better LaTeX template. As 
another way to contribute, you can buy me a coffee through paypal: 
https://paypal.me/marofede.

## License

This repository contains two independent works. On the one hand, the 
kaobook class, consisting of `kaobook.cls`, `kaohandt.cls`, and 
`kao.def` files plus all of the files listed in the `styles` directory; 
on the other hand, the templates and the examples in the `examples` 
directory.

The first work is licensed under the Linux Project Public License, so if 
you want to modify and/or distribute the `*.cls` and `*.sty` files 
pertaining to this work you have to complain with the terms of the 
license. However, if you just want to use the class to compile your 
documents you need not worry about the license.

The second work is released into the public domain with a Creative 
Commons Zero License.

Read [MANIFEST.md](MANIFEST.md) for the details.
