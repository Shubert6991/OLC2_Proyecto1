class Simbolo{
  constructor(nombre,tipo,ambito,fila,columna){
    this.nombre = nombre;
    this.tipo = tipo;
    this.ambito = ambito;
    this.fila = fila;
    this.columna = columna;
  }
  getNombre(){
    return this.nombre;
  }
  getTipo(){
    return this.tipo;
  }
  getAmbito(){
    return this.ambito;
  }
  getFila(){
    return this.fila;
  }
  getColumna(){
    return this.columna;
  }
}