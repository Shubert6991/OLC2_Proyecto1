export class Nodo{
    private tipo:string;
    private nombre:string;
    private listaNodos: Array<Nodo>

    constructor(tipo:string,nombre:string){
        this.tipo = tipo;
        this.nombre = nombre;
        this.listaNodos = new Array();
    }

    public getTipo():string{
        return this.tipo;
    }

    public getNombre():string{
        return this.nombre;
    }

    public getListaNodos():Array<Nodo>{
        return this.listaNodos;
    }

    public hijosCount():number {
        return this.listaNodos.length;
    }

    public addHijo(nodo: Nodo){
        this.listaNodos.push(nodo);
    }

    public graficar(){
        console.log(this.tipo);
    }
}