% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pre_tokenizers.R
\name{pre_tokenizer_byte_level}
\alias{pre_tokenizer_byte_level}
\title{Byte level pre tokenizer}
\description{
Byte level pre tokenizer

Byte level pre tokenizer
}
\details{
This pre-tokenizer takes care of replacing all bytes of the given string with
a corresponding representation, as well as splitting into words.
}
\seealso{
Other pre_tokenizer: 
\code{\link{pre_tokenizer}},
\code{\link{pre_tokenizer_whitespace}}
}
\concept{pre_tokenizer}
\section{Super class}{
\code{tok::tok_pre_tokenizer} -> \code{tok_pre_tokenizer_whitespace}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-tok_pre_tokenizer_whitespace-new}{\code{pre_tokenizer_byte_level$new()}}
\item \href{#method-tok_pre_tokenizer_whitespace-clone}{\code{pre_tokenizer_byte_level$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-tok_pre_tokenizer_whitespace-new"></a>}}
\if{latex}{\out{\hypertarget{method-tok_pre_tokenizer_whitespace-new}{}}}
\subsection{Method \code{new()}}{
Initializes the bytelevel tokenizer
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{pre_tokenizer_byte_level$new(add_prefix_space = TRUE, use_regex = TRUE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{add_prefix_space}}{Whether to add a space to the first word}

\item{\code{use_regex}}{Set this to False to prevent this pre_tokenizer from using
the GPT2 specific regexp for spliting on whitespace.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-tok_pre_tokenizer_whitespace-clone"></a>}}
\if{latex}{\out{\hypertarget{method-tok_pre_tokenizer_whitespace-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{pre_tokenizer_byte_level$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
