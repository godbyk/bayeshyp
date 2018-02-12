%
% Book design for Bayes Hypothesis Testing Without Tears: Examples for Students
%

\NeedsTeXFormat{LaTeX2e}[1994/06/01]

\RequirePackage{expl3}
\RequirePackage{xparse}

\ProvidesExplClass {bayeshyp} {2017/01/26} {1.0.1}
  {Bayes Hypothesis Testing book design}

%
% Pass any class options to the underlying tufte-book class
%
\DeclareOption* { \PassOptionsToClass { \CurrentOption } { tufte-book } }

\ProcessOptions

\LoadClass{tufte-book}

\RequirePackage{graphicx}

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

\cs_set_eq:NN \author \authors

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
  [block]% shape
  {\relax\ifthenelse{\NOT\boolean{@tufte@symmetric}}{\begin{fullwidth}}{}}% format applied to label+text
  {\itshape\huge\thechapter\quad}% label
  {0pt}% horizontal separation between label and title body
  {\huge\rmfamily\itshape}% before the title body
  [\ifthenelse{\NOT\boolean{@tufte@symmetric}}{\end{fullwidth}}{}]% after the title body

\titleformat{\section}%
  [hang]% shape
  {\normalfont\Large\scshape}% format applied to label+text
  {\thesection}% label
  {1em}% horizontal separation between label and title body
  {}% before the title body
  []% after the title body



\setcounter{secnumdepth}{1}

%
% Formatting of table of contents
%

\setcounter{tocdepth}{1}

\dim_new:N \g_bayes_contentsindent_dim
\dim_set:Nn \g_bayes_contentsindent_dim {1.5em}

\titlecontents{part}%
    [0pt]% distance from left margin
    {\vspace{0.5\baselineskip}}% above (global formatting of entry)
    {{\tl_upper_case:n{\partname\space\thecontentslabel}}\uppercase}% before w/ label (label = ``Part I'')
    {{\tl_upper_case:n{\partname\space\thecontentslabel}}\uppercase}% before w/o label
    {}% filler and page (leaders and page num)
    []% below

\titlecontents{chapter}%
    [2\g_bayes_contentsindent_dim]% distance from left margin
    {\vspace{0.5\baselineskip}}% above (global formatting of entry)
    {\contentslabel{\g_bayes_contentsindent_dim}\textit}% before w/ label (label = ``Chapter 1'')
    {\textit}% before w/o label
    {\qquad\thecontentspage}% filler and page (leaders and page num)
    []%[\vspace*{0.5\baselineskip}]% after

\titlecontents{section}%
    [3.5\g_bayes_contentsindent_dim]% distance from left margin
    {}% above (global formatting of entry)
    {\contentslabel{1.5\g_bayes_contentsindent_dim}}% before w/ label (label = ``1.1'')
    {}% before w/o label
    {\qquad\thecontentspage}% filler and page (leaders and page num)
    []%[\vspace*{0.5\baselineskip}]% after


%
% Define extended heading macros
%

% Part
\bool_new:N \l_bayes_part_starred_bool
\tl_new:N \l_bayes_part_graphics_options_tl
\tl_new:N \l_bayes_part_toc_tl
\tl_new:N \l_bayes_part_image_tl
\msg_new:nnn { bayeshyp } { old-style-short-heading } {
  Use ~ the ~ new ~ `toc={short ~ heading}' ~ key-value ~ pair.
}

\keys_define:nn { bayeshyp / part } {
  starred       .bool_set:N = \l_bayes_part_starred_bool,
  image         .tl_set:N = \l_bayes_part_image_tl,
  image-options .tl_set:N = \l_bayes_part_graphics_options_tl,
  toc           .tl_set:N = \l_bayes_part_toc_tl,
  unknown       .code:n = { \msg_error:nn { bayeshyp } { old-style-short-heading } },
}

\cs_set_eq:NN \bayes_backup_part: \part

\cs_new:Npn \cs_bayes_part:nn #1#2 {
  \group_begin:
    \keys_set:nn {bayeshyp / part} {#1}
    \bool_if:NTF \l_bayes_part_starred_bool {
      \bayes_backup_part:*{#2}
    } {
      \tl_if_empty:NTF \l_bayes_part_toc_tl {
        \bayes_backup_part:[#2]{#2}
      } {
        \bayes_backup_part:[\l_bayes_part_toc_tl]{#2}
      }
    }
  \group_end:
}

\cs_set_eq:NN \bayes_backup_endpart: \@endpart
\cs_new:Nn \bayes_endpart: {
  \tl_if_empty:NF \l_bayes_part_image_tl {
    \begin{center}
      \expandafter\includegraphics\expandafter[\l_bayes_part_graphics_options_tl]{\l_bayes_part_image_tl}
    \end{center}
    \bayes_backup_endpart:
  }
}
\cs_set_eq:NN \@endpart \bayes_endpart:

\NewDocumentCommand \Part { s o m } {
  \IfBooleanTF {#1} {
    \IfValueTF {#2} {
      \cs_bayes_part:nn {starred=true,#2} {#3}
    } {
      \cs_bayes_part:nn {starred=true} {#3}
    }
  } {
    \IfValueTF {#2} {
      \cs_bayes_part:nn {starred=false,#2} {#3}
    } {
      \cs_bayes_part:nn {starred=false} {#3}
    }
  }
}

\cs_set_eq:NN \part \Part

% Chapter
\bool_new:N \l_bayes_chapter_starred_bool
\tl_new:N \l_bayes_chapter_toc_tl
\tl_new:N \l_bayes_chapter_byline_tl
\keys_define:nn { bayeshyp / chapter } {
  starred       .bool_set:N = \l_bayes_chapter_starred_bool,
  toc           .tl_set:N = \l_bayes_chapter_toc_tl,
  byline        .tl_set:N = \l_bayes_chapter_byline_tl,
  unknown       .code:n = { \msg_error:nn { bayeshyp } { old-style-short-heading } },
}

\cs_set_eq:NN \bayes_backup_chapter: \chapter

\cs_new:Npn \cs_bayes_chapter:nn #1#2 {
  \group_begin:
    \keys_set:nn {bayeshyp / chapter} {#1}
    \tl_if_empty:NF \l_bayes_chapter_byline_tl {
      \tl_put_left:Nn \l_bayes_chapter_byline_tl {\\ \LARGE}
    }
    \bool_if:NTF \l_bayes_chapter_starred_bool {
      \bayes_backup_chapter:*{#2 \l_bayes_chapter_byline_tl}
    } {
      \tl_if_empty:NTF \l_bayes_chapter_toc_tl {
        \bayes_backup_chapter:[#2]{#2 \l_bayes_chapter_byline_tl}
      } {
        \bayes_backup_chapter:[\l_bayes_chapter_toc_tl]{#2 \l_bayes_chapter_byline_tl}
      }
    }
  \group_end:
}

\NewDocumentCommand \Chapter { s o m } {
  \IfBooleanTF {#1} {
    \IfValueTF {#2} {
      \cs_bayes_chapter:nn {starred=true,#2} {#3}
    } {
      \cs_bayes_chapter:nn {starred=true} {#3}
    }
  } {
    \IfValueTF {#2} {
      \cs_bayes_chapter:nn {starred=false,#2} {#3}
    } {
      \cs_bayes_chapter:nn {starred=false} {#3}
    }
  }
}

\cs_set_eq:NN \chapter \Chapter

%
% Code listings
%
\RequirePackage{listings}
\NewDocumentEnvironment { codecomment } { } {
  \begin{lrbox}{\@tufte@margin@floatbox}
    \begin{minipage}[t]{\marginparwidth}
      \@tufte@marginnote@font
      \@tufte@marginnote@justification
      \@tufte@margin@par
      \noindent\itshape\leavevmode\ignorespaces
}{
    \end{minipage}
  \end{lrbox}
  \marginpar{\usebox{\@tufte@margin@floatbox}}
}

\definecolor{MyDarkGreen}{rgb}{0.0,.2,0.0}
\definecolor{Blue}{rgb}{0.0,0.0,.5}
\definecolor{Purple}{rgb}{0.5,0.0,0.5}

\lstloadlanguages{matlab}
\lstdefinestyle{matlab}{%
  language=matlab,
  frame=none, % no frame around code
  basicstyle=\small\ttfamily, % Use small true type font
  keywordstyle=[1], % matlab functions same
  keywordstyle=[2]\color{Purple}, % Perl function arguments purple
  keywordstyle=[3]\color{Blue}\underbar, % Custom functions underlined and blue
  identifierstyle=, % Nothing special about identifiers
  commentstyle=\color{MyDarkGreen}\small, % Comments small dark green courier font
  stringstyle=\color{Purple}, % Strings are purple
  showstringspaces=false, % Don't put marks in string spaces
  tabsize=1, % spaces per tab
  %
  % Put standard matlab functions not included in the default language here
  morekeywords={rand},
  %
  % Put matlab function parameters here
  morekeywords=[2]{on, off, interp},
  %
  % Put user defined functions here
  morekeywords=[3]{test},
  %
  morecomment=[l][\color{Blue}]{...}, % Line continuation (...) like blue comment
  numbers=left, % Line numbers on left
  firstnumber=1, % Line numbers start with line 1
  numberstyle=\tiny\sffamily\color{Black}, % Line numbers are blue and small
  stepnumber=1, % Line numbers steps
  breaklines=true,breakatwhitespace=false,
  %
  % Put comments in margin notes
  escapeinside={(*@}{@*)},
  escapebegin={\begin{codecomment}},
  escapeend={\end{codecomment}},
}

\lstnewenvironment{matlab}[1][]{%
  \lstset{style=matlab,#1}%
}{}


%
% Framed environments
%

\RequirePackage{mdframed}

\definecolor{BayesLightGray}{rgb}{0.85,0.85,0.85}
\definecolor{BayesDarkGray}{rgb}{0.4,0.4,0.4}

\mdfdefinestyle{graybg}{
  backgroundcolor=BayesLightGray,
  frametitlebackgroundcolor=BayesDarkGray,
  frametitlefontcolor=white,
  frametitlefont=\sffamily\bfseries,
  frametitlealignment=\centering,
  font=\sffamily,
  leftmargin=-\parindent,
  rightmargin=-\parindent,
  innermargin=-\parindent,
  outermargin=-\parindent,
  innerleftmargin=\parindent,
  innerrightmargin=\parindent,
  innertopmargin=\parindent,
  innerbottommargin=\parindent,
  hidealllines=true,
}

\NewDocumentEnvironment { graybg } { o } {
  \IfValueTF {#1} {
    \begin{mdframed}[style=graybg,frametitle=#1]
  } {
    \begin{mdframed}[style=graybg]
  }
    \@tufte@justification
} {
  \end{mdframed}
}


%
% Handy helper macros
%

\RequirePackage{mathtools}

\tl_new:N \l__my_active_tl
\cs_new_protected:Nn \bayes_mathdef:Nn {
  \tl_set_rescan:Nnn \l__my_active_tl {\char_set_catcode_active:N #1} {#1}
  \exp_last_unbraced:NV \cs_set:Npn~\l__my_active_tl~{ #2 }
  \char_set_mathcode:nn {`#1} {"8000}
}

\cs_new:Nn \bayes_activatebar: {
  \bayes_mathdef:Nn | {\;\delimsize\vert\;}
}

\DeclarePairedDelimiterX \bayes_p_aux:n [1] () {
  \bayes_activatebar:
  #1
}

\NewDocumentCommand \p { s O{} r() } {
  \operatorname{p}
  \group_begin:
    \IfBooleanTF {#1} {
      \bayes_p_aux:n*{#3}
    } {
      \bayes_p_aux:n[#2]{#3}
    }
  \group_end:
}

