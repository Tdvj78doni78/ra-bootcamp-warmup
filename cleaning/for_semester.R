library(tidyverse)
#1データの読み込み
semester_1<-read.csv("01_data/raw/semester_dummy/semester_data_1.csv")
semester_2<-read.csv("01_data/raw/semester_dummy/semester_data_2.csv")
#2 データの列名変更  1行目を列名にする
colnames(semester_1) <- semester_1[1,]
semester_1 <- semester_1[-1,]
colnames(semester_2) <- colnames(semester_1)
#文字型を整数型にする
semester_1 <- semester_1 %>%
  mutate(unitid = as.integer(unitid),
         year = as.integer(year),
         semester = as.integer(semester),
         quarter = as.integer(quarter),
         Y = as.integer(Y))
#3 データを縦に結合
semesterdummy <- bind_rows(semester_1, semester_2)
#4Y列の削除
semesterdummy <- semesterdummy %>%
  select(-Y)
#5セメスター開始年の追加
semesterdummy <- semesterdummy %>%
  group_by(unitid) %>%
  mutate(semester_start_year = ifelse(any(semester == 1), min(year[semester == 1], na.rm = TRUE), NA)) %>%
  mutate(semester_start_year = ifelse(all(semester == 1), NA, semester_start_year)) %>%
  ungroup()

#6セメスター開始後ダミーの追加
semesterdummy <- semesterdummy %>%
  group_by(unitid) %>%
  mutate(after_semester_dummy = ifelse(is.na(semester_start_year), NA, ifelse(year >= semester_start_year, 1, 0))) %>%
  ungroup()

#データの保存
write.csv(semesterdummy, "semesterdummy.csv", row.names = FALSE)