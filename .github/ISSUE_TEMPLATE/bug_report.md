---
name: Bug report
about: Create a report to help us improve

---


### Prerequisites

* [ ] Put an X between the brackets on this line if you have done all of the following:
    * Check that you are using the latest version of kaobook.
    * Check that your issue isn't already filed: https://github.com/fmarotta/kaobook/issues

### Description

[Description of the issue]

### Minimal Working Example
[You can use the following document to help you create a minimal working example.]
```
\documentclass{kaobook}
\usepackage[english]{babel}
\usepackage{blindtext}
\usepackage{kaobiblio}
\usepackage{kaotheorems}
\usepackage{kaorefs}


\begin{document}

\title{Bug Report}
\author{Author}
\date{\today}

\frontmatter

\KOMAoptions{twoside=semi}
\maketitle
\KOMAoptions{twoside=false}

\mainmatter
\setchapterstyle{kao}

\chapter{First Chapter}
\blindtext

\end{document}
```

**Expected behavior:** [What you expect to happen]

**Actual behavior:** [What actually happens. Feel free to include the logfile or screenshots of your document]


### Additional Information

[Any relevant additional information]
