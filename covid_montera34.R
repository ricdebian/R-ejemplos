download.file(paste0("https://raw.githubusercontent.com/montera34/escovid19data/f49fd033c2d3ebd5288b4fce918accfbc40e6c38/data/output/","covid19-ccaa-spain_consolidated.csv"), "covid19-ccaa-spain_consolidated.csv", mode="wb")

covid19_ccaa = read.csv("covid19-ccaa-spain_consolidated.csv", sep=",",fileEncoding = "UTF-8")

covid19_ccaa_mad = covid19_ccaa[covid19_ccaa[,2]==13,]

str(covid19_ccaa_mad)

library(plotly)
plot_ly(covid19_ccaa_mad, x = ~date, name ="Fecha" ) %>% 
  add_lines(y = ~num_casos2, color =I("blue"), name = "casos positivos")  %>%
  add_lines(y = ~hospitalized , color = I("orange"), name = "hospitalizados") %>%
  add_lines(y = ~num_hosp , color = I("green"), name = "Ingresos diarios") %>%
  add_lines(y = ~intensive_care , color = I("red"), name = "uci")


covid19_ccaa_and = covid19_ccaa[covid19_ccaa[,2]==1,]  


plot_ly(covid19_ccaa_and, x = ~date, name ="Fecha" ) %>% 
  add_lines(y = ~num_casos2, color =I("blue"), name = "casos positivos")  %>%
  add_lines(y = ~hospitalized , color = I("orange"), name = "hospitalizados") %>%
  add_lines(y = ~num_hosp , color = I("green"), name = "Ingresos diarios") %>%
  add_lines(y = ~intensive_care , color = I("red"), name = "uci")

covid19_ccaa_cat = covid19_ccaa[covid19_ccaa[,2]==9,]  


plot_ly(covid19_ccaa_cat, x = ~date, name ="Fecha" ) %>% 
  add_lines(y = ~num_casos2, color =I("blue"), name = "casos positivos")  %>%
  add_lines(y = ~hospitalized , color = I("orange"), name = "hospitalizados") %>%
  add_lines(y = ~num_hosp , color = I("green"), name = "Ingresos diarios") %>%
  add_lines(y = ~intensive_care , color = I("red"), name = "uci")

download.file(paste0("https://raw.githubusercontent.com/montera34/escovid19data/f49fd033c2d3ebd5288b4fce918accfbc40e6c38/data/output/","covid19-ccaa-spain_consolidated.csv"), "covid19-ccaa-spain_consolidated.csv", mode="wb")

covid19_ccaa2 = read.csv("ccaa_covid19_datos_sanidad_nueva_serie.csv", sep=",",fileEncoding = "UTF-8")

covid19_ccaa2_mad = covid19_ccaa2[covid19_ccaa2[,2]==13,]


plot_ly(covid19_ccaa2_mad, x = ~Fecha, name ="Fecha" ) %>% 
  add_lines(y = ~Casos, color =I("blue"), name = "casos positivos")  %>%
  add_lines(y = ~Hospitalizados , color = I("orange"), name = "Ingresos diarios") %>%
  add_lines(y = ~UCI , color = I("red"), name = "uci")


covid19_ccaa2_and = covid19_ccaa2[covid19_ccaa2[,2]==1,]  


plot_ly(covid19_ccaa2_and, x = ~Fecha, name ="Fecha" ) %>% 
  add_lines(y = ~Casos, color =I("blue"), name = "casos positivos")  %>%
  add_lines(y = ~Hospitalizados , color = I("orange"), name = "hospitalizados") %>%
  add_lines(y = ~UCI , color = I("red"), name = "uci")

covid19_ccaa2_cat = covid19_ccaa2[covid19_ccaa2[,2]==9,]  


plot_ly(covid19_ccaa2_cat, x = ~Fecha, name ="Fecha" ) %>% 
  add_lines(y = ~Casos, color =I("blue"), name = "casos positivos")  %>%
  add_lines(y = ~Hospitalizados , color = I("orange"), name = "hospitalizados") %>%
  add_lines(y = ~UCI , color = I("red"), name = "uci")
