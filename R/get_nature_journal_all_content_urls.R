#' get nature journal all content urls
#'
#' @param journal_name journal name
#' @param article_type article type
#'
#' @return a vector of all cotnent pages of a journal's specific article type
#' @export
#'
#' @examples get_nature_journal_all_content_urls('Cell Research','review')
get_nature_journal_all_content_urls <- function(journal_home_page){

  if(article_type == 'article'){
    url_2 <- 'research-articles'
  } else if(article_type == 'review'){
    url_2 <- 'reviews-and-analysis'
  } else if(article_type == 'comment'){
    url_2 <- 'news-and-comment'
  }

  first_page_url <- paste0(journal_home_page,url_2)
  first_page <- xml2::read_html(first_page_url,encoding = 'utf-8')
  all_li_a <- rvest::html_nodes(first_page,'li a') %>% as.character()
  visual_pages_idx <- grep('<span class=\"u-visually-hidden\">page </span>',all_li_a)
  lastpage_idx <- visual_pages_idx[length(visual_pages_idx)]
  lastpage_li_a <- all_li_a[lastpage_idx]
  start_loc <- stringr::str_locate(lastpage_li_a,'searchType=journalSearch&amp;sort=PubDate&amp;page=')[1,2] + 1
  end_loc <- stringr::str_locate(lastpage_li_a,'\">\n')[1,1] - 1
  last_page <- stringr::str_sub(lastpage_li_a,start_loc,end_loc) %>% as.numeric()
  last_page

  paste0(first_page_url,'?searchType=journalSearch&sort=PubDate&page=',1:last_page) %>%
    return()
}




