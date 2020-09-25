class Simbolo{
  constructor(tdec,nombre,tipo,valor,ambito,fila,columna){
    this.tdec = tdec;
    this.nombre = nombre;
    this.tipo = tipo;
    this.valor = valor;
    this.ambito = ambito;
    this.fila = fila;
    this.columna = columna;
  }
  getTipoDec(){
    return this.tdec;
  }
  getNombre(){
    return this.nombre;
  }
  getTipo(){
    return this.tipo;
  }
  getValor(){
    return this.valor;
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