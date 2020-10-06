"use strict";

var ejecutarWhile = function ejecutarWhile(nodo, entorno, errores) {
  //hijo1 = condicion
  //hijo2 = sentencias
  var val = getValor(nodo.getListaNodos()[0], entorno, errores);

  while (val) {
    var r = ejecutar(nodo.getListaNodos()[1], entorno, errores);
    if (r == "BREAK") break;
    if (r == "CONTINUE") continue;
    if (r == "RETURN") return;
    if (r != null) return r;
    val = getValor(nodo.getListaNodos()[0], entorno, errores);
  }
};

var ejecutarDoWhile = function ejecutarDoWhile(nodo, entorno, errores) {
  //hijo1 = sentencias
  //hijo2 = condicion
  var cond = getValor(nodo.getListaNodos()[1], entorno, errores);

  do {
    var r = ejecutar(nodo.getListaNodos()[0], entorno, errores);
    if (r == "BREAK") break;
    if (r == "CONTINUE") continue;
    if (r == "RETURN") return;
    if (r != null) return r;
    cond = getValor(nodo.getListaNodos()[1], entorno, errores);
  } while (cond);
};