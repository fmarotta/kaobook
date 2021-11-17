%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kaobook
% LaTeX Class
% Version 0.9.8 (2021/08/23)
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
\ProvidesClass{kaobook}[2021/08/23 v0.9.8 kaobook]
\newcommand{\@baseclass}{scrbook} % Base class name

% Set the default options
\PassOptionsToClass{a4paper}{\@baseclass}
\PassOptionsToClass{fontsize=10pt}{\@baseclass}
\PassOptionsToClass{parskip=half}{\@baseclass}
\PassOptionsToClass{headings=optiontoheadandtoc}{\@baseclass}

% Pass through any other options to the base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\@baseclass}} 

\ProcessOptions\relax % Process the options

\LoadClass{\@baseclass} % Load the base class

\RequirePackage{kao} % Load the code common to all classes

%----------------------------------------------------------------------------------------
%	FRONT-, MAIN-, BACK- MATTERS BEHAVIOUR
%----------------------------------------------------------------------------------------

% Front matter
\let\oldfrontmatter\frontmatter % Store the old command
\renewcommand{\frontmatter}{%
	\oldfrontmatter% First of all, call the old command
	\pagestyle{plain.scrheadings}% Use a plain style for the header and the footer
	\pagelayout{wide}% Use a wide page layout
	\setchapterstyle{plain} % Choose the default chapter heading style
	% \sloppy % Required to better break long lines
}

%------------------------------------------------

% Main matter
\let\oldmainmatter\mainmatter % Store the old command
\renewcommand{\mainmatter}{%
	\oldmainmatter% Call the old command
	\pagestyle{scrheadings}% Use a fancy style for the header and the footer
	\pagelayout{margin}% Use a 1.5 column layout
	\setchapterstyle{kao} % Choose the default chapter heading style
}

%------------------------------------------------

% Appendix
\let\oldappendix\appendix% Store the old command
\renewcommand{\appendix}{%
	\oldappendix% Call the old command
	\bookmarksetup{startatroot}% Reset the bookmark depth
}

%------------------------------------------------

% Back matter
\let\oldbackmatter\backmatter% Store the old command
\renewcommand{\backmatter}{%
	\oldbackmatter% Call the old command
	\bookmarksetup{startatroot}% Reset the bookmark depth
	\pagestyle{plain.scrheadings}% Use a plain style for the header and the footer
	\pagelayout{wide}% Use a wide page layout
	\setchapterstyle{plain} % Choose the default chapter heading style
}

%----------------------------------------------------------------------------------------
%	CHAPTER HEADING STYLES
%----------------------------------------------------------------------------------------

% Command to easily switch between chapter styles
\DeclareDocumentCommand{\setchapterstyle}{m}{%
	\ifthenelse{\equal{plain}{#1}}{\chapterstyleplain}{}
	\ifthenelse{\equal{bar}{#1}}{\chapterstylebar}{}
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
	\RedeclareSectionCommand[beforeskip=0cm,afterskip=10\vscale]{chapter}
	\setlength{\mtocshift}{-1\vscale}
}

% Gray bar
\DeclareDocumentCommand{\chapterstylebar}{}{%
	\renewcommand*{\chapterformat}{%
		\mbox{\chapappifchapterprefix{\nobreakspace}\thechapter%
		\autodot\IfUsePrefixLine{}{\enskip}}%
	}
	\renewcommand{\chapterlinesformat}[3]{%
		\begin{tikzpicture}[remember picture, overlay]
			\node[
				anchor=south west,
				xshift=\dimexpr - \hoffset - \oddsidemargin - 1in -1mm,%-30\hscale,
				yshift=4.3mm,
				rectangle,
				fill=gray!20!white,
				fill opacity=0.8,
				inner ysep=5\vscale,
				inner xsep=\dimexpr \hoffset + \oddsidemargin + 1in,%30\hscale,
				text opacity=1,
				text width=\paperwidth-40\hscale,
			]{\@hangfrom{##2}{##3}};
		\end{tikzpicture}
	}
	\RedeclareSectionCommand[beforeskip=-55\vscale,afterskip=6\vscale]{chapter}
	\setlength{\mtocshift}{-1\vscale}
}

% Lines
\renewcommand{\hrulefill}[1][0.4pt]{%
	\leavevmode\leaders\hrule height #1\hfill\kern\z@%
}
\DeclareDocumentCommand{\chapterstylelines}{}{%
	\renewcommand*{\chapterformat}{%
		\chapappifchapterprefix{\nobreakspace}\scalebox{3.5}{\thechapter\autodot}%
	}%
	\renewcommand\chapterlinesformat[3]{%
		%\vspace*{-1cm}%
		\leavevmode%
		\makebox[0pt][l]{%
		\makebox[\textwidth][l]{\hrulefill[1pt]##2}%\hfill%\par%\bigskip
		\makebox[\marginparsep][l]{}%
		\makebox[\marginparwidth][l]{}%
		}\\
		%\vspace{.5cm}
		\makebox[0pt][l]{%
		\makebox[\textwidth][l]{##3}%
		\makebox[\marginparsep][l]{}%
		\makebox[\marginparwidth][l]{}%
		}\\
		\makebox[0pt][l]{%
		\makebox[\textwidth+\marginparsep+\marginparwidth][l]{\hrulefill[1.1pt]}%
		}%
	}%
	\RedeclareSectionCommand[beforeskip=0cm,afterskip=10\vscale]{chapter}
	\setlength{\mtocshift}{-1\vscale}%
}

% The Kao style
\DeclareDocumentCommand{\chapterstylekao}{}{%
    \IfWideLayout{%
        \renewcommand*{\chapterformat}{%
	    	\mbox{\chapappifchapterprefix{\nobreakspace}\scalebox{2.85}{\thechapter\autodot}}%
	    }%
	    \renewcommand\chapterlinesformat[3]{%
	    	\vspace{3.5\vscale}%
	    	\if@twoside%
	    		\Ifthispageodd{%
	    			\smash{\makebox[0pt][l]{%
                        \parbox[b]{\textwidth - 6.2\hscale}{\flushright{##3}}%
                        \makebox[6.2\hscale][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    				\parbox[b]{\marginparwidth}{##2}%
	    			}}%
	    		}{
                    \smash{\makebox[\textwidth + 6.2\hscale][r]{%
                        \parbox[b]{47.7\hscale + 6.2\hscale}{\flushright{##2}}%
                        \makebox[6.2\hscale][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    				\parbox[b]{\textwidth}{\flushleft{##3}}%
	    			}}%
	    		}
	    	\else%
	    		\smash{\makebox[0pt][l]{%
                    \parbox[b]{\textwidth - 6.2\hscale}{\flushright{##3}}%
                    \makebox[6.2\hscale][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
                    \parbox[b]{\marginparwidth}{##2}%
	    		}}%
	    	\fi%
	    }%
    }{%
        \renewcommand*{\chapterformat}{%
	    	\mbox{\chapappifchapterprefix{\nobreakspace}\scalebox{2.85}{\thechapter\autodot}}%
	    }%
	    \renewcommand\chapterlinesformat[3]{%
	    	\vspace{3.5\vscale}%
	    	\if@twoside%
	    		\Ifthispageodd{%
	    			\smash{\makebox[0pt][l]{%
	    				\parbox[b]{\textwidth}{\flushright{##3}}%
	    				\makebox[\marginparsep][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    				\parbox[b]{\marginparwidth}{##2}%
	    			}}%
	    		}{
	    			\smash{\makebox[\textwidth][r]{%
	    				\parbox[b]{\marginparwidth}{\flushright{##2}}%
	    				\makebox[\marginparsep][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    				\parbox[b]{\textwidth}{\flushleft{##3}}%
	    			}}%
	    		}
	    	\else%
	    		\smash{\makebox[0pt][l]{%
	    			\parbox[b]{\textwidth}{\flushright{##3}}%
	    			\makebox[\marginparsep][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    			\parbox[b]{\marginparwidth}{##2}%
	    		}}%
	    	\fi%
	    }%
    }%
	\RedeclareSectionCommand[beforeskip=0cm,afterskip=10\vscale]{chapter}%
	\setlength{\mtocshift}{-3.5\vscale}%
}

% Takes as input the image path and optionally the "beforeskip"
\DeclareDocumentCommand{\setchapterimage}{O{55\vscale} m}{%
	\setchapterpreamble[o]{%
		\vspace*{-27\vscale}\hspace*{\dimexpr - \hoffset - \oddsidemargin - 1in}%
		\includegraphics[width=\paperwidth,height=#1+27\vscale,keepaspectratio=false]{#2}%
	}%
	\chapterstylebar%
	% beforeskip=-(figure_height-top_margin)
	\RedeclareSectionCommand[beforeskip=-#1, afterskip=6\vscale]{chapter}%
	\setlength{\mtocshift}{0cm}%
}

% By default start with the plain style
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

% Set default options regarding the table of contents
\PassOptionsToClass{toc=listof}{\@baseclass}
\PassOptionsToClass{toc=index}{\@baseclass}
\PassOptionsToClass{toc=bibliography}{\@baseclass}

%----------------------------------------------------------------------------------------
%	NUMBERING
%----------------------------------------------------------------------------------------

%\setcounter{secnumdepth}{\kao@secnumdepth} % Set section numbering depth

\counterwithin*{sidenote}{chapter} % Uncomment to reset the sidenote counter at each chapter
%\counterwithout{sidenote}{chapter} % Uncomment to have one sidenote counter for the whole document
