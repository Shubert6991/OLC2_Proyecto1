//funcion para ejecutar codigo
const ejecutar = (ast,entorno,errores) => {
  if(ast != null){
    let tipo = ast.getTipo();
    console.log(tipo);
    switch (tipo) {
      case "S":
        return ejecutar(ast.getListaNodos()[0],entorno,errores);
      case "I":
        return Math.max(ejecutar(ast.getListaNodos()[0],entorno,errores),ejecutar(ast.getListaNodos()[1],entorno,errores));
      case "DECLARACION":
        //ejecutar declaracion;
        declaracion(ast,entorno,errores);
        break;
      case "INCREMENTO":
        var id = getID(ast.getListaNodos()[0]);
        // console.log(id)
        //buscar en tabla de simbolos
        var tid = entorno.getSimbolo(id);
        // console.log(tid)
        if(tid === false){
          //error semantico
          var err = new Error("Semantico","No se puede incrementar ->"+id+" no esta declarado",nodo.getFila(),nodo.getColumna());
          errores.push(err);
        } else {
          if (tid.getTipo() !== "NUMBER") {
            var err = new Error("Semantico","No se puede incrementar ->"+id+" no es tipo numero",nodo.getFila(),nodo.getColumna());
            errores.push(err);
          }
        }
        // sumarle 1
        // regresar nuevo valor
        var result = entorno.getSimbolo(id);
        var nval = +result.getValor() + 1;

        result.valor = nval;
        entorno.updateSimbolo(result);
        break;
      case "DECREMENTO":
        var id = getID(ast.getListaNodos()[0]);
        // console.log(id)
        //buscar en tabla de simbolos
        var tid = entorno.getSimbolo(id);
        // console.log(tid)
        if(tid === false){
          //error semantico
          var err = new Error("Semantico","No se puede incrementar ->"+id+" no esta declarado",nodo.getFila(),nodo.getColumna());
          errores.push(err);
        } else {
          if (tid.getTipo() !== "NUMBER") {
            var err = new Error("Semantico","No se puede incrementar ->"+id+" no es tipo numero",nodo.getFila(),nodo.getColumna());
            errores.push(err);
          }
        }
        // sumarle 1
        // regresar nuevo valor
        var result = entorno.getSimbolo(id);
        var nval = +result.getValor() - 1;

        result.valor = nval;
        entorno.updateSimbolo(result);
        break;
      case "ASIGNACION":
        asignacion(ast,entorno,errores);
        break;
      case "CONSOLE":
        print(ast,entorno,errores);
        break;
      case "GRAFICAR":
        graphts(entorno);
        break;
      case "PUSH":
        arrPush(ast,entorno,errores);
        break;
      case "POP":
        arrPop(ast,entorno,errores);
        break;
      case "IF":
        var ent = new Entorno("IF",entorno);
        ejecutarIF(ast,ent,errores);
        break;
      case "ELSE":
        ejecutarElse(ast,entorno,errores);
        break;
      case "SENTENCIAS":
        return Math.max(ejecutar(ast.getListaNodos()[0],entorno,errores),ejecutar(ast.getListaNodos()[1],entorno,errores));
      case "SWITCH":
        ejecutarSwitch(ast,new Entorno("SWITCH",entorno),errores);
        break;
      case "BREAK":
        if(entorno.nombre === "SWITCH"){
          return 1;
        }
        console.error("Error Semantico");
        var err = new Error("Semantico","La sentencia break solo se puede utilzar en switch",ast.getFila(),ast.getColumna());
        errores.push(err);
        break;
      case "WHILE":
        ejecutarWhile(ast,new Entorno("WHILE",entorno),errores);
        break;
      case "DOWHILE":
        ejecutarDoWhile(ast,new Entorno("DOWHILE",entorno),errores);
        break;
      default:
        console.error("todavia no he programado eso -> "+tipo);
        break;
    }
  }
  return 0;
}