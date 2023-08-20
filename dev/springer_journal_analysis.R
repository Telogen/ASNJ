# springer_journal_analysis

library(ASNJ)

url <- 'http://link.springer.com/journal/13187'
webpage <- xml2::read_html(url, encoding = "utf-8")
journal_metrics <- rvest::html_nodes(webpage, "dl dd") %>% as.character()

title_start_loc <- stringr::str_locate(journal_metrics, "impact-factor-value")[2] +
  1
title_end_loc <- stringr::str_locate(title_line, "</h1>")[1] -
  1
title <- stringr::str_sub(title_line, title_start_loc, title_end_loc)
title <- gsub("<i>", "", title)
title <- gsub("</i>", "", title)
title <- gsub("\n", "", title)
title <- gsub("<sup>", "", title)
title <- gsub("</sup>", "", title)
title

