const print = (nodo,entorno,errores) => {
  var consola = document.getElementById("consola");
  var valor = getValor(nodo.getListaNodos()[0],entorno,errores);
  consola.value += valor+"\n";
}

const graphts = (entorno) => {
  entorno.printTablaSimbolos();
  reportSimbolos(entorno.getTablaSimbolos());
}