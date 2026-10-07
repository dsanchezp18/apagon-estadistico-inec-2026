# ============================================================
# Estilo de la casa de El Quantificador
# Author: Daniel Sanchez
# Purpose: Tema, paleta, envoltorios de texto, formatos es-EC y logo que usan
#          los cuatro gráficos. Sigue HOUSE_STYLE.md de
#          elquantificador/graficos-el-quantificador (lienzo de 4 x 5 pulgadas).
# Inputs:  quantificador.png (logo)
# Outputs: Objetos en memoria
# ============================================================

# 0. Setup ----

library(cowplot)
library(ggplot2)
library(scales)
library(stringr)

# Un solo acento para lo destacado y gris para el resto

color_acento <- "#2D7DB3"
color_gris <- "#7B8D97"

logo_path <- "quantificador.png"

# Tamaños de la casa (pt) y ancho de ajuste del título

tamano_titulo <- 12.5
tamano_subtitulo <- 9
tamano_pie <- 6.5
ancho_titulo <- 38

house_wrap_width <- function(text_size_pt,
                             reference_width = ancho_titulo,
                             reference_size_pt = tamano_titulo) {
  round(reference_width * reference_size_pt / text_size_pt)
}

ancho_pie <- round(60 * tamano_subtitulo / tamano_pie)

wrap_title_house <- function(text) str_wrap(text, width = ancho_titulo)
wrap_caption_house <- function(text) str_wrap(text, width = ancho_pie)

# Tema base: theme_classic con textos grises, sin cuadrícula ni leyenda

theme_quantificador <- function() {
  theme_classic() +
    theme(
      axis.text = element_text(colour = "grey20", size = 7.5),
      axis.title.x = element_text(size = 7, margin = margin(t = 8), hjust = 0),
      axis.title.y = element_text(size = 7, margin = margin(r = 6), hjust = 1),
      plot.title = element_text(
        colour = "grey20", size = tamano_titulo, face = "bold", hjust = 0
      ),
      plot.subtitle = element_text(
        colour = "grey30", size = tamano_subtitulo, lineheight = 1.1, hjust = 0
      ),
      plot.caption = element_text(
        colour = "grey30", size = tamano_pie, lineheight = 1.1, hjust = 0,
        margin = margin(t = 6)
      ),
      axis.line = element_line(colour = "grey60"),
      legend.position = "none",
      panel.grid = element_blank(),
      plot.margin = margin(6, 36, 6, 16),
      plot.title.position = "plot",
      plot.caption.position = "plot"
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

# Logo con la posición y el tamaño de la casa; solo y puede variar

agregar_logo <- function(plot, y = 0.28) {
  ggdraw() +
    theme(
      plot.background = element_rect(fill = "white", colour = NA),
      panel.background = element_rect(fill = "white", colour = NA)
    ) +
    draw_plot(plot, x = 0, y = 0, width = 1, height = 1) +
    draw_image(logo_path, x = 0.88, y = y, width = 0.09, height = 0.09)
}

# Lienzo estándar: 4 x 5 pulgadas a 300 dpi

lienzo_ancho <- 4
lienzo_alto <- 5
