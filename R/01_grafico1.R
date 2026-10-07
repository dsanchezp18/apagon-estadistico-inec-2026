# ============================================================
# Gráfico 1. Indicadores de mercado laboral y pobreza
# Author: Daniel Sanchez
# Purpose: Barras horizontales en dos bloques (empleo y pobreza), nacional,
#          mayo de 2026 y diciembre de 2025
# Inputs:  data/grafico1_enemdu.csv
# Outputs: figuras/grafico1.png, figuras/grafico1.svg
# ============================================================

# 0. Setup ----

library(dplyr)
library(forcats)
library(ggplot2)
library(readr)

source("R/tema.R")

# 1. Read inputs ----

enemdu <- read_csv("data/grafico1_enemdu.csv", show_col_types = FALSE)

# 3. Prepare data ----

# El orden del CSV se conserva de arriba hacia abajo dentro de cada bloque

enemdu <- enemdu |>
  mutate(
    grupo = factor(
      grupo,
      levels = c("empleo", "pobreza"),
      labels = c(
        "Mercado laboral, mayo de 2026",
        "Pobreza por ingresos, diciembre de 2025"
      )
    ),
    indicador = fct_rev(fct_inorder(indicador)),
    etiqueta = porcentaje_es(valor)
  )

# 4. Plot ----

grafico1 <- ggplot(enemdu, aes(x = valor, y = indicador)) +
  geom_col(fill = color_barra, width = 0.65) +
  geom_text(aes(label = etiqueta), hjust = -0.15, size = 4.2, colour = "grey20") +
  facet_wrap(vars(grupo), ncol = 1, scales = "free_y") +
  scale_x_continuous(
    limits = c(0, 65),
    breaks = seq(0, 60, 20),
    expand = c(0, 0)
  ) +
  labs(x = "Porcentaje (%)", y = NULL) +
  theme_grafico() +
  theme(
    panel.spacing.y = unit(0.35, "in"),
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0, face = "bold", size = 12, colour = "grey20")
  )

# 6. Write outputs ----

ggsave(
  "figuras/grafico1.png",
  grafico1,
  device = ragg::agg_png,
  width = lienzo_ancho, height = lienzo_alto, units = "in", dpi = 300
)

ggsave(
  "figuras/grafico1.svg",
  grafico1,
  device = svglite::svglite,
  width = lienzo_ancho, height = lienzo_alto, units = "in"
)

message("Gráfico 1 guardado en figuras/")
