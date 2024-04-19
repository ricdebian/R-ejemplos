
download.file(paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/documentos/",fichero), fichero, mode="wb")
covid19_ccaa = read.csv("datos_ccaas.csv", sep=",")

#covid19_ccaa
covid19_madrid = covid19_ccaa[covid19_ccaa[,1]=="MD",]
#plot(covid19_madrid)

library(plotly)

plot_ly(covid19_madrid, x = ~fecha ) %>% 
  add_lines(y = ~num_casos, color =I("blue"), name = "casos")  %>%
  add_lines(y = ~num_casos_prueba_pcr, color = I("red"), name = "pcr") %>%
  add_lines(y = ~num_casos_prueba_test_ac , color = I("green"), name = "test ac")


#head(covid19_madrid)
covid19_ccaa_fall = read.csv("ccaa_covid19_fallecidos_por_fecha_defuncion_o.csv", sep=",")
covid19_ccaa_fall


 c_nacional = covid19_ccaa_fall[covid19_ccaa_fall$CCAA=="España",]

 
 plot_ly(c_nacional, x = ~Fecha ) %>% 
   add_lines(y = ~Fallecidos, color =I("blue"), name = "Fallecidos")
  
covid19_madrid_fall = covid19_ccaa_fall[covid19_ccaa_fall$CCAA =="Madrid",] 
#covid19_ccaa$fallecidos = covid19_ccaa_fall$Fallecidos
#covid19_madrid_fall




for (f in covid19_madrid$fecha ) {


 for (fa in covid19_madrid_fall$Fallecidos[covid19_madrid_fall$Fecha == f]){

   covid19_madrid$fallecidos[covid19_madrid$fecha == f] = fa

}

}

covid19_madrid[covid19_madrid$fecha == "2020-08-16",]

covid19_madrid_fall[covid19_madrid_fall$Fecha == "2020-08-16",]



plot_ly(covid19_madrid, x = ~fecha ) %>% 
  add_lines(y = ~num_casos, color =I("blue"), name = "casos")  %>%
 # add_lines(y = ~num_casos_prueba_pcr, color = I("red"), name = "pcr") %>%
 #  add_lines(y = ~num_casos_prueba_test_ac , color = I("green"), name = "test ac")%>%
   add_lines(y = ~fallecidos , color = I("red"), name = "fallecios")



covid19_nacional <- group_by(covid19_ccaa, fecha)

sum_covid19_nacional = summarise(covid19_nacional, sum(num_casos,na.rm = TRUE))

str(sum_covid19_nacional)

plot_ly(sum_covid19_nacional, x = ~fecha ) %>% 
  add_lines(y = sum_covid19_nacional$`sum(num_casos, na.rm = TRUE)`, color =I("blue"), name = "casos")

covid19_nac_fall
covid19_nac_fall <- group_by(covid19_ccaa_fall,Fecha)
covid19_nac_fall
sum_covid19_nac_fall <- summarise(covid19_nac_fall, sum(Fallecidos,na.rm = TRUE))
sum_covid19_nac_fall

for (f in sum_covid19_nacional$fecha ) {
  
  
  for (fa in sum_covid19_nac_fall$`sum(Fallecidos, na.rm = TRUE)`[sum_covid19_nac_fall$Fecha == f]){
    
    sum_covid19_nacional$fallecidos[sum_covid19_nacional$fecha == f] = fa
    
  }
  
}

sum_covid19_nacional
covid19_ccaa
fa

fuente1 <- list(
  family = "Calibri",
  size = 14,
  color = "grey")
fuente2 <- list(
  family = "Calibri",
  size = 12,
  color = "grey")

plot_ly(sum_covid19_nacional, x = ~fecha ) %>% 
  add_lines(y = sum_covid19_nacional$`sum(num_casos, na.rm = TRUE)`, color =I("blue"), name = "casos") %>% 
  add_lines(y = sum_covid19_nacional$fallecidos, color =I("red"), name = "fallecidos")  %>% 
 layout(  title = "Situación Covid19 España",font=fuente1, xaxis = (tickfont=fuente2 ),yaxis = (tickfont=fuente2 ))
  

write.csv(sum_covid19_nacional, "sum_covid19_nacional.csv", sep=",")
help("write.csv") 

