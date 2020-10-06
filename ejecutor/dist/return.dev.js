"use strict";

var ejecutarReturn = function ejecutarReturn(nodo, entorno, errores) {
  var tipo = nodo.getNombre();
  console.log(tipo);

  switch (tipo) {
    case "RETURN":
      return null;

    case "VALOR":
      return getValor(nodo.getListaNodos()[0], entorno, errores);

    case "ASIGNACION":
      asignacion(nodo.getListaNodos()[0], entorno, errores);
      return getValor(nodo.getListaNodos()[0].getListaNodos()[0], entorno, errores);
  }
};