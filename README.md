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
that a PDF is worth a thousand words, have a look at [this](example_and_documentation.pdf).

## Usage

### On Overleaf

Browse to the [latextemplates.com page for
kaobook](https://www.latextemplates.com/template/kaobook) and start 
editing the `main.tex` file to fill it with your own contents.

### On your computer

Download the latest release from GitHub. At the root of the repository, 
create a new `.tex` file and make sure that the first line reads 
`\documentclass{kaobook}` (for books) or `\documentclass{kaohandt}` (for 
reports). Then, fill the file with your LaTeX contents.

### Other

Check out the [instructions](instructions) directory for additional 
guidance.

---

The class is documented and exemplified in the 
[example\_and\_documentation.pdf](example_and_documentation.pdf) file. 
The easiest way to start using the class is to open one of the examples 
and start editing them.

## Repository Schema

There are two main class files: `kaobook.cls`, used for books, and 
`kaohandt.cls`, used for reports or handouts; both heavily rely on 
`styles/kao.sty`, which contains the bulk of the definitions that are 
common to both classes. In the future there may be another class for 
theses.

Some examples and templates are listed in the `examples` directory. The 
book that documents the class is an example itself, and the pdf has been 
copied to the root of the repository so that it will be found easier.

The `styles` directory contains additional packages that are used by the 
class, but in principle they are independent of it (even though in 
practice it is still not so).

If you want to do something more peculiar, the `instructions` directory 
may contain what you need.

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
another way to contribute, you can buy me a coffee through PayPal: 
https://paypal.me/marofede.

## License

This repository contains two independent works. On the one hand, the 
kaobook class, consisting of `kaobook.cls`, `kaohandt.cls`, and 
`kao.def` files plus all of the files listed in the `styles` directory; 
on the other hand, the templates and the examples in the `examples` 
directory.

The first work is licensed under the [LaTeX Project Public License](https://www.latex-project.org/lppl/), so if 
you want to modify and/or distribute the `*.cls` and `*.sty` files 
pertaining to this work you have to complain with the terms of the 
license. However, if you just want to use the class to compile your 
documents you need not worry about the license.

The second work is released into the public domain with a Creative 
Commons Zero License.

Read [MANIFEST.md](MANIFEST.md) for the details.
