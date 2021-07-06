# Script to clean congress data

library(magrittr)
readr::read_csv("https://theunitedstates.io/congress-legislators/legislators-current.csv") %>%
  dplyr::select(full_name, gender, type, party, birthday) %>%
  dplyr::mutate(type = forcats::fct_recode(type, House = "rep", Senate = "sen"),
         party = forcats::fct_recode(party, Dem = "Democrat", Rep = "Republican", Ind = "Independent"),
         yrs = as.integer(floor((Sys.Date()-birthday)/365.25)),
         age = paste0(floor(yrs/10), "0s")) %>%
  dplyr::mutate(party = factor(party)) %>% # drops unused levels
  readr::write_csv("data/congress.csv")
