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
    {\addvspace{0.5\baselineskip}}% above (global formatting of entry)
    {{\tl_upper_case:n{\partname\space\thecontentslabel}}\uppercase}% before w/ label (label = ``Part I'')
    {{\tl_upper_case:n{\partname\space\thecontentslabel}}\uppercase}% before w/o label
    {}% filler and page (leaders and page num)
    []% below

\titlecontents{chapter}%
    [2\g_bayes_contentsindent_dim]% distance from left margin
    {\addvspace{0.5\baselineskip}\pagebreak[1]}% above (global formatting of entry)
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
  starred       .initial:x = {false},
  image         .tl_set:N = \l_bayes_part_image_tl,
  image         .initial:x = {},
  image-options .tl_set:N = \l_bayes_part_graphics_options_tl,
  image-options .initial:x = {},
  toc           .tl_set:N = \l_bayes_part_toc_tl,
  toc           .initial:x = {},
  unknown       .code:n = { \msg_error:nn { bayeshyp } { old-style-short-heading } },
}

\cs_set_eq:NN \bayes_backup_part: \part

\cs_new:Npn \cs_bayes_part:nn #1#2 {
  \keys_set:nn {bayeshyp / part} {
    starred=false,
    image={},
    image-options={},
    toc={}
  }
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
}

\cs_set_eq:NN \bayes_backup_endpart: \@endpart
\cs_new:Nn \bayes_endpart: {
  \tl_if_empty:NF \l_bayes_part_image_tl {
    \begin{center}
      \expandafter\includegraphics\expandafter[\l_bayes_part_graphics_options_tl]{\l_bayes_part_image_tl}
    \end{center}
  }
  \bayes_backup_endpart:
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
\tl_new:N \l_bayes_chapter_toc_tl
\tl_new:N \l_bayes_chapter_byline_tl
\keys_define:nn { bayeshyp / chapter } {
  toc           .tl_set:N = \l_bayes_chapter_toc_tl,
  toc           .initial:x = {},
  byline        .tl_set:N = \l_bayes_chapter_byline_tl,
  byline        .initial:x = {},
  unknown       .code:n = { \msg_error:nn { bayeshyp } { old-style-short-heading } },
}

\cs_set_eq:NN \bayes_backup_chapter: \chapter

\cs_new:Npn \cs_bayes_group_insert_after:n #1 {
  \tl_gset:Nn \g_tmpa_tl {#1}
  \group_insert_after:N \g_tmpa_tl
}

\cs_generate_variant:Nn \cs_bayes_group_insert_after:n { o }

\cs_new:Npn \cs_bayes_chapter_expanded:nnn #1#2#3 {
  \tl_if_empty:nTF {#3} {
    \cs_bayes_group_insert_after:n {
      \bayes_backup_chapter:[#1]{#2}
    }
  } {
    \cs_bayes_group_insert_after:n {
      \bayes_backup_chapter:[#1]{#2\\\relax#3}
    }
  }
}

\cs_new:Npn \cs_bayes_chapter_starred_expanded:nn #1#2 {
  \tl_if_empty:nTF {#2} {
    \cs_bayes_group_insert_after:n {
      \bayes_backup_chapter:{#1}
    }
  } {
    \cs_bayes_group_insert_after:n {
      \bayes_backup_chapter:{#1\\\relax#2}
    }
  }
}

\cs_new:Npn \cs_bayes_chapter:nn #1#2 {
  \group_begin:
    \keys_set:nn {bayeshyp / chapter} {#1}
    \tl_if_empty:NTF \l_bayes_chapter_toc_tl {
      \exp_args:Nnno \cs_bayes_chapter_expanded:nnn { #2 } { #2 } { \l_bayes_chapter_byline_tl }
    } {
      \exp_args:Nono \cs_bayes_chapter_expanded:nnn { \l_bayes_chapter_toc_tl } { #2 } { \l_bayes_chapter_byline_tl }
    }
  \group_end:
}

\cs_new:Npn \cs_bayes_chapter_starred:nn #1#2 {
  \group_begin:
    \keys_set:nn {bayeshyp / chapter} {#1}
    \exp_args:Nno \cs_bayes_chapter_starred_expanded:nn { #2 } { \l_bayes_chapter_byline_tl }
  \group_end:
}

\NewDocumentCommand \Chapter { s O{} m } {
  \IfBooleanTF {#1} {
    \cs_bayes_chapter_starred:nn {#2} {#3}
  } {
    \cs_bayes_chapter:nn {#2} {#3}
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
  leftmargin=\parindent,
  rightmargin=\parindent,
  innermargin=\parindent,
  outermargin=\parindent,
  %leftmargin=-\parindent,
  %rightmargin=-\parindent,
  %innermargin=-\parindent,
  %outermargin=-\parindent,
  %innerleftmargin=\parindent,
  %innerrightmargin=\parindent,
  %innertopmargin=\parindent,
  %innerbottommargin=\parindent,
  hidealllines=true,
}

% Declare new float type for our boxes
\newcounter{bayesbox}[chapter]
\renewcommand \thebayesbox
     {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@bayesbox}
\def\fps@bayesbox{tbp}
\def\ftype@bayesbox{8}% must by power of 2: 1-figure, 2-table, 4-often defined by other packages
\def\ext@bayesbox{lob}
\def\fnum@bayesbox{\bayesboxname\nobreakspace\thebayesbox}
\def\bayesboxname{Example}

\newcommand\listofbayesbox{%
  \ifthenelse{\equal{\@tufte@class}{book}}{%
    \chapter*{\listbayesboxname}%
  }{%
    \section*{\listbayesboxname}%
  }%
  \@starttoc{lob}%
}
\let\l@bayesbox\l@figure



\NewDocumentEnvironment { graybg } { s o O{htbp} } {
  \IfBooleanTF {#1} {
    \begin{@tufte@float}[#3]{bayesbox}{star}
  } {
    \begin{@tufte@float}[#3]{bayesbox}{}
  }
  \IfValueTF {#2} {
    \begin{mdframed}[style=graybg,frametitle={#2}]
  } {
    \begin{mdframed}[style=graybg]
  }
  \@tufte@justification
} {
    \end{mdframed}
  \end{@tufte@float}
}

% Starred versions of the environment
\cs_new:cpn {graybg*} {\graybg*}
\cs_new_eq:cN {endgraybg*} \endgraybg

% Footnote macros for minipages
\newcommand\mpfootnotemark{%
  \@ifnextchar[%
    \@xmpfootnotemark
    {%
      \stepcounter\@mpfn
      \protected@xdef\@thefnmark{\thempfn}%
      \@footnotemark
    }%
}
\def\@xmpfootnotemark[#1]{%
  \begingroup
    \csname c@\@mpfn\endcsname #1\relax
    \unrestored@protected@xdef\@thefnmark{\thempfn}%
  \endgroup
  \@footnotemark
}


% Collect \cites within floats
\newcommand{\@tufte@infloat@cite}[1]{%
  \protected@xdef\@thefnmark{\thempfn}%
  \mpfootnotemark%
  \@tufte@add@citation{{#1}}%
}

\cs_new:Npn \tufte_bibentry:N #1 {
  \clist_map_inline:Nn #1 {
    \bibentry{##1}\par
  }
}

\newcommand{\@tufte@print@infloat@citations}{
  \clist_set:Nx \l_tmpa_clist { \@tufte@citations }
  \clist_map_inline:Nn \l_tmpa_clist {
    \clist_set:Nx \l_tmpb_clist { ##1 }
    \footnotesize\normalfont\@tufte@citation@font
    \noindent%
    \stepcounter\@mpfn%
    \protected@xdef\@thefnmark{\thempfn}%
    \protected@edef\@currentlabel{%
      \csname p@footnote\endcsname\@thefnmark%
    }%
    \color@begingroup%
      \@makefntext{%
        \ignorespaces
        \tufte_bibentry:N \l_tmpb_clist
      }%
    \color@endgroup%
  }
}


% Added code to handle \cite within a float body (not just the caption)
\renewenvironment{@tufte@float}[3][htbp]%
  {% begin @tufte@float
    % Should this float be full-width or just text-width?
    \ifthenelse{\equal{#3}{star}}%
      {\gsetboolean{@tufte@float@star}{true}}%
      {\gsetboolean{@tufte@float@star}{false}}%
    % Check page side (recto/verso) and store detected value -- can be overriden in environment contents
    \@tufte@checkoddpage%
    \ifthenelse{\boolean{@tufte@odd@page}}%
      {\gsetboolean{@tufte@float@recto}{true}\@tufte@float@debug{Detected page: [recto/odd]}}%
      {\gsetboolean{@tufte@float@recto}{false}\@tufte@float@debug{Detected page: [verso/even]}}%
    % If the float placement specifier is 'b' and only 'b', then bottom-align the mini-pages, otherwise top-align them.
    \renewcommand{\@tufte@fps}{#1}%
    \@tufte@float@debug{Allowed positions: [#1]}%
    \ifthenelse{\equal{#1}{b}\OR\equal{#1}{B}}%
      {\renewcommand{\floatalignment}{b}\@tufte@float@debug{Presumed position: [bottom]}}%
      {\renewcommand{\floatalignment}{t}\@tufte@float@debug{Presumed position: [top]}}%
    % Capture the contents of the \caption and \label commands to use later
    \global\let\@tufte@orig@caption\caption%
    \global\let\@tufte@orig@label\label%
    \renewcommand{\caption}{\optparams{\@tufte@caption}{[][0pt]}}%
    \renewcommand{\label}[1]{\@tufte@label{##1}}%
    % Handle subfigure package compatibility
    \ifthenelse{\boolean{@tufte@packages@subfigure}}{%
      % don't move the label while inside a \subfigure or \subtable command
      \global\let\label\@tufte@orig@label%
    }{}% subfigure package is not loaded
    \@tufte@orig@float{#2}[#1]%
    \ifthenelse{\boolean{@tufte@float@star}}%
      {\setlength{\@tufte@float@contents@width}{\@tufte@fullwidth}}%
      {\setlength{\@tufte@float@contents@width}{\textwidth}}%
    \begin{lrbox}{\@tufte@figure@box}%
      \begin{minipage}[\floatalignment]{\@tufte@float@contents@width}\hbox{}%
        \gdef\@tufte@citations{}%           clear out any old citations
        \let\cite\@tufte@infloat@cite
  }{% end @tufte@float
      \par\hbox{}\vspace{-\baselineskip}\ifthenelse{\prevdepth>0}{\vspace{-\prevdepth}}{}% align baselines of boxes
      \end{minipage}%
    \end{lrbox}%
    % build the caption box
    \begin{lrbox}{\@tufte@caption@box}%
      \begin{minipage}[\floatalignment]{\marginparwidth}\hbox{}%
        \ifthenelse{\NOT\equal{\@tufte@stored@caption}{}}{\@tufte@orig@caption[\@tufte@stored@shortcaption]{\@tufte@stored@caption}}{}%
        \ifthenelse{\NOT\equal{\@tufte@citations}{}}{\@tufte@print@infloat@citations}{}%
        \ifthenelse{\NOT\equal{\@tufte@stored@label}{}}{\@tufte@orig@label{\@tufte@stored@label}}{}%
        \par\vspace{-\prevdepth}%% TODO: DOUBLE-CHECK FOR SAFETY
      \end{minipage}%
    \end{lrbox}%
    % now typeset the stored boxes
    \begin{fullwidth}%
      \begin{minipage}[\floatalignment]{\linewidth}%
        \ifthenelse{\boolean{@tufte@float@star}}%
          {\@tufte@float@fullwidth[\@tufte@caption@vertical@offset]{\@tufte@figure@box}{\@tufte@caption@box}}%
          {\@tufte@float@textwidth[\@tufte@caption@vertical@offset]{\@tufte@figure@box}{\@tufte@caption@box}}%
      \end{minipage}%
    \end{fullwidth}%
    \@tufte@orig@endfloat% end original LaTeX float environment
    % output debug info
    \ifthenelse{\boolean{@tufte@debug}}{%
      \typeout{^^J^^J----------- Tufte-LaTeX float information ----------}%
      \ifthenelse{\equal{\@tufte@stored@label}{}}%
        {\typeout{Warning: Float unlabeled!}}%
        {\typeout{Float label: [\@tufte@stored@label]}}%
      \typeout{Page number: [\thepage]}%
      \def\MessageBreak{^^J}%
      \typeout{\@tufte@float@debug@info}%
      \ifthenelse{\boolean{@tufte@symmetric}}%
        {\typeout{Symmetric: [true]}}%
        {\typeout{Symmetric: [false]}}%
      \typeout{----------------------------------------------------^^J^^J}%
    }{}%
    % reset commands and temp boxes and captions
    \gdef\@tufte@float@debug@info{}%
    \let\caption\@tufte@orig@caption%
    \let\label\@tufte@orig@label%
    \begin{lrbox}{\@tufte@figure@box}\hbox{}\end{lrbox}%
    \begin{lrbox}{\@tufte@caption@box}\hbox{}\end{lrbox}%
    \gdef\@tufte@stored@shortcaption{}%
    \gdef\@tufte@stored@caption{}%
    \gdef\@tufte@stored@label{}%
    \gsetlength{\@tufte@caption@vertical@offset}{0pt}% reset caption offset
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

