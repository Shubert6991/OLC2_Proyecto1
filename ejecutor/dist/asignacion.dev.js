"use strict";

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

var asignacion = function asignacion(nodo, entorno, errores) {
  var id = getID(nodo.getListaNodos()[0]);

  if (id) {
    //acualizar
    var sim = entorno.getSimbolo(id);
    var valor = getValor(nodo.getListaNodos()[1], entorno, errores); //verificar si no es constante

    if (sim.getTipoDec() === 0) {
      console.error("Error Semantico");
      var err = new Error("Semantico", "No se puede cambiar la constante -> " + id, nodo.getFila(), nodo.getColumna(), entorno.nombre);
      errores.push(err);
      return;
    } //verificar el tipo


    var tval = _typeof(valor);

    console.log(tval);

    switch (sim.getTipo()) {
      case null:
        var tip = "";
        sim.valor = valor;

        if (tval == "string") {
          tip = "STRING";
        }

        if (tval == "number") {
          tip = "NUMBER";
        }

        if (tval == "boolean") {
          tip = "BOOLEAN";
        }

        if (tval == "object") {
          if (Array.isArray(valor)) {
            tip = "ARRAY";
          } else {
            tip = "TYPE"; // var valtext = "{";
            // for (const [key, value] of Object.entries(valor)) {
            //   console.log(`${key}: ${value}`);
            //   valtext += `${key}: ${value},`;
            // } 
            // valtext = valtext.slice(0,-1); 
            // valtext += "}";

            sim.valor = JSON.stringify(valor);
          }
        }

        sim.tipo = tip;
        break;

      case "STRING":
        if (tval != "string") {
          //errror
          console.error("Error Semantico");
          var err = new Error("Semantico", "La variable " + id + " es de tipo string no se puede asignar el nuevo valor", nodo.getFila(), nodo.getColumna(), entorno.nombre);
          errores.push(err);
          return;
        }

        sim.valor = valor;
        break;

      case "BOOLEAN":
        if (tval != "boolean") {
          //errror
          console.error("Error Semantico");
          var err = new Error("Semantico", "La variable " + id + " es de tipo boolean no se puede asignar el nuevo valor", nodo.getFila(), nodo.getColumna(), entorno.nombre);
          errores.push(err);
          return;
        }

        sim.valor = valor;
        break;

      case "NUMBER":
        if (tval != "number") {
          //errror
          console.error("Error Semantico");
          var err = new Error("Semantico", "La variable " + id + " es de tipo boolean no se puede asignar el nuevo valor", nodo.getFila(), nodo.getColumna(), entorno.nombre);
          errores.push(err);
          return;
        }

        sim.valor = valor;
        break;

      case "ARRAY":
        sim.valor = valor;
        break;

      case "TYPE":
        // var valtext = "{";
        // for (const [key, value] of Object.entries(valor)) {
        //   console.log(`${key}: ${value}`);
        //   valtext += `${key}: ${value},`;
        // } 
        // valtext = valtext.slice(0,-1); 
        // valtext += "}";
        sim.valor = JSON.stringify(valor);
        break;
    } //actualizar simbolo
    //console.log("simbolo actualizado");
    //console.log(sim);


    entorno.updateSimbolo(sim);
  }
};