# Algoritmo que dado un umbral por el usuario, dados 10 números por el usuario,
# cuente cuántos de esos números supera el umbral indicado.
a <-scan (n=10)
umbral <-22
suma <-0
for (valor in a){
  if (valor > umbral)
    (suma <- suma+1)
}
print(suma)
