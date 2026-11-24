# ============================================================
# Render del artículo a HTML
# Author: Daniel Sanchez
# Purpose: Convierte el artículo en un HTML autocontenido con las
#          figuras publicadas y sus fuentes, sin alterar el original.
# Inputs:  articulo/apagon-estadistico.md, articulo/estilo.css, figuras/*.png
# Outputs: articulo/apagon-estadistico.html
# ============================================================

# 0. Setup ----

library(purrr)
library(stringr)

quarto_path <- Sys.which("quarto")

# 1. Read inputs ----

articulo <- readLines("articulo/apagon-estadistico.md", encoding = "UTF-8")

# 2. Check inputs ----

stopifnot(nzchar(quarto_path))

# 3. Prepare data ----

marca_figura <- "^&#91;embedded content: "
posicion_figura <- which(str_detect(articulo, marca_figura))
posicion_titulo <- map_int(
  posicion_figura,
  \(i) max(which(nzchar(articulo[seq_len(i - 1)])))
)

# El número del título mantiene el vínculo aunque se retire una figura.

titulo_figura <- str_remove(articulo[posicion_titulo], "^\\*\\*Gráfico ")
numero_figura <- titulo_figura |>
  str_extract("^[0-9]+(?=\\.\\*\\*)") |>
  as.integer()

stopifnot(!anyNA(numero_figura), !anyDuplicated(numero_figura))

ruta_figura <- paste0("figuras/grafico", numero_figura, ".png")
stopifnot(all(file.exists(ruta_figura)))

fuente_figura <- articulo[posicion_figura] |>
  str_remove(marca_figura) |>
  str_remove("\\\\\\]$")

articulo[posicion_figura] <- paste0(
  "![](", ruta_figura, ")\n\n",
  "<p class=\"fuente\">", fuente_figura, "</p>\n\n:::"
)
articulo[posicion_titulo] <- paste0("::: grafico\n\n", articulo[posicion_titulo])

# 6. Write outputs ----

markdown_temporal <- tempfile(fileext = ".md")
writeLines(articulo, markdown_temporal, useBytes = TRUE)

# Sin implicit_figures, el texto alternativo no se convierte en pie de foto.

titulo <- "Apagón estadístico: ¿qué está pasando en el INEC en 2026?"
estado <- system2(
  quarto_path,
  args = c(
    "pandoc", shQuote(markdown_temporal),
    "-f", "markdown-implicit_figures", "-t", "html5", "--standalone",
    "--embed-resources",
    "--css", "articulo/estilo.css",
    "--metadata", "lang=es",
    "--metadata", shQuote(paste0("pagetitle=", titulo)),
    "-o", "articulo/apagon-estadistico.html"
  )
)
stopifnot(estado == 0L)

message("HTML guardado en articulo/apagon-estadistico.html")
sessionInfo()
