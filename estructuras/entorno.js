class Entorno {
  constructor(nombre,anterior){
    this.nombre = nombre;
    this.anterior = anterior;
    this.tablaSimbolos = new TablaSimbolos();
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