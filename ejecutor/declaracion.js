//fucion para ejecutar declaracion
const declaracion = (nodo,entorno,errores) => {
  //verificar tipo de declaracion
  var tipo = 1;
  if(nodo.getNombre() === "CONST"){
    tipo = 0;
  }
  var count = nodo.hijosCount();
  var hijos = nodo.getListaNodos();
  switch (count){
    case 3:
      //primer hijo id
      var id = getID(hijos[0]);
      //segundo hijo tipo
      var type = getType(hijos[1],entorno,errores);
      if(type === false){
        break;
      }
      if(type === "VOID"){
        console.error("Error Semantico");
        var err = new Error("Semantico","La variable "+id+" no puede ser de tipo void",nodo.getFila(),nodo.getColumna());
        errores.push(err);
        break;
      }
      //tercer hijo valor
      var valor = getValor(hijos[2],entorno,errores);

      var nuevo = new Simbolo(tipo,id,type,valor,entorno.nombre,nodo.getFila(),nodo.getColumna());
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

//getID
const getID = (nodo) => {
  if(nodo.getTipo() === "ID"){
    return nodo.getNombre();
  }
}

//get type
const getType = (nodo,entorno,errores) => {
  if(nodo.getTipo() === "TIPO"){
    if(nodo.getNombre() === "ID"){
      var id = getID(nodo.getListaNodos()[0]);
      return "ID_"+id;
    }
    if(nodo.getNombre() === "ARRAY_ID"){
      //array de types
      var id = getID(nodo.getListaNodos()[0]);
      //buscar en la tabla de simbolos si el id es tipo type
      var tid = entorno.getSimbolo(id);
      //sino error sintactico
      console.log(tid);
      if(tid === false){
        var err = new Error("Semantico","No se puede asignar ->"+id+" como tipo porque no es un type",nodo.getFila(),nodo.getColumna());
        errores.push(err);
        return false;
      } else {
        //get tipo id
        if(tid.getTipo() !== "TYPE"){
          var err = new Error("Semantico","No se puede asignar ->"+id+" como tipo porque no es un type",nodo.getFila(),nodo.getColumna());
          errores.push(err);
          return false;
        }
      }
      return "ARRAY_"+id;
    }
    if (nodo.getNombre() === "ARRAY_TIPO"){
      var tipo = getType(nodo.getListaNodos()[0]);
      return "ARRAY_"+tipo;
    }
    return nodo.getNombre();
  }
}

//get valor
const getValor = (nodo,entorno,errores) =>{
  if(nodo.getTipo() === "VALOR"){
    //Valores
  }
  if(nodo.getTipo() === "A"){
    return 120;
  }
  if(nodo.getTipo() === "INCREMENTO"){
    var id = getID(nodo.getListaNodos()[0]);
    // console.log(id)
    //buscar en tabla de simbolos
    var tid = entorno.getSimbolo(id);
    // console.log(tid)
    if(tid === false){
      //error semantico
      var err = new Error("Semantico","No se puede incrementar ->"+id+" no esta declarado",nodo.getFila(),nodo.getColumna());
      errores.push(err);
      return 0;
    } else {
      if (tid.getTipo() !== "NUMBER") {
        var err = new Error("Semantico","No se puede incrementar ->"+id+" no es tipo numero",nodo.getFila(),nodo.getColumna());
        errores.push(err);
        return 0;
      }
    }
    // sumarle 1
    // regresar nuevo valor
    return tid.getValor()+1;
  }
  if(nodo.getTipo() === "DECREMENTO"){
    var id = getID(nodo.getListaNodos()[0]);
    //buscar en tabla de simbolos
    var tid = entorno.getSimbolo(id);
    if(tid === false){
      //error semantico
      var err = new Error("Semantico","No se puede decrementar ->"+id+" no esta declarado",nodo.getFila(),nodo.getColumna());
      errores.push(err);
      return 0;
    } else {
      if (tid.getTipo() !== "NUMBER") {
        var err = new Error("Semantico","No se puede decrementar ->"+id+" no es tipo numero",nodo.getFila(),nodo.getColumna());
        errores.push(err);
        return 0;
      }
    }
    //sumarle 1
    //regresar nuevo valor
    return tid.getValor()-1;
  }
}