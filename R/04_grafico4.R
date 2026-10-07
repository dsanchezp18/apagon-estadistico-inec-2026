# ============================================================
# Gráfico 4. Línea de tiempo de la transición de la ENEMDU a la ENCIET
# Author: Daniel Sanchez
# Purpose: Barras de rango para los periodos y rombos para las fechas
#          puntuales, noviembre de 2024 a diciembre de 2026
# Inputs:  data/grafico4_cronologia.csv
# Outputs: figuras/grafico4.png, figuras/grafico4.svg
# ============================================================

# 0. Setup ----

library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(tibble)

source("R/tema.R")

# Desde esta fecha la fecha del hito va a la izquierda de la marca

fecha_corte_fecha <- ymd("2026-06-01")

# 1. Read inputs ----

cronologia <- read_csv(
  "data/grafico4_cronologia.csv",
  col_types = cols(hito = col_character(), inicio = col_date(), fin = col_date())
)

# 3. Prepare data ----

# El orden del CSV se conserva de arriba hacia abajo; el apagón va en acento

cronologia <- cronologia |>
  mutate(
    destacado = hito == "Apagón de publicaciones",
    color_marca = if_else(destacado, color_acento, color_base),
    color_fecha = if_else(destacado, color_acento, "grey30"),
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
    x_fecha = if_else(fin > fecha_corte_fecha, inicio - 10, fin + 24),
    hjust_fecha = if_else(fin > fecha_corte_fecha, 1, 0)
  )

periodos <- cronologia |>
  filter(inicio < fin)

fechas <- cronologia |>
  filter(inicio >= fin)

# 4. Plot ----

# Diagrama de Gantt: una fila por hito, bandas alternas, cuadrícula trimestral,
# barras para los periodos (el último día cuenta completo) y rombos para las
# fechas puntuales. Los rótulos del eje y siguen el orden de los cortes.

bandas <- cronologia |>
  filter(fila %% 2 == 0)

trimestres <- tibble(inicio_trimestre = seq(ymd("2024-11-01"), ymd("2027-01-01"), by = "3 months"))

grafico4 <- ggplot() +
  geom_rect(
    data = bandas,
    aes(ymin = fila - 0.5, ymax = fila + 0.5),
    xmin = -Inf, xmax = Inf, fill = "grey95"
  ) +
  geom_vline(
    data = trimestres,
    aes(xintercept = inicio_trimestre),
    colour = "grey85", linewidth = 0.4
  ) +
  geom_rect(
    data = periodos,
    aes(xmin = inicio, xmax = fin + 1, ymin = fila - 0.3, ymax = fila + 0.3, fill = color_marca)
  ) +
  geom_point(
    data = fechas,
    aes(x = inicio, y = fila, colour = color_marca),
    shape = 18, size = 6
  ) +
  geom_text(
    data = cronologia,
    aes(
      x = x_fecha, y = fila, label = etiqueta_fecha, hjust = hjust_fecha,
      colour = color_fecha, fontface = if_else(destacado, "bold", "plain")
    ),
    size = 3.8
  ) +
  scale_colour_identity() +
  scale_fill_identity() +
  scale_y_continuous(
    breaks = cronologia$fila,
    labels = cronologia$hito,
    limits = c(0.5, nrow(cronologia) + 0.5),
    expand = c(0, 0)
  ) +
  scale_x_date(
    limits = c(ymd("2024-10-15"), ymd("2027-01-15")),
    breaks = seq(ymd("2024-11-01"), ymd("2026-11-01"), by = "6 months"),
    labels = \(x) paste(meses_abreviados[month(x)], year(x)),
    position = "top",
    expand = c(0, 0)
  ) +
  labs(x = NULL, y = NULL) +
  theme_grafico() +
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(
      colour = if_else(cronologia$destacado, color_acento, "grey20"),
      face = if_else(cronologia$destacado, "bold", "plain")
    ),
    axis.line.x = element_blank(),
    axis.ticks.x = element_blank(),
    panel.border = element_rect(colour = "grey60", fill = NA, linewidth = 0.5)
  )

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
