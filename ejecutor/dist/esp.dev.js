"use strict";

var print = function print(nodo, entorno, errores) {
  var consola = document.getElementById("consola");
  var valor = getValor(nodo.getListaNodos()[0], entorno, errores);
  consola.value += valor + "\n";
};

var graphts = function graphts(entorno) {
  entorno.printTablaSimbolos();
  reportSimbolos(entorno.getTablaSimbolos());
};