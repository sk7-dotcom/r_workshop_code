# Loading necessary libraries
library(ggplot2)
library(dplyr)

# Fetching data
data <- airquality

# Data Cleaning - Remove rows with NA
cleaned_data <- data %>% 
  na.omit()

# Function to calculate average solar radiation for each month
calculate_average_solar <- function(month, data) {
  avg_solar <- data %>%
    filter(Month == month) %>%
    summarise(avg_solar = mean(Solar.R)) %>%
    pull()
  return(avg_solar)
}

# Function to calculate correlation between Ozone and Solar Radiation for each month
calculate_correlation <- function(month, data) {
  correlation <- cor(data$Ozone[data$Month == month], data$Solar.R[data$Month == month])
  return(correlation)
}

# Calculating average and print to console
months <- c(5, 6, 7, 8, 9)
for (month in months) {
  avg_solar <- calculate_average_solar(month, cleaned_data)
  print(paste("Average Solar Radiation for Month", month, ": ", avg_solar))
}

# Calculating correlation and print to console
for (month in months) {
  correlation <- calculate_correlation(month, cleaned_data)
  print(paste("Correlation for Month", month, ": ", correlation))
}

# Function to save plots
save_plots <- function(month, data) {
  plot_data <- data[data$Month == month, ]
  g <- ggplot(plot_data, aes(x = Solar.R, y = Ozone)) + geom_point(aes(shape = factor(Month))) + ggtitle(month.name(month))
  ggsave(paste("plot_", tolower(month.name(month)), ".png", sep = ""), g)
}

# Save Plots
for (month in months) {
  save_plots(month, cleaned_data)
}

# Save data
write.csv(cleaned_data, "cleaned_data.csv", row.names = FALSE)
