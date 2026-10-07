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
library(stringr)

source("R/tema.R")

# Desde esta fecha la etiqueta de fechas va a la izquierda de la marca

fecha_corte_etiqueta <- ymd("2026-06-01")

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
    fila = rev(row_number()),
    fecha_inicio = paste(day(inicio), meses_abreviados[month(inicio)], year(inicio)),
    fecha_fin = paste(day(fin), meses_abreviados[month(fin)], year(fin)),
    etiqueta = if_else(inicio < fin, paste0(fecha_inicio, " a ", fecha_fin), fecha_inicio),
    x_etiqueta = if_else(fin > fecha_corte_etiqueta, inicio - 18, fin + 18),
    hjust = if_else(fin > fecha_corte_etiqueta, 1, 0)
  )

periodos <- cronologia |>
  filter(inicio < fin)

fechas <- cronologia |>
  filter(inicio >= fin)

# 4. Plot ----

grafico4 <- ggplot() +
  geom_segment(
    data = periodos,
    aes(x = inicio, xend = fin, y = fila, yend = fila, colour = destacado),
    linewidth = 6, lineend = "butt"
  ) +
  geom_point(
    data = fechas,
    aes(x = inicio, y = fila, colour = destacado),
    shape = 18, size = 5.5
  ) +
  geom_text(
    data = cronologia,
    aes(
      x = x_etiqueta, y = fila, label = etiqueta, hjust = hjust,
      colour = destacado, fontface = if_else(destacado, "bold", "plain")
    ),
    size = 3.2, family = "serif"
  ) +
  scale_colour_manual(
    values = c("TRUE" = color_acento, "FALSE" = color_gris),
    guide = "none"
  ) +
  scale_y_continuous(
    breaks = cronologia$fila,
    labels = cronologia$hito,
    limits = c(0.5, nrow(cronologia) + 0.5),
    expand = c(0, 0)
  ) +
  scale_x_date(
    limits = c(ymd("2024-10-15"), ymd("2027-01-15")),
    breaks = seq(ymd("2024-11-01"), ymd("2026-11-01"), by = "3 months"),
    labels = \(x) paste(meses_abreviados[month(x)], year(x)),
    expand = c(0, 0)
  ) +
  labs(
    title = str_wrap(
      "Gráfico 4. Línea de tiempo de la transición de la ENEMDU a la ENCIET, noviembre de 2024 a diciembre de 2026",
      width = ancho_titulo
    ),
    caption = str_wrap(
      "Fuente: INEC, calendario 2026 y contratos EC-INEC-489713 y EC-INEC-533831; Banco Mundial, informes de supervisión del proyecto P178564; CNE.",
      width = ancho_pie
    ),
    x = NULL,
    y = NULL
  ) +
  theme_project() +
  theme(
    axis.text.y = element_text(
      colour = if_else(cronologia$destacado, color_acento, "grey30"),
      face = if_else(cronologia$destacado, "bold", "plain")
    ),
    panel.grid.major.y = element_blank()
  )

# 6. Write outputs ----

ggsave(
  "figuras/grafico4.png",
  grafico4,
  device = ragg::agg_png,
  width = 24, height = 11, units = "cm", dpi = 300
)

ggsave(
  "figuras/grafico4.svg",
  grafico4,
  device = svglite::svglite,
  width = 24, height = 11, units = "cm"
)

message("Gráfico 4 guardado en figuras/")
