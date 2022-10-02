#' get_paper_urls
#'
#' @param content_url one content_url
#'
#' @return Return the paper urls on content_url
#' @export
#'
#' @examples get_paper_urls('https://www.nature.com/celldisc/news-and-comment?searchType=journalSearch&sort=PubDate&page=8')
get_paper_urls <- function(content_url){
  # content_url <- 'https://www.nature.com/celldisc/news-and-comment?searchType=journalSearch&sort=PubDate&page=8'
  paper_urls_tmp <- html_nodes(content_url,'h3 a') %>% as.character()
  paper_urls_tmp
  paper_urls <- sapply(paper_urls_tmp,function(paper_url_tmp){
    # paper_url_tmp <- paper_urls_tmp[1]
    start_loc <- str_locate(paper_url_tmp,'<a href=\"/articles/')[1,2] + 1
    end_loc <- str_locate(paper_url_tmp,'\" class=\"c-card__link')[1,1] - 1
    paper_url_tmp <- str_sub(paper_url_tmp,start_loc,end_loc)
    paper_url_tmp
    out <- paste0('https://www.nature.com/articles/',paper_url_tmp)
    return(out)
  },USE.NAMES = F)
  return(paper_urls)
}



#' get_all_paper_urls
#'
#' @param content_urls Many content urls
#' @param sleep_seconds sleep_seconds
#'
#' @return Return paper urls of all content urls
#' @export
#'
#' @examples
#' all_content_urls <- get_nature_journal_all_content_urls('STTT','comment')
#' get_all_paper_urls(all_content_urls)
get_all_paper_urls <- function(content_urls,sleep_seconds = 10){
  all_papers_urls <- c()
  for(content_url in content_urls){
    this_content_paper_urls <- get_paper_urls(content_url,sleep_seconds = sleep_seconds)
    all_papers_urls <- c(all_papers_urls,this_content_paper_urls)
    Sys.sleep(sleep_seconds)
  }
  return(all_papers_urls)
}





