class Simbolo{
  constructor(tdec,nombre,tipo,ambito,fila,columna){
    this.tdec = tdec;
    this.nombre = nombre;
    this.tipo = tipo;
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