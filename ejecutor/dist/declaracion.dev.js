"use strict";

//fucion para ejecutar declaracion
var declaracion = function declaracion(nodo, entorno, errores) {
  //verificar tipo de declaracion
  var tipo = 1;

  if (nodo.getNombre() === "CONST") {
    tipo = 0;
  }

  var count = nodo.hijosCount();
  var hijos = nodo.getListaNodos();

  switch (count) {
    case 3:
      //primer hijo id
      var id = getID(hijos[0]); //segundo hijo tipo

      var type = getType(hijos[1]); //tercer hijo valor

      var valor = "prueba";
      var nuevo = new Simbolo(tipo, id, type, valor, entorno.nombre, nodo.getFila(), nodo.getColumna());
      var result = entorno.addSimbolo(nuevo);
      console.log(result);

      if (!result) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "La variable " + id + " ya se habia declarado", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        break;
      }

      entorno.printTablaSimbolos();
      reportSimbolos(entorno.getTablaSimbolos());
      break;

    default:
      console.error("todavia no he programado la declaracion con esos hijos -> " + nodo.hijosCount());
      break;
  }
}; //getID


var getID = function getID(nodo) {
  if (nodo.getTipo() === "ID") {
    return nodo.getNombre();
  }
}; //get type


var getType = function getType(nodo) {
  if (nodo.getTipo() === "TIPO") {
    return nodo.getNombre();
  }
}; //get valor