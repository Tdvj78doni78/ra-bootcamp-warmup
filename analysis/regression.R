install.packages("broom")
install.packages("knitr")
library(broom)
library(knitr)

# 回帰分析
model <- lm(totalgradrate ~ after_semester_dummy, data = master_data)

# 結果を表にまとめる
summary_table <- tidy(model)

# 結果を表示
print(kable(summary_table, format = "markdown"))