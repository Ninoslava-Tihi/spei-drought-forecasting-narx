



# =========================
# Load data with SPEI3
# =========================
data <- read_excel("climate_data_with_SPEI3.xlsx")


# =========================
# create a clean file with only Date and SPEI_3
# =========================
spei_only <- data.frame(
  Date = data$Date,
  SPEI = data$SPEI_3
)



# Remove NA values (the first rows for SPEI-3 are expected to be NA)
spei_only <- na.omit(spei_only)


# =========================
# 2. Convert the SPEI-3 column from the dataset into a time series object.
# The frequency = 12 indicates that the data are monthly observations.
# =========================
spei_ts <- ts(data$SPEI_3, frequency = 12)


# =========================
# 3. Plot the Autocorrelation Function (ACF) of the SPEI-3 time series.
# =========================
ggAcf(spei_ts) +
  ggtitle("ACF of SPEI-3 Time Series")

# =========================
# 4. Plot the Partial Autocorrelation Function (ACF) of the SPEI-3 time series.
# =========================
ggPacf(spei_ts) +
  ggtitle("PACF of SPEI-3 Time Series")


# =========================
# 5. Optional: plot SPEI-3 time series
# =========================
plot(spei_only$Date, spei_only$SPEI,
     type = "l",
     lwd = 2,
     main = "SPEI-3 Time Series",
     xlab = "Date",
     ylab = "SPEI-3")
abline(h = 0, lty = 2)