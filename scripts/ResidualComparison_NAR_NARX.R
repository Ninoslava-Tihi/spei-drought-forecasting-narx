# ==========================================
# 1. Match prediction lengths with actual values
# ==========================================
nar_predictions_lag2 <- nar_predictions_lag2[1:length(actuals)]
narx_predictions_lag3 <- narx_predictions_lag3[1:length(actuals)]

# ==========================================
# 2. Compute residuals
# ==========================================
nar_residuals <- actuals - nar_predictions_lag2
narx_residuals <- actuals - narx_predictions_lag3



# ==========================================
# 3. Create dataframe
# ==========================================
residual_df <- data.frame(
  Time = 1:length(actuals),
  NAR_Residuals = nar_residuals,
  NARX_Residuals = narx_residuals
)
print(residual_df)



residual_summary <- data.frame(
  Model = c("NAR", "NARX"),
  Mean  = c(mean(nar_residuals), mean(narx_residuals)),
  SD    = c(sd(nar_residuals), sd(narx_residuals)),
  Min   = c(min(nar_residuals), min(narx_residuals)),
  Max   = c(max(nar_residuals), max(narx_residuals))
)

print(residual_summary)
# ==========================================
# 4. Base R plot
# ==========================================
plot(residual_df$Time,
     residual_df$NAR_Residuals,
     type = "l",
     lwd = 2,
     col = "red",
     ylim = range(c(residual_df$NAR_Residuals, residual_df$NARX_Residuals)),
     main = "Residual Comparison: NAR vs NARX",
     xlab = "Forecast step",
     ylab = "Residual")

lines(residual_df$Time,
      residual_df$NARX_Residuals,
      col = "blue",
      lwd = 2,
      lty = 2)

abline(h = 0, lty = 3, col = "black")

legend("bottomleft",
       legend = c("NAR Residuals", "NARX Residuals"),
       col = c("red", "blue"),
       lty = c(1, 2),
       lwd = 2,
       bty = "n")








