"use strict";

var ejecutarSwitch = function ejecutarSwitch(nodo, entorno, errores) {
  //hijo1 = condicion
  var cond = getValor(nodo.getListaNodos()[0], entorno, errores); //hijo2 = bloque switch

  ejecutarBSwitch(cond, nodo.getListaNodos()[1], entorno, errores);
};

var ejecutarBSwitch = function ejecutarBSwitch(cond, nodo, entorno, errores) {
  if (nodo.hijosCount() == 2) {
    //case default
    ejecutarCases(cond, nodo.getListaNodos()[0], entorno, errores, false, false);
    ejecutarDefault(nodo.getListaNodos()[1], entorno, errores);
  }

  if (nodo.hijosCount() == 1) {
    //case
    ejecutarCases(cond, nodo.getListaNodos()[0], entorno, errores);
  }
};

var ejecutarCases = function ejecutarCases(cond, nodo, entorno, errores) {
  if (nodo.hijosCount() == 3) {
    if (ejecutarCases(cond, nodo.getListaNodos()[0], entorno, errores)) {
      console.log("Ejecutando cases 3 hijos");
      ejecutar(nodo.getListaNodos()[2], entorno, errores);
      return true;
    } else {
      //verificar la sentencia
      console.log("verificando sentencias cases 3 hijos");
      var val = getValor(nodo.getListaNodos()[1], entorno, errores);
      console.log("verificando: " + val + " y " + cond);

      if (val === cond) {
        ejecutar(nodo.getListaNodos()[2], entorno, errores);
        return true;
      }
    }
  }

  if (nodo.hijosCount() == 2) {
    if (nodo.getListaNodos()[0].getTipo() === "CASE") {
      if (ejecutarCases(cond, nodo.getListaNodos()[0], entorno, errores)) {
        //no tiene nada;
        console.log("Ejecutando cases 2 hijos no tiene nada v1");
        return true;
      } else {
        //verificar la sentencia
        console.log("verificando sentencias cases 2 hijos v1");
        var val = getValor(nodo.getListaNodos()[1], entorno, errores);
        console.log("verificando: " + val + " y " + cond);

        if (val === cond) {
          // no tiene nada
          return true;
        }
      }
    } else {
      console.log("verificando sentencias cases 2 hijos v2");
      var val = getValor(nodo.getListaNodos()[0], entorno, errores);
      console.log("verificando: " + val + " y " + cond);

      if (val === cond) {
        console.log("Ejecutando cases 2 hijos v2");
        ejecutar(nodo.getListaNodos()[1], entorno, errores);
        return true;
      }
    }
  }

  if (nodo.hijosCount() == 1) {
    console.log("verificando sentencias cases 1 hijos");
    var val = getValor(nodo.getListaNodos()[0], entorno, errores);
    console.log("verificando: " + val + " y " + cond);

    if (val === cond) {
      //no tiene sentencias
      console.log("Ejecutando cases 1 hijos no tiene nada");
      return true;
    }
  }

  return false;
};

var ejecutarDefault = function ejecutarDefault(nodo, entorno, errores, hasBreak) {
  if (!hasBreak) {
    if (nodo.hijosCount() == 1) {
      ejecutar(nodo.getListaNodos()[0], entorno, errores);
    }
  }
};