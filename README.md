# Apagón estadístico: ¿qué está pasando en el INEC en 2026?

Repositorio público del artículo de [El Quantificador](https://github.com/elquantificador) "Apagón estadístico: ¿qué está pasando en el INEC en 2026?", de Daniel Sánchez-Pazmiño (octubre de 2026).

Desde junio de 2026, Ecuador no tiene cifras oficiales nuevas de empleo. El artículo revisa la información pública del INEC y del Banco Mundial para separar qué parte del retraso se explica por el cambio de marco muestral (del censo de 2010 al de 2022) y por la transición de la ENEMDU a la ENCIET, y qué parte queda sin explicar. Aquí encuentras los datos de los cuatro gráficos, el código para reproducirlos y las fuentes.

## Estructura

```text
articulo/apagon-estadistico.md   texto completo del artículo
articulo/apagon-estadistico.html  el artículo renderizado, con las figuras
data/                            un CSV por gráfico
data/raw/                        copias de fuentes que pueden cambiar o desaparecer
R/                               un script por gráfico y un script que corre todo
figuras/                         salidas en PNG (300 dpi) y SVG
```

## Cómo reproducir los gráficos

1. Clona el repositorio y abre una terminal en la raíz.
2. Instala R (4.5 o posterior) y los paquetes `dplyr`, `forcats`, `ggplot2`, `lubridate`, `ragg`, `readr`, `scales`, `stringr`, `svglite` y `tidyr`.
3. Corre:

```bash
Rscript R/00_run_all.R
```

Cada script (`R/01_grafico1.R` a `R/04_grafico4.R`) también corre por separado desde la raíz. Todos leen el CSV de `data/`, grafican con ggplot2 y guardan en `figuras/`. El tema, la paleta, el logo y el formato de números es-EC (coma decimal) están en `R/tema.R`, que sigue el estilo de las figuras públicas de [enighur-quantificador](https://github.com/elquantificador/enighur-quantificador): `theme_classic` de 12 pt, lienzo de 8 x 6,4 pulgadas a 300 dpi y sin título ni pie dentro de la imagen (van en el texto del artículo).

Para volver a generar el HTML del artículo con las figuras (necesita [Quarto](https://quarto.org/) instalado):

```bash
Rscript R/05_render_html.R
```

## Gráficos y datos

| Gráfico | Datos | Salidas |
|---|---|---|
| 1. Indicadores de mercado laboral y pobreza, nacional, mayo de 2026 y diciembre de 2025 (%) | `data/grafico1_enemdu.csv` | `figuras/grafico1.png`, `.svg` |
| 2. Puestos en convocatorias del INEC, por operación estadística, 10 de septiembre a 8 de octubre de 2026 | `data/grafico2_convocatorias.csv`, `data/grafico2_enemdu_desglose.csv` | `figuras/grafico2.png`, `.svg` |
| 3. Indicadores de población, hogares y vivienda, nacional, censos de 2010 y 2022 | `data/grafico3_censos.csv` | `figuras/grafico3.png`, `.svg` |
| 4. Línea de tiempo de la transición de la ENEMDU a la ENCIET, noviembre de 2024 a diciembre de 2026 | `data/grafico4_cronologia.csv` | `figuras/grafico4.png`, `.svg` |

Notas sobre los datos:

- Gráfico 1: el mercado laboral es de mayo de 2026 y la pobreza por ingresos, de diciembre de 2025. Fuente: INEC, ENEMDU.
- Gráfico 2: cada barra cuenta puestos (cargos por lugar de trabajo), no personas. Los 44 puestos de la ENEMDU se desglosan en `data/grafico2_enemdu_desglose.csv`. Consulta hecha el 6 de octubre de 2026 en la página *Trabaja con nosotros* del INEC. Los conteos del CSV son los del artículo; `data/raw/convocatorias_inec.csv` trae las filas de la página al 7 de octubre (ver TODO).
- Gráfico 3: los porcentajes son sobre el total de hogares o de viviendas. Fuente: INEC, Censo de Población y Vivienda 2010 y 2022.
- Gráfico 4: el segundo contrato usa el calendario de entregas de los términos de referencia (160 días), aunque el contrato dice 120 días. El primer contrato de empalme va del 19 de julio al 30 de noviembre de 2025, que son los 135 días de plazo de ejecución de sus términos de referencia (fechados el 16 de junio de 2025).

## Fuentes guardadas en `data/raw/`

Copias de documentos que pueden cambiar o desaparecer, con la fecha de descarga (7 de octubre de 2026) en el nombre:

- `calendario_operaciones_2026_descargado_2026-10-07.xlsx`: calendario de operaciones estadísticas 2026 del INEC. Origen: <https://www.ecuadorencifras.gob.ec/documentos/web-inec/Calendario_Estadistico/Calendario_estadistico_2026/files/operaciones.xlsx>
- `boletin_reess_2026-05_descargado_2026-10-07.pdf`: boletín del Registro Estadístico de Empleo en la Seguridad Social (REESS) de mayo de 2026. Origen: <https://www.ecuadorencifras.gob.ec/documentos/web-inec/Estadisticas_Economicas/Estadistica_empleo_seguridad_social/2026/mayo/05_2026_Boletin_REESS.pdf>
- `trabaja_con_nosotros_descargado_2026-10-07.html`: copia de la página *Trabaja con nosotros* del INEC, <https://www.ecuadorencifras.gob.ec/institucional/trabaja-con-nosotros/>.
- `convocatorias_inec.csv`: una fila por cargo de esa página (83 filas, cierres entre el 13 de septiembre y el 9 de octubre de 2026), con la operación asignada por el proyecto de cada convocatoria. La columna `cuenta_como_puesto` es `no` en las 3 filas de servicio de transporte (contratación pública, no son puestos); las otras 80 filas suman los 80 puestos del Gráfico 2.

## Fuentes

La numeración es la del artículo.

### Fuentes primarias (INEC y Banco Mundial)

[1] Instituto Nacional de Estadística y Censos. (s.f.). *ENEMDU-2026*. Recuperado el 6 de octubre de 2026, de <https://www.ecuadorencifras.gob.ec/enemdu-2026/>

[3] Instituto Nacional de Estadística y Censos. (s.f.). *Calendario de Operaciones Estadísticas 2026*. Recuperado el 6 de octubre de 2026, de <https://www.ecuadorencifras.gob.ec/documentos/web-inec/Calendario_Estadistico/Calendario_estadistico_2026/>

[11] Instituto Nacional de Estadística y Censos. (2021). *Recálculo de las estadísticas de empleo y pobreza: septiembre 2020 - mayo 2021* \[Nota técnica\]. <https://www.ecuadorencifras.gob.ec/documentos/web-inec/EMPLEO/2021/Nota_tecnica/202106_Nota_tecnica_ENEMDU.pdf>

[12] Instituto Nacional de Estadística y Censos. (2023, 21 de septiembre). *Ecuador creció en 2.5 millones de personas entre 2010 y 2022*. <https://www.ecuadorencifras.gob.ec/ecuador-crecio-en-2-5-millones-de-personas-entre-2010-y-2022/>

[18] Banco Mundial. (2022, 1 de julio). *El Banco Mundial aprueba un crédito por US$80 millones para fortalecer el Sistema Nacional de Estadísticas en Ecuador* \[Comunicado de prensa\]. <https://www.bancomundial.org/es/news/press-release/2022/07/01/banco-mundial-aprueba-credito-fortalecer-sistema-nacional-estadisticas-ecuador>

[23] Instituto Nacional de Estadística y Censos. (2024, 20 de marzo). *El INEC ratificó la validez, veracidad y confiabilidad del Censo Ecuador 2022*. <https://www.ecuadorencifras.gob.ec/el-inec-ratifico-la-validez-veracidad-y-confiabilidad-del-censo-ecuador-2022/>

[24] Banco Mundial. (2026). *Proyecto de Fortalecimiento del Sistema Estadístico Nacional – P178564: Misión de supervisión del proyecto, 23 de febrero al 5 de marzo de 2026. Ayuda memoria*. <https://documents.worldbank.org/curated/en/099033026133017132/pdf/P178564-f13ead93-dbc7-4aff-92e8-623602605618.pdf>

[26] Banco Mundial. (2025). *Proyecto de Fortalecimiento del Sistema Estadístico Nacional – P178564: Misión de supervisión del proyecto, 12-22 de agosto, 2025. Ayuda memoria*. <https://documents.worldbank.org/curated/en/099091625153551890/pdf/P178564-24a02511-f1bc-482d-b7f1-fe5cf5c13a23.pdf>

[27] Instituto Nacional de Estadística y Censos. (2025, 16 de junio). *Términos de referencia: Servicios de consultoría para empalme de series con ENEMDU – C2 – ENCIET* (EC-INEC-489713-CS-INDV). <https://www.ecuadorencifras.gob.ec/documentos/web-inec/Adquisiciones/Procesos_adquisiciones_Banco_Mundial/2025/empalme/2.TERMINOS_DE_REFERENCIA.pdf>

[28] Instituto Nacional de Estadística y Censos. (2026, 3 de marzo). *Informe de necesidad: Servicios de consultoría para reconstrucción de series de mercado laboral, pobreza y desigualdad por cambio de marco muestral ENEMDU – C2 – ENCIET* (EC-INEC-533831-CS-INDV). <https://www.ecuadorencifras.gob.ec/documentos/web-inec/Adquisiciones/Procesos_adquisiciones_Banco_Mundial/2026/enemdu-enciet-533831/14-INFORME_DE_NECESIDAD.pdf>

[29] Instituto Nacional de Estadística y Censos. (2026). *Contratación de servicios de consultoría para reconstrucción de series de mercado laboral, pobreza y desigualdad por cambio de marco muestral ENEMDU – C2 – ENCIET* \[Contrato\] (EC-INEC-533831-CS-INDV). <https://www.ecuadorencifras.gob.ec/documentos/web-inec/Adquisiciones/Procesos_adquisiciones_Banco_Mundial/2026/enemdu-enciet-533831/59_CONTRATO.pdf>

[30] Instituto Nacional de Estadística y Censos. (2026, 3 de marzo). *Términos de referencia: Servicios de consultoría para reconstrucción de series de mercado laboral, pobreza y desigualdad por cambio de marco muestral ENEMDU – C2 – ENCIET* (EC-INEC-533831-CS-INDV). <https://www.ecuadorencifras.gob.ec/documentos/web-inec/Adquisiciones/Procesos_adquisiciones_Banco_Mundial/2026/enemdu-enciet-533831/17-TERMINOS_DE_REFERENCIA.pdf>

[31] Instituto Nacional de Estadística y Censos. (2026, julio). *Boletín técnico: Registro Estadístico de Empleo en la Seguridad Social (REESS), mayo 2026* (Boletín técnico N.° 7-2026-REESS). <https://www.ecuadorencifras.gob.ec/documentos/web-inec/Estadisticas_Economicas/Estadistica_empleo_seguridad_social/2026/mayo/05_2026_Boletin_REESS.pdf>

[32] Instituto Nacional de Estadística y Censos. (2026, 24 de marzo). *Acta Nro. 005: Negociación* (EC-INEC-533831-CS-INDV). <https://www.ecuadorencifras.gob.ec/documentos/web-inec/Adquisiciones/Procesos_adquisiciones_Banco_Mundial/2026/enemdu-enciet-533831/48_Acta_005.pdf>

### Otras fuentes institucionales (comparaciones internacionales)

[13] Departamento Administrativo Nacional de Estadística. (2022, 11 de febrero). *Nuevo enfoque conceptual y metodológico Gran Encuesta Integrada de Hogares (GEIH)* \[Comunicado de prensa\]. <https://www.dane.gov.co/files/investigaciones/fichas/empleo/Comunicado_prensa_nuevo_enfoque_GEIH.pdf>

[14] Departamento Administrativo Nacional de Estadística. (2024, noviembre). *Desafíos y métodos aplicados para realizar el empalme de la GEIH en los indicadores de mercado laboral, pobreza y desigualdad* \[Presentación\]. Comisión Económica para América Latina y el Caribe. <https://www.cepal.org/sites/default/files/presentations/desafios-metodos-empalme-geih_dane_ericson_osorio.pdf>

[15] Statistics Canada. (2025, 24 de enero). *The 2025 revisions of the Labour Force Survey (LFS)* (Catálogo n.º 71F0031X). <https://www150.statcan.gc.ca/n1/pub/71f0031x/71f0031x2025001-eng.htm>

[16] U.S. Bureau of Labor Statistics. (2026). *Adjustments to household survey population estimates in January 2026*. <https://www.bls.gov/web/empsit/cps-pop-control-adjustments.pdf>

[17] Office for National Statistics. (2023, 2 de noviembre). *Labour Force Survey: Planned improvements and its reintroduction*. <https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/methodologies/labourforcesurveyplannedimprovementsanditsreintroduction>

[25] International Labour Office. (2023). *Resolution II: Resolution to amend the 19th ICLS resolution concerning statistics of work, employment and labour underutilization* (ICLS/21/2023/RES. II). Organización Internacional del Trabajo. <https://www.ilo.org/sites/default/files/wcmsp5/groups/public/@dgreports/@stat/documents/normativeinstrument/wcms_230304.pdf>

### Prensa y redes sociales

[2] González, P. (2026, 11 de agosto). El INEC lleva 20 días de retraso en la publicación de los datos de empleo de junio. *Primicias*. <https://www.primicias.ec/economia/inec-retraso-publicacion-datos-empleo-desempleo-junio-trimestral-pobreza-enemdu-130008/>

[4] Acosta-Burneo, A. \[@ALBERTOACOSTAB\]. (2026, 2 de septiembre). *ECUADOR SE QUEDÓ SIN DATOS DE EMPLEO... Desde JUNIO, el #INEC mantiene pendientes TRES publicaciones de la ENEMDU. Lo más* \[Publicación\]. X. <https://x.com/ALBERTOACOSTAB/status/2095108977986334795>

[5] CORDES Ecuador \[@CORDES\_Ecuador\]. (2026, 23 de septiembre). *Por tercer mes consecutivo, el INEC no publicó el informe de la encuesta de empleo. Además, no publicará hasta diciembre* \[Publicación\]. X. <https://x.com/CORDES_Ecuador/status/2102881373883400202>

[6] Farfán Endara, C. (2026, 27 de marzo). CNE adelanta elecciones seccionales en Ecuador: comicios se realizarán el 29 de noviembre de 2026. *Vistazo*. <https://www.vistazo.com/politica/nacional/2026-03-27-consejo-nacional-electoral-adelanta-elecciones-seccionales-cpccs-AI10812828>

[7] Redacción Radio Pichincha. (2026, 19 de agosto). Seccionales 2026: esta es la lista de candidatos inscritos para las alcaldías de Quito y Guayaquil, y las prefecturas de Pichincha y Guayas. *Radio Pichincha*. <https://www.radiopichincha.com/quito-guayaquil-conozca-candidatos-definidos-adn-pse-psc-rc-otras-organizaciones-alcaldias-prefecturas/>

[8] Redacción Gestión. (2026, 14 de septiembre). ¿Cuál será el costo a largo plazo para el Ecuador de no contar con estadísticas de empleo y pobreza actualizadas? *Revista Gestión*. <https://www.primicias.ec/revistagestion/analisis/sera-costo-plazo-ecuador-contar-estadisticas-empleo-pobreza-actualizadas-132439/>

[9] Murillo Mojica, O. F. (2026, 24 de mayo). Las claves del discurso de Daniel Noboa en el informe a la Nación 2026. *Extra*. <https://www.extra.ec/noticia/politica/claves-discurso-daniel-noboa-informe-nacion-2026-154375.html>

[10] Redacción Primicias. (2026, 3 de octubre). INEC publicará en diciembre los resultados de empleo y desempleo del período junio-octubre. *Primicias*. <https://www.primicias.ec/economia/inec-empleo-desempleo-subempleo-pobreza-enemdu-134062/>

[19] Redacción Primicias. (2023, 15 de enero). El censo poblacional, entre críticas, dudas técnicas y retrasos. *Primicias*. <https://primicias.ec/noticias/sociedad/censo-poblacional-aprietos-extension-ecuador>

[20] Redacción Primicias. (2024, 19 de febrero). INEC ajusta las cifras del Censo: Ecuador tiene 17,7 millones de habitantes. *Primicias*. <https://primicias.ec/noticias/sociedad/censo-ecuador/inec-ecuador-habitantes-censo>

[21] González, P. (2026, 27 de agosto). Informe de Contraloría ya revelaba inconsistencias en los datos del Censo 2022 antes de que lo haga una consultoría de la ONU. *Primicias*. <https://www.primicias.ec/economia/informe-contraloria-inconsistencias-bases-datos-censo2022-inec-onu-131104/>

[22] González, P. (2026, 25 de agosto). Censo 2022 en Ecuador: una consultoría de la ONU detecta distorsiones en sus resultados, incluso los de empleo. *Primicias*. <https://www.primicias.ec/economia/censo2022-inec-mercado-laboral-empleo-desempleo-pobreza-ecuador-consultoria-onu-130718/>

### Software

[33] Figueroa, L., y Sánchez-Pazmiño, D. (2026). *EcuDataMCP* \[Software\]. GitHub. <https://github.com/DweskZ/EcuDataMCP>

## Cómo se hizo

Las fuentes se revisaron a mano. Para buscar documentos (boletines, calendarios, contratos e informes) se usó [EcuDataMCP](https://github.com/DweskZ/EcuDataMCP), un servidor de código abierto que conecta asistentes de inteligencia artificial con fuentes oficiales de Ecuador. La herramienta ayudó a encontrar las fuentes; la lectura, la verificación y el análisis los hizo el autor.

## Licencia

El código (`R/`) se publica bajo licencia MIT. El texto del artículo y las figuras se publican bajo [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.es). Los detalles están en [LICENSE](LICENSE). Los documentos de `data/raw/` son del INEC y conservan sus propias condiciones.
