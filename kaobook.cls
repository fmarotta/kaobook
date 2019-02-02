%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kaobook
% LaTeX Class
% Version 1.0 (2/2/19)
%
% This template originates from:
% http://www.LaTeXTemplates.com
%
% Authors:
% Federico Marotta (federicomarotta@mail.com)
% Based on the doctoral thesis of Ken Arroyo Ohori (https://3d.bk.tudelft.nl/ken/en)
% and on the Tufte-LaTeX class.
% Modified for LaTeX Templates by Vel (vel@LaTeXTemplates.com)
%
% License:
% GPL Version 3 (see included LICENSE file)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------------------------
%	CLASS CONFIGURATION
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kaobook}[2019/02/02 v1.0 kaobook class v1.0]

\newcommand{\@classname}{kaobook} % the name of the class 
\newcommand{\@baseclass}{scrbook} % the name of the base class

% Set the default options
\PassOptionsToClass{fontsize=9pt}{\@baseclass}
\PassOptionsToClass{parskip=half}{\@baseclass}
\PassOptionsToClass{toc=listof}{\@baseclass}
\PassOptionsToClass{toc=index}{\@baseclass}
\PassOptionsToClass{toc=bibliography}{\@baseclass}
\PassOptionsToClass{headings=optiontoheadandtoc}{\@baseclass}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\@baseclass}} % Pass through any options to the base class

\ProcessOptions\relax % Process the options

\LoadClass{\@baseclass} % Load the base class

%----------------------------------------------------------------------------------------
%	USEFUL PACKAGES AND COMMANDS
%----------------------------------------------------------------------------------------

% Load low-level packages required to implement the class
\RequirePackage{etoolbox}	% Easy programming to modify TeX stuff
\RequirePackage{calc}		% Make calculations
\RequirePackage{xifthen}	% Easy conditionals
\RequirePackage{xkeyval}	% Manage class options
\RequirePackage{xparse}		% Parse arguments for macros
\RequirePackage{xstring}	% Parse strings

%----------------------------------------------------------------------------------------
%	TITLE AND AUTHOR MACROS
%----------------------------------------------------------------------------------------

% Provide an optional argument to the \title command in which to store a 
% plain text title, without any formatting.
% Usage: \title[Plain Title]{Actual Title}
\newcommand{\@plaintitle}{}
\renewcommand{\title}[2][]{
  \gdef\@title{#2} % store the full title in @title
  \ifthenelse{\isempty{#1}}{ % if there is no plain title
	\renewcommand{\@plaintitle}{\title} % use full title
  }{ % if there is a plain title
	\renewcommand{\@plaintitle}{#1} % use provided plain-text title
  }
  \hypersetup{pdftitle={\@plaintitle}} % set the PDF metadata title
}

% Provide an optional argument to the \author command in which to store 
% a plain text author, without any formatting.
% Usage: \author[Plain Author]{Actual Author}
\newcommand{\@plainauthor}{}
\renewcommand{\author}[2][]{
  \gdef\@author{#2} % store the full author in @author
  \ifthenelse{\isempty{#1}}{ % if there is no plain author
	\renewcommand{\@plainauthor}{\author}% use full author
  }{ % if there is a plain author
	\renewcommand{\@plainauthor}{#1}% use provided plain-text author
  }
  \hypersetup{pdfauthor={\@plainauthor}} % set the PDF metadata author
}

% Make a bookmark to the title page
\pretocmd{\maketitle}{\pdfbookmark[1]{\@title}{title}}{}{}

%----------------------------------------------------------------------------------------
%	PARAGRAPH FORMATTING
%----------------------------------------------------------------------------------------

\RequirePackage{ragged2e}	% Required to achieve better ragged paragraphs
\RequirePackage{setspace}	% Required to easily set the space between lines

% TODO: recognize space/indent justified/raggedright class options

% Settings for a normal paragraph
\newcommand{\@body@par}{%
  \justifying% justify text
  \singlespacing% set the interline space to a single line
  \frenchspacing% no additional space after periods
  \normalfont% use the default font
  \normalsize% use the default size
}

% Settings for a paragraph in the margins
\newcommand{\@margin@par}{%
  \justifying% justify text
  \setlength{\RaggedRightParindent}{0em}% Suppress indentation
  \setlength{\parindent}{0em}% Suppress indentation
  \setlength{\parskip}{0.5pc}% set the space between paragraphs
  \singlespacing% set the space between lines
  \frenchspacing% no additional space after periods
  \normalfont% use the default font
  \footnotesize% use a smaller size
}

% By default, use @body@par settings
\@body@par

%----------------------------------------------------------------------------------------
%	FRONT-, MAIN-, BACK- MATTERS BEHAVIOUR
%----------------------------------------------------------------------------------------

% Front matter
\let\oldfrontmatter\frontmatter % store the old command
\renewcommand{\frontmatter}{
  \oldfrontmatter % first of all, call the old command

  \widepage % Use a wide page layout

  % Set some Lengths used for the page headers
  \newlength{\overflowingheadlen}
  \setlength{\overflowingheadlen}{\linewidth}
  \addtolength{\overflowingheadlen}{\marginparsep}
  \addtolength{\overflowingheadlen}{\marginparwidth}

  \pagestyle{plain.scrheadings} % Use a plain style for the header and the footer
  %\sloppy % Required to better break long lines
}

% Main matter
\let\oldmainmatter\mainmatter % store the old command
\renewcommand{\mainmatter}{
  \oldmainmatter % call the old command

  \marginpage % Use a 1.5 column layout

  % Set some Lengths used for the page headers
  \setlength{\overflowingheadlen}{\linewidth}
  \addtolength{\overflowingheadlen}{\marginparsep}
  \addtolength{\overflowingheadlen}{\marginparwidth}

  \pagestyle{scrheadings} % Use a fancy style for the header and the footer
}

% Appendix
%\let\oldappendix\appendix % store the old command
%\renewcommand{\appendix}{
  %\oldappendix % Call the cold command
  %\bookmarksetup{startatroot} % Reset the bookmark depth
%}

% Back matter
\let\oldbackmatter\backmatter % store the old command
\renewcommand{\backmatter}{
  \oldbackmatter % Call the cold command

  \widepage % Use a wide page layout

  % Set some Lengths used for the page headers
  \setlength{\overflowingheadlen}{\linewidth}
  \addtolength{\overflowingheadlen}{\marginparsep}
  \addtolength{\overflowingheadlen}{\marginparwidth}

  \bookmarksetup{startatroot} % Reset the bookmark depth
  \pagestyle{plain.scrheadings} % Use a plain style for the header and the footer
}

%----------------------------------------------------------------------------------------
%	FOOTNOTES, MARGINNOTES AND SIDENOTES
%----------------------------------------------------------------------------------------

\RequirePackage[section]{placeins}	% Prevent floats to cross sections

% Request more floats
\extrafloats{100}

%------------------------------------------------

\RequirePackage[
  bottom,
  symbol*,
  hang,
  flushmargin,
  perpage,
  stable,
]{footmisc}							% Required to set up the footnotes
\RequirePackage{footnotebackref}	% Creates back references from footnotes to text

% Fix the color of the footnote marker when back-referenced
\patchcmd{\footref}{\ref}{\hypersetup{colorlinks=black}\ref}{}{}
% Workaround to fix back references
\edef\BackrefFootnoteTag{bhfn:\theBackrefHyperFootnoteCounter}

% FIXME: I am not able to choose the paragraph layout of footnotes, 
% probably footnotes conflicts with scrbook.
%\renewcommand{\footnotelayout}{\@margin@par}

%------------------------------------------------

\RequirePackage{marginnote}			% Provides options for margin notes
\RequirePackage{marginfix}			% Make marginpars float freely

% Justify and format margin notes
\renewcommand*{\raggedleftmarginnote}{} % Suppress left margin
\renewcommand*{\raggedrightmarginnote}{} % Suppress right margin
\renewcommand*{\marginfont}{\@margin@par} % Format marginnotes according to \@marginpar (see above)
\renewcommand{\marginnotevadjust}{-8.5pt} % Bring all marginnotes upward a bit
\RequirePackage[marginnote=true]{snotez}	% Provides options for sidenotes

% Redefine the command to print marginnotes:
% (a) the optional offset argument goes at the first position
% (b) the offset can also be a multiple of baselineskip, like for
%     snotez's \sidenote
% Usage: \marginnote[<offset>]{Text of the note.}
\let\oldmarginnote\marginnote
\renewcommand{\marginnote}[2][0pt]{
  \oldmarginnote{#2}[\snotez@if@nblskip{#1}{\@cdr#1\@nil\baselineskip}{#1}]
}

% Formatting sidenotes
\setsidenotes{
	text-mark-format=\textsuperscript{\normalfont#1}, % Use a superscript for the marker in the text
	note-mark-format=#1:, % Use a normal font for the marker in the margin; use a colon after the sidenote number
	note-mark-sep=\enskip, % Set the space after the marker
}

%------------------------------------------------

\RequirePackage{chngcntr}	% Allows to reset the sidenotes counter at each chapter

% If you want to reset the sidenote counter at each chapter,
% 1) comment `\counterwithout{sidenote}{chapter}'
% 2) uncomment `\newcommand{pp@g@sidenote}{}'
%
% If you want only one counter for the entire document,
% 1) uncomment `\counterwithout{sidenote}{chapter}'
% 2) comment `\newcommand{pp@g@sidenote}{}'

%\counterwithout{sidenote}{chapter}
\newcommand{\pp@g@sidenote}{}

% NOTE: the definition of \pp@g@sidenote is a small workaround in order 
% to fix the behaviour of chngcntr.

%----------------------------------------------------------------------------------------
%	FIGURES, TABLES AND CAPTIONS
%----------------------------------------------------------------------------------------

\RequirePackage{graphicx}				% Include figures
\setkeys{Gin}{width=\linewidth,totalheight=\textheight,keepaspectratio} % Improves figure scaling
\RequirePackage{booktabs}               % Nicer tables
\RequirePackage{multirow}               % Cells occupying multiple rows in tables
\RequirePackage{multicol}               % Multiple columns in dictionary
\RequirePackage[hypcap=true]{caption}   % Correctly placed anchors for hyperlinks
\RequirePackage{scrhack}				% Force KOMA to like floatrow
\RequirePackage{floatrow}               % Set up captions of floats

% Improve the figure placing
% (See https://www.overleaf.com/learn/latex/Tips)
\def\topfraction{.9}
\def\textfraction{0.35}
\def\floatpagefraction{0.8}

% Set the space between floats and main text
\renewcommand\FBaskip{.4\topskip}
\renewcommand\FBbskip{\FBaskip}

% (Borrowed from tufte-latex)
% Tighten up space between displays (e.g., equations) and make symmetric
\setlength\abovedisplayskip{6pt plus 2pt minus 4pt}
\setlength\belowdisplayskip{6pt plus 2pt minus 4pt}
\abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
\abovedisplayshortskip \z@ \@plus3\p@
\belowdisplayskip \abovedisplayskip
\belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@

\setlength\columnseprule{.4pt} % Set the width of vertical rules in tables

% (Code borrowed from the sidenotes package)
% Environment to hold a margin figure
\newsavebox{\@sidenotes@marginfigurebox}
\newenvironment{marginfigure}[1][0pt] % The optional parameter is the vertical offset
{
  %\let\footnotemark\mpfootnotemark
  \FloatBarrier % Force LaTeX to place previous floats
  \mparshift{\snotez@if@nblskip{#1}{\@cdr#1\@nil\baselineskip}{#1}} % Move the figure up or down according to the offset argument
  \begin{lrbox}{\@sidenotes@marginfigurebox}
	\begin{minipage}{\marginparwidth}
	  \captionsetup{type=figure}
}
{
	\end{minipage}
  \end{lrbox}
  \marginpar{\usebox{\@sidenotes@marginfigurebox}} % Place the figure box in the margin
}

% (Code borrowed from the sidenotes package)
% Environment to hold a margin table
\newsavebox{\@sidenotes@margintablebox}
\newenvironment{margintable}[1][0pt] % The optional parameter is the vertical offset
{
  \FloatBarrier % Force LaTeX to place previous floats
  \mparshift{\snotez@if@nblskip{#1}{\@cdr#1\@nil\baselineskip}{#1}} % Move the table up or down according to the offset argument
  \begin{lrbox}{\@sidenotes@margintablebox}
	\begin{minipage}{\marginparwidth}
	  %\captionsetup{type=table,style=margintable}
	  \captionsetup{type=table}
	  \centering
}
{
	\end{minipage}
  \end{lrbox}
  \marginpar{\usebox{\@sidenotes@margintablebox}} % Place the table box in the margin
}

% Change the position of the captions
\floatsetup[figure]{				% Captions for figueres
	margins=hangoutside,			% Put captions in the margins
	facing=yes,
	capposition=beside,
	capbesideposition=outside,
	capbesideframe=yes,
	capbesidewidth=\marginparwidth, % Width of the caption equal to the width of the margin
	floatwidth=sidefil,				% Width of the figure equal to the width of the text
}
\floatsetup[widefigure]{			% Captions for wide figures
	margins=hangoutside,			% Put captions below the figure
	facing=yes,
	capposition=bottom
}
\floatsetup[table]{					% Captions for tables
	margins=hangoutside,			% Put captions in the margin
	facing=yes,
	capposition=beside,
	capbesideposition=outside,
	capbesideframe=yes,
	capbesidewidth=\marginparwidth, % Width of the caption equal to the width of the margin
	floatwidth=sidefil,				% Width of the figure equal to the width of the text
}
\floatsetup[widetable]{				% Captions for wide tables
	margins=hangoutside,			% Put captions below the table
	facing=yes,
	capposition=bottom
}

% Change the formatting of the captions
\addtokomafont{captionlabel}{\bfseries}	% Bold font for the figure label
\DeclareCaptionFormat{margin}{\@margin@par #1#2#3}	% Declare a new style to format the caption according to \@margin@par (see above)
\captionsetup{
	format=margin,	% Use the style previously declared
	strut=no,
	%%hypcap=true, % links point to the top of the figure
	singlelinecheck=false,
	%width=\marginparwidth,
	indention=0pt,	% Suppress indentation
	parindent=0pt,	% Suppress space between paragraphs
	skip=-15pt,		% Decrease the space between the figure and the caption
}

%----------------------------------------------------------------------------------------
%	MARGIN TOC
%----------------------------------------------------------------------------------------

\RequirePackage{etoc}	% Required to insert local tables of contents

\newlength{\mtocshift} % Length of the vertical offset used for margin tocs
\setlength{\mtocshift}{-5.2cm}

% Command to print a table of contents in the margin
\newcommand{\margintoc}[1][\mtocshift]{ % The first parameter is the vertical offset; by default it is \mtocshift
  \begingroup
	% Set the style for section entries
	\etocsetstyle{section}
	{\parindent -5pt \parskip 0pt}
	{\leftskip 0pt}
	{\makebox[.5cm]{\etocnumber\autodot}
	\etocname\nobreak\leaders\hbox{\hbox to 1.5ex {\hss.\hss}}\hfill\nobreak
	\etocpage\par}
	{}
	% Set the style for subsection entries
	\etocsetstyle{subsection}
	{\parindent -5pt \parskip 0pt}
	{\leftskip 0pt}
	{\makebox[.5cm]{}
	\etocname\nobreak\leaders\hbox{\hbox to 1.5ex {\hss.\hss}}\hfill\nobreak
	\etocpage\par}
	{}
	% Set the global style of the toc
	%\etocsettocstyle{}{}
	%\etocsettocstyle{\normalfont\sffamily\normalsize}{}
	%\etocsettocstyle{\usekomafont{section}\small}{}
	\etocsettocstyle{\usekomafont{chapterentry}\small}{}
	\etocsetnexttocdepth{subsection}
	% Print the table of contents in the margin
	\marginnote[#1]{\localtableofcontents}
  \endgroup
}

%----------------------------------------------------------------------------------------
%	 BIBLIOGRAPHY
%----------------------------------------------------------------------------------------

% Load biblatex and set the style
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
	backref=true,
	citecounter=true,
	citetracker=true,
]{biblatex}

% Remove some unwanted entries from the bibliography
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

% Set the back reference strings
\DefineBibliographyStrings{english}{%
  backrefpage = {cited on page},
  backrefpages = {cited on pages},
}

% Command to print a citation in the margins
\NewDocumentCommand{\sidecite}{m}{% The parameter is the citation key
  \cite{#1}% With this we print the marker in the text and add the item to the bibliography at the end
  \margincitation{#1}% We then pass the cited items to this command, \margincitation
}

% Command to split the cited items and execute an action for each of them
\NewDocumentCommand{\margincitation}{ >{\SplitList{,}} m }{% The parameter is a comma-separated list of citation keys, which is splitted into single items
  \marginnote[-1.2pt]{\ProcessList{#1}{\formatmargincitation}}% Create a marginnote for each item
}

% Command to format the marginnote created for cited items
\NewDocumentCommand{\formatmargincitation}{m}{% The parameter is a single citation key
  \parencite{#1}: \citeauthor*{#1} (\citeyear{#1}), \citetitle{#1}\\
}

%----------------------------------------------------------------------------------------
%	HYPERREFERENCES
%----------------------------------------------------------------------------------------

\RequirePackage{hyperref}	% Required for hyperlinks
\RequirePackage{bookmark}	% Required for pdf bookmarks

\PassOptionsToPackage{hyphens}{url}	% Break long URLs and use hyphens to separate the pieces

\hypersetup{				% Set up hyperref options
	unicode,				% Use unicode for links
	pdfborder={0 0 0},		% Suppress border around pdf
	%xetex,
	%pagebackref=true,
	%hyperfootnotes=false,	% We already use footmisc
	bookmarksdepth=section,
	bookmarksopen=true,		% Expand the bookmarks as soon as the pdf file is opened
	%bookmarksopenlevel=4,
	linktoc=all,			% Toc entries and numbers links to pages
	breaklinks=true,
	colorlinks=true,
	%allcolors=DarkGreen,
	citecolor = DarkOrange,
	linkcolor = DarkBlue,
	%pagecolor = DarkBlue,
	urlcolor = DarkGreen,
}

% Define a new color for the footnote marks
\def\@footnotecolor{black}
\define@key{Hyp}{footnotecolor}{%
 \HyColor@HyperrefColor{#1}\@footnotecolor%
}
\def\@footnotemark{%
    \leavevmode
    \ifhmode\edef\@x@sf{\the\spacefactor}\nobreak\fi
    \stepcounter{Hfootnote}%
    \global\let\Hy@saved@currentHref\@currentHref
    \hyper@makecurrent{Hfootnote}%
    \global\let\Hy@footnote@currentHref\@currentHref
    \global\let\@currentHref\Hy@saved@currentHref
    \hyper@linkstart{footnote}{\Hy@footnote@currentHref}%
    \@makefnmark
    \hyper@linkend
    \ifhmode\spacefactor\@x@sf\fi
    \relax
}

% Adjust the colour of the footnotes marks using the colour defined 
% above
\renewcommand\@makefntext[1]{%
	\renewcommand\@makefnmark{%
		\mbox{\textsuperscript{\normalfont%
			\hyperref[\BackrefFootnoteTag]{%
				\color{\@footnotecolor}{\@thefnmark}%
			}}\,%
		}%
	}%
	\BHFN@OldMakefntext{#1}%
}

% THINGS THAT I DON'T KNOW WHERE TO PLACE

\setcounter{secnumdepth}{1}	% Number only up to sections

\renewcommand{\hrulefill}[1][0.4pt]{%
	\leavevmode\leaders\hrule height #1\hfill\kern\z@%
}

\RequirePackage{hyphenat}	% Hyphenation for special fonts
\RequirePackage{microtype}	% Improves character and word spacing
\RequirePackage[usenames,svgnames]{xcolor}	% 

\RequirePackage{ifxetex}	% Detect if we are using XeLaTeX

% Polyglossia must be set up before biblatex
% The language can be changed later
\ifxetex
  \RequirePackage{polyglossia}
  \setdefaultlanguage{english}
\fi


