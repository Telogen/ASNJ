#' get_paper_metrics
#'
#' @param paper_url paper_url
#'
#' @return Return paper metrics
#' @export
#'
#' @examples get_paper_metrics('https://www.nature.com/articles/s41421-018-0016-3')
get_paper_metrics <- function(paper_url){
  # paper_url <- 'https://www.nature.com/articles/s41421-018-0016-3'
  paper_page <- xml2::read_html(paper_url,encoding = 'utf-8')

  # title
  title_line <- rvest::html_nodes(paper_page,'header h1')[1] %>% as.character()
  title_start_loc <- stringr::str_locate(title_line,'data-article-title=\"\">')[2] + 1
  title_end_loc <- stringr::str_locate(title_line,'</h1>')[1] - 1
  title <- stringr::str_sub(title_line,title_start_loc,title_end_loc)
  title <- gsub('<i>','',title)
  title <- gsub('</i>','',title)
  title <- gsub('\n','',title)
  title <- gsub('<sup>','',title)
  title <- gsub('</sup>','',title)
  title

  # type
  type_line <- rvest::html_nodes(paper_page,'ul li')[grep('article-category',rvest::html_nodes(paper_page,'ul li'))] %>% as.character()
  type_start_loc <- stringr::str_locate(type_line,'"article-category\">')[2] + 1
  type_end_loc <- stringr::str_locate(type_line,'</li>')[1] - 1
  type <- stringr::str_sub(type_line,type_start_loc,type_end_loc)
  type
  if(length(type) == 0){
    type <- 'NA'
  }
  type

  # access
  access_line <- rvest::html_nodes(paper_page,'li p')[grep('Accesses',rvest::html_nodes(paper_page,'li p'))] %>% as.character()
  access_start_loc <- stringr::str_locate(access_line,'<p class=\"c-article-metrics-bar__count\">')[2] + 1
  access_end_loc <- stringr::str_locate(access_line,' <span class=\"c-article-metrics-bar__label\"')[1] - 1
  access <- stringr::str_sub(access_line,access_start_loc,access_end_loc)
  access
  if(length(access) == 0){
    access <- 0
  }
  access
  if(stringr::str_detect(access,'k')){
    access <- stringr::str_sub(access,1,stringr::str_locate(access,'k')[1,1]-1)
    access <- as.numeric(access) * 1000
  }
  if(stringr::str_detect(access,'m')){
    access <- stringr::str_sub(access,1,stringr::str_locate(access,'m')[1,1]-1)
    access <- as.numeric(access) * 1000000
  }
  access

  # citation
  citation_line <- rvest::html_nodes(paper_page,'li p')[grep('Citations',rvest::html_nodes(paper_page,'li p'))] %>% as.character()
  citation_start_loc <- stringr::str_locate(citation_line,'<p class=\"c-article-metrics-bar__count\">')[2] + 1
  citation_end_loc <- stringr::str_locate(citation_line,' <span class=\"c-article-metrics-bar__label\"')[1] - 1
  citation <- stringr::str_sub(citation_line,citation_start_loc,citation_end_loc)
  citation
  if(length(citation) == 0){
    citation <- 0
  }
  citation

  # altmetric
  altmetric_line <- rvest::html_nodes(paper_page,'li p')[grep('Altmetric',rvest::html_nodes(paper_page,'li p'))] %>% as.character()
  altmetric_start_loc <- stringr::str_locate(altmetric_line,'<p class=\"c-article-metrics-bar__count\">')[2] + 1
  altmetric_end_loc <- stringr::str_locate(altmetric_line,' <span class=\"c-article-metrics-bar__label\"')[1] - 1
  altmetric <- stringr::str_sub(altmetric_line,altmetric_start_loc,altmetric_end_loc)
  altmetric
  if(length(altmetric) == 0){
    altmetric <- 0
  }
  altmetric

  # subject
  subject_line <- rvest::html_nodes(paper_page,'li a')[grep('data-track-action=\"view subject\" data-track-label=\"link\">',rvest::html_nodes(paper_page,'li a'))] %>% as.character()
  subjects <- sapply(subject_line,function(line){
    # line <- subject_line[1]
    start_loc <- stringr::str_locate(line,'data-track-label=\"link\">')[2] + 1
    end_loc <- stringr::str_locate(line,'</a>')[1] - 1
    subject <- stringr::str_sub(line,start_loc,end_loc)
    return(subject)
  }) %>% unname() %>% paste(collapse = ', ')
  subjects

  # time
  time_line <- rvest::html_nodes(paper_page,'li a')[grep('Published',rvest::html_nodes(paper_page,'li a'))] %>% as.character()
  time_start_loc <- stringr::str_locate(time_line,'Published: <time datetime=\"')[2] + 1
  time_end_loc <- time_start_loc + 9
  time <- stringr::str_sub(time_line,time_start_loc,time_end_loc)
  time
  year <- strsplit(time,'-')[[1]][1]
  year
  year_month <- paste0(strsplit(time,'-')[[1]][1],'-',strsplit(time,'-')[[1]][2])
  year_month

  out <- c(year = year,
           year_month = year_month,
           online_time = time,
           type = type,
           access = access,
           citation = citation,
           altmetric = altmetric,
           subjects = subjects,
           url = paper_url,
           title = title)
  out

  return(out)

}


#' get_all_paper_metrics
#'
#' @param paper_urls All paper urls
#' @param sleep_seconds sleep_seconds
#'
#' @return Return a dataframe of all papers' metrics
#' @export
#'
#' @examples
#' get_all_paper_metrics(c('https://www.nature.com/articles/s41421-018-0016-3',
#' 'https://www.nature.com/articles/s41421-022-00458-3'))
get_all_paper_metrics <- function(paper_urls,sleep_seconds = 10){
  all_paper_metrics <- c()
  for(idx in 1:length(paper_urls)){
    message(paste0(idx,' of ',length(paper_urls),'...'))
    paper_url <- paper_urls[idx]
    this_paper_metrics <- get_paper_metrics(paper_url)
    all_paper_metrics <- rbind(all_paper_metrics,this_paper_metrics)
    Sys.sleep(sleep_seconds)
  }
  all_paper_metrics <- data.frame(all_paper_metrics)
  all_paper_metrics$access <- as.numeric(all_paper_metrics$access)
  all_paper_metrics$citation <- as.numeric(all_paper_metrics$citation)
  all_paper_metrics$altmetric <- as.numeric(all_paper_metrics$altmetric)
  all_paper_metrics$year <- as.numeric(all_paper_metrics$year)
  rownames(all_paper_metrics) <- NULL

  return(all_paper_metrics)
}




