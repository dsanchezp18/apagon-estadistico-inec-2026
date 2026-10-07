# ============================================================
# Render del artículo a HTML
# Author: Daniel Sanchez
# Purpose: Convierte articulo/apagon-estadistico.md en un HTML autocontenido,
#          con las cuatro figuras en lugar de los marcadores [embedded content]
#          y la fuente de cada gráfico debajo. No modifica el artículo.
# Inputs:  articulo/apagon-estadistico.md, articulo/estilo.css, figuras/*.png
# Outputs: articulo/apagon-estadistico.html
# ============================================================

# 0. Setup ----

library(stringr)

# Pandoc viene con Quarto; si falta, este script se detiene aquí

quarto_path <- Sys.which("quarto")

# 1. Read inputs ----

articulo <- readLines("articulo/apagon-estadistico.md", encoding = "UTF-8")

# 3. Prepare data ----

# Cada marcador "[embedded content: fuente]" se vuelve figura más su fuente

es_figura <- str_detect(articulo, "^&#91;embedded content: ")
numero_figura <- cumsum(es_figura)

fuente_figura <- articulo[es_figura] |>
  str_remove("^&#91;embedded content: ") |>
  str_remove("\\\\\\]$")

articulo[es_figura] <- paste0(
  "![Gráfico ", numero_figura[es_figura], "](figuras/grafico",
  numero_figura[es_figura], ".png)\n\n<p class=\"fuente\">", fuente_figura, "</p>"
)

markdown_temporal <- tempfile(fileext = ".md")
writeLines(articulo, markdown_temporal, useBytes = TRUE)

# 6. Write outputs ----

system2(
  quarto_path,
  args = c(
    "pandoc", shQuote(markdown_temporal),
    "-f", "markdown", "-t", "html5", "--standalone", "--embed-resources",
    "--css", "articulo/estilo.css",
    "--metadata", "lang=es",
    "--metadata", shQuote("pagetitle=Apagón estadístico: ¿qué está pasando en el INEC en 2026?"),
    "-o", "articulo/apagon-estadistico.html"
  )
)

message("HTML guardado en articulo/apagon-estadistico.html")
