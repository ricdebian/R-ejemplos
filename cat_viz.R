library(readxl)
library(xml2)
library(dplyr)
library(sjmisc)
library(sf)
library(stringr)
library(rvest)
library(tidyverse)
#ruta de descarga local
ruta_descarga <- "C:/Users/mamaberi/OneDrive/Documentos/Cat_Viz"

if(!file.exists(ruta_descarga)){
  dir.create(ruta_descarga)
}

ruta <- "https://opengis.bizkaia.eus/Planificacion%20territorial%20y%20catastro/Catastro/"

download.file(url = ruta, destfile = paste(ruta_descarga,"/ficheros.html",sep = ""), method = "auto")

a <- paste(ruta_descarga,"/ficheros.html",sep = "")


tabla_h <- read_html(a)
#tabla_h <- html_nodes(tabla_h, "table")

tr <- tabla_h %>% html_nodes("table") %>% html_nodes("tr")

td <- tabla_h %>% html_nodes("tr") %>% html_nodes("td")

print(td[[17]])

aimg <- tabla_h %>% html_nodes("td") %>% html_nodes("a")   

print(aimg[[4]])
 
hr <-  tabla_h %>%  html_node("aimg") %>% html_attr("href")
      
html <- read_html(a)

html %>% 
  html_element(".tracklist") %>% 
  html_table()      
      
