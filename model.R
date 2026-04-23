#Library
library(dplyr)
library(lme4)

#Dataset

ch3 <- read.csv(
  "https://raw.githubusercontent.com/jlopezco-wm/coagulation/main/Lopez_coagulation_JWREUSE.csv",
  stringsAsFactors = TRUE
)

#Model
tanfloc_rem<-lmer(removal ~ dose * turb_ini + I(dose^2) + I(turb_ini^2) + (1 | round), data = subset(ch3,coagulant == "tanfloc"))
saveRDS(tanfloc_rem, "tanfloc_rem.rds") #this RDS contains the model formula with coefficients, no data is stored

# predict(tanfloc_rem, newdata = data.frame(dose = 1337, turb_ini = 2856.5*(1 - 0.681)), re.form = NA)   test

# Max clarification model -------------------------------------------------

#turbidity is in NTU
#effluent in in litres
#concentration is in mg/L

# Function  1------------------------------------------------------------

dose_mod <- function(model = tanfloc_rem,
                        turbidity,
                        target,
                        max_dose = 10000) {
  turb_ini <- turbidity * (1 - 0.681)
  
  doses <- 0:max_dose   # ← critical change
  
  preds <- predict(
    model,
    newdata = data.frame(
      dose = doses,
      turb_ini = rep(turb_ini, length(doses))
    ),
    re.form = NA
  )
  
  if (length(preds) < 2 || all(is.na(preds))) {
    return(NA_real_)
  }
  
  target_pred <- turb_ini - target
  
  # Crossing
  crossing <- target >= turb_ini - preds
  
  idx <- which(crossing)[1]
  
  if (is.na(idx)) {
    return(NA_real_)
  }
  return(as.numeric(idx-1))  #-1 matches with tanfloc_max model
}
#dose_mod(tanfloc_rem, turbidity = 2856.5, target = 50)


# Function  2------------------------------------------------------------


tanfloc_mod <- function(model = tanfloc_rem,
                        turbidity,
                        effluent,
                        concentration,
                        target,
                        nsim = 1000) {
  
  default_concentration <- 207
  
  #IF concentration is left blank, then use default_concentration
  if (missing(concentration)) {
    concentration <- default_concentration
  }
  
  # Model should be lmer
  if (!inherits(model, "lmerMod")) {
    stop("model must be a fitted lmer model")
  }
  
  # Point estimate
  dose_hat <- dose_mod(model, turbidity,target)
  
  # Bootstrap CI
  library(lme4)
  
  boot_res <- bootMer(
    model,
    FUN = function(fit)
      dose_mod(fit, turbidity,target),
    nsim = nsim,
    type = "parametric",
    re.form = NA,
    use.u = FALSE
  )
  
  dose_ci <- quantile(
    boot_res$t,
    c(0.025, 0.5, 0.975),
    na.rm = TRUE
  )
  
  dose_ml_ci <- dose_ci * effluent / concentration
  
  
  
  # ---- FORMATTED OUTPUT ----
  paste(
    paste("Dose:", round(dose_hat, 1), "mg/L"),
    paste("Volume:",
          round(dose_hat * effluent / concentration, 1),
          "mL of Tanfloc"),
    paste(
      "Acceptable range:",
      round(dose_ml_ci[1], 1), "-",
      round(dose_ml_ci[3], 1),
      "mL of Tanfloc"
    ),
    sep = "\n"
  )
  
}

#tanfloc_mod(turbidity = 2856.5,effluent = 80,concentration = 1000*0.8545*0.25,target = 0)
saveRDS(dose_mod, "dose_mod.rds")
saveRDS(tanfloc_mod, "tanfloc_mod.rds")

