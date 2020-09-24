"use strict";

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var Nodo =
/*#__PURE__*/
function () {
  function Nodo(tipo, nombre) {
    _classCallCheck(this, Nodo);

    this.tipo = tipo;
    this.nombre = nombre;
    this.listaNodos = new Array();
  }

  _createClass(Nodo, [{
    key: "getTipo",
    value: function getTipo() {
      return this.tipo;
    }
  }, {
    key: "getNombre",
    value: function getNombre() {
      return this.nombre;
    }
  }, {
    key: "getListaNodos",
    value: function getListaNodos() {
      return this.listaNodos;
    }
  }, {
    key: "hijosCount",
    value: function hijosCount() {
      return this.listaNodos.length;
    }
  }, {
    key: "addHijo",
    value: function addHijo(nodo) {
      this.listaNodos.push(nodo);
    }
  }]);

  return Nodo;
}();