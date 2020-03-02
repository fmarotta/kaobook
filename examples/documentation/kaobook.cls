%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kaobook
% LaTeX Class
% Version 1.2 (4/1/2020)
%
% This template originates from:
% https://www.LaTeXTemplates.com
%
% For the latest template development version and to make contributions:
% https://github.com/fmarotta/kaobook
%
% Authors:
% Federico Marotta (federicomarotta@mail.com)
% Based on the doctoral thesis of Ken Arroyo Ohori (https://3d.bk.tudelft.nl/ken/en)
% and on the Tufte-LaTeX class.
% Modified for LaTeX Templates by Vel (vel@latextemplates.com)
%
% License:
% LPPL (see included MANIFEST.md file)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------------------------
%	CLASS CONFIGURATION
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kaobook}[2020/01/04 kaobook class v1.2]

\newcommand{\@classname}{kaobook} % Class name
\newcommand{\@baseclass}{scrbook} % Base class name

% Set the default options
\PassOptionsToClass{fontsize=9.5pt}{\@baseclass}
\PassOptionsToClass{parskip=half}{\@baseclass}
\PassOptionsToClass{headings=optiontoheadandtoc}{\@baseclass}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\@baseclass}} % Pass through any options to the base class

\ProcessOptions\relax % Process the options

\LoadClass{\@baseclass} % Load the base class
\input{styles/kao.sty} % Load the code common to all classes

%----------------------------------------------------------------------------------------
%	FRONT-, MAIN-, BACK- MATTERS BEHAVIOUR
%----------------------------------------------------------------------------------------

% Define a LaTeX length used in the page headers
\newlength{\overflowingheadlen}

% Front matter
\let\oldfrontmatter\frontmatter % Store the old command
\renewcommand{\frontmatter}{
	\oldfrontmatter % First of all, call the old command

	% Set some lengths used for the page headers
	\setlength{\overflowingheadlen}{\linewidth}
	\addtolength{\overflowingheadlen}{\marginparsep}
	\addtolength{\overflowingheadlen}{\marginparwidth}

	\pagestyle{plain.scrheadings} % Use a plain style for the header and the footer
	\pagelayout{wide} % Use a wide page layout
	% \sloppy % Uncomment to better break long lines
}

%------------------------------------------------

% Main matter
\let\oldmainmatter\mainmatter % Store the old command
\renewcommand{\mainmatter}{

	% Add a blank page before the main matter if the front matter has an
	% odd number of pages
	\ifthispageodd{
		\afterpage{\blankpage}
	}{}

	\oldmainmatter % Call the old command

	% Set some lengths used for the page headers
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

	% Set some lengths used for the page headers
	\setlength{\overflowingheadlen}{\linewidth}
	\addtolength{\overflowingheadlen}{\marginparsep}
	\addtolength{\overflowingheadlen}{\marginparwidth}

	\bookmarksetup{startatroot} % Reset the bookmark depth
	\pagestyle{plain.scrheadings} % Use a plain style for the header and the footer
	\pagelayout{wide} % Use a wide page layout
}

%----------------------------------------------------------------------------------------
%	CHAPTER HEADING STYLES
%----------------------------------------------------------------------------------------

\DeclareDocumentCommand{\setchapterstyle}{m}{%
	\ifthenelse{\equal{plain}{#1}}{\chapterstyleplain}{}
	\ifthenelse{\equal{lines}{#1}}{\chapterstylelines}{}
	\ifthenelse{\equal{kao}{#1}}{\chapterstylekao}{}
}

% The default definition in KOMA script
\DeclareDocumentCommand{\chapterstyleplain}{}{%
	\renewcommand{\chapterlinesformat}[3]{%
		\@hangfrom{##2}{##3}}
	\renewcommand*{\chapterformat}{%
		\mbox{\chapappifchapterprefix{\nobreakspace}\thechapter%
		\autodot\IfUsePrefixLine{}{\enskip}}}

	\RedeclareSectionCommand[beforeskip=0cm,afterskip=1cm]{chapter}
	\setlength{\mtocshift}{-3.2cm}
}

% The Kao style
\DeclareDocumentCommand{\chapterstylekao}{}{%
	\renewcommand*{\chapterformat}{%
		\mbox{\chapappifchapterprefix{\nobreakspace}\scalebox{2.85}{\thechapter\autodot}}%
	}
	\renewcommand\chapterlinesformat[3]{%
		\vspace*{-4.5cm}%
		\makebox[\textwidth+\marginparsep+\marginparwidth]{%
			\parbox[b]{\textwidth}{\flushright{##3}}%
			\makebox[\marginparsep][c]{\rule[-.2cm]{1pt}{5.7cm}}%
			\parbox[b]{\marginparwidth}{##2}%
		}
	}

	\RedeclareSectionCommand[beforeskip=0cm,afterskip=1cm]{chapter}
	\setlength{\mtocshift}{0mm}
}

% Rules
\renewcommand{\hrulefill}[1][0.4pt]{%
	\leavevmode\leaders\hrule height #1\hfill\kern\z@%
}
\DeclareDocumentCommand{\chapterstylelines}{}
{
	\renewcommand*{\chapterformat}
	{
	  \chapappifchapterprefix{\nobreakspace}\scalebox{3.5}{\thechapter\autodot}
	}
	\renewcommand\chapterlinesformat[3]
	{
	  %\vspace*{-1cm}%
	  \leavevmode
	  \makebox[\textwidth+\marginparsep+\marginparwidth]{%
		\makebox[\textwidth][l]{\hrulefill[1pt]##2}%\hfill%\par%\bigskip
		\makebox[\marginparsep][l]{}%
		\makebox[\marginparwidth][l]{}%
	  }\\
	  %\vspace{.5cm}
	  \makebox[\textwidth+\marginparsep+\marginparwidth]{%
		\makebox[\textwidth][l]{##3}%
		\makebox[\marginparsep][l]{}%
		\makebox[\marginparwidth][l]{}%
	  }\\
	  \makebox[\textwidth+\marginparsep+\marginparwidth]{%
		\hrulefill[1.1pt]%
		%\makebox[\textwidth][l]{\hrulefill}%
		%\makebox[\marginparsep][l]{\hrulefill}%
		%\makebox[\marginparwidth][l]{\hrulefill}%
	  }
	}

	\RedeclareSectionCommand[beforeskip=0cm,afterskip=1cm]{chapter}
	\setlength{\mtocshift}{-2.5cm}
}

% Image (Used internally for \chapterimage; normal users should not need this command)
\DeclareDocumentCommand{\chapterstyleimage}{}{%
	\renewcommand*{\chapterformat}{%
		\mbox{\chapappifchapterprefix{\nobreakspace}\thechapter%
		\autodot\IfUsePrefixLine{}{\enskip}}
	}
	\renewcommand{\chapterlinesformat}[3]{%
		\begin{tikzpicture}[remember picture, overlay]
			\node[
				anchor=west,
				xshift=-3cm,
				yshift=1.15cm,
				rectangle,
				fill=gray!20!white,
				fill opacity=0.8,
				inner ysep=14pt,
				inner xsep=3cm,
				text opacity=1,
				text width=\paperwidth+3cm, % Set text width in order to force left-alignment
			]{\makebox[0pt][l]{\@hangfrom{##2}{##3}}};
			\node[
				anchor=west,
				xshift=-3cm,
				yshift=2mm,
				rectangle,
				fill=white,
				minimum height=.5cm,
				minimum width=\paperwidth+3cm,
			]{};
		\end{tikzpicture}
	}
}

% Takes as input the image path and optionally the "beforeskip"
\DeclareDocumentCommand{\setchapterimage}{O{5.5cm} m}{%
	\setchapterpreamble[o]{%
		\vspace*{-2.7cm}\hspace*{-2.5cm}%
		\includegraphics[width=\paperwidth,height=#1+2.7cm,keepaspectratio=false]{#2}%
	}%
	\chapterstyleimage%
	% beforeskip=-(figure_height-top_margin)
	\RedeclareSectionCommand[beforeskip=-#1, afterskip=.6cm]{chapter}%
	\setlength{\mtocshift}{0cm}%
}

% By default start with plain style
\chapterstyleplain

%----------------------------------------------------------------------------------------
%	FONTS AND STYLES
%----------------------------------------------------------------------------------------

% Set KOMA fonts for book-specific elements
\addtokomafont{part}{\normalfont\scshape\bfseries}
\addtokomafont{partentry}{\normalfont\scshape\bfseries}
\addtokomafont{chapter}{\normalfont\bfseries}
\addtokomafont{chapterentry}{\normalfont\bfseries}

% Set KOMA fonts for elements common to all classes
\addtokomafont{section}{\normalfont\bfseries}
\addtokomafont{subsection}{\normalfont\bfseries}
\addtokomafont{subsubsection}{\normalfont\bfseries}
\addtokomafont{paragraph}{\normalfont\bfseries}
\setkomafont{descriptionlabel}{\normalfont\bfseries}

%----------------------------------------------------------------------------------------
%	TOC, LOF & LOT
%----------------------------------------------------------------------------------------

\PassOptionsToClass{toc=listof}{\@baseclass}
\PassOptionsToClass{toc=index}{\@baseclass}
\PassOptionsToClass{toc=bibliography}{\@baseclass}

%----------------------------------------------------------------------------------------
%	NUMBERING
%----------------------------------------------------------------------------------------

\setcounter{secnumdepth}{1} % Number only up to sections

\counterwithin*{sidenote}{chapter} % Uncomment to reset the sidenote counter at each chapter
%\counterwithout{sidenote}{chapter} % Uncomment to have one sidenote counter for the whole document
