class Traduccion {
    constructor(ast,traduccion,listaErrores){
        this.ast = ast;
        this.traduccion = traduccion;
        this.listaErrores = listaErrores;
    }
    getAST(){
        return this.ast;
    }
    getTraduccion(){
        return this.traduccion;
    }
    getListaErrores(){
        return this.listaErrores;
    }
}