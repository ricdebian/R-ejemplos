library(sf)
library(sp)
# libreria Httr
library(httr)
# Libreria XML2
library(xml2)

AppsConCoords <- Apps %>% filter(!is.na(COOR_X)) %>% mutate(COOR_X = as.numeric(COOR_X), COOR_Y = as.numeric(COOR_Y)) %>%
  select(SECU_APP_FINAL, COOR_X, COOR_Y, REFCAT_R, REFCAT_U)
coordinates(AppsConCoords) = ~COOR_X+COOR_Y
AppsConCoords <- st_as_sf(AppsConCoords)
# Sistema de referencia de las coordenadas
# EPSG 4326 'WGS84'
st_crs(AppsConCoords)=25830
# Servicio WMS DGC
ruta <- "https://ovc.catastro.meh.es/Cartografia/INSPIRE/spadgcwms.aspx"
url <- parse_url(ruta)
# Funcion
cruceWMS <- function(i,datosSP) {
  print(paste("Registro:",i))
  
  KK <- unlist(st_bbox(datosSP[i,]))
  KK <- KK +c(0,0,1,1)
  KK <- paste0(KK,collapse = ",")
  
  url$query <- list(service = "wms",
                    request = "GetFeatureInfo",
                    QUERY_LAYERS="CP.CADASTRALPARCEL",
                    FORMAT="image/png",
                    srs="EPSG:25830",
                    bbox=KK,
                    width="200",
                    height="200",
                    I="100",
                    J="100"
  )
  request <- build_url(url)
  recintoSP <- GET(request)
  recintoSP<- content(recintoSP,"parsed")
  
  aux <- try(xml_text(xml_child(xml_child(xml_child(xml_child(xml_child(xml_child(xml_child(xml_child(recintoSP, 3), 1), 1), 2), 1), 1), 5), 2)))
  if (nchar(aux)>30) {RefCat <-0} else {RefCat <- aux}
  
  return(RefCat)
}
# Aplica la funcion a cada fila del dataframe
AppsConCoords$refCat <- sapply(1:nrow(AppsConCoords), function(i) cruceWMS(i, AppsConCoords))
# Asignamos una RC final, refCatFin
AppsConCoords <- AppsConCoords %>% mutate(refCatFin = case_when(
  !is.na(REFCAT_U) ~ REFCAT_U, # Si tenemos REFCAT_U, REFCAT_U
  refCat != '0' ~ refCat,      # Si no tenemos REFCAT_U pero si refcat, refcat
  !is.na(REFCAT_R) ~ REFCAT_R, # Si solo tenemos REFCAT_R, REFCAT_R
  TRUE ~ ''                    # Si no tenemos nada, ''
))
# Conteos
CONTEOS <- c(
  sum(!is.na(AppsConCoords$REFCAT_U)), # Con REFCAT_U
  sum(AppsConCoords$refCat != '0'), # Con refCat
  sum(AppsConCoords$refCat != '0' & is.na(AppsConCoords$REFCAT_U)), # con refcat y sin REFCAT_U -> refCatFin = refcat
  sum(is.na(AppsConCoords$REFCAT_U) & AppsConCoords$refCat == '0' & !is.na(AppsConCoords$REFCAT_R)), # solo REFCAT_R
  sum(is.na(AppsConCoords$REFCAT_U) & AppsConCoords$refCat == '0' & is.na(AppsConCoords$REFCAT_R)) # sin nada
)
CONTEOS <- as.data.frame(t(CONTEOS))
names(CONTEOS) <- c("CON_REFCAT_U", "CON_refCat", "refCat_FIN", "SOLO_REFCAT_R", "NO_RC")
RCAppsCoords <- AppsConCoords %>%
  st_drop_geometry() %>%
  select(SECU_APP_FINAL, REFCAT_R, REFCAT_U, refCat, refCatFin1) %>%
  mutate(SECU_APP_FINAL = format(SECU_APP_FINAL, scientific = FALSE))
# Generamos un fichero
write.table(RCAppsCoords, file = "RCsdeAppsConCoords.txt", sep = ";", row.names = FALSE, col.names = TRUE, na = "", quote = FALSE)