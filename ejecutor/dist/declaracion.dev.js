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

      var type = getType(hijos[1], entorno, errores);

      if (type === false) {
        break;
      }

      if (type === "VOID") {
        console.error("Error Semantico");
        var err = new Error("Semantico", "La variable " + id + " no puede ser de tipo void", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        break;
      } //tercer hijo valor


      var valor = getValor(hijos[2], entorno, errores);
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


var getType = function getType(nodo, entorno, errores) {
  if (nodo.getTipo() === "TIPO") {
    if (nodo.getNombre() === "ID") {
      var id = getID(nodo.getListaNodos()[0]);
      return "ID_" + id;
    }

    if (nodo.getNombre() === "ARRAY_ID") {
      //array de types
      var id = getID(nodo.getListaNodos()[0]); //buscar en la tabla de simbolos si el id es tipo type

      var tid = entorno.getSimbolo(id); //sino error sintactico

      console.log(tid);

      if (tid === false) {
        var err = new Error("Semantico", "No se puede asignar ->" + id + " como tipo porque no es un type", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return false;
      } else {
        //get tipo id
        if (tid.getTipo() !== "TYPE") {
          var err = new Error("Semantico", "No se puede asignar ->" + id + " como tipo porque no es un type", nodo.getFila(), nodo.getColumna());
          errores.push(err);
          return false;
        }
      }

      return "ARRAY_" + id;
    }

    if (nodo.getNombre() === "ARRAY_TIPO") {
      var tipo = getType(nodo.getListaNodos()[0]);
      return "ARRAY_" + tipo;
    }

    return nodo.getNombre();
  }
}; //get valor


var getValor = function getValor(nodo, entorno, errores) {
  if (nodo.getTipo() === "VALOR") {//Valores
  }

  if (nodo.getTipo() === "A") {
    if (nodo.getNombre() === "SUMA") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      return val1 + val2;
    }

    if (nodo.getNombre() === "RESTA") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      var res = val1 - val2;

      if (isNaN(res)) {
        var err = new Error("Semantico", "No se pueden restar valores no numericos", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return 0;
      }

      return res;
    }

    if (nodo.getNombre() === "MULTI") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      var res = val1 * val2;

      if (isNaN(res)) {
        var err = new Error("Semantico", "No se pueden multiplicar valores no numericos", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return 0;
      }

      return res;
    }

    if (nodo.getNombre() === "DIV") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      var res = val1 / val2;

      if (isNaN(res)) {
        var err = new Error("Semantico", "No se pueden dividir valores no numericos", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return 0;
      }

      if (val2 === 0) {
        var err = new Error("Semantico", "No se pueden dividir entre 0", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return 0;
      }

      return res;
    }

    if (nodo.getNombre() === "EXP") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      var res = Math.pow(val1, val2);

      if (isNaN(res)) {
        var err = new Error("Semantico", "No se pueden elevar valores no numericos", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return 0;
      }

      return res;
    }

    if (nodo.getNombre() === "MOD") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      var res = val1 % val2;

      if (isNaN(res)) {
        var err = new Error("Semantico", "No se pueden encontrar mod de valores no numericos", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return 0;
      }

      return res;
    }
  }

  if (nodo.getTipo() === "R") {
    if (nodo.getNombre() === "MAYOR") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);

      if (isNaN(+val1) || isNaN(+val2)) {
        var err = new Error("Semantico", "No se puede realizar la operacion > con valores que no sean numericos", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return false;
      }

      return val1 > val2;
    }

    if (nodo.getNombre() === "MENOR") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);

      if (isNaN(+val1) || isNaN(+val2)) {
        var err = new Error("Semantico", "No se puede realizar la operacion < con valores que no sean numericos", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return false;
      }

      return val1 < val2;
    }

    if (nodo.getNombre() === "MAYORIGUAL") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);

      if (isNaN(+val1) || isNaN(+val2)) {
        var err = new Error("Semantico", "No se puede realizar la operacion >= con valores que no sean numericos", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return false;
      }

      return val1 >= val2;
    }

    if (nodo.getNombre() === "MENORIGUAL") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);

      if (isNaN(+val1) || isNaN(+val2)) {
        var err = new Error("Semantico", "No se puede realizar la operacion <= con valores que no sean numericos", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return false;
      }

      return val1 <= val2;
    }

    if (nodo.getNombre() === "IGUALDAD") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      return val1 == val2;
    }

    if (nodo.getNombre() === "DESIGUALDAD") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      return val1 != val2;
    }
  }

  if (nodo.getTipo() === "L") {
    if (nodo.getNombre() === "AND") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      return val1 && val2;
    }

    if (nodo.getNombre() === "OR") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
      return val1 || val2;
    }

    if (nodo.getNombre() === "NOT") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      return !val1;
    }
  }

  if (nodo.getTipo() === "BOOLEAN") {
    if (nodo.getNombre() === "true") {
      return true;
    } else {
      return false;
    }
  }

  if (nodo.getTipo() === "INCREMENTO") {
    var id = getID(nodo.getListaNodos()[0]); // console.log(id)
    //buscar en tabla de simbolos

    var tid = entorno.getSimbolo(id); // console.log(tid)

    if (tid === false) {
      //error semantico
      var err = new Error("Semantico", "No se puede incrementar ->" + id + " no esta declarado", nodo.getFila(), nodo.getColumna());
      errores.push(err);
      return 0;
    } else {
      if (tid.getTipo() !== "NUMBER") {
        var err = new Error("Semantico", "No se puede incrementar ->" + id + " no es tipo numero", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return 0;
      }
    } // sumarle 1
    // regresar nuevo valor


    return +tid.getValor() + 1;
  }

  if (nodo.getTipo() === "DECREMENTO") {
    var id = getID(nodo.getListaNodos()[0]); //buscar en tabla de simbolos

    var tid = entorno.getSimbolo(id);

    if (tid === false) {
      //error semantico
      var err = new Error("Semantico", "No se puede decrementar ->" + id + " no esta declarado", nodo.getFila(), nodo.getColumna());
      errores.push(err);
      return 0;
    } else {
      if (tid.getTipo() !== "NUMBER") {
        var err = new Error("Semantico", "No se puede decrementar ->" + id + " no es tipo numero", nodo.getFila(), nodo.getColumna());
        errores.push(err);
        return 0;
      }
    } //sumarle 1
    //regresar nuevo valor


    return +tid.getValor() - 1;
  }

  if (nodo.getTipo() === "NEGATIVO") {
    var val = getValor(nodo.getListaNodos()[0], entorno, errores);
    var res = +val * -1;

    if (isNaN(res)) {
      var err = new Error("Semantico", "Solo se puede volver negativo un valor numerico", nodo.getFila(), nodo.getColumna());
      errores.push(err);
      return 0;
    }

    return +val * -1;
  }

  if (nodo.getTipo() === "STRING") {
    return nodo.getNombre();
  }

  if (nodo.getTipo() === "ENTERO") {
    return +nodo.getNombre();
  }

  if (nodo.getTipo() === "DECIMAL") {
    return +nodo.getNombre();
  }

  if (nodo.getTipo() === "ID") {
    //buscar valor de id en la tabla de simbolos
    var id = nodo.getNombre();
    var tid = entorno.getSimbolo(id);

    if (!tid) {
      var err = new Error("Semantico", "La variable ->" + id + " no ha sido declarada", nodo.getFila(), nodo.getColumna());
      errores.push(err);
      return 0;
    }

    return tid.getValor();
  }
};