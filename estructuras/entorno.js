class Entorno {
  constructor(nombre,anterior){
    this.nombre = nombre;
    this.anterior = anterior;
    this.tablaSimbolos = new TablaSimbolos();
    this.listaFunciones = new listaFunciones();
  }

  addSimbolo(simbolo) {
    //ver si ya esta en la tabla de simbolor
    var tmp = this.tablaSimbolos.getTabla();
    for (let index = 0; index < tmp.length; index++) {
      if(tmp[index].getNombre() === simbolo.getNombre()){
        console.error("la variable -> "+simbolo.getNombre()+" ya existe;");
        //error semantico
        return false;
      } 
    }
    this.tablaSimbolos.addSimbolo(simbolo);
    return true;
  }  

  addFuncion(funcion) {
    var tmp = this.listaFunciones.getLista();
    for (let index = 0; index < tmp.length; index++) {
      if(tmp[index].id === funcion.id){
        console.error("la funcion -> "+funcion.id+" ya fue declarada;");
        //error semantico
        return false;
      } 
    }
    this.listaFunciones.addFuncion(funcion);
    return true;
  }

  getSimbolo(nombre) {
    var ent = this;
    while(ent != null){
      var tmp = ent.tablaSimbolos.getTabla();
      for (let index = 0; index < tmp.length; index++) {
        if(tmp[index].getNombre() === nombre){
          return tmp[index];
        } 
      }
      ent = ent.anterior;
    }
    return false;
  }

  getFuncion(id) {
    var ent = this;
    while(ent != null){
      var tmp = ent.listaFunciones.getLista();
      for (let index = 0; index < tmp.length; index++) {
        if(tmp[index].id === id){
          return tmp[index];
        } 
      }
      ent = ent.anterior;
    }
    return false;
  }

  updateSimbolo(simbol){
    var ent = this;
    while(ent != null){
      var tmp = ent.tablaSimbolos.getTabla();
      for (let index = 0; index < tmp.length; index++) {
        if(tmp[index].getNombre() === simbol.getNombre()){
          tmp[index] = simbol;
          return true;
        }
      } 
      ent = ent.anterior;
    }
    return false;
  }

  printTablaSimbolos(){
    var ent = this;
    while(ent != null){
      var tmp = ent.tablaSimbolos.getTabla();
      tmp.forEach(element => {
        console.log(element)
      });
      ent = ent.anterior;
    }
  }

  printListaFunciones(){
    var ent = this;
    while(ent != null){
      var tmp = ent.listaFunciones.tabla;
      tmp.forEach(element => {
        console.log(element)
      });
      ent = ent.anterior;
    }
  }

  getTablaSimbolos(){
    var ent = this;
    var simb = new Array();
    while(ent != null){
      var tmp = ent.tablaSimbolos.getTabla();
      tmp.forEach(element => {
        simb.push(element)
      });
      ent = ent.anterior;
    }
    return simb;
  }
}