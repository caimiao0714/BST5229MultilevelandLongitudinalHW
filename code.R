dat = haven::read_sas("Final Project/FinalProjectData_bst522.sas7bdat")

pacman::p_load(tidyverse)

dat %>% 
  ggplot(aes(visit)) + 
  geom_histogram( fill = "blue", color = "white") + theme_bw()
ggsave("Final project/Count of visits.png", width = 10, height = 6.18, dpi = 500)