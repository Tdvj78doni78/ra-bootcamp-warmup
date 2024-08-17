library(tidyverse)
library(readxl)

# 各ファイルを読み込み、リストに追加
library(readxl)

combined_data <- tibble()

# 各ファイルを読み込み、データフレームに結合
for (year in 1991:2016) {
  file_path <- paste0("01_data/raw/outcome/", year, ".xlsx")
  if (file.exists(file_path)) {
    data <- read_xlsx(file_path)
    combined_data <- bind_rows(combined_data, data)
  } else {
    warning(paste("File does not exist:", file_path))
  }
}
# 女子学生の4年卒業率の列を0から1のスケールに変更
combined_data <- combined_data %>%
  mutate(women_gradrate_4yr=women_gradrate_4yr* 0.01)

#全体の進学率を計算
combined_data <- combined_data%>%
  mutate(totalgradrate=tot4yrgrads/as.integer(totcohortsize))
#有効数字３桁に変換
combined_data <- combined_data %>%
  mutate(totalgradrate = round(totalgradrate, 3))
combined_data <- combined_data %>%
  filter(year < 2011)
#データの型変更
write.csv(combined_data, "Gradrate_Data.csv", row.names = FALSE)
