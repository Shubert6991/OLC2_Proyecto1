"use strict";

console.log("index.js");

var analizarTexto = function analizarTexto() {
  //analizar y ejecutar
  var texto = document.getElementById("textInput").value;

  try {
    var result = analizador.parse(texto); // console.log(result);
    //imprimir traduccion

    escribirTraduccion(result.traduccion); //reporte ast

    reporteAST(result.ast); //ejecutar ast,pasar lista errores

    ejecutar(result.ast, new Entorno("GLOBAL", null), result.listaErrores); //reporte lista de errores

    reportErrores(result.listaErrores);
  } catch (error) {
    console.log(error);
  }
}; //funcion para escribir traduccion


var escribirTraduccion = function escribirTraduccion(texto) {
  var area = document.getElementById("area_result");
  area.value = texto;
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