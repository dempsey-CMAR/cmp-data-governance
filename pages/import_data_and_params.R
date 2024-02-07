library(dplyr)
library(DT)
library(here)
library(ggplot2)
library(leaflet)
library(lubridate)
library(plotly)
library(qaqcmar)
library(RColorBrewer)
library(readr)
library(sensorstrings)
library(summaryplots)
library(stringr)
library(strings)
library(tidyr)



# resize interactive figures ----------------------------------------------

# Get the current figure size in pixels:
h_interactive <- function() 
  with(knitr::opts_current$get(c("fig.height", "dpi", "fig.retina")),
       fig.height*dpi/fig.retina)


# datatable settings ------------------------------------------------------

dt_options <- list(
  dom = 'Bft',
  paging = FALSE,
  searching = TRUE,
  scrollY = "500px",
  scrollX = "500px",
  columnDefs = list(list(className = 'dt-center', targets = "_all")),
  buttons = c('copy', 'csv')
)

dt_options2 <- list(
  dom = 'ft',
  paging = FALSE,
  searching = FALSE,
  columnDefs = list(list(className = 'dt-center', targets = "_all"))
)


# data --------------------------------------------------------------------

# summarized data - all observations
dat <- read_csv(
  here("pages/data/summary.csv"), show_col_types = FALSE
)

# summarized data - filtered (obvious outliers, suspected biofouling, and freshwater stations omitted)
dat_filt <- read_csv(
  here("pages/data/summary_filtered_data.csv"), show_col_types = FALSE
)

# gross range thresholds (sensors)
sensors <- read_csv(
  here("pages/data/sensors.csv"), show_col_types = FALSE
)

# station locations
st_locations <- read_csv(
  here("pages/data/Station_Locations_2022-12-06.csv"), show_col_types = FALSE
) %>% 
  mutate(
    STATION = case_when(
      STATION == "Sandy Cove St. Mary's" ~ "Sandy Cove St. Marys",
      STATION == "Larry's River" ~ "Larrys River",
      TRUE ~ STATION),
    popup = paste("County: ", COUNTY, "</br>", "Station: ", STATION) 
  )

# DO units for each station
do_units <- read_csv(here("pages/data/do_units.csv"), show_col_types = FALSE)

# plot settings -----------------------------------------------------------

theme_set(theme_light())

county_pal <- get_county_colour_palette(length(unique(st_locations$COUNTY)))

theme_facet_plotly <- theme(
  panel.spacing.y = unit(20, "lines"),
  panel.spacing.x = unit(10, "lines")
) +
  theme(strip.background = element_rect(color = 1)) 

theme_facet_plotly2 <- theme(
  panel.spacing.y = unit(20, "lines"),
  panel.spacing.x = unit(20, "lines")
) +
  theme(strip.background = element_rect(color = 1)) 

hist_pal <- "grey50"
