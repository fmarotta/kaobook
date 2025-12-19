# kaobook

## For Developers

The code for the classes and packages of the kao bundle is found in the `source` directory, organized as .dtx and .ins files.
These need to be unpacked into .cls and .sty files before they can be used.
The `source` directory also contain the .tex file which typesets the manual.
Test files and corresponding expectations are in the `testfiles` directory.
Here is a typical development workflow.

1. Make your own fork of the repository and clone it, e.g. `git clone git@github.com/fmarotta/kaobook`
1. Edit one of the .dtx or other files in `./source` to add a feature or fix a bug
1. Compile the .dtx into local .cls and .sty files: `l3build unpack`, they will be saved under `build/unpacked`
1. Generate the documentation and the manual: `l3build doc`, they will be saved in `docs`
1. Create a new test file, e.g. `testfiles/mytest.pvt` (for PDF comparison) or `testfiles/mytest.lvt` (for log comparison)
1. Save the expectation for that test: `l3build save mytest`, this creates the raw PDF at `build/test/mytest.pdf` and the expectation file at `testfiles/mytest.tpf` (for PDF comparison) or `testfiles/mytest.tlg` (for log comparison)
1. Run the tests: `l3build check`, this will compare the new .tpf or .tlg with the saved ones and raise errors if they differ
1. Install the .cls and .sty files in your local texmf directory: `l3build install`
1. Verify that everything works, then bump the package version: `l3build tag --date <YYYY/MM/DD> --version <MAJOR.MINOR.PATCH>`
1. Prepare release for CTAN: TODO

Further reading on l3build:
- https://www.latex-project.org/publications/2022-JAW-TUB-tb133wright-l3build.pdf
- https://github.com/pablgonz/demopkg-jw

### .dtx file quick reference

`DocStrip` reads the .dtx file twice.
The first time it only looks at the uncommented `<driver>` code.
This creates a "template" for the .tex file with the documentation, which has the line `\DocInput{kao.dtx}` at its core.
The second time it looks at the commented code and generates the documentation.
Blocks between `\iffalse`-`\fi` are read by docstrip and may be sent to output files, but they are not included in the documentation.

Traditionally, the .dtx file is supposed to be divided in two parts.
The initial part describes the usage of a package's macros for users.
The second part goes between the `\MaybeStop` (a.k.a. `\StopEventually`) and the `\Finale`, and it should contain the implementation.
The reason for this separation is that most users will not be interested in the implementation, so the code would be a big distraction when they just want to know how to use the package.
The code can even be turned off with the `\OnlyDescription` directive in the driver part of the .dtx file.

Write content for humans:
```latex
% \section{Introduction}
% A long time ago, in a galaxy far, \textit{far} away...
%
```

Also for humans, index a paragraph describing `\examplemacro`:
```latex
%\DescribeMacro{\examplemacro}
% Here is how you can use the macro \cs{examplemacro}, which
% has one mandatory argument \marg{arg1}.
% ...
%
```

Send output to all generated files:
```latex
% \iffalse
\newcommand\sayhi{Hi!}
% \fi
```

Send output to a specific file:
```latex
% \iffalse
%<mypkg>
\newcommand\sayhi{Hi!}
%</mypkg>
% \fi
```

Send output to all generated files AND write it in the documentation:
```latex
% \begin{macro}{\incrementexample}
% Describe the macro in plain text, using vertical bars for verbatim
%    \begin{macrocode}
\newcommand\incrementexample{%
%    \end{macrocode}
% This macro just increments the counter "example"
%    \begin{macrocode}
  \addtocounter{example}{1}%
}
%    \end{macrocode}
% \end{macro}
```

Send output to a specific file AND write it in the documentation:
```latex
% \iffalse
%<*mypkg>
% \fi
% \begin{macro}{\incrementexample}
% <...>
% \end{macro}
% \iffalse
%</mypkg>
% \fi
```

Record changes exactly where they happen:
```latex
% \changes{v1.0}{2002/03/25}{Initial version}
```

Further reading on .dtx files:
- https://mirrors.mit.edu/CTAN/info/dtxtut/dtxtut.pdf
- https://www.texdev.net/2009/10/05/the-dtx-format/
- https://www.texdev.net/2009/10/06/a-model-dtx-file/

