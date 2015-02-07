#Caracterización del funcionamiento del ecosistema y de las variables ambientales que 
#lo condicionan. Gracias a la gran cantidad de información procedente de sensores 
#remotos, es posible conocer la evolución temporal de variables como la cobertura de 
#nieve, índice de vegetación o temperatura del suelo en los distintos tipos de 
#ecosistemas diana. En concreto evaluaremos la tendencia en la cobertura de nieve 
#para los robledales de Sierra Nevada. Se trata de caracterizar la tendencia en la 
#duración de la nieve para cada píxel ocupado por robledal y año hidrológico. El 
#producto final será un mapa que muestre las tendencias en la duración de la nieve 
#para cada píxel en toda la serie temporal (2000-2012).


#Vamos a trabajar en raster y vamos a calcular tendencias, cargamos raster y kendall
library('Kendall')
library('raster')

#Creamos un data.frame donde se van a acumular los datos que vayamos obteniendo
tabla <- data.frame()

#Creamos una tabla auxiliar donde guardamos los datos de cada pixel (iv_malla_modi_id)
#el valor de tau que nos da kendal y el pvalue
tabla_aux <- data.frame(iv_malla_modi_id=NA, 
                        tau=NA, 
                        pvalue=NA)

#Creamos el bucle que nos analice cada pixel en cada año
for (j in datos){

  #Creamos variable de pixeles para que el bucle lea cada pixel de j 
  pixel <-datos[datos$iv_malla_modi_id==j,]
  #haces el mannkendall para obtener los valores de tau y p para el ndvi
  kendal <- MannKendall(pixel$ndvi_i)
  #Asignas a cada uno de los valores que queremos para nuestra tabla (j que es el
  #pixel unico, tau y pvalue) un nombre
  tabla_aux$iv_malla_modi_id <- j
  tabla_aux$tau <- kendal$tau[1]
  tabla_aux$pvalue <- kendal$pvalue[1]
  
  #el rbind nos pasa los valores de tabla_aux a tabla
  tabla <- rbind(tabla,tabla_aux)
}
