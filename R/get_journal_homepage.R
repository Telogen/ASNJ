#' Get journal homepage
#'
#' @param journal journal name
#'
#' @return Return the journal homepage
#' @export
#'
#' @examples get_journal_homepage('Phenomics')
get_journal_homepage <- function(journal_name) {
  # journal_name <- 'STTT'

  data("journal_homepage_df")
  journal_homepage_df %>%
    dplyr::filter(journal == journal_name) %>%
    dplyr::select(homepage) %>%
    as.character() %>%
    return()
}


