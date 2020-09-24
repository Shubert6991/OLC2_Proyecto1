"use strict";

console.log("index.js");

var analizarTexto = function analizarTexto() {
  //analizar y ejecutar
  var texto = document.getElementById("textInput").value;

  try {
    var result = analizador.parse(texto);
    console.log(result); //imprimir traduccion

    escribirTraduccion(result.traduccion); //reporte lista de errores
    //reporte ast
    //ejecutar ast,pasar lista errores
  } catch (error) {
    console.log(error);
  }
}; //funcion para escribir traduccion


var escribirTraduccion = function escribirTraduccion(texto) {
  var area = document.getElementById("area_result");
  area.value = texto;
}; //funcion para crear reporte de errores
//funcion para boton reportes


var descargarReportes = function descargarReportes() {
  console.log("descargando reportes...");
};

document.getElementById("reportesBtn").addEventListener("click", descargarReportes);
document.getElementById("analizarBtn").addEventListener("click", analizarTexto);