# ============================================================
# Tema y utilidades compartidas de los gráficos
# Author: Daniel Sanchez
# Purpose: Define el tema, la paleta y los formatos es-EC que usan los
#          cuatro gráficos. Cada script lo carga con source("R/tema.R").
# Inputs:  Ninguno
# Outputs: Objetos en memoria (theme_project, paleta, formatos)
# ============================================================

# 0. Setup ----

library(ggplot2)
library(scales)

# Un solo acento para lo destacado y gris para el resto

color_acento <- "#0D3692"
color_gris <- "#9A9A9A"

# Base de 11 pt porque las figuras miden 20 cm de ancho y se leen en pantalla

theme_project <- function(base_size = 11) {
  theme_minimal(base_size = base_size) +
    theme(
      text = element_text(family = "serif"),
      plot.background = element_rect(fill = "white", colour = "white"),
      panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.5),
      panel.grid.major = element_line(linetype = "dashed", colour = "grey85"),
      panel.grid.minor = element_blank(),
      plot.title = element_text(face = "bold", size = 12.5),
      plot.title.position = "plot",
      plot.caption = element_text(hjust = 0, size = 7.5, colour = "grey30"),
      plot.caption.position = "plot",
      plot.margin = margin(10, 12, 8, 10),
      legend.position = "bottom"
    )
}

# Formato es-EC: punto de miles, coma decimal y espacio fino antes del %

numero_es <- function(x, accuracy = 0.1) {
  number(x, accuracy = accuracy, big.mark = ".", decimal.mark = ",")
}

porcentaje_es <- function(x, accuracy = 0.1) {
  paste0(numero_es(x, accuracy), " %")
}

meses_abreviados <- c(
  "ene", "feb", "mar", "abr", "may", "jun",
  "jul", "ago", "sep", "oct", "nov", "dic"
)

# Ancho de ajuste de texto proporcional al tamaño de letra del elemento

house_wrap_width <- function(text_size_pt,
                             reference_width = 82,
                             reference_size_pt = 12.5) {
  round(reference_width * reference_size_pt / text_size_pt)
}

ancho_titulo <- house_wrap_width(12.5)
ancho_pie <- house_wrap_width(7.5)
