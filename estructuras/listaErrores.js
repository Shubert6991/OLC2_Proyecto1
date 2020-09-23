class ListaErrores{
  constructor(){
    this.lista = new Array();
  }
  addError(error){
    this.lista.push(error);
  }
  getLista(){
    return this.lista
  }
  limpiar(){
    this.lista = new Array();
  }
}