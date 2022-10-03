# ASNJ (Analysis of Springer Nature Journal)

## Installation
```
devtools::install_github('Telogen/ASNJ')
```

## Functions
- Get the home page URL of a Springer Nature journal.
- Get all papers' URLs of of a specific article type of a Springer Nature journal.
- Get all papers' metrics including title, article type, online time, accesses, citations, altmetrics, subjects, etc.

## Examples

Analysis of Springer Nature Journal data


## Usages

Here we take STTT comment papers as an example.

- Step 0. Get STTT homepage
```
library(ASNJ)
STTT_homepage <- get_journal_homepage('STTT')
STTT_homepage
## [1] "https://www.nature.com/sigtrans/"
```
Journal homepage can also be manually specified.


#### Step 1. Get STTT all comment papers' content urls

```
STTT_comment_content_urls <- get_all_content_urls(STTT_homepage,'comment')
head(STTT_comment_content_urls)
## [1] "https://www.nature.com/sigtrans/news-and-comment?searchType=journalSearch&sort=PubDate&page=1"
## [2] "https://www.nature.com/sigtrans/news-and-comment?searchType=journalSearch&sort=PubDate&page=2"
## [3] "https://www.nature.com/sigtrans/news-and-comment?searchType=journalSearch&sort=PubDate&page=3"
## [4] "https://www.nature.com/sigtrans/news-and-comment?searchType=journalSearch&sort=PubDate&page=4"
## [5] "https://www.nature.com/sigtrans/news-and-comment?searchType=journalSearch&sort=PubDate&page=5"
## [6] "https://www.nature.com/sigtrans/news-and-comment?searchType=journalSearch&sort=PubDate&page=6"
```


#### Step 2. Get STTT all comment papers' urls

```
STTT_comment_paper_urls <- get_all_paper_urls(STTT_comment_content_urls[1:5])
head(STTT_comment_paper_urls)
## [1] "https://www.nature.com/articles/s41392-022-01192-8"
## [2] "https://www.nature.com/articles/s41392-022-01204-7"
## [3] "https://www.nature.com/articles/s41392-022-01193-7"
## [4] "https://www.nature.com/articles/s41392-022-01180-y"
## [5] "https://www.nature.com/articles/s41392-022-01187-5"
## [6] "https://www.nature.com/articles/s41392-022-01162-0"
```


#### Step 3. Get STTT all comment papers' metrics

```
STTT_comment_paper_metrics <- get_all_paper_metrics(STTT_comment_paper_urls[1:5])
tibble::as.tibble(STTT_comment_paper_metrics)
## # A tibble: 5 × 10
##    year year_month online_time type               access citation altmetric subjects     url   title
##   <dbl> <chr>      <chr>       <chr>               <dbl>    <dbl>     <dbl> <chr>        <chr> <chr>
## 1  2022 2022-10    2022-10-02  Research Highlight      0        0         3 Adaptive im… http… Hide…
## 2  2022 2022-10    2022-10-02  Research Highlight      0        0         0 Cellular ne… http… Open…
## 3  2022 2022-09    2022-09-28  Research Highlight    200        0         0 Infectious … http… Omic…
## 4  2022 2022-09    2022-09-27  Research Highlight    163        0         0 Adaptive im… http… Four…
## 5  2022 2022-09    2022-09-27  Research Highlight    114        0         0 Microbiolog… http… Cis-…
```

## Contact
ljtian20@fudan.edu.cn



