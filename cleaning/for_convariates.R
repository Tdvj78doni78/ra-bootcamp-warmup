library(tidyverse)
library(readxl)
convariates<-read_xlsx("01_data/raw/covariates/covariates.xlsx")
#名前変更
convariates<-rename(convariates,unitid=university_id)
#データの名前を整える
convariates <- convariates %>%
  mutate(unitid = str_replace(unitid, "aaaa", ""))
# wide型に変更
convariates_wide <- convariates %>%
  pivot_wider(names_from = category, values_from = value, 
              names_prefix = "", 
              values_fill = list(value = NA))
semester<-read.csv("semesterdummy.csv")
Gradrate<-read.csv("Gradrate_Data.csv")

# 年を抽出して一意の年を取得
gradrate_years <- unique(Gradrate$year)
semester_years <- unique(semester$year)

# covariatesデータの期間を調整
min_year <- max(min(gradrate_years), min(semester_years))
max_year <- min(max(gradrate_years), max(semester_years))

new_covariates <- convariates_wide[convariates_wide$year >= min_year & convariates_wide$year <= max_year, ]
#1994年のデータを削除
new_covariates <- subset(new_covariates, year != 1994)
# Gradrateに含まれるunitidを特定
gradrate_unitids <- unique(Gradrate$unitid)

# covariatesに含まれるunitidをGradrateのunitidに揃える
new_covariates <- new_covariates %>%
  filter(unitid %in% gradrate_unitids)
write.csv(new_covariates,"covariates.csv",row.names=FALSE)