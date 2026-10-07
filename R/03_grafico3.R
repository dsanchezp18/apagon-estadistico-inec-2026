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

# 1. Read inputs ----

censos <- read_csv("data/grafico3_censos.csv", show_col_types = FALSE)

# 3. Prepare data ----

censos <- censos |>
  mutate(indicador = fct_inorder(indicador))

# Un tramo por indicador y un tope de escala que deja espacio a las etiquetas

tramos <- censos |>
  mutate(
    desde = pmin(censo_2010, censo_2022, na.rm = TRUE),
    hasta = pmax(censo_2010, censo_2022, na.rm = TRUE),
    tope = hasta * 1.45
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
    hjust = if_else(es_menor, 1.25, -0.25),
    destacado = censo == "2022"
  )

# Los años se rotulan solo en la primera fila, en lugar de una leyenda

rotulos_anio <- puntos |>
  filter(indicador == first(levels(indicador)))

# 4. Plot ----

grafico3 <- ggplot() +
  geom_blank(data = tramos, aes(x = 0, y = 0)) +
  geom_blank(data = tramos, aes(x = tope, y = 0)) +
  geom_segment(
    data = tramos,
    aes(x = desde, xend = hasta, y = 0, yend = 0),
    colour = color_gris, linewidth = 1.2
  ) +
  geom_point(
    data = puntos,
    aes(x = valor, y = 0, colour = destacado),
    size = 4
  ) +
  geom_text(
    data = puntos,
    aes(
      x = valor, y = 0, label = etiqueta, hjust = hjust,
      colour = destacado, fontface = if_else(destacado, "bold", "plain")
    ),
    size = 3.6, family = "serif"
  ) +
  geom_text(
    data = rotulos_anio,
    aes(x = valor, y = 0, label = censo, colour = destacado),
    vjust = -1.6, size = 3.4, family = "serif"
  ) +
  facet_wrap(vars(indicador), ncol = 1, scales = "free_x") +
  scale_colour_manual(
    values = c("TRUE" = color_acento, "FALSE" = color_gris),
    guide = "none"
  ) +
  scale_x_continuous(expand = c(0, 0), labels = numero_es) +
  scale_y_continuous(limits = c(-0.6, 0.9)) +
  labs(
    title = str_wrap(
      "Gráfico 3. Indicadores de población, hogares y vivienda, nacional, censos de 2010 y 2022",
      width = ancho_titulo
    ),
    caption = str_wrap(
      "Fuente: INEC, Censo de Población y Vivienda 2010 y 2022. Nota: los porcentajes son sobre el total de hogares o de viviendas.",
      width = ancho_pie
    ),
    x = NULL,
    y = NULL
  ) +
  theme_project() +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.spacing.y = unit(0.35, "cm"),
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0, face = "bold", size = 10.5)
  )

# 6. Write outputs ----

ggsave(
  "figuras/grafico3.png",
  grafico3,
  device = ragg::agg_png,
  width = 20, height = 18, units = "cm", dpi = 300
)

ggsave(
  "figuras/grafico3.svg",
  grafico3,
  device = svglite::svglite,
  width = 20, height = 18, units = "cm"
)

message("Gráfico 3 guardado en figuras/")
