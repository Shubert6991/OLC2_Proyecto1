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

var arrPush = function arrPush(nodo, entorno, errores) {
  var id = getID(nodo.getListaNodos()[0]);
  var sim = entorno.getSimbolo(id);

  if (sim.getTipo().includes("ARRAY")) {
    var val = getValor(nodo.getListaNodos()[1], entorno, errores);
    sim.getValor().push(val);
  } else {
    console.error("Error Semantico");
    var err = new Error("Semantico", "La variable " + id + " no es un array, no se puede utilizar esta funcion", nodo.getFila(), nodo.getColumna());
    errores.push(err);
  }
};

var arrPop = function arrPop(nodo, entorno, errores) {
  var id = getID(nodo.getListaNodos()[0]);
  var sim = entorno.getSimbolo(id);

  if (sim.getTipo().includes("ARRAY")) {
    sim.getValor().pop();
  } else {
    console.error("Error Semantico");
    var err = new Error("Semantico", "La variable " + id + " no es un array, no se puede utilizar esta funcion", nodo.getFila(), nodo.getColumna());
    errores.push(err);
  }
};