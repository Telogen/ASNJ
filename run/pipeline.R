# pipeline

library(ASNJ)
homepage <- get_journal_homepage('Cell Discovery')
homepage

article_content_urls <- get_nature_journal_all_content_urls(homepage,'article')
article_paper_urls                              <- get_all_paper_urls(article_content_urls)
article_paper_metrics                        <- get_all_paper_metrics(article_paper_urls)
article_paper_metrics$orig_type                                   <- 'article'

review_content_urls <- get_nature_journal_all_content_urls(homepage,'review')
review_paper_urls                              <- get_all_paper_urls(review_content_urls)
review_paper_metrics                        <- get_all_paper_metrics(review_paper_urls)
review_paper_metrics$orig_type                                   <- 'review'

comment_content_urls <- get_nature_journal_all_content_urls(homepage,'comment')
comment_paper_urls                              <- get_all_paper_urls(comment_content_urls)
comment_paper_metrics                        <- get_all_paper_metrics(comment_paper_urls)
comment_paper_metrics$orig_type                                   <- 'comment'

all_paper_metrics <- rbind(article_paper_metrics,
                           review_paper_metrics,
                           comment_paper_metrics)

dim(all_paper_metrics)
head(all_paper_metrics)


