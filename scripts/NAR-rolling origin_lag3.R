# ==========================================
# 1. Load required packages
# ==========================================
if (!require(readxl)) install.packages("readxl")
if (!require(forecast)) install.packages("forecast")
if (!require(Metrics)) install.packages("Metrics")

library(readxl)
library(forecast)
library(Metrics)

# ==========================================
# 2. Load dataset
# ==========================================
data <- read_excel("C:/Users/bsshe/Desktop/Doktorske/podaci/31.08.2021/podaci/rad za Information 2026/files for Github/data/climate_data_with_SPEI3.xlsx")

# Remove missing values
data <- na.omit(data)

# Extract SPEI values
spei <- as.numeric(data$SPEI_3)

# Convert to time series
start_year  <- data$Year[1]
start_month <- data$Month_num[1]

spei_ts <- ts(spei, start = c(start_year, start_month), frequency = 12)

# ==========================================
# 3. Rolling forecasting origin setup
# ==========================================
initial_train <- 60
n <- length(spei_ts)



# ==========================================
# 5. Rolling forecasting loop
# ==========================================

nar_predictions_lag3<- c()
actuals <- c()

for(i in initial_train:(n-1)){
  
  # Training data
  train_ts <- window(spei_ts, end = time(spei_ts)[i])
  
  # setting a fixed random seed to ensure reproducibility
  set.seed(123)

  
  # NAR model with lag 3
  model_lag3 <- nnetar(
  train_ts,
  p = 3,      # lag 3
  size = 5,
  repeats = 20
  )
  
  # One-step ahead forecast
  fc_lag3 <- forecast(model_lag3, h = 1)

  
  # Store prediction 3nd actual value
  nar_predictions_lag3 <- c(nar_predictions_lag3, as.numeric(fc_lag3$mean))
  actuals <- c(actuals, spei_ts[i+1])
}

# ==========================================
# 6. Compute performance metrics
# ==========================================
rmse_val <- rmse(actuals, nar_predictions_lag3)
mae_val  <- mae(actuals, nar_predictions_lag3)
r2_val   <- cor(actuals, nar_predictions_lag3)^2

results <- data.frame(
  Model = "NAR Rolling Origin",
  RMSE = rmse_val,
  MAE = mae_val,
  R2 = r2_val
)

print(results)

# ==========================================
# 7. Plot real vs predicted values
# ==========================================
plot(actuals,
     type = "l",
     lwd = 3,
     col = "black",
     ylim = range(c(actuals, nar_predictions_lag3)),
     main = "NAR Rolling Origin: Real vs Predicted SPEI",
     xlab = "Forecast step",
     ylab = "SPEI")

lines(nar_predictions_lag3,
      col = "red",
      lwd = 2,
      lty = 2)

legend("bottomright",
       legend = c("Real SPEI", "Predicted SPEI"),
       col = c("black", "red"),
       lty = c(1,2),
       lwd = c(3,2),
       bty = "n")