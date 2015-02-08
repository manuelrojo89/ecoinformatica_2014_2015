#Algoritmo que haga la media de 10 temperaturas indicadas por el usuario.

#Forma 1. Simple
a <- scan(n=10)
mean(a)
print(mean)


##Forma 2. Con bucle
suma <- 0
for (b in suma) {
  temperaturas<-scan(n=10)
  total <- suma + temperaturas
  
}

media <- mean(total)
print(media)

### Ejemplo funcion media. Para preguntar. No evaluar

mimedia <- function(x){ 
            sum(x)/length(x) }


c <- scan(n=10)
mimedia(x=c)
