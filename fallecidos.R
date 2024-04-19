f = "ccaa_covid19_fallecidos_por_fecha_defuncion_nueva_serie_original.csv"
download.file(paste0("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/", f),
              f, mode="wb")

fallecidos <- read.csv(f)
fallecidos$CCAA <- iconv(fallecidos$CCAA, "UTF-8","ISO_8859-1" )

fallecidos_g_fec <- group_by(fallecidos,Fecha)
fallecidos_g_fec
fallecidos_g_fec_sum <- summarise(fallecidos_g_fec, tot_fallecidos=sum(Fallecidos,na.rm = TRUE))


plot_ly(fallecidos_g_fec_sum, x = ~Fecha ) %>% 
  add_lines(y =  ~tot_fallecidos, color =I("blue"), name = "Fallecidos")

fallecidos_g_fec_sum$suma = fallecidos_g_fec_sum[,2]

