# kaobook

## Acknowledgements

This class is based on the work of [Ken Arroyo
Ohori](https://3d.bk.tudelft.nl/ken/en/) for his doctoral thesis.
The main ideas behind the layout can be found in this [blog
post](https://3d.bk.tudelft.nl/ken/en/2016/04/17/a-1.5-column-layout-in-latex.html).
The [Tufte-LaTeX class](https://github.com/Tufte-LaTeX/tufte-latex) has also been a
source of ideas about the layout.

My gratitude goes also to [Vel](https://www.vel.nz/), for his patience 
and his invaluable suggestions about the design, and to all the people 
who have contributed either on 
[GitHub](https://github.com/fmarotta/kaobook/graphs/contributors) or by 
sending e-mails.

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

## Showcase

In the [examples](examples) directory you can find some sample 
documents, but here are some more books or reports created with the 
kaobook class. If you want to add a link to your work, please send me an 
email or open a pull request!

* [Growing Open Source Projects with a Stable Foundation (short book)](https://www.cyrius.com/foss-foundations/growing-open-source-projects.pdf)
* [Cours De Physique - Mécanique Classique (textbook)](https://femto-physique.fr/mecanique/pdf/book_meca.pdf)
* [Introduction to Causal Inference (textbook)](https://www.bradyneal.com/Introduction_to_Causal_Inference-Dec17_2020-Neal.pdf)
* [Formalisation and Meta-Theory of Type Theory (PhD thesis)](https://github.com/TheoWinterhalter/phd-thesis/releases/latest)
* [Computational modelling of terrains (textbook)](https://github.com/tudelft3d/terrainbook/releases/latest)
* [Meta-analysis of Type Theories with an Application to the Design of Formal Proofs (PhD thesis)](https://anjapetkovic.com/img/doctoralThesis.pdf)
* [Deep Inference for Graphical Theorem Proving (PhD thesis)](https://github.com/Champitoad/thesis/releases/tag/v1.0.0)
* [Psychedelic therapy in practice. Case studies of self-treatment, individual therapy, and group therapy (academic book)](https://www.researchgate.net/publication/389998402)
* [Ayahuasca revisited: Case studies & observations (academic book)](https://www.researchgate.net/publication/389998045)
* [From Underactuation to Quasi-Full Actuation: A Unifying Control Framework for Rigid and Elastic Joint Robots (PhD thesis)](https://mediatum.ub.tum.de/1662418)

## Getting Started

If you are not familiar with LaTeX, I recommend starting with [this 
tutorial](https://www.overleaf.com/learn/latex/Learn_LaTeX_in_30_minutes), 
which will give you a basic understanding of the language. As you will 
read in the tutorial, all LaTeX documents, including books, start by 
defining the so-called *class* of the document, for example 'article', 
or 'book'. Thus, the first line of a LaTeX document will be something 
like
```
\documentclass{book}
```

Each class provides a unique style and set of commands that can be used 
throughout the document. `kaobook` is just another class. The following 
paragraphs will outline how to use it.

### On Overleaf

Browse to the [latextemplates.com page for
kaobook](https://www.latextemplates.com/template/kaobook) and start 
editing the `main.tex` file to fill it with your own contents.

### On your computer

Download the latest release from GitHub. At the root of the repository, 
create a new `.tex` file and make sure that the first line reads 
`\documentclass{kaobook}` (for books) or `\documentclass{kaohandt}` (for 
reports). Then, fill the file with your LaTeX contents.

Important: when we say `\documentclass{kaobook}`, LaTeX needs to know 
where the `kaobook` file is. This means that the `.tex` file should be 
in the same folder as the `kaobook.cls` file, *i.e.* at the root of the 
repository. (There are exceptions to this rule. For instance, the 
kaobook files can be placed in a folder that is automatically searched 
by LaTeX. This, way, the `.tex` file with your contents can be placed 
anywhere; check out the [instructions](instructions) directory for 
hints.)

If you don't want to start from scratch, go to the `examples` directory, 
and find a template that you like; then, copy the corresponding 
`main.tex` at the root of the repository, and start editing it, filling 
it with your contents.

### Other

Check out the [instructions](instructions) directory for additional 
guidance. There, you can read about setting up your own sharelatex 
server or integrating kaobook with your local LaTeX installation.

---

The class is documented and exemplified in the 
[example\_and\_documentation.pdf](example_and_documentation.pdf) file. 
The easiest way to start using the class is to open one of the examples 
and start editing them.

## Compiling the examples

In the `examples` directory of this repository you can find several
documents exemplifying the kaobook class. For the sake of simplicity
I shall list the commands to compile only the documentation, but the
compilation of the other examples would proceed in the same way. Also,
you can replace pdflatex with your favorite engine, like *e.g.* xelatex.

### From the command line (Unix-like operating systems)

`cd` into the root of the repository, and run
```
pdflatex -output-directory examples/documentation main.tex
biber -output-directory examples/documentation main
pdflatex -output-directory examples/documentation main.tex
pdflatex -output-directory examples/documentation main.tex
pdflatex -output-directory examples/documentation main.tex
```

To compile the glossary and nomenclature as well, `cd` into the 
`examples/documentation` directory and run
```
makeindex main.nlo -s nomencl.ist -o main.nls
makeglossaries main
```
Then, `cd` back into the root of the repository and re-run pdflatex.

NOTE: sometimes LaTeX needs more than one run to get the correct
position of each element; this is true in particular for the positioning
of floating elements like figures, tables, and margin notes.
Occasionally, LaTeX can need up to four re-runs, so If the alignment of
margin elements looks odd, or if they bleed into ther main text, try
running pdflatex one more time.

## Updating kaobook

To update kaobook you should download the whole repository (or one of
the releases) again, and replace all of your old files with the newer
ones, *except* for the main.tex and the files that you have created,
like the chapters of the book. The crucial files that pertain to kaobook
and that you should always update are:

1. `kaobook.cls`;
2. `kaohandt.cls`;
3. `kao.sty`;
3. `kaobiblio.sty` (optional);
4. `kaorefs.sty` (optional);
5. `kaotheorems.sty` (optional);

These files should be in the same folder as your `main.tex`. Even if a
file has not been modified, I would still suggest to replace everything
because it is easier.

In practice, I would do as follows. I would have a directory, called for 
example 'my\_book', with all the files necessary for the book: 
`kaobook.cls`, `kaohand.cls`, the `*.sty` files, and the `main.tex`. I 
like to have a separate file for each chapter, so I would also have a 
directory called `chapters`, with all the `.tex` files with the actual 
chapters. Then, when I want to update kaobook, I would download the 
GitHub repository (or one of the releases) into a directory called 
'kaobook', and finally copy the `kaobook.cls`, `kaohandt.cls`, and the 
whole `styles` directory from 'kaobook' to 'my\_book'. Once the update 
is completed, the whole 'my\_book' directory can be uploaded on Overleaf 
or on a personal ShareLaTeX server.

Alternatively, advanced users can download the repository in their local 
texmf tree; see the [instructions](instructions) directory for hints.

## Repository Schema

There are two main class files: `kaobook.cls`, used for books, and 
`kaohandt.cls`, used for reports or handouts; both heavily rely on 
`kao.sty`, which contains the bulk of the definitions that are common to 
both classes. In the future there may be another class for theses.

Some examples and templates are listed in the `examples` directory. The 
book that documents the class is an example itself, and the pdf has been 
copied to the root of the repository so that it will be found more 
easily.

The `*.sty` files contain additional packages that are used by the 
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

## Supporting

I am always happy to help as much as I can, and I am glad if someone
uses the `kaobook` class for their works, so there is no real need to do
anything: the kaobook can be used just like any other LaTeX package (no 
need to add copyright statements). However, if you want to acknowledge 
kaobook, adding somewhere a sentence like 'This book was typeset with the
kaobook class' would suffice.

Coffee keeps me awake and helps me writing a better LaTeX template. As 
another way to contribute, you can buy me a coffee through PayPal: 
https://paypal.me/marofede.

## License

This repository contains two independent works. On the one hand, the 
kaobook class, consisting of `kaobook.cls`, `kaohandt.cls`, and 
`kao.def` files plus all of the files listed in the `styles` directory; 
on the other hand, the templates and the examples in the `examples` 
directory.

The first work is licensed under the [LaTeX Project Public
License](https://www.latex-project.org/lppl/), so if you want to modify
and/or distribute the `*.cls` and `*.sty` files pertaining to this work
you have to complain with the terms of the license. However, if you just
want to use the class to compile your documents you need not worry about
the license.

The second work is released into the public domain with a Creative 
Commons Zero License.

Read [MANIFEST.md](MANIFEST.md) for the details.
