"use strict";

var ejecutarFor = function ejecutarFor(nodo, entorno, errores) {
  //4/3 hijos
  //hijo1 = Declaracion/Asigncion
  //hijo2 = condicion
  //hijo3 = incremento/decremento
  //hijo4 = sentencias
  var h1 = nodo.getListaNodos()[0];
  var tipo = h1.getTipo();
  var val = 0;

  switch (tipo) {
    case "DECLARACION":
      declaracion(h1, entorno, errores); //val = getValor(h1.getListaNodos()[1],entorno,errores);

      break;

    case "ASIGNACION":
      asignacion(h1, entorno, errores); //val = getValor(h1.getListaNodos()[1],entorno,errores);

      break;

    default:
      return;
  }

  var cond = getValor(nodo.getListaNodos()[1], entorno, errores);

  while (cond) {
    var r = ejecutar(nodo.getListaNodos()[3], entorno, errores);
    ejecutar(nodo.getListaNodos()[2], entorno, errores);
    cond = getValor(nodo.getListaNodos()[1], entorno, errores);
    if (r == "BREAK") break;
    if (r == "CONTINUE") continue;
    if (r == "RETURN") return;
    if (r != null) return r;
  }
};

var ejecutarForIn = function ejecutarForIn(nodo, entorno, errores) {
  //3 hijos
  //id,declaracion
  //id
  //sentencias
  var h1 = nodo.getListaNodos()[0];
  var h2 = nodo.getListaNodos()[1];
  var h3 = nodo.getListaNodos()[2];
  var id1;
  var id2 = h2.getNombre();
  var sim;

  switch (h1.getTipo()) {
    case "ID":
      id1 = h1.getNombre();
      sim = entorno.getSimbolo(id1);

      if (sim === false) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "la variable: " + id1 + " no esta declarada", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
        return;
      }

      break;

    case "DECLARACION":
      declaracion(h1, entorno, errores);
      id1 = h1.getListaNodos()[0].getNombre();
      sim = entorno.getSimbolo(id1);

      if (sim === false) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "La variable: " + id1 + " no esta declarada", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
        return;
      }

      break;
  }

  console.log(sim); //get id hijo 2 en tabla de simbolos

  var sim2 = entorno.getSimbolo(id2);
  console.log(sim2);
  console.log(sim2.getTipo());

  if (sim2.getTipo().includes("TYPE")) {
    var obj = sim2.getValor();
    var tmp = JSON.parse(obj); //ejecutar sentencias hasta que se acaben los elementos del arreglo

    for (var key in tmp) {
      console.log(key);
      sim.valor = key;
      sim.tipo = sim2.tipo;
      entorno.updateSimbolo(sim);
      var r = ejecutar(h3, entorno, errores);
      if (r == "BREAK") break;
      if (r == "CONTINUE") continue;
      if (r == "RETURN") return;
      if (r != null) return r;
    }

    return;
  }

  console.error("Error Semantico");
  var err = new Error("Semantico", "la variable: " + id2 + " no es un arreglo", nodo.getFila(), nodo.getColumna(), entorno.nombre);
  errores.push(err);
  return;
};

var ejecutarForOf = function ejecutarForOf(nodo, entorno, errores) {
  //3 hijos
  //id|declaracion let|declaracion const
  //id
  //sentencias
  var h1 = nodo.getListaNodos()[0];
  var h2 = nodo.getListaNodos()[1];
  var h3 = nodo.getListaNodos()[2];
  var id1;
  var id2 = h2.getNombre();
  var sim;

  switch (h1.getTipo()) {
    case "ID":
      //buscar id en tabla de simbolos
      id1 = h1.getNombre();
      sim = entorno.getSimbolo(id1);

      if (sim === false) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "la variable: " + id1 + " no esta declarada", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
        return;
      }

      break;

    case "DECLARACION":
      //ejecutar declaracion
      declaracion(h1, entorno, errores);
      id1 = h1.getListaNodos()[0].getNombre();
      sim = entorno.getSimbolo(id1);

      if (sim === false) {
        console.error("Error Semantico");
        var err = new Error("Semantico", "La variable: " + id1 + " no esta declarada", nodo.getFila(), nodo.getColumna(), entorno.nombre);
        errores.push(err);
        return;
      }

      break;
  }

  console.log(sim); //get id hijo 2 en tabla de simbolos

  var sim2 = entorno.getSimbolo(id2);
  console.log(sim2);
  console.log(sim2.getTipo());

  if (sim2.getTipo().includes("ARRAY")) {
    var arr = sim2.getValor();
    console.log(arr); //ejecutar sentencias hasta que se acaben los elementos del arreglo

    var _iteratorNormalCompletion = true;
    var _didIteratorError = false;
    var _iteratorError = undefined;

    try {
      for (var _iterator = arr[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
        var i = _step.value;
        sim.valor = i;
        sim.tipo = sim2.tipo;
        entorno.updateSimbolo(sim);
        var r = ejecutar(h3, entorno, errores);
        if (r == "BREAK") break;
        if (r == "CONTINUE") continue;
        if (r == "RETURN") return;
        if (r != null) return r;
      }
    } catch (err) {
      _didIteratorError = true;
      _iteratorError = err;
    } finally {
      try {
        if (!_iteratorNormalCompletion && _iterator["return"] != null) {
          _iterator["return"]();
        }
      } finally {
        if (_didIteratorError) {
          throw _iteratorError;
        }
      }
    }

    return;
  }

  console.error("Error Semantico");
  var err = new Error("Semantico", "la variable: " + id2 + " no es un arreglo", nodo.getFila(), nodo.getColumna(), entorno.nombre);
  errores.push(err);
  return;
};