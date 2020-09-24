"use strict";

console.log("index.js");

var analizarTexto = function analizarTexto() {
  //analizar y ejecutar
  var texto = document.getElementById("textInput").value;

  try {
    var result = analizador.parse(texto); // console.log(result);
    //imprimir traduccion

    escribirTraduccion(result.traduccion); //reporte lista de errores

    reportErrores(result.listaErrores); //reporte ast

    reporteAST(result.ast); //ejecutar ast,pasar lista errores
  } catch (error) {
    console.log(error);
  }
}; //funcion para escribir traduccion


var escribirTraduccion = function escribirTraduccion(texto) {
  var area = document.getElementById("area_result");
  area.value = texto;
}; //funcion para crear reporte de errores


var reportErrores = function reportErrores(lista) {
  var div = document.createElement("div");
  var h3 = document.createElement("h3");
  h3.innerHTML = "Tabla De Errores";
  var tablaErr = document.createElement("table");
  tablaErr.className = "table table-hover";
  var head = tablaErr.createTHead();
  head.className = "thead-dark";
  var row = head.insertRow();
  var cel = row.insertCell();
  cel.outerHTML = "<th>Tipo</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Descripcion</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Linea</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Columna</th>"; //tbody

  var body = tablaErr.createTBody();
  lista.forEach(function (element) {
    console.log(element);
    var row = body.insertRow();
    var cel = row.insertCell();
    cel.innerHTML = element.getTipo();
    cel = row.insertCell();
    cel.innerHTML = element.getDescripcion();
    cel = row.insertCell();
    cel.innerHTML = element.getLinea();
    cel = row.insertCell();
    cel.innerHTML = element.getColumna();
  });
  div.appendChild(h3);
  div.appendChild(tablaErr);
  document.getElementById("reportes").appendChild(div);
}; //funcion para crear reporte ast


var reporteAST = function reporteAST(ast) {
  console.log(ast);
  var div = document.createElement("div");
  var h3 = document.createElement("h3");
  h3.innerHTML = "Arbol de Analisis Sintactico(AST)";
  var result = recorrer(ast);
  var cadena = "digraph { "; //sacar nodos
  //cadena += "1[label=\"test\", fillcolor=\"lightskyblue\", style=\"filled\",shape=\"oval\"];"

  cadena += result.nodos; //sacar conexiones
  // cadena += "1 -> 2;";

  cadena += result.conexiones;
  cadena += "}";
  var viz = new Viz();
  console.log(cadena);
  viz.renderSVGElement(cadena).then(function (element) {
    div.appendChild(h3);
    div.appendChild(element);
    document.getElementById("reportes").appendChild(div); // document.body.appendChild(element);
  })["catch"](function (error) {
    // Create a new Viz instance (@see Caveats page for more info)
    viz = new Viz(); // Possibly display the error

    console.error(error);
  });
}; //funcion para obtener Nodos


var recorrer = function recorrer(ast) {
  var nodos = "";
  var conexiones = "";
  var res = recursivo(ast, nodos, conexiones, 0);
  nodos = res.nodos;
  conexiones = res.conexiones;
  return {
    nodos: nodos,
    conexiones: conexiones
  };
};

var recursivo = function recursivo(ast, nodos, conexiones, cont) {
  if (ast.getTipo() !== "") {
    if (ast.getTipo() !== ast.getNombre()) {
      nodos = nodos + cont + "[label=\"" + ast.getTipo() + "(" + ast.getNombre() + ")" + "\"];\n";
    } else {
      nodos = nodos + cont + "[label=\"" + ast.getTipo() + "\"];\n";
    }

    var aux = cont;

    if (ast.hijosCount() > 0) {
      ast.getListaNodos().forEach(function (element) {
        cont++;
        conexiones = conexiones + aux + " -> " + cont + ";\n";
        var res = recursivo(element, nodos, conexiones, cont);
        nodos = res.nodos;
        conexiones = res.conexiones;
        cont = res.cont;
      });
    }
  } else {
    cont--;
  }

  return {
    nodos: nodos,
    conexiones: conexiones,
    cont: cont
  };
}; //funcion para boton reportes


var descargarReportes = function descargarReportes() {
  var x = document.getElementById("rowReportes");

  if (x.style.display === "none") {
    x.style.display = "block";
  }

  window.location.href = "#rowReportes";
}; //funcion para regresar reportes


var regresarReportes = function regresarReportes() {
  var x = document.getElementById("rowReportes");

  if (x.style.display != "none") {
    x.style.display = "none";
    document.getElementById("reportes").innerHTML = '';
  }

  window.location.href = "#home";
};

document.getElementById("reportesBtn").addEventListener("click", descargarReportes);
document.getElementById("analizarBtn").addEventListener("click", analizarTexto);
document.getElementById("regresarBtn").addEventListener("click", regresarReportes);