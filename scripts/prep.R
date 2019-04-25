  library(tidyverse)
  library(pastecs)
  library(reshape2)
  library(sf) 
  # 2016----  

    ## Import data tables & shapefiles----
  setwd("~/projects/research/ca-political-power/")
  vote16 <- read.csv("./2016/state_g16_sov_data_by_g16_srprec/state_g16_sov_data_by_g16_srprec.csv")
  reg16 <- read.csv("./2016/state_g16_registration_by_g16_srprec/state_g16_registration_by_g16_srprec.csv")
  shape16 <- st_read("./2016/mprec_state_g16_v01_shp/mprec_state_g16_v01.shp")
  