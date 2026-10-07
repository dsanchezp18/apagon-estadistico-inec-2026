# ============================================================
# Gráfico 2. Puestos en convocatorias del INEC, por operación estadística
# Author: Daniel Sanchez
# Purpose: Barras horizontales con la ENEMDU destacada y su porcentaje del
#          total, 10 de septiembre a 8 de octubre de 2026
# Inputs:  data/grafico2_convocatorias.csv, quantificador.png
# Outputs: figuras/grafico2.png, figuras/grafico2.svg
# ============================================================

# 0. Setup ----

library(dplyr)
library(forcats)
library(ggplot2)
library(readr)
library(stringr)

source("R/tema.R")

# 1. Read inputs ----

convocatorias <- read_csv("data/grafico2_convocatorias.csv", show_col_types = FALSE)

# 3. Prepare data ----

# La barra de la ENEMDU lleva su peso en el total; las demás, solo el conteo

total_puestos <- sum(convocatorias$puestos, na.rm = TRUE)

convocatorias <- convocatorias |>
  mutate(
    destacada = operacion == "ENEMDU (empleo)",
    etiqueta = if_else(
      destacada,
      paste0(
        puestos, " de ", total_puestos, " (",
        porcentaje_es(100 * puestos / total_puestos, accuracy = 1), ")"
      ),
      as.character(puestos)
    ),
    operacion = fct_rev(fct_inorder(operacion))
  )

# 4. Plot ----

# La etiqueta de la barra destacada va dentro; las demás, al final de la barra

grafico2 <- ggplot(convocatorias, aes(x = puestos, y = operacion, fill = destacada)) +
  geom_col(width = 0.65) +
  geom_text(
    data = \(d) filter(d, destacada),
    aes(label = etiqueta),
    hjust = 1.08, size = 3, fontface = "bold", colour = "white"
  ) +
  geom_text(
    data = \(d) filter(d, !destacada),
    aes(label = etiqueta),
    hjust = -0.25, size = 3, colour = "grey20"
  ) +
  scale_fill_manual(
    values = c("TRUE" = color_acento, "FALSE" = color_gris),
    guide = "none"
  ) +
  scale_x_continuous(limits = c(0, 48), expand = c(0, 0)) +
  scale_y_discrete(labels = \(x) str_wrap(x, 16)) +
  labs(
    title = wrap_title_house(
      "Puestos en convocatorias del INEC, por operación estadística, 10 de septiembre a 8 de octubre de 2026"
    ),
    caption = wrap_caption_house(
      "Fuente: INEC, página Trabaja con nosotros, convocatorias con plazo de postulación entre el 10 de septiembre y el 8 de octubre de 2026, consultada el 6 de octubre de 2026. Elaboración: El Quantificador. Nota: cada barra cuenta puestos (cargos por lugar de trabajo), no personas."
    ),
    x = NULL,
    y = NULL
  ) +
  theme_quantificador() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.line.x = element_blank()
  )

grafico2 <- agregar_logo(grafico2)

# 6. Write outputs ----

ggsave(
  "figuras/grafico2.png",
  grafico2,
  device = ragg::agg_png,
  width = lienzo_ancho, height = lienzo_alto, units = "in", dpi = 300
)

ggsave(
  "figuras/grafico2.svg",
  grafico2,
  device = svglite::svglite,
  width = lienzo_ancho, height = lienzo_alto, units = "in"
)

message("Gráfico 2 guardado en figuras/")
