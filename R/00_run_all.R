# ============================================================
# Reproducir los cuatro gráficos
# Author: Daniel Sanchez
# Purpose: Ejecuta los cuatro scripts en orden. Corre desde la raíz del
#          repositorio: Rscript R/00_run_all.R
# Inputs:  data/*.csv
# Outputs: figuras/grafico1 a grafico4 (.png y .svg)
# ============================================================

# 0. Setup ----

dir.create("figuras", recursive = TRUE, showWarnings = FALSE)

# 4. Calculate estimates ----

source("R/01_grafico1.R")
source("R/02_grafico2.R")
source("R/03_grafico3.R")
source("R/04_grafico4.R")
