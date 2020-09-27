const asignacion = (nodo,entorno,errores) => {
  var id = getID(nodo.getListaNodos()[0]);
  if(id){
    //acualizar
    var sim = entorno.getSimbolo(id);
    var valor = getValor(nodo.getListaNodos()[1],entorno,errores);
    //verificar si no es constante
    if(sim.getTipoDec() === 0){
      console.error("Error Semantico");
      var err = new Error("Semantico","No se puede cambiar la constante -> "+id,nodo.getFila(),nodo.getColumna());
      errores.push(err);
      return;
    }
    //verificar el tipo
    var tval = typeof(valor);
    switch (sim.getTipo()) {
      case "":
        var tip = "";
        if(tval == "string"){
          tip = "STRING";
        }
        if(tval == "number"){
          tip = "NUMBER";
        } 
        if(tval == "boolean"){
          tip = "BOOLEAN";
        } 
        sim.tipo = tip;
        sim.valor = valor;
        break;
      case "STRING":
        if(tval != "string"){
          //errror
          console.error("Error Semantico");
          var err = new Error("Semantico","La variable "+id+" es de tipo string no se puede asignar el nuevo valor",nodo.getFila(),nodo.getColumna());
          errores.push(err);
          return;
        }
        sim.valor = valor;
        break;
      case "BOOLEAN":
        if(tval != "boolean"){
          //errror
          console.error("Error Semantico");
          var err = new Error("Semantico","La variable "+id+" es de tipo boolean no se puede asignar el nuevo valor",nodo.getFila(),nodo.getColumna());
          errores.push(err);
          return;
        }
        sim.valor = valor;
        break;
      case "NUMBER":
        if(tval != "number"){
          //errror
          console.error("Error Semantico");
          var err = new Error("Semantico","La variable "+id+" es de tipo boolean no se puede asignar el nuevo valor",nodo.getFila(),nodo.getColumna());
          errores.push(err);
          return;
        }
        sim.valor = valor;
      break;
    }
    //actualizar simbolo
    entorno.updateSimbolo(sim);
  }
}