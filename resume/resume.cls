% vi: ft=tex

\ProvidesClass{resume}[2022/06/22 Resume LaTeX class]
\NeedsTeXFormat{LaTeX2e}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt]{article}

% Disable article header and footer.
\pagestyle{empty}

% Import all required packages.
\RequirePackage{accsupp, etoolbox}
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

\hypersetup{
    colorlinks = true, % Color links instead of ugly boxes
    urlcolor = black, % Color for external hyperlinks
    linkcolor = black, % Color of internal links
}

% Override the main font.
\setmainfont[Path = fonts/raleway/, BoldFont = Raleway-Bold]{Raleway-Light}

% Creates the resume header with a first name, last name, and current position.
%
% ```latex
% \header{FIRST_NAME}{LAST_NAME}{POSITION}{
%     % Item to put in right header section, e.g. location, phone, website...
% }
% ```
\newcommand{\header}[4]{
    \setlength{\parindent}{0em}

    % Draw name and position on left, contact details on right
    \BeginAccSupp{method=pdfstringdef=true,ActualText=#1 #2\unichar{"000A}#3\unichar{"000A}}
        \begin{minipage}{2.8in}
            \addfontfeatures{LetterSpace=10.0}
            \setlength{\parskip}{1em}

            {\fontsize{28}{28} \selectfont \uppercase{\textbf{#1}\par\textbf{#2}}}

            {\fontspec[Path=fonts/raleway/, LetterSpace=14.0, WordSpace=1.75]{Raleway-Medium} \selectfont \uppercase{#3}}
        \end{minipage}
    \EndAccSupp{}
    \hfill
    \begin{minipage}{2.2in}
        \begin{flushleft}
            #4
        \end{flushleft}
    \end{minipage}

    \vspace{2em}\par
    \rule{\linewidth}{.5pt}\par
}

% Creates a contact info link with an icon, alt text, display text, and URL.
\newcommand{\contact}[4]{%
    \BeginAccSupp{method=pdfstringdef,unicode=false,ActualText=#2:}#1\EndAccSupp{} \hspace{1pt}\href{#4}{#3}%
}

% Define convenient shorthand forms of the `\contact` command.
\newcommand{\phone}[1]{\contact{\faPhone}{Phone}{#1}{tel:+1 #1}}
\newcommand{\email}[1]{\contact{\faAt}{Email}{#1}{mailto:#1}}
\newcommand{\website}[1]{\contact{\faGlobe}{Website}{#1}{https://#1}}
\newcommand{\linkedin}[1]{\contact{\faLinkedin}{LinkedIn}{#1}{https://www.linkedin.com/in/#1}}
\newcommand{\github}[1]{\contact{\faGithub}{GitHub}{#1}{https://github.com/#1}}

% Customize `\section` format and before/after spacing.
\titleformat{\section}
    {\fontspec[Path=fonts/raleway/, LetterSpace=16.0, WordSpace=1.75]{Raleway-Bold} \fontsize{14}{14} \selectfont}
    {\MakeUppercase{#1}}
    {1em}
    {}
    [{\rule[5pt]{30pt}{1pt}}]
\titlespacing*{\section}
    {0pt}{1.5em}{0em}

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

% Utility macro which draws a gray horizontal rule.
\newcommand{\sectionrule}{
    \begin{flushleft}
        \textcolor{lightgray}{\rule{\linewidth}{.5pt}}
    \end{flushleft}
}

% Draws a dotted vertical bar. Used as implementation detail of `timeline`.
\newcommand{\dottedline}{\makebox[0pt]{\tikz[baseline=-4pt]\draw[gray,fill=gray] (0,0) circle (0.5ex);}\color{gray}\hskip-0.5pt\vrule width 1pt height 7mm\hspace{8mm}}

% Creates a vertical timeline of job experience entries.
\newenvironment{timeline}
    {
        \begin{longtable}{!{\dottedline} @{\,} l l}
    }
    {
        \end{longtable}
    }

% Defines a job experience entry in the timeline containing the company name,
% start/end dates, position name, and job description.
\newcommand{\entry}[4]{
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
