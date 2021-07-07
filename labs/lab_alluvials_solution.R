# 1. Load the birth-data-for-alluvial.csv file 
# 2. Run the data cleaning code 
# 3. Make an alluvial diagram that will give you the mother's weight quartile pre-pregnancy as the first state and the mother's weight gain quartile at pregnancy
# 4. Pick a color scheme 

# Variables
# user_id: randomly generated user id        
# pre_weight: weight of mother before pregnancy      
# pre_weight_cat: weight of mother before pregnancy split into quartiles  
# weight_gain: weight gain of mother during pregnancy        
# weight_gain_cat: weight gain of mother during pregnancy split into quartiles   
# mother_age: mother's age at start of pregnancy

library(tidyverse)
library(scales)

## Read in data 

birth_data <- readr::read_csv("https://raw.githubusercontent.com/jtr13/graphcat/main/data/birth_data_alluvial.csv")

birth_data %>% 
  select(user_id, pre_weight_cat, weight_gain_cat) %>% 
  ggalluvial::to_lodes_form(key = "period", axes = 2:3) %>% 
  ggplot(aes(x = period, 
             stratum = fct_rev(stratum), 
             alluvium = alluvium,
             fill = fct_rev(stratum), 
             label = fct_rev(stratum))) +
  ggalluvial::geom_flow(color = "grey") +
  ggalluvial::geom_stratum(color = "grey") +
  scale_fill_manual("Quartile",
                    values = c("1st Q" = "#bae4bc", "2nd Q" = "#7bccc4", 
                               "3rd Q" = "#43a2ca", "4th Q" = "#0868ac")) +
  scale_y_continuous(labels = comma) +
  labs(x = "") +
  theme_minimal() + 
  theme(panel.border = element_blank(), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), 
        axis.line = element_line(colour = "grey"), 
        axis.text.x = element_text(size = 18), 
        axis.text.y = element_text(size = 14), 
        strip.text.x = element_text(size = 16), 
        legend.position = "bottom", 
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16))
