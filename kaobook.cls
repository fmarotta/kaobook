\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kaobook}[2019/01/01 v0.0.1 kaobook class]

\newcommand{\@classname}{kaobook} % the name of the class 
\newcommand{\@baseclass}{scrbook} % the name of the base class 

\RequirePackage{etoolbox}		% Easy programming to modify TeX stuff
\RequirePackage{xifthen}		% Easy conditionals
\RequirePackage{xkeyval}		% Manage class options
\RequirePackage{ifxetex}		% Detect if we are using XeLaTeX

% CLASS OPTIONS {{{

\newboolean{@option@justified}
\DeclareOption{justified}{
  \setboolean{@option@justified}{true}
}
\newboolean{@option@raggedright}
\DeclareOption{raggedright}{
  \setboolean{@option@raggedright}{true}
}
\newboolean{@option@indent} % indent the first line of a paragraph
\DeclareOption{indent}{
  \setboolean{@option@indent}{true}
}
\newboolean{@option@space} % separate paragraphs with space
\DeclareOption{space}{
  \setboolean{@option@space}{true}
}
\newboolean{@option@innermargins}
\DeclareOption{innermargins}{
  \setboolean{@option@innermargins}{true}
  \ClassInfo{@fmarotta@pkgname}{The `innermargins' option implies `twoside'}
  \ExecuteOptions{twoside}
}
\newboolean{@option@leftmargins}
\DeclareOption{leftmargins}{
  \setboolean{@option@leftmargins}{true}
  \ClassInfo{@fmarotta@pkgname}{The `leftmargins' option implies `oneside'}
  \ExecuteOptions{oneside}
}
\DeclareOption{onecolumn}{\OptionNotUsed}
\DeclareOption{twocolumn}{\OptionNotUsed}
\DeclareOption{landscape}{\OptionNotUsed}

% Set default options
\ExecuteOptions{openright}
\ExecuteOptions{twoside}
\ExecuteOptions{fontsize=9pt}
%\ExecuteOptions{space}
%\ExecuteOptions{justify}

% Pass the other options to the base class
\DeclareOption*{
  \PassOptionsToClass{\CurrentOption}{\@baseclass}
}

% Process the options
\ProcessOptions\relax

% Use the KOMA scrbook class as template
\LoadClass{scrbook}

% }}}

% COLORS AND FONTS, ENCODING {{{

\RequirePackage[utf8]{inputenc}	% utf8 encoding in the input (.tex) file
\RequirePackage[english=british]{csquotes}	% English quotes
\RequirePackage{hyphenat}					% Hyphenation for special fonts
\RequirePackage{xcolor}						% Colours in text
\RequirePackage{microtype} % Improves character and word spacing

% }}}

% PARAGRAPH FORMATTING {{{

\RequirePackage{ragged2e}
\RequirePackage{setspace}

% TODO: recognize space/indent justified/raggedright class options

\newcommand{\@body@par}{%
  \justifying%
  %\setlength{\RaggedRightParindent}{0pc}%
  %\setlength{\parindent}{0pc}%
  %\setlength{\parskip}{1pc}%
  \singlespacing%
  \frenchspacing% no additional space after periods
  \normalfont%
  \normalsize%
}

\newcommand{\@margin@par}{%
  \justifying%
  \setlength{\RaggedRightParindent}{0pc}%
  \setlength{\parindent}{0pc}%
  \setlength{\parskip}{0.5pc}%
  \singlespacing%
  \frenchspacing% no additional space after periods
  \normalfont%
  \footnotesize%
  \color{blue}%
}

% By default, use @body@par specifications
\@body@par

% }}}

% PAGE LAYOUT {{{

\RequirePackage{scrlayer-scrpage}       % Customise head and foot regions
\setlength{\headheight}{115pt}			% Enlarge the header

% Part title style [todo]
%\renewcommand*{\partformat}{\vspace{-6cm}\partname~\thepart\autodot\thispagestyle{empty}}

% Chapter title style
\setlength{\fboxsep}{0cm}
\renewcommand*{\@@makechapterhead}[1]{%
  \vspace*{3\baselineskip plus \parskip}
  \makebox{%
	\makebox[\linewidth]{\parbox[c][2cm]{\linewidth}{%
	  \if@mainmatter\raggedleft\fi\size@chapter{#1}%
	}}%
    \if@mainmatter%
	  \makebox[\marginparsep]{\parbox[c][2cm]{%
		\marginparsep}{\centering\rule{1pt}{2cm}}%
	  }%
	  \makebox[4cm]{\parbox[c][2cm]{4cm}{%
		\scalebox{5}{\usekomafont{chapter}\thechapter\autodot}}%
	  }%
    \fi
  }%
  \vspace*{1.5\baselineskip plus .1\baselineskip minus .167\baselineskip}
}

\let\oldfrontmatter\frontmatter
\renewcommand{\frontmatter}{

  \oldfrontmatter

  \newgeometry{
	top=2.620cm,
	bottom=4.238cm,
	%top=2.170cm,
	%bottom=3.510cm,
	inner=2.1835cm,
	outer=2.1835cm,
	ignoremp
  }

  \renewpagestyle{scrheadings}{
	{\makebox[2em][r]{\thepage}\quad\rule{1pt}{100pt}\quad{}Contents}%
	{\hfill\rightmark\quad\rule{1pt}{100pt}\quad\makebox[2em][l]{\thepage}}%
	{}
  }{
	{}%
	{}%
	{}
  }
  \renewpagestyle{plain.scrheadings}{
	{}%
	{}%
	{}
  }{
	{\thepage}%
	{\hfill\thepage}%
	{}
  }

  % Uncomment if you want a first blank page
  %\oldfrontmatter
  \sloppy

}

\let\oldmainmatter\mainmatter
\renewcommand{\mainmatter}{

  \if@openright\cleardoublepage\else\clearpage\fi

  \restoregeometry

  % Lengths used for page head
  \newlength{\overflowingheadlen}
  \setlength{\overflowingheadlen}{\linewidth}
  \addtolength{\overflowingheadlen}{\marginparsep}
  \addtolength{\overflowingheadlen}{\marginparwidth}

  % Page style for chapters
  \renewpagestyle{scrheadings}{
	{\hspace{-\marginparwidth}\hspace{-\marginparsep}\makebox[\overflowingheadlen][l]{\makebox[2em][r]{\thepage}\quad\rule{1pt}{100pt}\quad{}\leftmark}}%
	{\makebox[\overflowingheadlen][r]{\rightmark\quad\rule{1pt}{100pt}\quad\makebox[2em][l]{\thepage}} }%
	{}
  }{
	{}%
	{}%
	{}
  }
  \renewpagestyle{plain.scrheadings}{
	{}%
	{}%
	{}
  }{
	{\thepage}%
	{\makebox[\overflowingheadlen][r]{\thepage}}%
	{}
  }

  \oldmainmatter

}

\let\oldbackmatter\backmatter
\renewcommand{\backmatter}{

  \if@openright\cleardoublepage\else\clearpage\fi

  \restoregeometry
  \newgeometry{
	%top=2.170cm,
	%bottom=3.510cm,
	top=2.620cm,
	bottom=4.238cm,
	inner=2.1835cm,
	outer=2.1835cm,
	ignoremp}

  % Page style for back matter
  \renewpagestyle{scrheadings}{
	{\hspace{-\marginparwidth}\hspace{-\marginparsep}\makebox[\overflowingheadlen][l]{\makebox[2em][r]{\thepage}\quad\rule{1pt}{100pt}\quad{}\leftmark}}%
	{\makebox[\overflowingheadlen][r]{\rightmark\quad\rule{1pt}{100pt}\quad\makebox[2em][l]{\thepage}} }%
	{}
  }{
	{}%
	{}%
	{}
  }
  \renewpagestyle{plain.scrheadings}{
	{}%
	{}%
	{}
  }{
	{\thepage}%
	{\makebox[\overflowingheadlen][r]{\thepage}}%
	{}
  }

  \oldbackmatter

}

% }}}

% FOOTNOTES, MARGINNOTES AND SIDENOTES {{{

\RequirePackage[
  bottom,
  symbol,
  para,
  perpage,
  stable,
  multiple
]{footmisc} % load after `setspace' and `raggedright'
\RequirePackage[marginnote=true]{snotez}	% For sidenotes
\RequirePackage{marginnote}
\RequirePackage{marginfix}              % Make marginpars float freely
\RequirePackage[section]{placeins}		% prevent floats to cross sections

% More floats
\extrafloats{100}

% Footnotes
% FIXME: I cannot choose the paragraph layout of footnotes
\renewcommand{\footnotelayout}{\@margin@par}

% marginfix: affects marginpars
\marginskip{10pt} % minimum distance between marginpars

% marginnote: affects marginnotes. Justify and format
\renewcommand*{\raggedleftmarginnote}{}
\renewcommand*{\raggedrightmarginnote}{}
\renewcommand*{\marginfont}{\@margin@par}

% Renew \marginnote command to make it similar to snotez's \sidenote
\def\mnotez@if@nblskip#1{%
  \expandafter\ifx\@car#1\@nil*%
	\expandafter\@firstoftwo
  \else
	\expandafter\@secondoftwo
  \fi
}
\let\oldmarginnote\marginnote
\renewcommand{\marginnote}[2][0pt]{
  \oldmarginnote{#2}[\mnotez@if@nblskip{#1}{\@cdr#1\@nil\baselineskip}{#1}]
}

% Sidenotes
\setsidenotes{text-mark-format=\textsuperscript{\normalfont#1},
              note-mark-format=#1:,
              note-mark-sep=\enskip}

% Small workaround for \chapter
\newcommand{\pp@g@sidenote}{}

% }}}

% FIGURES, TABLES AND CAPTIONS {{{

\RequirePackage{graphicx}
\RequirePackage{subfig}                 % Subfigures
\setkeys{Gin}{width=\linewidth,totalheight=\textheight,keepaspectratio} % Improves figure scaling
\RequirePackage{booktabs}               % Nicer tables
\RequirePackage{multirow}               % Cells occupying multiple rows in tables
\RequirePackage{multicol}               % Multiple columns in dictionary
\RequirePackage[hypcap=true]{caption}   % Correctly placed anchors for hyperlinks
\RequirePackage{scrhack}				% Force KOMA to like floatrow
\RequirePackage{floatrow}               % Set up captions of floats

%% (Borrowed from tufte-latex)
% Tighten up space between displays (e.g., a figure or table) and make symmetric
\setlength\abovedisplayskip{6pt plus 2pt minus 4pt}
\setlength\belowdisplayskip{6pt plus 2pt minus 4pt}

\setlength\columnseprule{.4pt}

% marginfigure and margintable
% (Code borrowed from the sidenotes package)
\newsavebox{\@sidenotes@marginfigurebox}
\newenvironment{marginfigure}[1][0pt]
{
  %\let\footnotemark\mpfootnotemark
  \FloatBarrier
  \mparshift{\mnotez@if@nblskip{#1}{\@cdr#1\@nil\baselineskip}{#1}}
  \begin{lrbox}{\@sidenotes@marginfigurebox}
	\begin{minipage}{\marginparwidth}
	  %\@margin@par
	  \captionsetup{type=figure}
	  %\captionsetup{type=marginfigure}
}
{
	\end{minipage}
  \end{lrbox}
  \marginpar{\usebox{\@sidenotes@marginfigurebox}}
  %\@body@par
}

\newsavebox{\@sidenotes@margintablebox}
\newenvironment{margintable}[1][0pt]
{
  \FloatBarrier
  \mparshift{\mnotez@if@nblskip{#1}{\@cdr#1\@nil\baselineskip}{#1}}
  \begin{lrbox}{\@sidenotes@margintablebox}
	\begin{minipage}{\marginparwidth}
	  %\captionsetup{type=table,style=margintable}
	  \captionsetup{type=table}
}
{
	\end{minipage}
  \end{lrbox}
  \marginpar{\usebox{\@sidenotes@margintablebox}}
}

% Figures and tables
\floatsetup[figure]{margins=hangoutside,
                    facing=yes,
                    capposition=beside,
					capbesideposition={top,outside},
					capbesideframe=yes,
                    floatwidth=\textwidth}
\floatsetup[widefigure]{margins=hangoutside,
                        facing=yes,
                        capposition=bottom}
\floatsetup[table]{margins=hangoutside,
                   facing=yes,
                   capposition=beside,
				   capbesideposition={top,outside},
				   capbesideframe=yes,
                   floatwidth=\textwidth}
\floatsetup[widetable]{margins=hangoutside,
                       facing=yes,
                       capposition=bottom}

% Captions
\DeclareCaptionFormat{margin}{\@margin@par #1#2#3}
\captionsetup{
  format=margin,
  %%hypcap=true, % links point to the top of the figure
  singlelinecheck=false,
  %width=\marginparwidth,
  indention=0pt,
  parindent=0pt,
  skip=10pt,
}

% }}}

% ENVIRONMENTS {{{

% Bullets
\renewcommand{\labelitemi}{$\blacktriangleright$}
\renewcommand{\labelitemii}{\textbullet}

% }}}

% BIBLIOGRAPHY {{{

% Bibliography
% In the future you might want to check this out: 
% https://tex.stackexchange.com/questions/244971/biblatex-order-of-entries-in-a-multi-citation
\RequirePackage[
	%style=numeric-comp,
	%citestyle=authortitle-icomp,
	citestyle=numeric-comp,
	%bibstyle=authoryear,
	bibstyle=numeric,
	sorting=none,
	%sorting=nyt,
	%sortcites=true,
	%autocite=footnote,
	backend=biber,
	hyperref=true,
	backref=true
]{biblatex}
\AtEveryBibitem{
	\clearfield{url}
	\clearfield{issn}
	\clearfield{isbn}
	\clearfield{archivePrefix}
	\clearfield{arxivId}
	\clearfield{pmid}
	\clearfield{eprint}
	\ifentrytype{book}{\clearfield{doi}}{}
}
%\DeclareLanguageMapping{english}{english-apa}
%\renewcommand{\cite}[2][0pt]{\sidenote[][#1]{\fullcite{#2}} }

\DefineBibliographyStrings{english}{%
  backrefpage = {page},% originally "cited on page"
  backrefpages = {pages},% originally "cited on pages"
}

% }}}

% HYPERREFERENCES {{{

\RequirePackage{hyperref}
\definecolor{greenforlinks}{rgb}{0.09, 0.45, 0.27}

\PassOptionsToPackage{hyphens}{url}
\hypersetup{
			unicode,
			pdfborder={0 0 0},
			%xetex,
			%pagebackref=true,
			%hyperfootnotes=false,
			bookmarksdepth=section,
			linktoc=all,
			breaklinks=true,
            colorlinks=true,
			allcolors=greenforlinks,
			%citecolor = DarkGreen,
			%linkcolor = DarkBlue,
			%pagecolor = DarkBlue,
			%urlcolor = DarkGreen,
}

% Formatting of back references
%\renewcommand*{\backref}[1]{}
%\renewcommand*{\backrefalt}[4]{{%
\newcommand*{\backref}[1]{}
\newcommand*{\backrefalt}[4]{{%
\ifcase#1 Not cited.%
\or{}Cited on page~#2.%
\else Cited on pages~#2.%
\fi%
}}

% Bookmarks
\BeforeTOCHead[toc]{%
  \cleardoublepage
    \edef\@tempa{%
      \noexpand\pdfbookmark[0]{\list@fname}{\@currext}%
    }\@tempa
}

% }}}
