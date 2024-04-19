library(sf)
library(sp)
library(httr)
library(stringr)
library(readxl)
library(readr)
library(rjson)
#library(jsonlite)
library(curl)
direcciones<-read_excel("D:\\Area\\R\\app_de_epf_sin_coordenadas_en_el_marco_ni_rc_14_final_31122023_B.xls");

i<-0
cerr <- data.frame()
for (i in 1:length(direcciones[[1]])){

  cat("registrotratado ",i)
  
  d<-direcciones[i,]

  
  n<-try(d$NUMER<-as.numeric(d$NUMER))
#  consulta <- paste0(d$TVIA,sep="&",d$NVIA_LARGO,sep="&",n) 
  consulta <- paste0(d$TVIA,sep="&",d$NVIA_LARGO,sep="&",d$NUMER,sep="&",d$DMUN,sep="&",d$DPRO) 
  if (i==1){
    c <- consulta
  } else{
    c <- rbind(c,consulta)
  }
  
 consulta <- curl_escape(consulta)
 # print(consulta)
  ruta<-paste0("https://www.cartociudad.es/geocoder/api/geocoder/findJsonp?q=",consulta);
  
  ruta<-(ruta);
  
  print(ruta);

  
  respuesta <- httr::GET(url = ruta, 
                         user_agent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36')
                         )

    print(http_type(respuesta))

   tryCatch(
     expr = {
    resptxt <-httr::content(respuesta, type='text', encoding = 'UTF-8')
  
     resptxt <- str_replace(resptxt, "callback\\(","");
     resptxt <- str_replace_all(resptxt, "(?<=\\})\\)","");
     
     print (resptxt)
     
      jj<-rjson::fromJSON(resptxt)

    # length(jj) 
    # 
    #  print(jj["id"])
    #  print(jj["lng"])
    #  print(jj["lat"])
     
    if(is.null(jj$refCatastral)){
      jj$refCatastral<-"S/N"
    }
     print(jj["refCatastral"])
 

     # g <- c(str_replace(jj$lng,"\\.","\\,"),str_replace(jj$lat,"\\.","\\,"))
     # g <- jj["geom"]
     # 
     # 
     # g<-(c(is.numeric(jj$lat),is.numeric(jj$lng)))
     # st_as_sf(g, st_crs(4326))
     

      
     q <- st_as_sfc(jj$geom,st_crs(4326))
     # Cambio del Sistema de Referencia
     
     g_trs <- st_transform(q,crs=st_crs(25830))
     
   

     gt<-st_coordinates(g_trs)
     
   xx<- data.frame(secu_app_final=d$SECU_APP_FINAL,d$TVIA,d$NVIA_LARGO,d$NUMER,d$DMUN,d$DPRO,id=jj["id"],jj$tip_via,jj$address,jj$portalNumber,jj$muni,jj$province,lng=jj["lng"],lat=jj["lat"],refCatastral=jj["refCatastral"],coorxt=gt[1],cooryt=gt[2])
   
   if (i==1){
     salida <- xx

   } else{
   salida <- rbind(salida,xx)
   
   }
  },
  error = function(e){

    print(e)
    cat("error en reg",i)
   }
 
 )

}
write.csv(salida,"búsqueda_coord_rc.csv")

