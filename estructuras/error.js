class Error{
  constructor(tipo,descripcion,linea,columna,ambito) {
    this.tipo = tipo;
    this.descripcion = descripcion;
    this.linea = linea;
    this.columna = columna;
    if(ambito == null) this.ambito = "ANALISIS"
    else this.ambito = ambito;
  }
  getTipo(){
    return this.tipo;
  }
  getDescripcion(){
    return this.descripcion;
  }
  getLinea(){
    return this.linea;
  }
  getColumna(){
    return this.columna;
  }
  getAmbito(){
    return this.ambito;
  }
}