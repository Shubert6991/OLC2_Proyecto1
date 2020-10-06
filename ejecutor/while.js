const ejecutarWhile = (nodo,entorno,errores) => {
  //hijo1 = condicion
  //hijo2 = sentencias
  var val = getValor(nodo.getListaNodos()[0],entorno,errores);
  while(val){
     var r = ejecutar(nodo.getListaNodos()[1],entorno,errores);
     if(r == "BREAK") break;
     val = getValor(nodo.getListaNodos()[0],entorno,errores);
  }
}

const ejecutarDoWhile = (nodo,entorno,errores) => {
  //hijo1 = sentencias
  //hijo2 = condicion
  var cond = getValor(nodo.getListaNodos()[1],entorno,errores);
  do {
    var r = ejecutar(nodo.getListaNodos()[0],entorno,errores);
    if(r == "BREAK") break;
    cond = getValor(nodo.getListaNodos()[1],entorno,errores);
  } while (cond);
}