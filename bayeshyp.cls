%
% Book design for Bayes Hypothesis Testing Without Tears: Examples for Students
%

\NeedsTeXFormat{LaTeX2e}[1994/06/01]

\ProvidesClass{bayeshyp}[2015/09/09 v1.0.0 Bayes Hypothesis Testing]

\RequirePackage{expl3}
\RequirePackage{xparse}

\PassOptionsToClass{nohyper}{tufte-book}

\LoadClass{tufte-book}

%
% Define \subtitle macro
%

\def\@subtitle{}
\newcommand{\subtitle}[1]{%
  \def\@subtitle{#1}%
}
\newcommand{\thesubtitle}{%
  \@subtitle
}

%
% Define \authors macro for multiple authors
%

\ExplSyntaxOn
\clist_new:N \g_tufte_authors_clist
\NewDocumentCommand \authors { m } {
  \clist_gset:Nn \g_tufte_authors_clist {#1}
}
\NewDocumentCommand \theauthors { } {
  \clist_clear:N \g_tmpa_clist
  \clist_map_inline:Nn \g_tufte_authors_clist {
    \clist_put_right:Nn \g_tmpa_clist { \mbox{##1} }
  }
  \clist_use:Nnnn \g_tmpa_clist { ~and~ } { ,~ } { ,~and~ }
}
\ExplSyntaxOff

\let\author\authors

%
% Redefine title page
%

\renewcommand{\maketitlepage}{%
  \cleardoublepage
  \begin{fullwidth}%
    \sloppy
    \setlength{\parindent}{0pt}%
    \fontsize{18}{20}\selectfont\textit{\theauthors}\par
    \vspace{1.75in}\fontsize{36}{40}\selectfont\@title\par
    \ifthenelse{\isempty{\@subtitle}}{}{%
      \vspace{0.5\baselineskip}%
      \fontsize{30}{34}\selectfont\textit{\thesubtitle}\par
    }%
    %\vspace{0.5in}\fontsize{14}{14}\selectfont\theedition\par
    \vfill\fontsize{14}{14}\selectfont\textit{\@publisher}\par
  \end{fullwidth}%
  \thispagestyle{empty}%
  \clearpage
}


%
% Formatting of headings
%

\titleformat{\chapter}%
    [display]% shape
    {\normalfont\fontsize{14}{14}\selectfont\itshape}% format applied to label+text
    {}% label
    {0pt}% horiz separation between label and title body
    {\vspace{1in}}% before the title body
    []% after the title body

\setcounter{secnumdepth}{1}

%
% Formatting of table of contents
%

\setcounter{tocdepth}{1}

\titlecontents{part}%
    [0pt]% distance from left margin
    {\addvspace{0.25\baselineskip}}% above (global formatting of entry)
    {\allcaps{Part~\thecontentslabel}\allcaps}% before w/ label (label = ``Part I'')
    {\allcaps{Part~\thecontentslabel}\allcaps}% before w/o label
    {}% filler and page (leaders and page num)
    [\vspace*{0.5\baselineskip}]% after

\titlecontents{chapter}%
    [4em]% distance from left margin
    {}% above (global formatting of entry)
    {\contentslabel{2em}\textit}% before w/ label (label = ``Chapter 1'')
    {\hspace{0em}\textit}% before w/o label
    {\qquad\thecontentspage}% filler and page (leaders and page num)
    [\vspace*{0.5\baselineskip}]% after



