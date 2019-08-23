%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kaobook
% LaTeX Class
% Version 1.0 (5/6/19)
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
\ProvidesClass{kaobook}[2019/06/05 v1.0 kaobook class v1.0]

\newcommand{\@classname}{kaobook} % Class name
\newcommand{\@baseclass}{scrartcl} % Base class name

% Set the default options
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\@baseclass}} % Pass through any options to the base class

\ProcessOptions\relax % Process the options

\LoadClass{\@baseclass} % Load the base class
\input{kao.def} % Load the code common to all classes

\renewcommand{\marginnotevadjust}{-4pt} % Bring all marginnotes downward a bit

\PassOptionsToClass{toc=nolistof}{\@baseclass}
\unsettoc{toc}{totoc}
