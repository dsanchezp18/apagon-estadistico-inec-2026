# ============================================================
# Gráfico 3. Indicadores de población, hogares y vivienda
# Author: Daniel Sanchez
# Purpose: Gráfico de pesas (dumbbell), un punto por censo y una escala
#          propia desde cero en cada fila, nacional, censos de 2010 y 2022
# Inputs:  data/grafico3_censos.csv
# Outputs: figuras/grafico3.png, figuras/grafico3.svg
# ============================================================

# 0. Setup ----

library(dplyr)
library(forcats)
library(ggplot2)
library(readr)
library(stringr)
library(tidyr)

source("R/tema.R")

# Esta figura lleva seis filas, así que es más alta que el lienzo estándar

alto_grafico3 <- 7.5

# 1. Read inputs ----

censos <- read_csv("data/grafico3_censos.csv", show_col_types = FALSE)

# 3. Prepare data ----

censos <- censos |>
  mutate(indicador = fct_inorder(indicador))

# Una pista por indicador, desde cero hasta un tope que deja espacio a las
# etiquetas; cada fila tiene su propia escala y por eso no lleva eje numérico

tramos <- censos |>
  mutate(
    desde = pmin(censo_2010, censo_2022, na.rm = TRUE),
    hasta = pmax(censo_2010, censo_2022, na.rm = TRUE),
    tope = hasta * 1.35
  )

# Un punto por censo; la etiqueta va hacia afuera del tramo

puntos <- censos |>
  pivot_longer(
    cols = c(censo_2010, censo_2022),
    names_to = "censo",
    names_prefix = "censo_",
    values_to = "valor"
  ) |>
  mutate(
    es_menor = rank(valor) == 1,
    .by = indicador
  ) |>
  mutate(
    etiqueta = paste0(
      str_remove(numero_es(valor, accuracy = 0.1), ",0$"),
      " ", unidad
    ),
    hjust = if_else(es_menor, 1, 0),
    destacado = censo == "2022",
    color_marca = if_else(destacado, color_acento, color_gris),
    color_texto = if_else(destacado, color_acento, "grey30")
  )

# Los años se rotulan solo en la primera fila, debajo de los puntos, en lugar
# de una leyenda; las etiquetas de valor van sobre la línea para no tocarla

rotulos_anio <- puntos |>
  filter(indicador == first(levels(indicador)))

# 4. Plot ----

grafico3 <- ggplot() +
  geom_segment(
    data = tramos,
    aes(x = 0, xend = tope, y = 0, yend = 0),
    colour = "grey85", linewidth = 0.6
  ) +
  geom_text(
    data = tramos,
    aes(x = 0, y = -0.32, label = "0"),
    hjust = 0.5, size = 3.6, colour = "grey45"
  ) +
  geom_segment(
    data = tramos,
    aes(x = desde, xend = hasta, y = 0, yend = 0),
    colour = color_gris, linewidth = 1.4
  ) +
  geom_point(
    data = puntos,
    aes(x = valor, y = 0, colour = color_marca),
    size = 4
  ) +
  geom_text(
    data = puntos,
    aes(
      x = valor, y = 0.3, label = etiqueta, hjust = hjust,
      colour = color_texto, fontface = if_else(destacado, "bold", "plain")
    ),
    size = 4.2, vjust = 0
  ) +
  geom_text(
    data = rotulos_anio,
    aes(x = valor, y = -0.32, label = censo, colour = color_texto),
    vjust = 1, size = 4
  ) +
  facet_wrap(vars(indicador), ncol = 1, scales = "free_x") +
  scale_colour_identity() +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0))) +
  scale_y_continuous(limits = c(-0.8, 0.8)) +
  labs(x = NULL, y = NULL) +
  theme_grafico() +
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    panel.spacing.y = unit(0.1, "in"),
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0, face = "bold", size = 12, colour = "grey20")
  )

# 6. Write outputs ----

ggsave(
  "figuras/grafico3.png",
  grafico3,
  device = ragg::agg_png,
  width = lienzo_ancho, height = alto_grafico3, units = "in", dpi = 300
)

ggsave(
  "figuras/grafico3.svg",
  grafico3,
  device = svglite::svglite,
  width = lienzo_ancho, height = alto_grafico3, units = "in"
)

message("Gráfico 3 guardado en figuras/")
