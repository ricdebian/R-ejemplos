library(sf)
library(stringr)

#https://catastro.navarra.es/descargas/municipios/001/08/alfanumerico.zip 
ruta_descarga <- "C:/Users/mamaberi/OneDrive/Documentos/ATOM/DescargaATOM"


for (i in 1:265){
  tryCatch(
    
    # Código a ser evaluado
    expr = {
      ruta1 <- "https://catastro.navarra.es/descargas/municipios/"
      ruta <- paste(ruta1,str_pad(i, 3, pad = "0"),"/08/alfanumerico.zip",sep = "")
      ruta
      ruta_descarga
      download.file(url = ruta, destfile = paste(ruta_descarga,"/alfanumerico",str_pad(i, 3, pad = "0"),".zip",sep = ""), method = "auto")
      
    },
    
    # Código si se captura un error
    error = function(e){
      print(e)
    }
  )

}


for (i in 901:908){
  
  ruta1 <- "https://catastro.navarra.es/descargas/municipios/"
  ruta <- paste(ruta1,str_pad(i, 3, pad = "0"),"/08/alfanumerico.zip",sep = "")
  ruta
  ruta_descarga
  download.file(url = ruta, destfile = paste(ruta_descarga,"/alfanumerico",str_pad(i, 3, pad = "0"),".zip",sep = ""), method = "auto")
}

