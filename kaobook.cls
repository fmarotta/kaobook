\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kaobook}[2019/01/01 v0.0.1 kaobook class]

\newcommand{\@classname}{kaobook} % the name of the class 
\newcommand{\@baseclass}{scrbook} % the name of the base class 

% Load low-level packages required for programming
\RequirePackage{etoolbox}	% Easy programming to modify TeX stuff
\RequirePackage{calc}		% Make calculations
\RequirePackage{xifthen}	% Easy conditionals
\RequirePackage{xkeyval}	% Manage class options
\RequirePackage{xparse}		% Parse arguments to macros
\RequirePackage{xstring}	% Parse strings

% CLASS OPTIONS {{{

\newboolean{@option@justified}
\DeclareOption{justified}{
  \setboolean{@option@justified}{true}
}
\newboolean{@option@raggedright}
\DeclareOption{raggedright}{
  \setboolean{@option@raggedright}{true}
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
%\DeclareOption{onecolumn}{\OptionNotUsed}
%\DeclareOption{twocolumn}{\OptionNotUsed}
%\DeclareOption{landscape}{\OptionNotUsed}

% Pass the other options to the base class
\DeclareOption*{
  \PassOptionsToClass{\CurrentOption}{\@baseclass}
}

% Set default options
\PassOptionsToClass{fontsize=9pt}{\@baseclass}
\PassOptionsToClass{parskip=half}{\@baseclass}
\PassOptionsToClass{toc=listof}{\@baseclass}
\PassOptionsToClass{toc=index}{\@baseclass}
\PassOptionsToClass{toc=bibliography}{\@baseclass}
\PassOptionsToClass{headings=optiontoheadandtoc}{\@baseclass}
%\ExecuteOptions{justify}

% Process the options
\ProcessOptions\relax

% Use the KOMA scrbook class as template
\LoadClass{scrbook}

% }}}

% DOCUMENT STRUCTURE {{{

% TOC
\RequirePackage{tocbasic}
\RequirePackage{etoc}
\setuptoc{toc}{totoc}

% Actual document structure
\setcounter{secnumdepth}{1}

\newcommand\partentrynumberformat[1]{\partname\ #1}
\RedeclareSectionCommand[
  tocentrynumberformat=\partentrynumberformat,
  tocnumwidth=5.5em
]{part}

\newcommand{\@plaintitle}{}
\renewcommand{\title}[2][]{
  \gdef\@title{#2}
  \ifthenelse{\isempty{#1}}%
  {
	\renewcommand{\@plaintitle}{\title}% use full title
  }
  {
	\renewcommand{\@plaintitle}{#1}% use provided plain-text title
  }
  \hypersetup{pdftitle={\@plaintitle}} % set the PDF metadata title
}

\newcommand{\@plainauthor}{}
\renewcommand{\author}[2][]{
  \gdef\@author{#2}
  \ifthenelse{\isempty{#1}}%
  {
	\renewcommand{\@plainauthor}{\author}% use full author
  }
  {
	\renewcommand{\@plainauthor}{#1}% use provided plain-text author
  }
  \hypersetup{pdfauthor={\@plainauthor}} % set the PDF metadata author
}

\pretocmd{\maketitle}{\pdfbookmark[1]{\@title}{title}}{}{}

% }}}

% COLORS AND FONTS, ENCODING {{{

\RequirePackage[utf8]{inputenc}	% utf8 encoding in the input (.tex) file
\RequirePackage{hyphenat}					% Hyphenation for special fonts
\RequirePackage{microtype} % Improves character and word spacing
\RequirePackage[usenames,dvipsnames,svgnames]{xcolor}

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
  %\onehalfspacing%
  %\setstretch{1.05}
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
  %\color{blue}%
}

% By default, use @body@par specifications
\@body@par

% }}}

% PAGE LAYOUT {{{

\RequirePackage{scrlayer-scrpage}       % Customise head and foot regions
\setlength{\headheight}{115pt}			% Enlarge the header

% Headings styles
\renewpagestyle{scrheadings}{
  {\hspace{-\marginparwidth}\hspace{-\marginparsep}%
	\makebox[\overflowingheadlen][l]{\makebox[2em][r]{\thepage}%
	\quad\rule{1pt}{100pt}\quad{}\leftmark}}%
  {\makebox[\overflowingheadlen][r]{\rightmark\quad\rule{1pt}{100pt}%
	\quad\makebox[2em][l]{\thepage}} }%
  {\makebox[\overflowingheadlen][r]{\rightmark\quad\rule{1pt}{100pt}%
	\quad\makebox[2em][l]{\thepage}} }%
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
  {}%
  {}%
  {}
}

\let\oldfrontmatter\frontmatter
\renewcommand{\frontmatter}{
  \oldfrontmatter

  % Shrink the margins
  \widepage

  % Lengths used for page head
  \newlength{\overflowingheadlen}
  \setlength{\overflowingheadlen}{\linewidth}
  \addtolength{\overflowingheadlen}{\marginparsep}
  \addtolength{\overflowingheadlen}{\marginparwidth}

  \pagestyle{plain.scrheadings}
  \sloppy
}

\let\oldmainmatter\mainmatter
\renewcommand{\mainmatter}{
  \oldmainmatter

  % Enlarge the margins
  \marginpage

  % Lengths used for page head
  %\newlength{\overflowingheadlen}
  \setlength{\overflowingheadlen}{\linewidth}
  \addtolength{\overflowingheadlen}{\marginparsep}
  \addtolength{\overflowingheadlen}{\marginparwidth}

  \pagestyle{scrheadings}
}

\let\oldappendix\appendix
\renewcommand{\appendix}{
  \oldappendix
  \bookmarksetup{startatroot}
}

\let\oldbackmatter\backmatter
\renewcommand{\backmatter}{
  \oldbackmatter

  % Shrink the margins
  \widepage

  % Lengths used for page head
  %\newlength{\overflowingheadlen}
  \setlength{\overflowingheadlen}{\linewidth}
  \addtolength{\overflowingheadlen}{\marginparsep}
  \addtolength{\overflowingheadlen}{\marginparwidth}

  \bookmarksetup{startatroot}
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
\RequirePackage{marginnote}
\RequirePackage{marginfix}              % Make marginpars float freely
\RequirePackage[section]{placeins}		% prevent floats to cross sections
\RequirePackage[marginnote=true]{snotez}	% For sidenotes

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
\renewcommand{\marginnotevadjust}{-11pt}

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
\RequirePackage{chngcntr}
\counterwithout{sidenote}{chapter}
%\newcommand{\pp@g@sidenote}{}

% }}}

% FIGURES, TABLES AND CAPTIONS {{{

\RequirePackage{graphicx}
%\RequirePackage{subfig}                 % Subfigures
\setkeys{Gin}{width=\linewidth,totalheight=\textheight,keepaspectratio} % Improves figure scaling
\RequirePackage{booktabs}               % Nicer tables
\RequirePackage{multirow}               % Cells occupying multiple rows in tables
\RequirePackage{multicol}               % Multiple columns in dictionary
\RequirePackage[hypcap=true]{caption}   % Correctly placed anchors for hyperlinks
\RequirePackage{scrhack}				% Force KOMA to like floatrow
\RequirePackage{floatrow}               % Set up captions of floats

% Space between float box and main text
\renewcommand\FBaskip{4pt}
\renewcommand\FBbskip{4pt}

%% (Borrowed from tufte-latex)
% Tighten up space between displays (e.g., equations) and make symmetric
\setlength\abovedisplayskip{6pt plus 2pt minus 4pt}
\setlength\belowdisplayskip{6pt plus 2pt minus 4pt}

%\setlength\columnseprule{.4pt}

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
					capbesideposition=outside,
					%capbesideposition=outside,
					capbesideframe=yes,
					capbesidewidth=\marginparwidth,
					floatwidth=sidefil}
\floatsetup[widefigure]{margins=hangoutside,
                        facing=yes,
                        capposition=bottom}
\floatsetup[table]{margins=hangoutside,
                   facing=yes,
                   capposition=beside,
				   capbesideposition=outside,
				   capbesideframe=yes,
				   capbesidewidth=\marginparwidth,
				   floatwidth=sidefil}
\floatsetup[widetable]{margins=hangoutside,
                       facing=yes,
                       capposition=bottom}

% Captions
%\setkomafont{captionlabel}{\@margin@par}
\DeclareCaptionFormat{margin}{\@margin@par #1#2#3}
\DeclareCaptionFormat{marginemph}{\@margin@par\bfseries #1#2#3}
\captionsetup{
  format=margin,
  strut=no,
  %%hypcap=true, % links point to the top of the figure
  singlelinecheck=false,
  %width=\marginparwidth,
  indention=0pt,
  parindent=0pt,
  skip=-15pt,
}

% }}}

% MARGIN TOC {{{

\newcommand{\margintoc}[1][*-2.9]{
  \begingroup
	\etocsetstyle{section}
	{\parindent -5pt \parskip 0pt}
	{\leftskip 0pt}
	{\makebox[.8cm]{\etocnumber\autodot}
	\etocname\nobreak\leaders\hbox{\hbox to .75ex {\hss.\hss}}\hfill\nobreak
	\etocpage\par}
	{}
	\etocsetstyle{subsection}
	{\parindent -5pt \parskip 0pt}
	{\leftskip 0pt}
	{\makebox[.8cm]{}
	\etocname\nobreak\hfill\nobreak\par}
	{}
	\etocsettocstyle{\usekomafont{dictum}}{}
	\etocsetnexttocdepth{subsection}
	\marginnote[#1]{\localtableofcontents}
  \endgroup
}

% }}}

% ENVIRONMENTS {{{

% Bullets
\RequirePackage{amssymb}        % AMS symbols and environments
\renewcommand{\labelitemi}{\footnotesize$\blacktriangleright$}
\renewcommand{\labelitemii}{\textbullet}

% }}}

% BIBLIOGRAPHY {{{

\NewDocumentCommand{\sidecite}{m}{%
  \cite{#1}%
  \margincitation{#1}%
}
\NewDocumentCommand{\margincitation}{ >{\SplitList{,}} m }{%
  \marginnote{\ProcessList{#1}{\formatmargincitation}}
}
\NewDocumentCommand{\formatmargincitation}{m}{%
  \parencite{#1}: \citeauthor*{#1} (\citeyear{#1}), \citetitle{#1}\\
}

% }}}

% HYPERREFERENCES {{{

\RequirePackage{hyperref}
\RequirePackage{bookmark}
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
			%allcolors=greenforlinks,
			citecolor = DarkGreen,
			linkcolor = DarkBlue,
			%pagecolor = DarkBlue,
			urlcolor = DarkGreen,
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

% }}}
