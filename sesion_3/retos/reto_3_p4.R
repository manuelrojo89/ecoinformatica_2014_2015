#Dado el conjunto de datos ndvi.zip (podeis descargar de http://www.iecolab.es/ecoinfo/sesion_3.zip)
#Cada imagen raster se tomó un día, a una hora y minutos concretos
#Queremos hacer un script que muestre la evolución del NDVI medio para las horas del día

#Palabras clave: Raster, list.files, paste, stack, mean, rbind, plot

#MODO 1

# Introducimos el comando para trabajar en raster 
library(raster)

#Creamos el vector especificando las horas de las que queremos obtener la media
horas <- c("12", "13", "14", "15")

#Se guarda la media de las horas obtenidas medias_ndvi para que no se borren con cada
#bucle que se realiza
medias_ndvi <- data.frame()

#Guardamos la media y la hora en que se realiza para poder dibujarlas posteriormente
medias_ndvi_aux <- data.frame(hora=NA, 
                          media_ndvi=NA)
#Se crea el bucle para que vaya leyendo las distintas franjas horarias especificadas en "horas" 
for (j in horas){
  # Se leen las distintas imágenes de j 
  imagenes_hora <- list.files(path="./sesion_3/retos/ndvi", full.names = TRUE, recursive=TRUE,
                         pattern=paste("_", j , "..\\.jpg\\.asc$", sep=""))
  
  # Se combinan todas las imagenes de la misma hora 
  todas_hora <- stack(imagenes_hora) 
  
  # Hacemos la media de las 3 imágenes (:00,:20,:40) para obtener la media por pixel
  media_pixel_hora <- mean(todas_hora)
  
  # Hacemos la media de todos los pixeles de la imagen anterior, con la misma hora
  media_hora <- mean(media_pixel_hora[])
  
  #Asignamos donde tienen que ir los valores del bucle a la "carpeta" con las horas y la media de ndvi
  medias_ndvi_aux$hora <- j 
  medias_ndvi_aux$media_ndvi <- media_hora
  
  # Se guardan los valores
  medias_ndvi <- rbind(medias_ndvi_aux, medias_ndvi)
  
}

#Se dibuja la gráfica
plot(medias_ndvi)



















