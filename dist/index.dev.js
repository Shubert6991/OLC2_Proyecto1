"use strict";

console.log("index.js");

var analizarTexto = function analizarTexto() {
  var texto = document.getElementById("textInput").value;

  try {
    var result = analizador.parse(texto);
    console.log(analizador.parse(texto));
  } catch (error) {
    console.log(error);
  }
};

document.getElementById("analizarBtn").addEventListener("click", analizarTexto);