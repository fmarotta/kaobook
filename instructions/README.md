# Instructions

Some of the users of the template were so kind as to provide 
instructions to recreate a particular set up that they have been using 
to compile their books. In particular, Karl-Heinz Becker, author of 
"Dynamical Systems and Fractals," among other books and articles, wrote 
detailed instructions to configure a private ShareLaTeX server; and 
@pwgallagher opened an issue to tell us how to integrate the kaobook 
template with one's local TeX installation. There are also instructions 
for what I regards as a 'normal' LaTeX workflow, intended for beginners. 
Further instructions are welcome by anyone and will be added here.

## ShareLaTeX Server

These instructions are useful if you don't want to use Overleaf, _e.g._ 
because of privacy concerns. Setting up your own ShareLaTeX server is a 
nice way to use the template from your browser. Moreover, you get 
autocompletion of the commands and automatic spell checking.

**IMPORTANT:** if you use a ShareLaTeX server, your `main.tex` file must 
be at the root of the project, otherwise weird things will happen!

## Integration with the Local TeX Installation

If you are used to TeXLive, then these instructions are for you. They 
tell you how to make sure that your local LaTeX installation will find 
the template's files, so that you do not need to have the `kaobook.cls` 
and `styles` files in the directory of your project.
