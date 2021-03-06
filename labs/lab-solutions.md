Lab
================
Joyce Robbins and Ludmila Janda
7/7/2021

``` r
congress <- readr::read_csv("https://raw.githubusercontent.com/jtr13/graphcat/main/data/congress.csv")
```

    ## 
    ## ── Column specification ────────────────────────────────────────────────────────
    ## cols(
    ##   full_name = col_character(),
    ##   gender = col_character(),
    ##   type = col_character(),
    ##   party = col_character(),
    ##   birthday = col_date(format = ""),
    ##   yrs = col_double(),
    ##   age = col_character()
    ## )

``` r
# from colorbrewer.org RdBu pallette, 4 classes; PuOr pallette (last 2 of 4 classes)

colors <- tibble::tibble(dem_men = "#92c5de", dem_women = "#0571b0",
                     rep_men = "#f4a582", rep_women = "#ca0020",
                 men = "#b2abd2", women = "#5e3c99")

# Switch order of gender factor levels
library(magrittr)
congress <- congress %>% dplyr::mutate(gender = forcats::fct_relevel(gender, "M"))

vcd::mosaic(gender ~ type + party, data = congress, 
       direction = c("v", "v", "h"))
```

![](lab-solutions_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
congress <- congress %>% dplyr::filter(party != "Ind") %>% 
  dplyr::mutate(party = factor(party))  # drops unused levels

# Switch

vcd::mosaic(gender ~ type + party, data = congress, 
       direction = c("v", "v", "h"),
       highlighting_fill = c(colors$men, colors$women))
```

![](lab-solutions_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
congress2 <- congress %>% dplyr::filter(type == "House")


vcd::mosaic(gender ~ party + age, data = congress2, 
       direction = c("h", "v", "h"),
       highlighting_fill = c(colors$men, colors$women))
```

![](lab-solutions_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
vcd::mosaic(gender ~ age + party + type, data = congress, 
       direction = c("h", "v", "v", "h"),
       highlighting_fill = c(rep(c(colors$dem_men, colors$dem_women), 2),
                          rep(c(colors$rep_men, colors$rep_women), 2)),
                 col = "white",
       labeling = vcd::labeling_border(rot_labels = c(0, 0, 0, 0)),
       spacing = vcd::spacing_equal(sp = grid::unit(.05, "lines")),
       rotate = c(0,0,0,0)) 
```

![](lab-solutions_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
vcd::mosaic(gender ~ type + age + party, data = congress, 
       direction = c("h", "v", "v", "h"),
       highlighting_fill = c(colors$dem_men, colors$dem_women, colors$rep_men, colors$rep_women),
                 col = "white",
       labeling = vcd::labeling_border(rot_labels = c(0, 0, 0, 0)),
       spacing = vcd::spacing_dimequal(c(.3, .3, 0, 0)),
       rotate = c(0,0,0,0)) 
```

![](lab-solutions_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->
