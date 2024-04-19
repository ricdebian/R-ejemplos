#hospitalizados = read.csv("ccaa_ingresos.csv", sep=",")
#hospitalizados_ant = read.csv("ccaa_covid19_datos_isciii.csv", sep=",")

hospitalizados_1 = read.csv("ccaa_covid19_hospitalizados_long.csv", sep=",")
uci_2 = read.csv("ccaa_covid19_uci_long.csv", sep=",")
fallecidos_3 = read.csv("ccaa_covid19_fallecidos_long.csv", sep=",")


str(hospitalizados_1)
str(uci_2)
str(fallecidos_3)

hospitalizados_1 = hospitalizados_1[hospitalizados_1$fecha > "2020-03-03",]
uci_2 = uci_2[uci_2$fecha > "2020-03-03",]

length(uci_2[uci_2$CCAA != "España",1])
length(hospitalizados_1[hospitalizados_1$CCAA!="España",1])
length(fallecidos_3[fallecidos_3$CCAA!="España",1])

uci_2 = uci_2[uci_2$CCAA != "España",]
hospitalizados_1 = hospitalizados_1[hospitalizados_1$CCAA!="España",]
fallecidos_3 = fallecidos_3[fallecidos_3$CCAA!="España",]

hospitalizados_ant = data.frame(Fecha=hospitalizados_1$fecha,CCAA=hospitalizados_1$CCAA,Hospitalizados=hospitalizados_1$total,UCI=uci_2$total,Fallecidos=fallecidos_3$total)
hospitalizados_ant = hospitalizados_train[!is.na(hospitalizados_train$Hospitalizados), ]
hospitalizados_ant$Fallecidos[is.na(hospitalizados_train$Fallecidos)] <- 0




set.seed(1234)
# Creamos un vector del tamaño del conjunto de datos con 1 y 0.
ind <- sample(2, nrow(hospitalizados_ant), replace = TRUE, prob = c(0.8, 0.2))
ind

hospitalizados_ant_train = hospitalizados_ant[ind == 1,]
hospitalizados_ant_test = hospitalizados_ant[ind == 2, ]

hospitalizados_ant_train
hospitalizados_ant_test


str(hospitalizados_ant_test)

linearModHos3 = lm(Fallecidos ~ Hospitalizados + UCI, data = hospitalizados_ant_train)
linearModHos3 = lm(Fallecidos ~ Hospitalizados , data = hospitalizados_ant_train)
print(linearModHos3)

plot(linearModHos3)

summary(linearModHos3)
#Error cd 7.9 según summary
residuos =rstandard(linearModHos3)
residuos
qqnorm(residuos)
qqline(residuos)

ajustados = fitted(linearModHos3)

linearModHos4 = lm(Fallecidos ~ Hospitalizados , data = hospitalizados_ant_train)



abline(linearModHos4)

intervaloConfianza = predict(linearModHos4, newdata = hospitalizados_ant_test,interval = 'confidence')
str(intervaloConfianza)
 
length(intervaloConfianza[,2])
length(intervaloConfianza[,3])

nrow(hospitalizados_ant_test)



hospitalizados_ant_test_i = cbind(hospitalizados_ant_test , intervaloConfianza)
hospitalizados_ant_test_i
hospitalizados_ant_madrid_i = hospitalizados_ant_test_i[hospitalizados_ant_test$CCAA=='Madrid',]
hospitalizados_ant_madrid_i

p = plot_ly(hospitalizados_ant_madrid_i, x = ~Fecha)%>%
  add_markers(y = ~Fallecidos, name="Fallecidos" )%>%
  add_lines(y = ~lwr, name="Rango inferior" )%>%
  add_lines(y = ~upr , name="Rango superiir")
p
intervaloConfianza2 = predict(linearModHos4, newdata = hospitalizados_ant_test,interval = 'prediction')
str(intervaloConfianza2)

length(intervaloConfianza2[,2])
length(intervaloConfianza2[,3])

nrow(hospitalizados_ant_test)
intervalo2=cbind(inf=intervaloConfianza2[,2],sup=intervaloConfianza2[,3])


hospitalizados_ant_test_i = cbind(hospitalizados_ant_test_i ,intervalo2 )
hospitalizados_ant_test_i
hospitalizados_ant_madrid_i = hospitalizados_ant_test_i[hospitalizados_ant_test$CCAA=='Madrid',]
hospitalizados_ant_madrid_i
hospitalizados_ant_asturias_i = hospitalizados_ant_test_i[hospitalizados_ant_test$CCAA=='Asturias',]

plot_ly(hospitalizados_ant_madrid_i, x = ~Fecha)%>%
  add_markers(y = ~Fallecidos, name="Fallecidos" )%>%
  add_lines(y = ~lwr, name="Rango inferior Confianza" )%>%
  add_lines(y = ~upr , name="Rango superiir Confianza")%>%
  add_lines(y = ~inf, name="Rango inferior Predicción" )%>%
  add_lines(y = ~sup , name="Rango superior Predicción")
plot_ly(hospitalizados_ant_asturias_i, x = ~Fecha)%>%
  add_markers(y = ~Fallecidos, name="Fallecidos" )%>%
  add_lines(y = ~lwr, name="Rango inferior Confianza" )%>%
  add_lines(y = ~upr , name="Rango superiir Confianza")%>%
  add_lines(y = ~inf, name="Rango inferior Predicción" )%>%
  add_lines(y = ~sup , name="Rango superior Predicción")

summary(linearModHos4)
confint(linearModHos4)
distPredFall3 <- predict(linearModHos4, hospitalizados_ant_test)
distPredFall3
str(distPredFall3)
hospitalizados_ant_test

hospitalizado_ant_test_a = data.frame(Fecha=hospitalizados_ant_test$Fecha,CCAA=hospitalizados_ant_test$CCAA, Hospitalizados=hospitalizados_ant_test$Hospitalizados,UCI=hospitalizados_ant_test$UCI, Fallecidos=hospitalizados_ant_test$Fallecidos,distPredFall3)

hospitalizado_ant_test_a[hospitalizado_ant_test_a$CCAA=='Madrid',]
hospitalizado_ant_test_a[hospitalizado_ant_test_a$CCAA=='Asturias',]



