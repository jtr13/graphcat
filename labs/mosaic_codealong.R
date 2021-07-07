# Mosaic Codealong, useR2021 tutorial

# Get and clean data
library(magrittr)

# CREATE A FREQ COLUMN!

df <- readr::read_tsv("https://raw.githubusercontent.com/jtr13/graphcat/main/data/age_preweight_gain.txt") %>%
  dplyr::filter(is.na(Notes)) %>%
  dplyr::select(-Notes) %>%
  dplyr::filter(!is.na(Births)) %>%
  dplyr::mutate(Freq = Births) # need a "Freq" column for vcd::mosaic

# NO SPACES IN VARIABLE NAMES! Create short variable names without spaces as vcd::mosaic can't handle spaces in variable names

# Remove "Unknown or Not Stated" and clean up Weight, combine high levels for both variables (be careful with fct_lump_n!)

df <- df %>%
  dplyr::mutate(Weight = factor(`Mother's Pre-pregnancy Weight`),
         Age = factor(`Age of Mother 9 Code`)) %>%
  dplyr::filter(Weight != "Unknown or Not Stated") %>%
  dplyr::mutate(Weight = factor(stringr::str_remove_all(Weight, "lbs| "))) %>%
  dplyr::mutate(Weight = forcats::fct_lump_n(Weight, w = Freq, n = 3, other_level = "225+")) %>%
  dplyr::mutate(Weight = forcats::fct_relevel(Weight, "75-124")) %>%
  dplyr::mutate(Age = dplyr::recode(Age, "40-44" = "40+", "45-49" = "40+", "50+" = "40+")) %>%
  dplyr::mutate(Gain = `Mother's Weight Gain Code`) %>%
  dplyr::mutate(Gain = floor(Gain/10)*10) %>%
  dplyr::mutate(Gain = ifelse(Gain %in% seq(0, 50, 10), Gain, "60+")) %>%
  dplyr::mutate(Gain = forcats::fct_recode(Gain, "0-10" = "0",
                                           "10-20" = "10",
                                           "20-30" = "20",
                                           "30-40" = "30",
                                           "40-50" = "40",
                                           "50-60" = "50")) %>%
  dplyr::select(Age, Weight, Gain, Freq)



# Ready to graph

dplyr::glimpse(df)

head(df)

# START SMALL

vcd::mosaic(~Age, data = df)
vcd::mosaic(~Age, direction = "v", data = df)

# Two variables

vcd::mosaic(Gain~Age, data = df)

# Change direction of cuts (last should be horizontal)

vcd::mosaic(Gain~Age, data = df, direction = c("v", "h"))

# Rotate labels

vcd::mosaic(Weight~Age, data = df, direction = c("v", "h"),
       rot_labels = c(0, 0, 0, 0))  # top, right, bottom, left

# Add fill color

mycolors <- RColorBrewer::brewer.pal(length(levels(df$Weight)), "Greens")

vcd::mosaic(Weight~Age, data = df,
            direction = c("v", "h"),
            rot_labels = c(0, 0, 0, 0), # top, right, bottom, left
            highlighting_fill = mycolors)

# Move labels to bottom

vcd::mosaic(Weight~Age, data = df, direction = c("v", "h"),
       rot_labels = c(0, 0, 0, 0), # top, right, bottom, left
       highlighting_fill = mycolors,
       # top = FALSE, left = TRUE
       labeling_args = list(tl_labels = c(FALSE, TRUE)))

# Change variable names

vcd::mosaic(Weight~Age, data = df, direction = c("v", "h"),
       rot_labels = c(0, 0, 0, 0), # top, right, bottom, left
       highlighting_fill = mycolors,
       labeling_args = list(tl_labels = c(FALSE, TRUE),
          set_varnames = c(Weight = "Pre-pregnancy\nWeight (lbs)")))

# Move variable names (increase margin), justify labels

vcd::mosaic(Weight~Age, data = df, direction = c("v", "h"),
       rot_labels = c(0, 0, 0, 0), # top, right, bottom, left
       highlighting_fill = mycolors,
       labeling_args = list(tl_labels = c(FALSE, TRUE),
          set_varnames = c(Weight = "Pre-pregnancy\nWeight (lbs)"),
          offset_varnames = c(0, 0, 0, 1),
          just_labels = c("center", "center", "center", "right")))

# THREE VARIABLES

#+ fig.width = 14
vcd::mosaic(Gain~Weight+Age, data = df,
            direction = c("v", "v", "h"),
            rot_labels = c(0,0,0,0),
            gp_labels = grid::gpar(fontsize = 8),
            spacing = vcd::spacing_dimequal(c(.3, 0, 0)),
            highlighting_fill = RColorBrewer::brewer.pal(7, "Blues"))


# ADVANCED: Example using labeling_cells, data must be in table form

#+ fig.width = 14
df <- df %>% dplyr::mutate(Weight = forcats::fct_rev(Weight))
dftab <- xtabs(Freq~Weight+Age+Gain, data = df)
vcd::mosaic(dftab,
       direction = c("v", "v", "h"),
       rot_labels = c(0,0,0,0),
       spacing = vcd::spacing_dimequal(c(.3, 0, 0)),
       labeling_args = list(abbreviate = c(Age = -1),
                            labeling = vcd::labeling_cells(text = labels)),  gp_labels = grid::gpar(fontsize = 8),
       highlighting = "Gain",
       highlighting_fill = RColorBrewer::brewer.pal(7, "Blues"), pop=FALSE)
labels <- ifelse(dftab > -1, NA, NA)
labels[2,,4] <- paste(levels(factor(df$Age)), "\n years")
vcd::labeling_cells(text = labels, margin = 0,
                    gp_text = grid::gpar(fontsize = 8))(dftab)

