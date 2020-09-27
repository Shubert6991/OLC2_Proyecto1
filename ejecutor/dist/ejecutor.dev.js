"use strict";

//funcion para ejecutar codigo
var ejecutar = function ejecutar(ast, entorno, errores) {
  if (ast != null) {
    var tipo = ast.getTipo();
    console.log(tipo);

    switch (tipo) {
      case "S":
        ejecutar(ast.getListaNodos()[0], entorno, errores);
        break;

      case "I":
        ejecutar(ast.getListaNodos()[0], entorno, errores);
        ejecutar(ast.getListaNodos()[1], entorno, errores);
        break;

      case "DECLARACION":
        //ejecutar declaracion;
        declaracion(ast, entorno, errores);
        break;

      case "INCREMENTO":
        var id = getID(ast.getListaNodos()[0]); // console.log(id)
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


        var result = entorno.getSimbolo(id);
        var nval = +result.getValor() + 1;
        result.valor = nval;
        entorno.updateSimbolo(result);
        break;

      case "DECREMENTO":
        var id = getID(ast.getListaNodos()[0]); // console.log(id)
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


        var result = entorno.getSimbolo(id);
        var nval = +result.getValor() - 1;
        result.valor = nval;
        entorno.updateSimbolo(result);
        break;

      default:
        console.error("todavia no he programado eso -> " + tipo);
        break;
    }
  }
};