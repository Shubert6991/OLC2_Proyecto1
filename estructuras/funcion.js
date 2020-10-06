class Funcion{
  constructor(id,tipo,parametros,sentencias){
    this.id = id;
    this.tipo = tipo;
    this.parametros = parametros;
    this.sentencias = sentencias;
  }
}

class listaFunciones {
  constructor(){
    this.tabla = new Array();
  }
  addFuncion(funcion){
    this.tabla.push(funcion);
  }
  getLista(){
    return this.tabla;
  }
}