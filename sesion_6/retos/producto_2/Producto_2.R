#Producto 2
#Caracterización de poblaciones de robledal en función de variables biofísicas. Se 
#realizará una clasificación de los distintos subtipos o poblaciones de ecosistemas 
#teniendo en cuenta variables climáticas, edáficas y de funcionamiento ecosistémico. 
#El producto final será un mapa o una tabla que muestre a qué grupo pertenece cada 
#píxel del mapa de distribución del robledal en Sierra Nevada. Es decir, se indicarán 
#los distintos “tipos” de robledal en función de las variables biofísicas utilizadas
#en la clasificación.


#Leemos 
robles<-read.csv("robles_ecoinfo.csv", header = T, sep = ",", dec=".")
str(robles)
head(robles)

#Definimos las variables que vamos a utilizar. Borramos las columnas "x" e "y" que no
#necesitamos "x" ni "y"
variables<- subset(robles, select=-c(x,y))

#Definimos el cluster de 3
n_cluster<-3

#Agrupamos los pixeles en el número de grupos del cluster de la tabla "variables", y 
#y recalculamos los centroides 200 veces para asegurarnos.
mi_cluster<-kmeans(variables, n_cluster, iter.max=200)

#Una vez hecho el cluster, seleccionamos las columnas "x" e "y" que definen cada pixel
#de la tabla "robles" para luego combinarla con los valores del cluster. 
coordenadas<-subset(robles,select=c(x,y))
head(robles)

#Combinamos las columnas de coordenadas con los valores del cluster para cada pixel.
#Los valores del cluster vienen determinados en la primera columna de "mi_cluster"
#si miramos el Environment.
coordenadas<-cbind(coordenadas, mi_cluster[[1]])
head(coordenadas)
str(coordenadas)

#Asignamos un nombre a la columna de la tabla coordenadas de los cluster
colnames(coordenadas)[3]<-"mi_cluster"

library(sp)
library(rgdal)
library(classInt)
library(RColorBrewer)

## definimos las coordenadas de los puntos
coordinates(coordenadas) =~x+y
## definimos el sistema de coordenadas WGS84
proj4string(coordenadas)=CRS("+init=epsg:23030")

## obtenemos n_cluster colores para una paleta de colores que se llama "Spectral", para cada cluster creado
plotclr <- rev(brewer.pal(n_cluster, "Spectral"))

## plot, asignando el color en función del cluster al que pertenece
plot(coordenadas, col=plotclr[coordenadas$mi_cluster], pch=19, cex = .6, main = "Mapa de grupos de roble")


