"use strict";
exports.__esModule = true;
var Traduccion = /** @class */ (function () {
    function Traduccion(ast, traduccion) {
        this.ast = ast;
        this.traduccion = traduccion;
    }
    Traduccion.prototype.getAST = function () {
        return this.ast;
    };
    Traduccion.prototype.graficarAST = function () {
        console.log("Graficando AST");
    };
    Traduccion.prototype.getTraduccion = function () {
        return this.traduccion;
    };
    return Traduccion;
}());
