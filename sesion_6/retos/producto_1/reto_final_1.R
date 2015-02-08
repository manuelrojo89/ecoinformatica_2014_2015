#Caracterización del funcionamiento del ecosistema y de las variables ambientales que 
#lo condicionan. Gracias a la gran cantidad de información procedente de sensores 
#remotos, es posible conocer la evolución temporal de variables como la cobertura de 
#nieve, índice de vegetación o temperatura del suelo en los distintos tipos de 
#ecosistemas diana. En concreto evaluaremos la tendencia en la cobertura de nieve 
#para los robledales de Sierra Nevada. Se trata de caracterizar la tendencia en la 
#duración de la nieve para cada píxel ocupado por robledal y año hidrológico. El 
#producto final será un mapa que muestre las tendencias en la duración de la nieve 
#para cada píxel en toda la serie temporal (2000-2012).


#He calculado la tendencias de NDVI y de NIEVE, ya que son los mismo, aunque en el
#sólo se pedía el de nieve, pero quería asegurarme de saber hacerlo bien y haber
#entendido correctamente el proceso

#PARA NDVI

#Vamos a calcular tendencias, cargamos kendall
library('Kendall')


#Primero cargamos la capa del ndvi y le damos un nombre
datos <- read.csv("ndvi_robledal.csv", sep=";")
str(datos)
head(datos)


#Creamos un data.frame donde se van a acumular los datos que vayamos obteniendo
tabla <- data.frame()

#Creamos una tabla auxiliar donde guardamos los datos de cada pixel (iv_malla_modi_id)
#el valor de tau que nos da kendal y el pvalue
tabla_aux <- data.frame(iv_malla_modi_id=NA, 
                        tau=NA, 
                        pvalue=NA)

#Definimos una variable unica para el pixel
pixeles <- unique(datos$iv_malla_modi_id)

#Creamos el bucle que nos analice cada pixel en cada año
for (j in pixeles){

  #Creamos variable de pixeles para que el bucle lea cada pixel de j 
  pixel <-datos[datos$iv_malla_modi_id==j,]
  #haces el mannkendall para obtener los valores de tau y p para el ndvi
  kendal <- MannKendall(pixel$ndvi_i)
  #Asignas a cada uno de los valores que queremos para nuestra tabla (j que es el
  #pixel unico, tau y pvalue) un nombre
  tabla_aux$iv_malla_modi_id <- j
  tabla_aux$tau <- kendal$tau[1]
  tabla_aux$pvalue <- kendal$sl[1]
  
  #el rbind nos pasa los valores de tabla_aux a tabla
  tabla <- rbind(tabla,tabla_aux)
}

# Selecciono las columnas que me interesan: "ndvi_i", "lat" y "lng" para pintarlas
#en el mapa final.
datospintar <- datos[,c(1,4:5)]
coordenadas<- unique(datospintar)

#Unimos los datos de la tabla y las coordenadas por el campo iv_malla_modi-id con el
#mismo nombre que le dais en el script a la tabla que se debe pintar (tendencias)
tendencias <- join(tabla, coordenadas, "iv_malla_modi_id")

#Representamos el mapa con el script que nos habéis proporcionado

library(sp)
library(rgdal)
library(classInt)
library(RColorBrewer)

## definimos las coordenadas de los puntos
coordinates(tendencias) =~lng+lat
## definimos el sistema de coordenadas WGS84
proj4string(tendencias)=CRS("+init=epsg:4326")

## partimos los valores de tau en 5 clases
clases <- classIntervals(tendencias$tau, n = 5)
## obtenemos cinco colores para una paleta de colores que se llama "Spectral"
plotclr <- rev(brewer.pal(5, "Spectral"))
## Asociamos los valores de tau a su valor correspondiente
colcode <- findColours(clases, plotclr)

## plot sin tener en cuenta
plot(tendencias, col=colcode, pch=19, cex = .6, main = "Mapa de tendencias")
## mostramos la leyenda
legend("topright", legend=names(attr(colcode, "table")), fill=attr(colcode, "palette"), bty="n")



#PARA LA CAPA NIEVE
#Primero cargamos la capa de nieve y le damos un nombre
datosnieve <- read.csv("nieve_robledal.csv", sep=";")
str(datosnieve)
head(datosnieve)


#Creamos un data.frame donde se van a acumular los datos que vayamos obteniendo
tabla <- data.frame()

#Creamos una tabla auxiliar donde guardamos los datos de cada pixel (nie_malla_modi_id)
#el valor de tau que nos da kendal y el pvalue
tabla_aux <- data.frame(nie_malla_modi_id=NA, 
                        tau=NA, 
                        pvalue=NA)

#Definimos una variable unica para el pixel
pixeles <- unique(datosnieve$nie_malla_modi_id)

#Creamos el bucle que nos analice cada pixel en cada año
for (j in pixeles){
  
  #Creamos variable de pixeles para que el bucle lea cada pixel de j 
  pixel <-datosnieve[datosnieve$nie_malla_modi_id==j,]
  #haces el mannkendall para obtener los valores de tau y p para la nieve
  kendal <- MannKendall(pixel$scd)
  #Asignas a cada uno de los valores que queremos para nuestra tabla (j que es el
  #pixel unico, tau y pvalue) un nombre
  tabla_aux$nie_malla_modi_id <- j
  tabla_aux$tau <- kendal$tau[1]
  tabla_aux$pvalue <- kendal$sl[1]
  
  #el rbind nos pasa los valores de tabla_aux a tabla
  tabla <- rbind(tabla,tabla_aux)
}

# Selecciono las columnas que me interesan: "ndvi_i", "lat" y "lng" para pintarlas
#en el mapa final.
datospintar <- datosnieve[,c(2,10:11)]
coordenadas<- unique(datospintar)

#Unimos los datos de la tabla y las coordenadas por el campo iv_malla_modi-id con el
#mismo nombre que le dais en el script a la tabla que se debe pintar (tendencias)
tendencias <- join(tabla, coordenadas, "nie_malla_modi_id")

#Representamos el mapa con el script que nos habéis proporcionado

library(sp)
library(rgdal)
library(classInt)
library(RColorBrewer)

## definimos las coordenadas de los puntos
coordinates(tendencias) =~lng+lat
## definimos el sistema de coordenadas WGS84
proj4string(tendencias)=CRS("+init=epsg:4326")

## partimos los valores de tau en 5 clases
clases <- classIntervals(tendencias$tau, n = 5)
## obtenemos cinco colores para una paleta de colores que se llama "Spectral"
plotclr <- rev(brewer.pal(5, "Spectral"))
## Asociamos los valores de tau a su valor correspondiente
colcode <- findColours(clases, plotclr)

## plot sin tener en cuenta
plot(tendencias, col=colcode, pch=19, cex = .6, main = "Mapa de tendencias")
## mostramos la leyenda
legend("topright", legend=names(attr(colcode, "table")), fill=attr(colcode, "palette"), bty="n")

