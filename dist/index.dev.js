"use strict";

console.log("index.js");

var analizarTexto = function analizarTexto() {
  //analizar y ejecutar
  var texto = document.getElementById("textInput").value;

  try {
    var result = analizador.parse(texto);
    console.log(result); //imprimir traduccion

    escribirTraduccion(result.traduccion); //reporte lista de errores

    reportErrores(result.listaErrores); //reporte ast
    //ejecutar ast,pasar lista errores
  } catch (error) {
    console.log(error);
  }
}; //funcion para escribir traduccion


var escribirTraduccion = function escribirTraduccion(texto) {
  var area = document.getElementById("area_result");
  area.value = texto;
}; //funcion para crear reporte de errores


var reportErrores = function reportErrores(lista) {
  // lista.forEach(element => {
  //   console.log(element)
  // });
  var viz = new Viz();
  viz.renderSVGElement('digraph { a -> b }').then(function (element) {
    console.log("diagrama");
    document.getElementById("pruebas").appendChild(element); // document.body.appendChild(element);
  })["catch"](function (error) {
    // Create a new Viz instance (@see Caveats page for more info)
    viz = new Viz(); // Possibly display the error

    console.error(error);
  });
}; //funcion para boton reportes


var descargarReportes = function descargarReportes() {
  console.log("descargando reportes...");
};

document.getElementById("reportesBtn").addEventListener("click", descargarReportes);
document.getElementById("analizarBtn").addEventListener("click", analizarTexto);