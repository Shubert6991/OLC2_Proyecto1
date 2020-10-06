"use strict";

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var Funcion = function Funcion(id, tipo, parametros, sentencias) {
  _classCallCheck(this, Funcion);

  this.id = id;
  this.tipo = tipo;
  this.parametros = parametros;
  this.sentencias = sentencias;
};

var listaFunciones =
/*#__PURE__*/
function () {
  function listaFunciones() {
    _classCallCheck(this, listaFunciones);

    this.tabla = new Array();
  }

  _createClass(listaFunciones, [{
    key: "addFuncion",
    value: function addFuncion(funcion) {
      this.tabla.push(funcion);
    }
  }, {
    key: "getLista",
    value: function getLista() {
      return this.tabla;
    }
  }]);

  return listaFunciones;
}();