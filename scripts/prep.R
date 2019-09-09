library(tidyverse)
library(pastecs)
library(reshape2)
library(sf) 
library(data.table)
library(gtools)
library(readxl)

setwd("~/projects/research/ca-political-power")

# 2010 census data----

# 2012----

# 2014----

# 2016----  
dir.create("~/projects/research/ca-political-power/2016/")
# Download data----
# SWDB---- 
# Statements of votes
download.file(
  "https://statewidedatabase.org/pub/data/G16/state/state_g16_sov_data_by_g16_srprec.zip", "./2016/sov_g16.zip"
)
unzip("./2016/sov_g16.zip", exdir =  "./2016/sov/")
sov_g16 <- read.csv("./2016/sov/state_g16_sov_data_by_g16_srprec.csv")
file.remove("./2016/sov_g16.zip")
# Party registration
download.file(
  "https://statewidedatabase.org/pub/data/G16/state/state_g16_registration_by_g16_srprec.zip", "./2016/reg_g16.zip"
)
unzip("./2016/reg_g16.zip", exdir = "./2016/reg/")
reg_g16 <- read.csv("./2016/reg/state_g16_registration_by_g16_srprec.csv")
file.remove("./2016/reg_g16.zip")
download.file(
  "https://statewidedatabase.org/pub/data/G16/G16_SOR_codebook.txt", 
  "./2016/reg/reg_g16_codebook.txt")
# Shapefiles
download.file(
  "https://statewidedatabase.org/pub/data/G16/state/srprec_state_g16_v01_shp.zip",
  "./2016/shape_g16.zip"
)
unzip("./2016/shape_g16.zip", exdir = "./2016/shapefiles/")  
shape_g16 <- read_sf(dsn = "./2016/shapefiles/",
                     layer = "srprec_state_g16_v01")
file.remove("./2016/shape_g16.zip")
# Precinct to block conversion data
download.file(
  "https://statewidedatabase.org/pub/data/G16/state/state_g16_sr_blk_map.zip",
  "./2016/sr_blk_10.zip"
)
unzip("./2016/sr_blk_10.zip", exdir = "./2016/conv/")
sr_blk_g16 <- read.csv("./2016/conv/state_g16_sr_blk_map.csv")
file.remove("./2016/sr_blk_10.zip")
# Add GEOIDs to conversion file
sr_blk_g16 <- sr_blk_g16 %>% mutate(TRACT = sprintf("%06d", TRACT))
sr_blk_g16$BLOCK <- as.character(sr_blk_g16$BLOCK)
sr_blk_g16$BLOCK_GROUP <- substr(sr_blk_g16$BLOCK, 0, 1)
sr_blk_g16$TRACT <- as.character(sr_blk_g16$TRACT)
sr_blk_g16$GEOID <- paste("15000US0", sr_blk_g16$FIPS, sr_blk_g16$TRACT,
                          sr_blk_g16$BLOCK_GROUP, sep="")

# ACS----
# Block group-level summary file
download.file(
  "https://www2.census.gov/programs-surveys/acs/summary_file/2016/data/5_year_by_state/California_Tracts_Block_Groups_Only.zip", "./2016/acs_16_5y.zip"
)
unzip("./2016/acs_16_5y.zip", exdir = "./2016/acs_5yr/")
temp <- list.files(path = "./2016/acs_5yr/", pattern = "e.*.txt", 
                   full.names = T) 
acs_16_5y <- lapply(temp, read.csv, header = F)
acs_16_5y <- lapply(acs_16_5y, function(x)
  x <- setDT(x))
file.remove("./2016/acs_16_5y.zip")
# Templates
download.file(
  "https://www2.census.gov/programs-surveys/acs/summary_file/2016/data/2016_5yr_Summary_FileTemplates.zip", "./2016/acs_2016_template.zip"
)
unzip("./2016/acs_2016_template.zip", exdir = "./2016/acs_5yr/")
temp <- list.files(path = "./2016/acs_5yr/templates/", pattern = "Seq.*.xls",
                   full.names = T)
acs_16_template <- lapply(temp, read_xls)
acs_16_template <- lapply(acs_16_template, function(x)
  x <- setDT(x))
file.remove("./2016/acs_2016_template.zip")
acs_id_cols <- acs_16_5y[[1]][,1:6]
acs_id_template <- acs_16_template[[1]][,1:6]
acs_16_5y <- lapply(acs_16_5y, function(x)
  x <- x %>% rename_at(vars(1:6), ~ names(acs_id_template)))
# Add GEOIDs
download.file(
  "https://www2.census.gov/programs-surveys/acs/summary_file/2016/documentation/geography/5yr_year_geo/ca.xlsx", "./2016/geoid_ca.xlsx"
)
geoid_ca <- read_xlsx("./2016/geoid_ca.xlsx")
acs_16_5y <- lapply(acs_16_5y, function(x)
  x <- x %>% mutate(LOGRECNO = sprintf("%07d", LOGRECNO)))
acs_16_5y <- lapply(acs_16_5y, function(x)
  x <- merge(geoid_ca, x, by = "LOGRECNO"))
acs_16_5y <- lapply(acs_16_5y, function(x)
  x <- setDT(x))

# Merging data and templates (if integrated data table needed)
# acs_16_5y_int <- lapply(acs_16_5y, function(x)
#   x <- x[, (1:6) := NULL])
# acs_16_5y_int <- bind_cols(acs_16_5y_int)
# acs_16_5y_int <- bind_cols(acs_id_cols, acs_16_5y_int)
# acs_16_template_int <- lapply(acs_16_template, function(x)
#   x <- x[, (1:6) := NULL])
# acs_16_template_int <- bind_cols(acs_16_template_int)
# acs_16_template_int <- bind_cols(acs_id_template, acs_16_template_int)
# names(acs_16_5y_int) <- names(acs_16_template_int)

# Convert ACS block group data to SR precincts----
# Aggregate block conversion file to block groups
sr_blk_g16 <- sr_blk_g16[c("SRPREC", "GEOID","BLKREG")]
sr_blk_g16 <- sr_blk_g16 %>% group_by(SRPREC, GEOID) %>%
  summarise_at("BLKREG", sum, na.rm = T)
sr_blk_g16 <- sr_blk_g16 %>% group_by(GEOID) %>%
  mutate(BLKGRP_TOT = sum(BLKREG))
sr_blk_g16 <- sr_blk_g16 %>% mutate(PCTBLK = BLKREG/BLKGRP_TOT)
# Convert ACS data to SR
acs_16_prec <- lapply(acs_16_5y, function(x) 
  x <- merge(sr_blk_g16, x, by = "GEOID"))
acs_16_prec <- lapply(acs_16_prec, function(x)
  x <- x %>% select(-c("GEOID", "BLKREG", "BLKGRP_TOT", "LOGRECNO", "STATE", 
                       "Name", "FILEID", "FILETYPE", "STUSAB", "CHARITER",
                       "SEQUENCE")))
acs_16_prec <- lapply(acs_16_prec, function(x)
  x <- x %>% mutate_at(vars(-SRPREC, -PCTBLK), funs(.*PCTBLK)))
acs_16_prec <- lapply(acs_16_prec, function(x)
  x <- x %>% group_by(SRPREC) %>% summarize_at(vars(-PCTBLK), sum))

# 2018----