# Cambio en la dirección web y en el nombre del archivo el 08/05/2020
f <- "datos_ccaas.csv"
download.file(paste0("https://cnecovid.isciii.es/covid19/resources/", f), f, mode="wb")


covid19_ccaa5 = read.csv("datos_ccaas.csv", sep=",")
write.csv(covid19_ccaa5,"datos_ccaas5.csv,")
covid19_ccaa5 = read.csv("datos_ccaas5.csv", sep=";")
