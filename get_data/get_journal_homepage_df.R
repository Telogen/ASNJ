journal_homepage_df <-
  data.frame(journal = c('Phenomics',
                         'STTT',
                         'Cell Discovery',
                         'Cell Research',
                         'CMI'),
             homepage = c('https://www.springer.com/journal/43657/',
                          'https://www.nature.com/sigtrans/',
                          'https://www.nature.com/celldisc/',
                          'https://www.nature.com/cr/',
                          'https://www.nature.com/cmi/'))

journal_homepage_df <- rbind(journal_homepage_df,c('Nature','https://www.nature.com/'))


usethis::use_data(journal_homepage_df,overwrite = TRUE)



