# Script to clean congress data

readr::read_csv("https://theunitedstates.io/congress-legislators/legislators-current.csv") %>% 
  select(full_name, gender, type, party, birthday) %>% 
  mutate(gender = fct_relevel(gender, "M"),
         type = fct_recode(type, House = "rep", Senate = "sen"),
         party = fct_recode(party, Dem = "Democrat", Rep = "Republican", Ind = "Independent"),
         yrs = as.integer(floor((today()-birthday)/365.25)),
         age = paste0(floor(yrs/10), "0s")) %>% 
  filter(party != "Ind") %>% 
  mutate(party = factor(party)) %>% # drops unused levels
  write_csv("data/congress.csv")
