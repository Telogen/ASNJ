---
title: "Tutorial of Analysis of Springer Nature Journal"
output: html_document
date: '2022-10-02'
---

## Installation
```{r setup, include=FALSE}
devtools::install_github('Telogen/ASNJ')
```

Here we take STTT comment papers as an example

## 0. Get STTT homepage

```{r cars}
library(ASNJ)
STTT_homepage <- get_journal_homepage('STTT')
STTT_homepage
```

## 1. Get STTT all comment papers' content urls

```{r cars}
STTT_comment_content_urls <- get_nature_journal_all_content_urls(STTT_homepage,'comment')
head(STTT_comment_content_urls)
```


## 2. Get STTT all comment papers' urls

```{r pressure, echo=FALSE}
STTT_comment_paper_urls <- get_all_paper_urls(STTT_comment_content_urls[1:5])
head(STTT_comment_paper_urls)
```


## 3. Get STTT all comment papers' metrics

```{r pressure, echo=FALSE}
STTT_comment_paper_metrics <- get_all_paper_metrics(STTT_comment_paper_urls[1:5])
head(STTT_comment_paper_metrics)
```






