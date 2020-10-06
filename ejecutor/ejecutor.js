//funcion para ejecutar codigo
const ejecutar = (ast,entorno,errores) => {
  if(ast != null){
    let tipo = ast.getTipo();
    console.log(tipo);
    switch (tipo) {
      case "S":
        return ejecutar(ast.getListaNodos()[0],entorno,errores);
      case "I":
        var e1 = ejecutar(ast.getListaNodos()[0],entorno,errores);
        var e2 = ejecutar(ast.getListaNodos()[1],entorno,errores);
        if(e1) return e1
        else return e2;
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
          var err = new Error("Semantico","No se puede incrementar ->"+id+" no esta declarado",ast.getFila(),ast.getColumna());
          errores.push(err);
          break;
        } else {
          if(tid.getTipo() == null){
            tid.tipo = "NUMBER";
          }
          if (tid.getTipo() !== "NUMBER") {
            var err = new Error("Semantico","No se puede incrementar ->"+id+" no es tipo numero",ast.getFila(),ast.getColumna());
            errores.push(err);
            break;
          }
        }
        // sumarle 1
        // regresar nuevo valor
        var nval = +tid.getValor() + 1;

        tid.valor = nval;
        entorno.updateSimbolo(tid);
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
          break;
        } else {
          if(tid.getTipo() == null){
            tid.tipo = "NUMBER";
          }
          if (tid.getTipo() !== "NUMBER") {
            var err = new Error("Semantico","No se puede incrementar ->"+id+" no es tipo numero",nodo.getFila(),nodo.getColumna());
            errores.push(err);
            break;
          }
        }
        // sumarle 1
        // regresar nuevo valor
        var nval = +tid.getValor() - 1;

        tid.valor = nval;
        entorno.updateSimbolo(tid);
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
        var e1 = ejecutar(ast.getListaNodos()[0],entorno,errores);
        var e2 = ejecutar(ast.getListaNodos()[1],entorno,errores);
        if(e1) return e1;
        else return e2;
      case "SWITCH":
        ejecutarSwitch(ast,new Entorno("SWITCH",entorno),errores);
        break;
      case "BREAK":
        if(entorno.nombre === "SWITCH"){
          return "BREAK";
        } 
        if(entorno.nombre === "WHILE"){
          return "BREAK";
        }
        if(entorno.nombre === "DOWHILE"){
          return "BREAK";
        }
        if(entorno.nombre === "FOR"){
          return "BREAK";
        }
        if(entorno.nombre === "FOROF"){
          return "BREAK";
        }
        if(entorno.nombre === "FORIN"){
          return "BREAK";
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
      case "FOR":
        ejecutarFor(ast,new Entorno("FOR",entorno),errores);
        break;
      case "FOROF":
        ejecutarForOf(ast,new Entorno("FOROF",entorno),errores);
        break;
      case "FORIN":
        ejecutarForIn(ast,new Entorno("FORIN",entorno),errores);
        break;
      case "FUNCION":
        declararFuncion(ast,entorno,errores);
        break;
      case "VALFUNCION":
        getValor(ast,entorno,errores);
        break;
      default:
        console.error("todavia no he programado eso -> "+tipo);
        break;
    }
  }
  return null;
}