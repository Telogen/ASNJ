# pipeline
devtools::install_local('/mdshare/node8/tianlejin/ASNJ/')
# devtools::install_github('Telogen/ASNJ')

library(ASNJ)
STTT_article_content_urls <- get_nature_journal_all_content_urls('STTT','article')
head(STTT_article_content_urls)
# > head(STTT_article_content_urls)
# [1] "https://www.nature.com/sigtrans/research-articles?searchType=journalSearch&sort=PubDate&page=1"
# [2] "https://www.nature.com/sigtrans/research-articles?searchType=journalSearch&sort=PubDate&page=2"
# [3] "https://www.nature.com/sigtrans/research-articles?searchType=journalSearch&sort=PubDate&page=3"
# [4] "https://www.nature.com/sigtrans/research-articles?searchType=journalSearch&sort=PubDate&page=4"
# [5] "https://www.nature.com/sigtrans/research-articles?searchType=journalSearch&sort=PubDate&page=5"
# [6] "https://www.nature.com/sigtrans/research-articles?searchType=journalSearch&sort=PubDate&page=6"
STTT_article_paper_urls <- get_all_paper_urls(STTT_article_content_urls)
