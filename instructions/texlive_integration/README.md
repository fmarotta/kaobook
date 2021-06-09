# TeXLive Integration

Normally, when you write a book with this template, you need that the 
`kaobook.cls` and the `styles` directory be in the same directory as the 
`main.tex`. After following these instructions, kindly provided by 
@pwgallagher, you can start writing your `main.tex` anywhere in your 
computer and still be able to use the kaobook class.

LaTeX looks at certain directories to find all the packages it can use.
Integrating the kaobook with the TeXLive installation amounts to 
copying all the `*.cls` and `*.sty` files in one of the places that are 
searched by LaTeX.

1. Find the appropriate directory by running `kpsewhich 
   -var-value=TEXMFHOME`. For instance, suppose it is 
   `/home/john/texmf/`.

1. Create the following hierarchy of directories under the texmf home: 
   `tex/latex/kaobook/`.

1. Copy all the `\*.cls` files and the `styles` directory from the 
   repository into the directory you just created. If you are in a 
   hurry, you can copy the whole repository into that directory.
   Alternatively, you can `git clone` the `kaobook` repository into that folder
   and periodically `git pull` to update your `kaobook` installation.
   In the end, the folder `/home/john/texmf/tex/latex/kaobook` should contain the 
   following files
   ```
   kao.sty
   kaobiblio.sty
   kaobook.cls
   kaohandt.cls
   kaorefs.sty
   kaotheorems.sty
   ```

1. Run `kpsewhich kaobook.cls` to make sure that LaTeX can find the 
   template.
