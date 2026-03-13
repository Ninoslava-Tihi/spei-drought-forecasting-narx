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

# Extract variables
spei <- as.numeric(data$SPEI_3)
temp <- as.numeric(data$Temperature)
prec <- as.numeric(data$Precipitation)
soil <- as.numeric(data$SoilMoisture)

# Create exogenous matrix
xreg <- cbind(temp, prec, soil)

# Convert SPEI to time series
start_year  <- data$Year[1]
start_month <- data$Month_num[1]

spei_ts <- ts(spei, start = c(start_year, start_month), frequency = 12)

# ==========================================
# 3. Rolling forecasting origin setup
# ==========================================

initial_train <- 60   # first training window
n <- length(spei_ts)

narx_predictions_lag2 <- c()
actuals <- c()

# ==========================================
# 4. Rolling forecasting loop
# ==========================================

for(i in initial_train:(n-1)){
  
  # Training series
  train_ts <- window(spei_ts, end = time(spei_ts)[i])
  
  # Exogenous variables
  xreg_train <- xreg[1:i, ]
  xreg_test  <- matrix(xreg[i+1, ], nrow = 1)
  
  # setting a fixed random seed to ensure reproducibility
  
  set.seed(123)
  # Fit NARX model
  model_lag2 <- nnetar(
    train_ts,
    p = 2,# number of SPEI lags
    xreg = xreg_train,
    size = 5,
    repeats = 20
  )
  
  # One-step ahead forecast
  fc_lag2 <- forecast(model_lag2, xreg = xreg_test, h = 1)
  
  # Store prediction and real value
  narx_predictions_lag2 <- c(narx_predictions_lag2, as.numeric(fc_lag2$mean))
  actuals <- c(actuals, spei_ts[i+1])
}

# ==========================================
# 5. Calculate performance metrics
# ==========================================

rmse_val <- rmse(actuals, narx_predictions_lag2)
mae_val  <- mae(actuals, narx_predictions_lag2)
r2_val   <- cor(actuals, narx_predictions_lag2)^2

results <- data.frame(
  Model = "NARX Rolling Origin",
  RMSE = rmse_val,
  MAE  = mae_val,
  R2   = r2_val
)

print(results)

# ==========================================
# 6. Plot results
# ==========================================

plot(actuals,
     type = "l",
     lwd = 3,
     col = "black",
     ylim = range(c(actuals, narx_predictions_lag2)),
     main = "NARX Rolling Origin: Real vs Predicted SPEI",
     xlab = "Forecast step",
     ylab = "SPEI")

lines(narx_predictions_lag2,
      col = "blue",
      lwd = 2,
      lty = 2)

legend("bottomright",
       legend = c("Real SPEI", "Predicted SPEI"),
       col = c("black", "blue"),
       lty = c(1,2),
       lwd = c(3,2),
       bty = "n")