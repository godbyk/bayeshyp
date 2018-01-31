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

