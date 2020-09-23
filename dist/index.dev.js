"use strict";

console.log("index.js");

var analizarTexto = function analizarTexto() {
  //analizar y ejecutar
  var texto = document.getElementById("textInput").value;

  try {
    var result = analizador.parse(texto);
    console.log(result); //imprimir traduccion

    console.log(result.traduccion);
    escribirTraduccion(result.traduccion); //ejecutar ast,pasar lista errores
  } catch (error) {
    console.log(error);
  }
}; //funcion para escribir traduccion


var escribirTraduccion = function escribirTraduccion(texto) {
  var area = document.getElementById("area_result");
  area.value = texto;
}; //funcion para boton reportes


document.getElementById("analizarBtn").addEventListener("click", analizarTexto);