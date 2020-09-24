class Nodo {
    constructor(tipo,nombre){
        this.tipo = tipo;
        this.nombre = nombre;
        this.listaNodos = new Array();
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
    hijosCount(){
        return this.listaNodos.length;
    }
    addHijo(nodo){
        this.listaNodos.push(nodo)
    }
}
