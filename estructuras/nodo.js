class Nodo {
    constructor(tipo,nombre,fila,col){
        this.tipo = tipo;
        this.nombre = nombre;
        this.listaNodos = new Array();
        this.fila = fila;
        this.col = col;
    }
    getTipo() {
        return this.tipo;
    }
    getNombre(){
        return this.nombre;
    }
    getListaNodos(){
        return this.listaNodos;
    }
    getFila(){
        return this.fila;
    }
    getColumna(){
        return this.col;
    }
    hijosCount(){
        return this.listaNodos.length;
    }
    addHijo(nodo){
        this.listaNodos.push(nodo)
    }
}
