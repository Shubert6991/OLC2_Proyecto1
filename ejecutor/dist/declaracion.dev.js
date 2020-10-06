"use strict";

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

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
      } // if(type === "VOID"){
      //   console.error("Error Semantico");
      //   var err = new Error("Semantico","La variable "+id+" no puede ser de tipo void",nodo.getFila(),nodo.getColumna());
      //   errores.push(err);
      //   break;
      // }
      //tercer hijo valor


      var valor = getValor(hijos[2], entorno, errores); //verificar tipo del valor

      console.log(_typeof(valor));

      switch (type) {
        case "STRING":
          if (typeof valor != "string") {
            //error
            console.error("Error Semantico");
            var err = new Error("Semantico", "El valor de la variable no es tipo string", nodo.getFila(), nodo.getColumna(), entorno.nombre);
            errores.push(err);
            return;
          }

          break;

        case "NUMBER":
          if (typeof valor != "number") {
            //error
            console.error("Error Semantico");
            var err = new Error("Semantico", "El valor de la variable no es tipo number", nodo.getFila(), nodo.getColumna(), entorno.nombre);
            errores.push(err);
            return;
          }

          break;

        case "BOOLEAN":
          if (typeof valor != "boolean") {
            //error
            console.error("Error Semantico");
            var err = new Error("Semantico", "El valor de la variable no es tipo boolean", nodo.getFila(), nodo.getColumna(), entorno.nombre);
            errores.push(err);
            return;
          }

          break;

        default:
          if (type.includes("ARRAY")) {
            if (_typeof(valor) != object) {
              console.error("Error Semantico");
              var err = new Error("Semantico", "El valor de la variable no es tipo array", nodo.getFila(), nodo.getColumna(), entorno.nombre);
              errores.push(err);
              return;
            }
          }

          break;
      }

      var nuevo = new Simbolo(tipo, id, type, valor, entorno.nombre, nodo.getFila(), nodo.getColumna());
      var result = entorno.addSimbolo(nuevo); // console.log(result)

      if (!result) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "La variable " + id + " ya se habia declarado", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
      }

      break;

    case 2:
      //hijo 1 id
      var id = getID(nodo.getListaNodos()[0]); //hijo 2 LTYPE

      if (nodo.getListaNodos()[1].getTipo() === "LTYPE") {
        console.log("Es una declaracion de tipo");
        var valor = getValor(nodo.getListaNodos()[1], entorno, errores);
        console.log(valor); // console.log(JSON.stringify(valor))
        // var valtext = "{";
        // for (const [key, value] of Object.entries(valor)) {
        //   console.log(`${key}: ${value}`);
        //   valtext += `"${key}": ${value},`;
        // } 
        // valtext = valtext.slice(0,-1); 
        // valtext += "}";     

        nuevo = new Simbolo(tipo, id, "TYPE", JSON.stringify(valor), entorno.nombre, nodo.getFila(), nodo.getColumna());
      } else {
        //hijo 2 valor
        var valor = getValor(nodo.getListaNodos()[1], entorno, errores); //hijo 2 tipo

        var type = getType(nodo.getListaNodos()[1]);
        console.log(valor);
        console.log(type);
        var nuevo;

        if (valor == null) {
          //es con tipo
          switch (type) {
            case "STRING":
              valor = "";
              break;

            case "NUMBER":
              valor = 0;
              break;

            case "BOOLEAN":
              valor = true;
              break;

            case undefined:
              type = "VOID";
              break;
          }

          nuevo = new Simbolo(tipo, id, type, valor, entorno.nombre, nodo.getFila(), nodo.getColumna());
        } else {
          //es con valor
          console.log(_typeof(valor));

          switch (_typeof(valor)) {
            case "string":
              type = "STRING";
              break;

            case "number":
              type = "NUMBER";
              break;

            case "boolean":
              type = "BOOLEAN";
              break;

            case "object":
              type = "ARRAY";

            case null:
              type = "VOID";
              break;

            default:
              break;
          }

          nuevo = new Simbolo(tipo, id, type, valor, entorno.nombre, nodo.getFila(), nodo.getColumna());
        }
      }

      var result = entorno.addSimbolo(nuevo); // console.log(result)

      if (!result) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "La variable " + id + " ya se habia declarado", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
      }

      break;

    case 1:
      //let id
      var id = getID(nodo.getListaNodos()[0]);
      var nuevo = new Simbolo(tipo, id, null, null, entorno.nombre, nodo.getFila(), nodo.getColumna());
      var result = entorno.addSimbolo(nuevo); // console.log(result)

      if (!result) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "La variable " + id + " ya se habia declarado", nodo.getFila(), nodo.getColumna());
        errores.push(err);
      }

      break;
  } // entorno.printTablaSimbolos();
  // reportSimbolos(entorno.getTablaSimbolos());

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

    if (nodo.getNombre() === "ARRAY") {
      return "ARRAY";
    }

    return nodo.getNombre();
  }
}; //get valor


var getValor = function getValor(nodo, entorno, errores) {
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
        var err = new Error("Semantico", "No se pueden restar valores no numericos", nodo.getFila(), nodo.getColumna(), entorno.nombre);
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
        var err = new Error("Semantico", "No se pueden multiplicar valores no numericos", nodo.getFila(), nodo.getColumna(), entorno.nombre);
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
        var err = new Error("Semantico", "No se pueden dividir valores no numericos", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
        return 0;
      }

      if (val2 === 0) {
        var err = new Error("Semantico", "No se pueden dividir entre 0", nodo.getFila(), nodo.getColumna(), entorno.nombre);
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
        var err = new Error("Semantico", "No se pueden elevar valores no numericos", nodo.getFila(), nodo.getColumna(), entorno.nombre);
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
        var err = new Error("Semantico", "No se pueden encontrar mod de valores no numericos", nodo.getFila(), nodo.getColumna(), entorno.nombre);
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
        var err = new Error("Semantico", "No se puede realizar la operacion > con valores que no sean numericos", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
        return false;
      }

      return val1 > val2;
    }

    if (nodo.getNombre() === "MENOR") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);

      if (isNaN(+val1) || isNaN(+val2)) {
        var err = new Error("Semantico", "No se puede realizar la operacion < con valores que no sean numericos", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
        return false;
      }

      return val1 < val2;
    }

    if (nodo.getNombre() === "MAYORIGUAL") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);

      if (isNaN(+val1) || isNaN(+val2)) {
        var err = new Error("Semantico", "No se puede realizar la operacion >= con valores que no sean numericos", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
        return false;
      }

      return val1 >= val2;
    }

    if (nodo.getNombre() === "MENORIGUAL") {
      var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
      var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);

      if (isNaN(+val1) || isNaN(+val2)) {
        var err = new Error("Semantico", "No se puede realizar la operacion <= con valores que no sean numericos", nodo.getFila(), nodo.getColumna(), entorno.nombre);
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

  if (nodo.getTipo() === "T") {
    var val1 = getValor(nodo.getListaNodos()[0], entorno, errores);
    var val2 = getValor(nodo.getListaNodos()[1], entorno, errores);
    var val3 = getValor(nodo.getListaNodos()[2], entorno, errores);

    if (val1) {
      return val2;
    } else {
      return val3;
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
      var err = new Error("Semantico", "No se puede decrementar ->" + id + " no esta declarado", nodo.getFila(), nodo.getColumna(), entorno.nombre);
      errores.push(err);
      return 0;
    } else {
      if (tid.getTipo() !== "NUMBER") {
        var err = new Error("Semantico", "No se puede decrementar ->" + id + " no es tipo numero", nodo.getFila(), nodo.getColumna(), entorno.nombre);
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
      var err = new Error("Semantico", "Solo se puede volver negativo un valor numerico", nodo.getFila(), nodo.getColumna(), entorno.nombre);
      errores.push(err);
      return 0;
    }

    return +val * -1;
  }

  if (nodo.getTipo() === "STRING") {
    var s = nodo.getNombre();

    if (s.includes("${")) {
      var regex = /\${([a-zA-ZñÑáéíóúÁÉÍÓÚ]["_"0-9a-zA-ZñÑáéíóúÁÉÍÓÚ]*|["_"]+[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ]["_"0-9a-zA-ZñÑáéíóúÁÉÍÓÚ]*)}/g;
      var tmp = s.match(regex);

      for (var index = 0; index < tmp.length; index++) {
        var ant = tmp[index];
        tmp[index] = tmp[index].replace("${", "").replace("}", "");
        var sim = entorno.getSimbolo(tmp[index]);
        console.log(sim.valor);
        s = s.replace(ant, sim.valor);
      }

      console.log(tmp);
    }

    return s;
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
      var err = new Error("Semantico", "La variable ->" + id + " no ha sido declarada", nodo.getFila(), nodo.getColumna(), entorno.nombre);
      errores.push(err);
      return 0;
    }

    return tid.getValor();
  }

  if (nodo.getTipo() === "ARRAY") {
    //hijo1 == id
    //hijo2 == pos
    //buscar valor en la tabla de simbolos
    var id = getID(nodo.getListaNodos()[0]);
    var pos = getValor(nodo.getListaNodos()[1], entorno, errores);
    var sim = entorno.getSimbolo(id);

    if (sim.getTipo().includes("ARRAY")) {
      return sim.getValor()[pos];
    } else {
      //error
      var err = new Error("Semantico", "La variable ->" + id + " no es un array", nodo.getFila(), nodo.getColumna(), entorno.nombre);
      errores.push(err);
      return 0;
    }
  }

  if (nodo.getTipo() === "VARRAY") {
    //arreglo
    //hijo1 = lista
    //obtener valores
    var val = getValor(nodo.getListaNodos()[0], entorno, errores);
    return val;
  }

  if (nodo.getTipo() === "LISTA_ARRAY") {
    //si tiene 2 hijos, vienen varios valores
    //si tiene 1 hijo viene 1 valor
    var lista = new Array();

    if (nodo.hijosCount() == 2) {
      //hijo1 = lista
      var tmp = getValor(nodo.getListaNodos()[0], entorno, errores);

      if (Array.isArray(tmp)) {
        tmp.forEach(function (element) {
          lista.push(element);
        });
      } else {
        lista.push(tmp);
      } //hijo2 = valor


      lista.push(getValor(nodo.getListaNodos()[1], entorno, errores));
    }

    if (nodo.hijosCount() == 1) {
      //hijo1 = valor
      lista.push(getValor(nodo.getListaNodos()[0], entorno, errores));
    }

    return lista;
  }

  if (nodo.getTipo() === "LENGTH") {
    var id = getID(nodo.getListaNodos()[0]);
    var sim = entorno.getSimbolo(id);

    if (sim.getTipo().includes("ARRAY")) {
      return sim.getValor().length;
    } else {
      console.error("Error Semantico");
      var err = new Error("Semantico", "La variable " + id + " no es un array, no se puede utilizar esta funcion", nodo.getFila(), nodo.getColumna(), entorno.nombre);
      errores.push(err);
    }
  }

  if (nodo.getTipo() === "LTYPE") {
    //3 hijos
    //LTYPE,ID,VALOR
    //2 hijos
    //ID,VALOR
    var ids = new Array();
    var valores = new Array();
    var obj = {};

    switch (nodo.hijosCount()) {
      case 3:
        obj = getValor(nodo.getListaNodos()[0], entorno, errores);
        ids.push(nodo.getListaNodos()[1].getNombre());
        valores.push(getValor(nodo.getListaNodos()[2], entorno, errores));
        break;

      case 2:
        ids.push(nodo.getListaNodos()[0].getNombre());
        valores.push(getValor(nodo.getListaNodos()[1], entorno, errores));
        break;

      default:
        break;
    }

    for (i = 0; i < ids.length; i++) {
      var o = _defineProperty({}, ids[i], valores[i]);

      Object.assign(obj, o);
    }

    return obj;
  }

  if (nodo.getTipo() === "PROPIEDAD") {
    //id obj
    //id propiedad
    var id1 = getID(nodo.getListaNodos()[0]); // var id2 = getID(nodo.getListaNodos()[1]);

    sim = entorno.getSimbolo(id1);

    if (sim.getTipo() === "TYPE") {
      var p = getValor(nodo.getListaNodos()[1], entorno, errores); // console.log(sim.getValor())

      var obj = JSON.parse(sim.getValor());
      console.log(obj);
      console.log(p);
      console.log(obj[p]);
      return obj[p];
    } else {
      console.error("Error Semantico");
      var err = new Error("Semantico", "La variable " + id + " no es un type, no se puede obtener una propiedad", nodo.getFila(), nodo.getColumna(), entorno.nombre);
      errores.push(err);
    }
  }

  if (nodo.getTipo() === "VALFUNCION") {
    //ejecutar funcion
    //1 hijo, sin parametros
    //ID
    //2 hijos con parametros
    //ID,LPAR
    //buscar funcion en lista de funciones
    //asignar parametros
    //ejecutar codigo
    var id = getID(nodo.getListaNodos()[0]);
    console.log(entorno.listaFunciones);
    var func = entorno.getFuncion(id);
    console.log(func);

    switch (nodo.hijosCount()) {
      case 1:
        //sin parametros
        return ejecutar(func.sentencias, new Entorno("FUNCION_" + func.id, entorno), errores);

      case 2:
        //asignar parametros
        var ent = new Entorno("FUNCION_" + func.id, entorno);
        decpar(func.parametros, ent, errores); //asig parametros
        //ejecutar codigo

        var arrvar = asigpar(nodo.getListaNodos()[1], ent, errores); //console.log(arrvar);
        // console.log(ent.tablaSimbolos.getTabla());

        var ts = ent.tablaSimbolos.getTabla();

        for (var _index = 0; _index < ts.length; _index++) {
          var sim = ts[_index];
          sim.valor = arrvar[_index];
          ent.updateSimbolo(sim);
        }

        return ejecutar(func.sentencias, ent, errores);
    }

    return null;
  }
};

var decpar = function decpar(nodo, entorno, errores) {
  //3||2 hijos
  switch (nodo.hijosCount()) {
    case 3:
      decpar(nodo.getListaNodos()[0], entorno, errores);
      var id = getID(nodo.getListaNodos()[1]);
      var tipo = getType(nodo.getListaNodos()[2]);
      var sim = new Simbolo(1, id, tipo, null, entorno.nombre, nodo.getFila(), nodo.getColumna());
      var result = entorno.addSimbolo(sim); // console.log(result)

      if (!result) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "La variable " + id + " ya se habia declarado", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
      }

      break;

    case 2:
      var id = getID(nodo.getListaNodos()[0]);
      var tipo = getType(nodo.getListaNodos()[1]);
      var sim = new Simbolo(1, id, tipo, null, entorno.nombre, nodo.getFila(), nodo.getColumna());
      var result = entorno.addSimbolo(sim); // console.log(result)

      if (!result) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "La variable " + id + " ya se habia declarado", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
      }

      break;
  }
};

var asigpar = function asigpar(nodo, entorno, errores) {
  //2 hijos
  var h1 = nodo.getListaNodos()[0];
  var h2 = nodo.getListaNodos()[1];
  var vars = new Array();

  if (h1.getTipo() === "LPAR") {
    var tmp = asigpar(h1, entorno, errores);

    if (Array.isArray(tmp)) {
      tmp.forEach(function (element) {
        vars.push(element);
      });
    }

    vars.push(getValor(h2, entorno, errores));
  } else {
    vars.push(getValor(h1, entorno, errores));
    vars.push(getValor(h2, entorno, errores));
  }

  return vars;
};