const ejecutarSwitch = (nodo,entorno,errores) => {
  //hijo1 = condicion
  var cond = getValor(nodo.getListaNodos()[0],entorno,errores);
  //hijo2 = bloque switch
  ejecutarBSwitch(cond,nodo.getListaNodos()[1],entorno,errores);
}

const ejecutarBSwitch = (cond,nodo,entorno,errores) => {
  if(nodo.hijosCount() == 2){
    //case default
    // console.log(ejecutarCases(cond,nodo.getListaNodos()[0],entorno,errores))
    if(ejecutarCases(cond,nodo.getListaNodos()[0],entorno,errores) != "BREAK"){
      ejecutarDefault(nodo.getListaNodos()[1],entorno,errores);
    }
  }
  if(nodo.hijosCount() == 1){
    //case
    ejecutarCases(cond,nodo.getListaNodos()[0],entorno,errores);
  }
}

const ejecutarCases = (cond,nodo,entorno,errores) => {
  if(nodo.hijosCount() == 3){
    var ec = ejecutarCases(cond,nodo.getListaNodos()[0],entorno,errores);
    if(ec === 0){
      r = ejecutar(nodo.getListaNodos()[2],entorno,errores)
      if(r === "BREAK") return r
      return 0
    } else {
      if(ec === "BREAK") return "BREAK"
      var val = getValor(nodo.getListaNodos()[1],entorno,errores);
      if(val === cond){
        r = ejecutar(nodo.getListaNodos()[2],entorno,errores)
        if(r === "BREAK") return r
        return 0
      }
      return 2;
    }
  }
  if(nodo.hijosCount() == 2){
    if(nodo.getListaNodos()[0].getTipo() === "CASE"){
      var ec = ejecutarCases(cond,nodo.getListaNodos()[0],entorno,errores);
      if(ec === 0){
        return 0;
      } else{
        if(ec === "BREAK") return "BREAK";
        var val = getValor(nodo.getListaNodos()[1],entorno,errores);
        if(val === cond){
          return 0;
        }
        return 2;
      }
    }else{
      var val = getValor(nodo.getListaNodos()[0],entorno,errores);
      if(val === cond){
        r = ejecutar(nodo.getListaNodos()[1],entorno,errores)
        if(r === "BREAK") return r
        return 0
      } 
      return 2;
    }
  }
  if(nodo.hijosCount() == 1){
    var val = getValor(nodo.getListaNodos()[0],entorno,errores);
    if(val === cond){
      return 0;
    }
    return 2;
  }
  //no encontro el valor
  return 2;
}

const ejecutarDefault = (nodo,entorno,errores,hasBreak) => {
  if(!hasBreak){
    if(nodo.hijosCount() == 1){
      ejecutar(nodo.getListaNodos()[0],entorno,errores);
    }
  }
}