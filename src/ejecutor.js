//funcion para ejecutar codigo
const ejecutar = (ast,entorno,errores) => {
  if(ast != null){
    let tipo = ast.getTipo();
    console.log(tipo);
    switch (tipo) {
      case "S":
        ejecutar(ast.getListaNodos()[0],entorno,errores);
        break;
      case "I":
        ejecutar(ast.getListaNodos()[0],entorno,errores);
        ejecutar(ast.getListaNodos()[1],entorno,errores);
        break;
      case "DECLARACION":
        //ejecutar declaracion;
        declaracion(ast,entorno,errores);
        break;
      default:
        console.error("todavia no he programado eso -> "+tipo);
        break;
    }
  }
}

//fucion para ejecutar declaracion
const declaracion = (nodo,entorno,errores) => {
  //verificar tipo de declaracion
  var tipo = 0;
  if(nodo.getNombre() === "LET"){
    tipo = 1;
  }
  switch (nodo.hijosCount()){
    case 3:
      //primer hijo id
      var id = "test";
      //segundo hijo tipo
      var type = "string";
      //tercer hijo valor
      var valor = "prueba";
      var nuevo = new Simbolo(tipo,id,type,entorno.nombre,nodo.getFila(),nodo.getColumna());
      var result = entorno.addSimbolo(nuevo);
      console.log(result)
      if(!result) {
        console.error("Error Semantico");
        var err = new Error("Semantico","La variable "+id+" ya se habia declarado",nodo.getFila(),nodo.getColumna());
        errores.push(err);
        break;
      }
      entorno.printTablaSimbolos();
      reportSimbolos(entorno.getTablaSimbolos());
      break;
    default:
      console.error("todavia no he programado la declaracion con esos hijos -> "+nodo.hijosCount());
      break;
  }
}