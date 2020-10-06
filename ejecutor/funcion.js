const declararFuncion = (nodo,entorno,errores) => {
  //ID,TIPO,SENTENCIAS
  if(nodo.hijosCount() === 3){
    var id = getID(nodo.getListaNodos()[0]);
    var type = getType(nodo.getListaNodos()[1],entorno,errores);
    // ejecutar(nodo.getListaNodos()[2],entorno,errores);
    var nuevo = new Funcion(id,type,null,nodo.getListaNodos()[2]);
    //console.log(nuevo);
    var result = entorno.addFuncion(nuevo);
    entorno.printListaFunciones();
    // console.log(result)
    if(!result) {
      console.error("Error Semantico");
      var err = new Error("Semantico","La funcion "+id+" ya se habia declarado",nodo.getFila(),nodo.getColumna(),entorno.nombre);
      errores.push(err);
    }
  }
  if(nodo.hijosCount() === 4){
  //ID,PARAMETROS,TIPO,SENTENCIAS
    var id = getID(nodo.getListaNodos()[0]);
    var type = getType(nodo.getListaNodos()[2],entorno,errores);
    // ejecutar(nodo.getListaNodos()[2],entorno,errores);
    var nuevo = new Funcion(id,type,nodo.getListaNodos()[1],nodo.getListaNodos()[3]);
    //console.log(nuevo);
    var result = entorno.addFuncion(nuevo);
    entorno.printListaFunciones();
    // console.log(result)
    if(!result) {
      console.error("Error Semantico");
      var err = new Error("Semantico","La funcion "+id+" ya se habia declarado",nodo.getFila(),nodo.getColumna(),entorno.nombre);
      errores.push(err);
    }
  }
}