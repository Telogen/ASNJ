#' get_Phenomics_paper_metrics
#'
#' @param online_data online_data from
#' @param idx index
#'
#' @return Return paper metrics
#' @export
#'
#' @examples todo
get_Phenomics_paper_metrics <- function(online_data,idx){
  # idx <- 1

  url <- online_data$URL[idx]
  webpage <- xml2::read_html(url,encoding = 'utf-8')

  # title
  title_line <- rvest::html_nodes(webpage,'header h1')[1] %>% as.character()
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
  type_line <- rvest::html_nodes(webpage,'ul li')[grep('article-category',rvest::html_nodes(webpage,'ul li'))] %>% as.character()
  type_start_loc <- stringr::str_locate(type_line,'"article-category\">')[2] + 1
  type_end_loc <- stringr::str_locate(type_line,'</li>')[1] - 1
  type <- stringr::str_sub(type_line,type_start_loc,type_end_loc)
  type

  # access
  access_line <- rvest::html_nodes(webpage,'li p')[grep('Accesses',rvest::html_nodes(webpage,'li p'))] %>% as.character()
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
  access

  # citation
  citation_line <- rvest::html_nodes(webpage,'li p')[grep('Citations',rvest::html_nodes(webpage,'li p'))] %>% as.character()
  citation_start_loc <- stringr::str_locate(citation_line,'<p class=\"c-article-metrics-bar__count\">')[2] + 1
  citation_end_loc <- stringr::str_locate(citation_line,' <span class=\"c-article-metrics-bar__label\"')[1] - 1
  citation <- stringr::str_sub(citation_line,citation_start_loc,citation_end_loc)
  citation
  if(length(citation) == 0){
    citation <- 0
  }
  citation

  # altmetric
  altmetric_line <- rvest::html_nodes(webpage,'li p')[grep('Altmetric',rvest::html_nodes(webpage,'li p'))] %>% as.character()
  altmetric_start_loc <- stringr::str_locate(altmetric_line,'<p class=\"c-article-metrics-bar__count\">')[2] + 1
  altmetric_end_loc <- stringr::str_locate(altmetric_line,' <span class=\"c-article-metrics-bar__label\"')[1] - 1
  altmetric <- stringr::str_sub(altmetric_line,altmetric_start_loc,altmetric_end_loc)
  altmetric
  if(length(altmetric) == 0){
    altmetric <- 0
  }
  altmetric

  # correspond_authors
  correspond_authors_line <- rvest::html_nodes(webpage,'li a')[grep('corresp',rvest::html_nodes(webpage,'li a'))] %>% as.character()
  correspond_authors <- sapply(correspond_authors_line,function(line){
    # line <- correspond_authors_line[1]
    start_loc <- stringr::str_locate(line,'Read more about ')[2] + 1
    end_loc <- stringr::str_locate(line,'\" data-author-popup=\"')[1] - 1
    correspond_author <- stringr::str_sub(line,start_loc,end_loc)
    return(correspond_author)
  }) %>% unname() %>% paste(collapse = ', ')

  # time
  time_line <- rvest::html_nodes(webpage,'li a')[grep('Published',rvest::html_nodes(webpage,'li a'))] %>% as.character()
  time_start_loc <- stringr::str_locate(time_line,'Published: <time datetime=\"')[2] + 1
  time_end_loc <- time_start_loc + 9
  time <- stringr::str_sub(time_line,time_start_loc,time_end_loc)
  time
  year <- strsplit(time, "-")[[1]][1]
  year
  year_month <- paste0(strsplit(time, "-")[[1]][1], "-", strsplit(time, "-")[[1]][2])
  year_month

  # volume
  volume <- online_data$Journal.Volume[idx]
  if(is.na(volume)){volume <- ' '}

  # issue
  issue <- online_data$Journal.Issue[idx]
  if(is.na(issue)){issue <- ' '}

  out <- c(title = title,
           url = url,
           type = type,
           year = year,
           year_month = year_month,
           online_time = time,
           access = access,
           citation = citation,
           altmetric = altmetric,
           correspond_authors = correspond_authors,
           volume = volume,
           issue = issue)
  return(out)
}



#' get_all_Phenomics_paper_metrics
#'
#' @param online_data get on web
#' @param sleep_seconds sleep_seconds
#'
#' @return Return a dataframe of all Phenomics papers' metrics
#' @export
#'
#' @examples todo
get_all_Phenomics_paper_metrics <- function(online_data,sleep_seconds = 10){
  all_Phenomics_papers_metrics <- c()
  for(idx in 1:nrow(online_data)){
    message(paste0(idx, " of ", nrow(online_data), "..."))
    this_paper_metrics <- get_Phenomics_paper_metrics(online_data,idx)
    all_Phenomics_papers_metrics <- rbind(all_Phenomics_papers_metrics,this_paper_metrics)
    Sys.sleep(sleep_seconds)
  }
  all_Phenomics_papers_metrics <- as.data.frame(all_Phenomics_papers_metrics)
  rownames(all_Phenomics_papers_metrics) <- NULL
  all_Phenomics_papers_metrics$access <- as.numeric(all_Phenomics_papers_metrics$access)
  all_Phenomics_papers_metrics$citation <- as.numeric(all_Phenomics_papers_metrics$citation)
  all_Phenomics_papers_metrics$altmetric <- as.numeric(all_Phenomics_papers_metrics$altmetric)
  all_Phenomics_papers_metrics$year <- as.numeric(all_Phenomics_papers_metrics$year)
  all_Phenomics_papers_metrics <- all_Phenomics_papers_metrics[order(all_Phenomics_papers_metrics$time,decreasing = T),]

  sys.time <- Sys.time() %>% as.character()
  update_time <- strsplit(sys.time,' ')[[1]][1]
  all_Phenomics_papers_metrics$update_time <- update_time

  return(all_Phenomics_papers_metrics)
}

