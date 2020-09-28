"use strict";

var ejecutarWhile = function ejecutarWhile(nodo, entorno, errores) {
  //hijo1 = condicion
  //hijo2 = sentencias
  var val = getValor(nodo.getListaNodos()[0], entorno, errores);

  while (val) {
    ejecutar(nodo.getListaNodos()[1], entorno, errores);
    val = getValor(nodo.getListaNodos()[0], entorno, errores);
  }
};