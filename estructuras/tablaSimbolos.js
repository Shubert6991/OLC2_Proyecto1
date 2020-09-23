class TablaSimbolos {
  constructor(){
    this.tabla = new Array();
  }
  addSimbolo(simbolo){
    this.tabla.push(simbolo);
  }
  getTabla(){
    return this.tabla;
  }
}