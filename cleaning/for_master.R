library(tidyverse)
covariates <- read.csv("covariates.csv")
semesters <- read.csv("semesterdummy.csv")
gradrates<- read.csv("Gradrate_Data.csv")

#年とunitidをキーにしてデータを結合
master_data <- semesters %>%
  left_join(gradrates, by = c("year", "unitid")) %>%
  left_join(covariates, by = c("year", "unitid"))
write.csv(master_data, "master_data.csv", row.names = FALSE)
