install.packages("ggplot2")
install.packages("rlang")
library(ggplot2)
library(rlang)
master<-read.csv("master_data.csv")
#1.各列に含まれるNAの数
na_count <- sapply(master, function(x) sum(is.na(x)))

print(na_count)
#主な記述統計

# after_semester_dummyがNAの行とそうでない行に分割
na_group <- master[is.na(master$after_semester_dummy), ]
non_na_group <- master[!is.na(master$after_semester_dummy), ]

# 各グループの平均値と標準偏差を計算
na_summary <- sapply(na_group, function(x) c(mean = mean(x, na.rm = TRUE), sd = sd(x, na.rm = TRUE)))
non_na_summary <- sapply(non_na_group, function(x) c(mean = mean(x, na.rm = TRUE), sd = sd(x, na.rm = TRUE)))

# 結果を表示
print("NA group summary:")
print(na_summary)

print("Non-NA group summary:")
print(non_na_summary)
# 5. 全データの記述統計
overall_summary <- sapply(master, function(x) c(mean = mean(x, na.rm = TRUE), sd = sd(x, na.rm = TRUE)))
print("Overall summary statistics:")
print(overall_summary)
#四年卒業率の平均推移
library(ggplot2)

# データを年ごとにグループ化し、4年卒業率の平均を計算

yearly_avg <- aggregate(master$totalgradrate, by = list(master$year), FUN = mean, na.rm = TRUE)
colnames(yearly_avg) <- c("Year", "Average_Graduation_Rate")

# 折れ線グラフを作成
ggplot(data = yearly_avg, aes(x = Year, y = Average_Graduation_Rate)) +
  geom_line() +
  geom_point() +
  labs(title = "4年卒業率の平均推移", x = "年", y = "平均卒業率") +
  theme_minimal()

#semester導入率の推移
# 年ごとにsemester導入率を計算
semester_rate <- aggregate(semester ~ year, data = master, FUN = mean)

# 列名変更
colnames(semester_rate) <- c("Year", "Semester_Rate")


# 折れ線グラフを作成
ggplot(data = semester_rate, aes(x = Year, y = Semester_Rate)) +
  geom_line() +
  geom_point() +
  labs(title = "Semester導入率の推移", x = "年", y = "導入率") +
  theme_minimal()
# 必要なパッケージのインストールと読み込み
install.packages("ggplot2")
install.packages("rlang")
library(ggplot2)
library(rlang)

# データの読み込み
master <- read.csv("master_data.csv")

# 女子学生比率を計算
master$women_ratio <- master$w_cohortsize / master$totcohortsize

# 散布図を作成する関数を定義
create_scatter_plot <- function(data, x_var, y_var) {
  x_var <- enquo(x_var)
  y_var <- enquo(y_var)
  
  ggplot(data, aes(x = !!x_var, y = !!y_var)) +
    geom_point() +
    labs(x = as_label(x_var), y = as_label(y_var)) +
    theme_minimal()
}

# 女子学生比率の散布図を作成
scatter_plot_women <- create_scatter_plot(master, women_ratio, totalgradrate)
print(scatter_plot_women)

# 白人学生割合の散布図を作成
scatter_plot_white <- create_scatter_plot(master, white_cohortsize, totalgradrate)
print(scatter_plot_white)

# 学費の散布図を作成
scatter_plot_tuition <- create_scatter_plot(master, instatetuition, totalgradrate)
print(scatter_plot_tuition)