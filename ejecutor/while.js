const ejecutarWhile = (nodo,entorno,errores) => {
  //hijo1 = condicion
  //hijo2 = sentencias
  var val = getValor(nodo.getListaNodos()[0],entorno,errores);
  while(val){
     ejecutar(nodo.getListaNodos()[1],entorno,errores);
     val = getValor(nodo.getListaNodos()[0],entorno,errores);
  }
}

const ejecutarDoWhile = (nodo,entorno,errores) => {
  //hijo1 = sentencias
  //hijo2 = condicion
  var cond = getValor(nodo.getListaNodos()[1],entorno,errores);
  do {
    ejecutar(nodo.getListaNodos()[0],entorno,errores);
    cond = getValor(nodo.getListaNodos()[1],entorno,errores);
  } while (cond);
}