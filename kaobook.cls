%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kaobook
% LaTeX Class
% Version 1.0 (28/4/19)
%
% This template originates from:
% https://www.LaTeXTemplates.com
%
% Authors:
% Federico Marotta (federicomarotta@mail.com)
% Based on the doctoral thesis of Ken Arroyo Ohori (https://3d.bk.tudelft.nl/ken/en)
% and on the Tufte-LaTeX class.
% Modified for LaTeX Templates by Vel (vel@latextemplates.com)
%
% License:
% GPL Version 3 (see included LICENSE file)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------------------------
%	CLASS CONFIGURATION
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kaobook}[2019/04/28 v1.0 kaobook class v1.0]

\newcommand{\@classname}{kaobook} % Class name
\newcommand{\@baseclass}{scrbook} % Base class name

% Set the default options
\PassOptionsToClass{fontsize=9.5pt}{\@baseclass}
\PassOptionsToClass{parskip=half}{\@baseclass}
\PassOptionsToClass{headings=optiontoheadandtoc}{\@baseclass}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\@baseclass}} % Pass through any options to the base class

\ProcessOptions\relax % Process the options

\LoadClass{\@baseclass} % Load the base class

%----------------------------------------------------------------------------------------
%	USEFUL PACKAGES AND COMMANDS
%----------------------------------------------------------------------------------------

\RequirePackage{etoolbox} % Easy programming to modify TeX stuff
\RequirePackage{calc} % Make calculations
\RequirePackage{xifthen} % Easy conditionals
\RequirePackage{xkeyval} % Manage class options
\RequirePackage{xparse} % Parse arguments for macros
\RequirePackage{xstring} % Parse strings

%----------------------------------------------------------------------------------------
%	TITLE AND AUTHOR MACROS
%----------------------------------------------------------------------------------------

% Provide an optional argument to the \title command in which to store a plain text title, without any formatting
% Usage: \title[Plain Title]{Actual Title}
\newcommand{\@plaintitle}{}
\renewcommand{\title}[2][]{
	\gdef\@title{#2} % Store the full title in @title
	\ifthenelse{\isempty{#1}}{ % If there is no plain title
		\renewcommand{\@plaintitle}{\title} % Use full title
	}{ % If there is a plain title
		\renewcommand{\@plaintitle}{#1} % Use provided plain-text title
	}
	\hypersetup{pdftitle={\@plaintitle}} % Set the PDF metadata title
}

% Provide an optional argument to the \author command in which to store a plain text author, without any formatting
% Usage: \author[Plain Author]{Actual Author}
\newcommand{\@plainauthor}{}
\renewcommand{\author}[2][]{
	\gdef\@author{#2} % Store the full author in @author
	\ifthenelse{\isempty{#1}}{ % If there is no plain author
		\renewcommand{\@plainauthor}{\author}% Use full author
  	}{ % If there is a plain author
		\renewcommand{\@plainauthor}{#1}% Use provided plain-text author
	}
	\hypersetup{pdfauthor={\@plainauthor}} % Set the PDF metadata author
}

% Make a bookmark to the title page
\pretocmd{\maketitle}{\pdfbookmark[1]{\@plaintitle}{title}}{}{}

%----------------------------------------------------------------------------------------
%	PARAGRAPH FORMATTING
%----------------------------------------------------------------------------------------

\RequirePackage{ragged2e} % Required to achieve better ragged paragraphs
\RequirePackage{setspace} % Required to easily set the space between lines
\RequirePackage{hyphenat} % Hyphenation for special fonts
\RequirePackage{microtype} % Improves character and word spacing
\RequirePackage{needspace} % Required to prevent page break right after a sectioning command
\RequirePackage{xspace} % Better print trailing whitespace
\RequirePackage[usenames,dvipsnames]{xcolor} % Colours

% TODO: recognize space/indent justified/raggedright class options

%------------------------------------------------

% Settings for a normal paragraph
\newcommand{\@body@par}{%
	\justifying% Justify text
	\singlespacing% Set the interline space to a single line
	\frenchspacing% No additional space after periods
	\normalfont% Use the default font
	\normalsize% Use the default size
}

%------------------------------------------------

% Settings for a paragraph in the margins
\newcommand{\@margin@par}{%
	\justifying% justify text
	\setlength{\RaggedRightParindent}{0em}% Suppress indentation
	\setlength{\parindent}{0em}% Suppress indentation
	\setlength{\parskip}{0.5pc}% Set the space between paragraphs
	%\singlespacing% Set the space between lines
	\frenchspacing% No additional space after periods
	\normalfont% Use the default font
	\footnotesize% Use a smaller size
}

%------------------------------------------------

% By default, use @body@par settings
\@body@par

%----------------------------------------------------------------------------------------
%	FRONT-, MAIN-, BACK- MATTERS BEHAVIOUR
%----------------------------------------------------------------------------------------

% Front matter
\let\oldfrontmatter\frontmatter % Store the old command
\renewcommand{\frontmatter}{
	\oldfrontmatter % First of all, call the old command

	% Set some Lengths used for the page headers
	\newlength{\overflowingheadlen}
	\setlength{\overflowingheadlen}{\linewidth}
	\addtolength{\overflowingheadlen}{\marginparsep}
	\addtolength{\overflowingheadlen}{\marginparwidth}

	\pagestyle{plain.scrheadings} % Use a plain style for the header and the footer
	\pagelayout{wide} % Use a wide page layout
	%\sloppy % Required to better break long lines
}

%------------------------------------------------

% Main matter
\let\oldmainmatter\mainmatter % Store the old command
\renewcommand{\mainmatter}{
	\oldmainmatter % Call the old command

	% Set some Lengths used for the page headers
	\setlength{\overflowingheadlen}{\linewidth}
	\addtolength{\overflowingheadlen}{\marginparsep}
	\addtolength{\overflowingheadlen}{\marginparwidth}

	\pagestyle{scrheadings} % Use a fancy style for the header and the footer
	\pagelayout{margin} % Use a 1.5 column layout
}

%------------------------------------------------

% Appendix
\let\oldappendix\appendix % Store the old command
\renewcommand{\appendix}{
	\oldappendix % Call the old command
	\bookmarksetup{startatroot} % Reset the bookmark depth
}

%------------------------------------------------

% Back matter
\let\oldbackmatter\backmatter % Store the old command
\renewcommand{\backmatter}{
	\oldbackmatter % Call the old command

	% Set some Lengths used for the page headers
	\setlength{\overflowingheadlen}{\linewidth}
	\addtolength{\overflowingheadlen}{\marginparsep}
	\addtolength{\overflowingheadlen}{\marginparwidth}

	\bookmarksetup{startatroot} % Reset the bookmark depth
	\pagestyle{plain.scrheadings} % Use a plain style for the header and the footer
	\pagelayout{wide} % Use a wide page layout
}

%----------------------------------------------------------------------------------------
%	FOOTNOTES, MARGINNOTES AND SIDENOTES
%----------------------------------------------------------------------------------------

\RequirePackage[section]{placeins} % Prevent floats to cross sections

% Request more floats
\extrafloats{100}

%------------------------------------------------

% TODO: see also page 440 of the KOMA-script guide

\RequirePackage[
	bottom,
	symbol*,
	hang,
	flushmargin,
	perpage,
	stable,
]{footmisc} % Required to set up the footnotes
\RequirePackage{footnotebackref} % Creates back references from footnotes to text

% Fix the color of the footnote marker when back-referenced
\patchcmd{\footref}{\ref}{\hypersetup{colorlinks=black}\ref}{}{}
% Workaround to fix back references
\edef\BackrefFootnoteTag{bhfn:\theBackrefHyperFootnoteCounter}

% FIXME: I am not able to choose the paragraph layout of footnotes, probably the footnotes package conflicts with scrbook.
%\renewcommand{\footnotelayout}{\@margin@par}

%------------------------------------------------

\RequirePackage{marginnote} % Provides options for margin notes
\RequirePackage{marginfix} % Make marginpars float freely

% Justify and format margin notes
\renewcommand*{\raggedleftmarginnote}{} % Suppress left margin
\renewcommand*{\raggedrightmarginnote}{} % Suppress right margin
\renewcommand*{\marginfont}{\@margin@par} % Format marginnotes according to \@marginpar (see above)
\renewcommand{\marginnotevadjust}{3pt} % Bring all marginnotes downward a bit
\RequirePackage[marginnote=true]{snotez} % Provides options for sidenotes

% Redefine the command to print marginnotes:
% (a) the optional offset argument goes at the first position
% (b) the offset can also be a multiple of baselineskip, like for snotez's \sidenote
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

%----------------------------------------------------------------------------------------
%	FIGURES, TABLES AND CAPTIONS
%----------------------------------------------------------------------------------------

\RequirePackage{graphicx} % Include figures
\setkeys{Gin}{width=\linewidth,totalheight=\textheight,keepaspectratio} % Improves figure scaling
\RequirePackage{tikz} % Allows to draw custom shapes
\RequirePackage{booktabs} % Nicer tables
\RequirePackage{multirow} % Cells occupying multiple rows in tables
\RequirePackage{multicol} % Multiple columns in dictionary
\RequirePackage[hypcap=true]{caption} % Correctly placed anchors for hyperlinks
\RequirePackage{atbegshi}
\RequirePackage{perpage}
\let\c@abspage\relax
\newcommand{\pp@g@sidenote}{}
\RequirePackage[nomencl=false]{scrhack} % Force KOMA to like floatrow
\RequirePackage{floatrow} % Set up captions of floats
\RequirePackage{dblfloatfix} % Better positioning of wide figures and tables


% Improve the figure placing (see https://www.overleaf.com/learn/latex/Tips)
\def\topfraction{.9}
\def\textfraction{0.35}
\def\floatpagefraction{0.8}

% Set the space between floats and main text
\renewcommand\FBaskip{.4\topskip}
\renewcommand\FBbskip{\FBaskip}

% Tighten up space between displays (e.g., equations) and make symmetric (from tufte-latex)
\setlength\abovedisplayskip{6pt plus 2pt minus 4pt}
\setlength\belowdisplayskip{6pt plus 2pt minus 4pt}
\abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
\abovedisplayshortskip \z@ \@plus3\p@
\belowdisplayskip \abovedisplayskip
\belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@

\setlength\columnseprule{.4pt} % Set the width of vertical rules in tables

% Environment to hold a margin figure (from the sidenotes package)
\newsavebox{\@sidenotes@marginfigurebox}
\newenvironment{marginfigure}[1][0pt]{ % The optional parameter is the vertical offset
	%\let\footnotemark\mpfootnotemark
	\FloatBarrier % Force LaTeX to place previous floats
	\mparshift{\snotez@if@nblskip{#1}{\@cdr#1\@nil\baselineskip}{#1}} % Move the figure up or down according to the offset argument
	\begin{lrbox}{\@sidenotes@marginfigurebox}
		\begin{minipage}{\marginparwidth}
			\captionsetup{type=figure}
}{
		\end{minipage}
	\end{lrbox}
	\marginpar{\usebox{\@sidenotes@marginfigurebox}} % Place the figure box in the margin
}

% Environment to hold a margin table (from the sidenotes package)
\newsavebox{\@sidenotes@margintablebox}
\newenvironment{margintable}[1][0pt]{ % The optional parameter is the vertical offset
	\FloatBarrier % Force LaTeX to place previous floats
	\mparshift{\snotez@if@nblskip{#1}{\@cdr#1\@nil\baselineskip}{#1}} % Move the table up or down according to the offset argument
	\begin{lrbox}{\@sidenotes@margintablebox}
		\begin{minipage}{\marginparwidth}
			%\captionsetup{type=table,style=margintable}
			\captionsetup{type=table}
			\centering
}{
		\end{minipage}
	\end{lrbox}
	\marginpar{\usebox{\@sidenotes@margintablebox}} % Place the table box in the margin
}

% Change the position of the captions
\DeclareFloatSeparators{marginparsep}{\hskip\marginparsep}
\if@twoside
	\floatsetup[figure]{ % Captions for figueres
		margins=hangoutside, % Put captions in the margins
		facing=yes,
		capposition=beside,
		capbesideposition={bottom,outside},
		capbesideframe=yes,
		capbesidewidth=\marginparwidth, % Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,
		floatwidth=\textwidth, % Width of the figure equal to the width of the text
	}
	\floatsetup[widefigure]{ % Captions for wide figures
		margins=hangoutside, % Put captions below the figure
		facing=yes,
		capposition=bottom
	}
	\floatsetup[table]{ % Captions for tables
		margins=hangoutside, % Put captions in the margin
		facing=yes,
		capposition=beside,
		capbesideposition={top,outside},
		%capbesideposition=outside,
		capbesideframe=yes,
		capbesidewidth=\marginparwidth, % Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,
		floatwidth=\textwidth, % Width of the figure equal to the width of the text
	}
	\floatsetup[widetable]{ % Captions for wide tables
		margins=hangoutside, % Put captions above the table
		facing=yes,
		capposition=above
	}
\else
	\floatsetup[figure]{ % Captions for figueres
		margins=hangright, % Put captions in the margins
		facing=yes,
		capposition=beside,
		capbesideposition={bottom,right},
		capbesideframe=yes,
		capbesidewidth=\marginparwidth, % Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,
		floatwidth=\textwidth, % Width of the figure equal to the width of the text
	}
	\floatsetup[widefigure]{ % Captions for wide figures
		margins=hangright, % Put captions below the figure
		facing=no,
		capposition=bottom
	}
	\floatsetup[table]{ % Captions for tables
		margins=hangright, % Put captions in the margin
		facing=yes,
		capposition=beside,
		capbesideposition={top,right},
		%capbesideposition=outside,
		capbesideframe=yes,
		capbesidewidth=\marginparwidth, % Width of the caption equal to the width of the margin
		capbesidesep=marginparsep,
		floatwidth=\textwidth, % Width of the figure equal to the width of the text
	}
	\floatsetup[widetable]{ % Captions for wide tables
		margins=hangright, % Put captions above the table
		facing=no,
		capposition=above
	}
\fi

% Change the formatting of the captions
\addtokomafont{captionlabel}{\bfseries} % Bold font for the figure label
\DeclareCaptionFormat{margin}{\@margin@par #1#2#3} % Declare a new style to format the caption according to \@margin@par (see above)
\captionsetup{
	format=margin, % Use the style previously declared
	strut=no,
	%%hypcap=true, % Links point to the top of the figure
	singlelinecheck=false,
	%width=\marginparwidth,
	indention=0pt, % Suppress indentation
	parindent=0pt, % Suppress space between paragraphs
	aboveskip=6pt, % Increase the space between the figure and the caption
	belowskip=6pt, % Increase the space between the caption and the table
}

% Needed to have continued figures and tables (https://en.wikibooks.org/wiki/LaTeX/Floats,_Figures_and_Captions#Figures_in_multiple_parts)
\DeclareCaptionLabelFormat{cont}{#1~#2\alph{ContinuedFloat}}
\captionsetup[ContinuedFloat]{labelformat=cont}

%----------------------------------------------------------------------------------------
%	MARGIN TOC
%----------------------------------------------------------------------------------------

\RequirePackage{etoc} % Required to insert local tables of contents

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
	backend=biber, % Compile the bibliography with biber
	hyperref=true,
	backref=true,
	citecounter=true,
	citetracker=true,
]{biblatex}

% Remove some unwanted entries from the bibliography
% TODO: the url should be kept for online resources
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

\RequirePackage{hyperref} % Required for hyperlinks
\RequirePackage{bookmark} % Required for pdf bookmarks

\PassOptionsToPackage{hyphens}{url} % Break long URLs and use hyphens to separate the pieces

\hypersetup{ % Set up hyperref options
	unicode, % Use unicode for links
	pdfborder={0 0 0}, % Suppress border around pdf
	%xetex,
	%pagebackref=true,
	%hyperfootnotes=false, % We already use footmisc
	bookmarksdepth=section,
	bookmarksopen=true, % Expand the bookmarks as soon as the pdf file is opened
	%bookmarksopenlevel=4,
	linktoc=all, % Toc entries and numbers links to pages
	breaklinks=true,
	colorlinks=true,
	%allcolors=DarkGreen,
	citecolor = DarkOrange,
	linkcolor = DarkBlue,
	%pagecolor = DarkBlue,
	urlcolor = OliveGreen,
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

% Adjust the colour of the footnotes marks using the colour defined above
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

%----------------------------------------------------------------------------------------
%	INCLUDE ADDITIONAL PACKAGES
%----------------------------------------------------------------------------------------

\RequirePackage{styles/references}
\RequirePackage{styles/packages}
\RequirePackage{styles/style}
