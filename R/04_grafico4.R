# ============================================================
# Gráfico 4. Línea de tiempo de la transición de la ENEMDU a la ENCIET
# Author: Daniel Sanchez
# Purpose: Barras de rango para los periodos y rombos para las fechas
#          puntuales, noviembre de 2024 a diciembre de 2026
# Inputs:  data/grafico4_cronologia.csv, quantificador.png
# Outputs: figuras/grafico4.png, figuras/grafico4.svg
# ============================================================

# 0. Setup ----

library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(stringr)

source("R/tema.R")

# Desde esta fecha la fecha del hito va a la izquierda de la marca, y desde
# esta otra el nombre del hito se alinea al final de la barra

fecha_corte_fecha <- ymd("2026-06-01")
fecha_corte_nombre <- ymd("2026-10-01")

# 1. Read inputs ----

cronologia <- read_csv(
  "data/grafico4_cronologia.csv",
  col_types = cols(hito = col_character(), inicio = col_date(), fin = col_date())
)

# 3. Prepare data ----

# El orden del CSV se conserva de arriba hacia abajo; el apagón va en acento.
# Cada carril lleva el nombre del hito arriba de la marca y la fecha al lado.

cronologia <- cronologia |>
  mutate(
    destacado = hito == "Apagón de publicaciones",
    color_marca = if_else(destacado, color_acento, color_gris),
    color_nombre = if_else(destacado, color_acento, "grey20"),
    fila = rev(row_number()),
    mismo_anio = year(inicio) == year(fin),
    fecha_inicio = paste(day(inicio), meses_abreviados[month(inicio)], year(inicio)),
    fecha_fin = paste(day(fin), meses_abreviados[month(fin)], year(fin)),
    fecha_inicio_corta = paste(day(inicio), meses_abreviados[month(inicio)]),
    etiqueta_fecha = case_when(
      inicio >= fin ~ fecha_inicio,
      mismo_anio ~ paste0(fecha_inicio_corta, " a ", fecha_fin),
      .default = paste0(fecha_inicio, " a ", fecha_fin)
    ),
    x_fecha = if_else(fin > fecha_corte_fecha, inicio - 22, fin + 22),
    hjust_fecha = if_else(fin > fecha_corte_fecha, 1, 0),
    nombre_tardio = fin > fecha_corte_nombre,
    x_nombre = if_else(nombre_tardio, fin, inicio + (fin - inicio) / 2),
    hjust_nombre = if_else(nombre_tardio, 1, 0.5)
  )

periodos <- cronologia |>
  filter(inicio < fin)

fechas <- cronologia |>
  filter(inicio >= fin)

# 4. Plot ----

grafico4 <- ggplot() +
  geom_segment(
    data = periodos,
    aes(x = inicio, xend = fin, y = fila, yend = fila, colour = color_marca),
    linewidth = 3.5, lineend = "butt"
  ) +
  geom_point(
    data = fechas,
    aes(x = inicio, y = fila, colour = color_marca),
    shape = 18, size = 3.5
  ) +
  geom_text(
    data = cronologia,
    aes(
      x = x_nombre, y = fila + 0.4, label = hito, hjust = hjust_nombre,
      fontface = if_else(destacado, "bold", "plain"),
      colour = color_nombre
    ),
    size = 3, vjust = 0
  ) +
  geom_text(
    data = cronologia,
    aes(x = x_fecha, y = fila, label = etiqueta_fecha, hjust = hjust_fecha),
    size = 2.6, colour = "grey30"
  ) +
  scale_colour_identity() +
  scale_y_continuous(limits = c(0.4, nrow(cronologia) + 0.9), expand = c(0, 0)) +
  scale_x_date(
    limits = c(ymd("2024-10-15"), ymd("2027-01-15")),
    breaks = seq(ymd("2024-11-01"), ymd("2026-11-01"), by = "6 months"),
    labels = \(x) paste(meses_abreviados[month(x)], year(x)),
    expand = c(0, 0)
  ) +
  labs(
    title = wrap_title_house(
      "Línea de tiempo de la transición de la ENEMDU a la ENCIET, noviembre de 2024 a diciembre de 2026"
    ),
    caption = wrap_caption_house(
      "Fuente: INEC, calendario 2026 y contratos EC-INEC-489713 y EC-INEC-533831; Banco Mundial, informes de supervisión del proyecto P178564; CNE. Elaboración: El Quantificador."
    ),
    x = NULL,
    y = NULL
  ) +
  theme_quantificador() +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line.y = element_blank()
  )

grafico4 <- agregar_logo(grafico4)

# 6. Write outputs ----

ggsave(
  "figuras/grafico4.png",
  grafico4,
  device = ragg::agg_png,
  width = lienzo_ancho, height = lienzo_alto, units = "in", dpi = 300
)

ggsave(
  "figuras/grafico4.svg",
  grafico4,
  device = svglite::svglite,
  width = lienzo_ancho, height = lienzo_alto, units = "in"
)

message("Gráfico 4 guardado en figuras/")
