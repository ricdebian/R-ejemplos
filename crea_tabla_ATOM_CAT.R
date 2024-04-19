library(dplyr)
library(readxl)
library(sf)
library(DBI)
municipios_INE_DGC <- read_excel("C:/Users/mamaberi/OneDrive/Documentos/ATOM/Municipios_INE_DGC_20140101_v1.xlsx")
filtro_cat <- municipios_INE_DGC$DESC_CAT
ruta_descarga <- "C:/Users/mamaberi/OneDrive/Documentos/ATOM/DescargaATOM"

 PBDBD14 <- dbConnect(odbc::odbc(), "PBDBD14", UID = "E592E", 
                        PWD = "E592E", encoding = "iso-8859-1", timeout = 10)

for(i in 2:7594){
  # Actualizacion tabla CAT
  insert<- ""
  mun <- st_read(paste0("C:/Users/mamaberi/OneDrive/Documentos/ATOM/DescargaATOM/A.ES.SDGC.AD.", filtro_cat[i], ".gml"))
  GML <- st_read(paste0("C:/Users/mamaberi/OneDrive/Documentos/ATOM/DescargaATOM/A.ES.SDGC.AD.", filtro_cat[i], ".gml"))
  strsplit(GML$localId,"[.]")
  strsplit(mun$gml_id[1],"[.]")
  mun$CVIA_DGC <- sapply(strsplit(mun$gml_id, "\\."), `[`, 6)
  mun$NUMER_DGC <- sapply(strsplit(mun$gml_id, "\\."), `[`, 7)
  mun$PAR <- sapply(strsplit(mun$gml_id, "\\."), `[`, 8)
  coord <- st_coordinates(st_transform(mun$geometry, "+init=epsg:25830"))
  mun$LAT <- coord[,2]
  mun$LNG <- coord[,1]
  mun$CPRO <- as.integer(municipios_INE_DGC$CPRO_INE[i])
  mun$CMUN <- as.integer(municipios_INE_DGC$CMUN_INE[i])
  strsplit(mun$gml_id, "\\.")

  
  mun <- as.data.frame(st_drop_geometry(mun %>% select(CPRO, CMUN, PAR, CVIA_DGC, NUMER_DGC, LAT, LNG)))

# dbSendQuery(PBDBD14, "ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,'")
# insert<- paste0("INSERT INTO PBTB_COORD_MUNI_CATASTRO VALUES (", mun$CPRO ,",",mun$CPRO,",'",mun$PAR,"',",mun$CVIA_DGC,",",mun$NUMER_DGC ,",'",mun$LAT,"','",mun$LNG,"')\n")
# cat(insert)
# res<-dbSendQuery(PBDBD14, insert,batch_rows = 100)
# dbAppendTable(PBDBD14, "PBTB_COORD_MUNI_CATASTRO",mun)
#dbWriteTable(PBDBD14, "PBTB_COORD_MUNI_CATASTRO", append=TRUE, batch_rows = 1,mun) 
#  dbWriteTable(PBDBD14, "PBTB_GML_MUNI_CATASTRO_X", append=TRUE, batch_rows = 1,GML)
  dbSendQuery(PBDBD14, "ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,'")
  SELECT<-"SELECT 'ÁÉÍÚÑ€' FROM DUAL"
  RES<-dbGetQuery(PBDBD14, SELECT)
     

}

 
 