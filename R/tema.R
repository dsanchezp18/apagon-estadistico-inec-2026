# ============================================================
# Tema y utilidades compartidas de los gráficos
# Author: Daniel Sanchez
# Purpose: Tema, paleta y formatos es-EC de los cuatro gráficos. Sigue el
#          estilo de las figuras públicas de enighur-quantificador:
#          theme_classic de 12 pt, sin título ni pie dentro de la imagen
#          (van en el texto del artículo), eje en gris y lienzo de 8 x 6,4 in.
# Inputs:  Ninguno
# Outputs: Objetos en memoria
# ============================================================

# 0. Setup ----

library(ggplot2)
library(scales)

# Un acento para lo destacado, azul para el resto y gris para referencias

color_acento <- "#C84040"
color_base <- "#6FA8DC"
color_barra <- "#357098"
color_gris <- "#6C7A80"

# Lienzo estándar de las figuras públicas: 8 x 6,4 in a 300 dpi (2400 x 1920 px)

lienzo_ancho <- 8
lienzo_alto <- 6.4

theme_grafico <- function(base_size = 12) {
  theme_classic(base_size = base_size) +
    theme(
      axis.text = element_text(colour = "grey20", size = base_size),
      axis.title = element_text(size = base_size),
      axis.line = element_line(colour = "grey60"),
      legend.position = "none",
      panel.grid = element_blank(),
      plot.margin = margin(8, 60, 8, 12)
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
