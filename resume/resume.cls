\ProvidesClass{resume}[2022/06/22 Resume LaTeX class]
\NeedsTeXFormat{LaTeX2e}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt]{article}

% Disable article header and footer.
\pagestyle{empty}

% Import all required packages.
\RequirePackage{array}
\RequirePackage{changepage}
\RequirePackage{enumitem}
\RequirePackage{fontspec}
\defaultfontfeatures{Path = /usr/share/texmf-dist/fonts/opentype/public/fontawesome/}
\RequirePackage{fontawesome}
\RequirePackage[hmargin = 0.75in, vmargin = 0.75in]{geometry}
\RequirePackage{hyperref}
\RequirePackage{longtable}
\RequirePackage{tikz}
\RequirePackage[explicit]{titlesec}

\usetikzlibrary{arrows.meta, chains, positioning}

% Override the main font.
\setmainfont[Path = fonts/raleway/, BoldFont = Raleway-Bold]{Raleway-Light}

% Creates the resume header with a first name, last name, and current position.
%
% ```latex
% \header{FIRST_NAME}{LAST_NAME}{POSITION}{
%     % Item to put in right header section, e.g. location, phone, website...
% }
% ```
\newcommand{\header}[4]{{
    \setlength{\parindent}{0em}

    % Draw name and position on left, contact details on right
    \begin{minipage}{2.8in}
        \addfontfeatures{LetterSpace=20.0}
        \setlength{\parskip}{1em}

        {\fontsize{28}{28} \selectfont \uppercase{\textbf{#1}\par\textbf{#2}}}

        {\fontspec[Path=fonts/raleway/, LetterSpace=20.0, WordSpace=1.5]{Raleway-Medium} \selectfont \uppercase{#3}}
    \end{minipage}
    \hfill
    \begin{minipage}{1.8in}
        \begin{flushleft}
            #4
        \end{flushleft}
    \end{minipage}

    \vspace{2em}\par
    \rule{\linewidth}{.5pt}\par
    \vspace{1em}\par
}}

% Customize `\section` format and before/after spacing.
\titleformat{\section}
    {\fontspec[Path=fonts/raleway/, LetterSpace=20.0, WordSpace=1.5]{Raleway-Bold} \fontsize{14}{14} \selectfont}
    {\MakeUppercase{#1}}
    {1em}
    {}
    [{\rule[5pt]{30pt}{1pt}}]
\titlespacing*{\section}
    {0pt}{1em}{1em}

% Utility macro which indents all lines evenly.
\newenvironment{blockquote}
    {
        \begin{adjustwidth}{1em}{}
            \begin{flushleft}
    }
    {
            \end{flushleft}
        \end{adjustwidth}
    }

% Draws a dotted vertical bar. Used as implementation detail of `timeline`.
\newcommand{\dottedline}{\color{gray} \makebox[8pt]{{\LARGE $\bullet$}}\hskip-4.75pt\vrule width 1.25pt height 8mm\hspace{8mm}}

% Creates a vertical timeline of job experience entries.
\newenvironment{timeline}
    {
        \begin{longtable}{@{\,}!{\dottedline} @{\,} c <{\hskip 2pt} >{\raggedright\arraybackslash}l}
    }
    {
        \end{longtable}
    }

% Defines a job experience entry in the timeline containing the company name,
% start/end dates, position name, and job description.
\newcommand{\entry}[4] {
    {\parbox[t]{1.5in}{
        {\fontspec[Path=fonts/raleway/]{Raleway-Medium} \fontsize{12}{12} \selectfont #1}\par
        \medskip
        {\fontsize{10}{10} \selectfont #2}
    }} & {\parbox[t]{5in}{
        {\fontsize{12}{12} \selectfont \textbf{#3}}\par
        \medskip
        #4
    }} \\
}
