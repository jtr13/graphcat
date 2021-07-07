library(tidyverse)

# source: https://www.nber.org/research/data/vital-statistics-natality-birth-data
# codebook: https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/DVS/natality/UserGuide2019-508.pdf

nat_2019 <- readr::read_csv("http://data.nber.org/natality/2019/nber_output/birth_2019_nber_ps_v2.csv")

nrow <- nrow(nat_2019)

nat_2019_w <- 
  nat_2019 %>% 
  select(pre_weight = pwgt_r, weight_gain = wtgain, mother_age = mager) %>% 
  mutate(user_id = uuid::UUIDgenerate(n = nrow), 
         pre_weight = as.numeric(pre_weight), 
         weight_gain = as.numeric(weight_gain), 
         pre_weight = ifelse(pre_weight == 999, NA, pre_weight), 
         weight_gain = ifelse(weight_gain == 999, NA, weight_gain),
         pre_weight_cat = ntile(pre_weight, 4), 
         pre_weight_cat = factor(pre_weight_cat, labels = c("1st Q", "2nd Q", "3rd Q", "4th Q")),
         weight_gain_cat = ntile(weight_gain, 4), 
         weight_gain_cat = factor(weight_gain_cat, labels = c("1st Q", "2nd Q", "3rd Q", "4th Q"))) %>% 
  select(user_id, pre_weight, pre_weight_cat, weight_gain, weight_gain_cat, mother_age) %>% 
  filter(!is.na(pre_weight_cat), !is.na(weight_gain_cat)) 

write_csv(nat_2019_w, "birth_data_alluvial.csv")

