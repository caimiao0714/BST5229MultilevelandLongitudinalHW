dat = haven::read_sas("Final Project/FinalProjectData_bst522.sas7bdat")

pacman::p_load(tidyverse)

dat %>% 
  ggplot(aes(visit)) + 
  geom_histogram( fill = "blue", color = "white") + theme_bw()
