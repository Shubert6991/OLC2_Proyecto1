"use strict";
exports.__esModule = true;
var Nodo = /** @class */ (function () {
    function Nodo(tipo, nombre) {
        this.tipo = tipo;
        this.nombre = nombre;
        this.listaNodos = new Array();
    }
    Nodo.prototype.getTipo = function () {
        return this.tipo;
    };
    Nodo.prototype.getNombre = function () {
        return this.nombre;
    };
    Nodo.prototype.getListaNodos = function () {
        return this.listaNodos;
    };
    Nodo.prototype.hijosCount = function () {
        return this.listaNodos.length;
    };
    Nodo.prototype.addHijo = function (nodo) {
        this.listaNodos.push(nodo);
    };
    return Nodo;
}());
exports["default"] = Nodo;
