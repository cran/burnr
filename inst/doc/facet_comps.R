## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(burnr)
library(ggplot2)

## Files were obtained from the IMPD
# url <- "https://www1.ncdc.noaa.gov/pub/data/paleo/firehistory/firescar/northamerica/"

pmr <- read_fhx("uspmr001.fhx")
pme <- read_fhx("uspme001.fhx")
pmw <- read_fhx("uspmw001.fhx")

## -----------------------------------------------------------------------------
pmr.meta <- data.frame(series = series_names(pmr), site = 'PMR', type = 'Tree')
pme.meta <- data.frame(series = series_names(pme), site = 'PME', type = 'Tree')
pmw.meta <- data.frame(series = series_names(pmw), site = 'PMW', type = 'Tree')

## -----------------------------------------------------------------------------
pmr.comp <- composite(pmr, comp_name = 'PMR.comp')
pme.comp <- composite(pme, comp_name = 'PME.comp')
pmw.comp <- composite(pmw, comp_name = 'PMW.comp')

## -----------------------------------------------------------------------------
comp.meta <- data.frame(series = c('PMR.comp', 'PME.comp', 'PMW.comp'), 
                        site = c('PMR', 'PME', 'PMW'), 
                        type = 'Composite')

## -----------------------------------------------------------------------------
all.fhx <- sort(pmr, sort_by = "first_year", decreasing = TRUE) + 
              sort(pme, sort_by = "first_year", decreasing = TRUE) + 
              sort(pmw, sort_by = "first_year", decreasing = TRUE) + 
              pmr.comp + pme.comp + pmw.comp

all.meta <- rbind(pmr.meta, pme.meta, pmw.meta, comp.meta)

## -----------------------------------------------------------------------------
all.fhx$series <- factor(all.fhx$series, levels = rev(levels(all.fhx$series)))

## -----------------------------------------------------------------------------
plot_demograph(all.fhx, facet_group = all.meta$site, 
               facet_id = all.meta$series,
               color_group = all.meta$type, 
               color_id = all.meta$series,
               ylabels = FALSE, event_size = c(2.5, 1, 1),
               plot_legend = TRUE, yearlims = c(1600, 1995)) +
  scale_color_manual(values=c('red', 'black')) +
  theme(legend.position = 'top', 
        legend.direction="horizontal", 
        legend.background=element_rect(fill='white'), 
        legend.box="horizontal")

## -----------------------------------------------------------------------------
comp.meta <- data.frame(series = c('PMR.comp', 'PME.comp', 'PMW.comp'), 
                        site = 'Composite', 
                        type = 'Composite')

all.meta <- rbind(pmr.meta, pme.meta, pmw.meta, comp.meta)
all.meta$site <- factor(all.meta$site, 
                        levels = c("PMR", "PME", "PMW", "Composite"))
# use factor() to resort the facets, placing Composite on bottom

plot_demograph(all.fhx, 
               facet_group = all.meta$site, 
               facet_id = all.meta$series,
               ylabels = FALSE, 
               event_size = c(2.5, 1, 1),
               plot_legend = TRUE, 
               yearlims = c(1600, 1995)) +
  theme(legend.position = 'top', 
        legend.direction="horizontal", 
        legend.background=element_rect(fill='white'), 
        legend.box="horizontal")


