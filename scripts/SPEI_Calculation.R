# =========================
# 1. Install and load required packages
# =========================
if (!require(readxl)) install.packages("readxl")
if (!require(writexl)) install.packages("writexl")
if (!require(SPEI)) install.packages("SPEI")

library(readxl)
library(writexl)
library(SPEI)
library(forecast)
library(ggplot2)

# =========================
# 2. Load the dataset
# =========================
# Replace the file name with your actual Excel file
data <- read_excel("C:/Users/bsshe/Desktop/Doktorske/podaci/31.08.2021/podaci/rad za Information 2026/files for Github/data/monthly-data.xlsx")

# Inspect the first rows and structure
print(head(data))
str(data)

# =========================
# 3. Convert Year and Month into a proper Date column
# =========================
# Convert Year to numeric
data$Year <- as.numeric(data$Year)

# Convert full month names (January, February, ...) to month numbers
data$Month_num <- match(trimws(data$Month), month.name)

# Create Date column in YYYY-MM-DD format
data$Date <- as.Date(sprintf("%d-%02d-01", data$Year, data$Month_num))

# Check if conversion worked
print(head(data[, c("Year", "Month", "Month_num", "Date")]))

# =========================
# 4. Sort data by Date (important for time series analysis)
# =========================
data <- data[order(data$Date), ]

# =========================
# 5. Extract precipitation and temperature
# =========================
# Make sure these column names exactly match your Excel file
precip <- as.numeric(data$Precipitation)
temp   <- as.numeric(data$Temperature)

# =========================
# 6. Create time series objects
# =========================
# Monthly data -> frequency = 12
# Start year and month are taken from the first row
start_year  <- data$Year[1]
start_month <- data$Month_num[1]

precip_ts <- ts(precip, start = c(start_year, start_month), frequency = 12)
temp_ts   <- ts(temp,   start = c(start_year, start_month), frequency = 12)

# =========================
# 7. Calculate PET using Thornthwaite method
# =========================
# Latitude for Novi Sad
latitude <- 45.27

pet <- thornthwaite(temp_ts, lat = latitude)

# =========================
# 8. Calculate climatic water balance
# =========================
water_balance <- precip_ts - pet

# =========================
# 9. Calculate SPEI-3
# =========================
# scale = 3 means SPEI-3
spei_result <- spei(water_balance, scale = 3)

# Extract fitted SPEI values
spei_values <- as.numeric(spei_result$fitted)

# =========================
# 10. Add PET, water balance, and SPEI to the dataset
# =========================
data$PET <- as.numeric(pet)
data$WaterBalance <- as.numeric(water_balance)
data$SPEI_3 <- spei_values

# =========================
# 11. Inspect the results
# =========================
print(head(data[, c("Date", "Precipitation", "Temperature", "PET", "WaterBalance", "SPEI_3")]))

# =========================
# 12. Save full dataset with SPEI-3 to Excel
# =========================
write_xlsx(data, "C:/Users/bsshe/Desktop/Doktorske/podaci/31.08.2021/podaci/rad za Information 2026/files for Github/data/climate_data_with_SPEI3.xlsx")
