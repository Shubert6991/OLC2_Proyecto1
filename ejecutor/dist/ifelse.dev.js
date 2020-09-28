"use strict";

var ejecutarIF = function ejecutarIF(nodo, entorno, errores) {
  //hijo1 condicion
  //hijo2 sentencias
  //hijo3 Else||IF||nada
  if (nodo.hijosCount() == 3) {
    var cond = getValor(nodo.getListaNodos()[0], entorno, errores);

    if (typeof cond != "boolean") {
      console.error("Error Semantico");
      var err = new Error("Semantico", "La condicion del if debe ser una expresion logica", nodo.getFila(), nodo.getColumna());
      errores.push(err);
      return;
    }

    if (cond) {
      ejecutar(nodo.getListaNodos()[1], entorno, errores);
    } else {
      ejecutar(nodo.getListaNodos()[2], entorno, errores);
    }
  }

  if (nodo.hijosCount() == 2) {
    var cond = getValor(nodo.getListaNodos()[0], entorno, errores);

    if (typeof cond != "boolean") {
      console.error("Error Semantico");
      var err = new Error("Semantico", "La condicion del if debe ser una expresion logica", nodo.getFila(), nodo.getColumna());
      errores.push(err);
      return;
    }

    if (cond) {
      ejecutar(nodo.getListaNodos()[1], entorno, errores);
    }
  }
};

var ejecutarElse = function ejecutarElse(nodo, entorno, errores) {
  ejecutar(nodo.getListaNodos()[0], entorno, errores);
};