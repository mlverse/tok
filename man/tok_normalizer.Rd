% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normalizers.R
\name{tok_normalizer}
\alias{tok_normalizer}
\title{Generic class for normalizers}
\description{
Generic class for normalizers

Generic class for normalizers
}
\seealso{
Other normalizers: 
\code{\link{normalizer_nfc}},
\code{\link{normalizer_nfkc}}
}
\concept{normalizers}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{.normalizer}}{Internal pointer to normalizer object}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-tok_normalizer-new}{\code{tok_normalizer$new()}}
\item \href{#method-tok_normalizer-clone}{\code{tok_normalizer$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-tok_normalizer-new"></a>}}
\if{latex}{\out{\hypertarget{method-tok_normalizer-new}{}}}
\subsection{Method \code{new()}}{
Initializes a tokenizer
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{tok_normalizer$new(normalizer)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{normalizer}}{a raw pointer to a tokenizer}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-tok_normalizer-clone"></a>}}
\if{latex}{\out{\hypertarget{method-tok_normalizer-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{tok_normalizer$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
