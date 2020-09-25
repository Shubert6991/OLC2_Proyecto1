"use strict";

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var Simbolo =
/*#__PURE__*/
function () {
  function Simbolo(tdec, nombre, tipo, valor, ambito, fila, columna) {
    _classCallCheck(this, Simbolo);

    this.tdec = tdec;
    this.nombre = nombre;
    this.tipo = tipo;
    this.valor = valor;
    this.ambito = ambito;
    this.fila = fila;
    this.columna = columna;
  }

  _createClass(Simbolo, [{
    key: "getTipoDec",
    value: function getTipoDec() {
      return this.tdec;
    }
  }, {
    key: "getNombre",
    value: function getNombre() {
      return this.nombre;
    }
  }, {
    key: "getTipo",
    value: function getTipo() {
      return this.tipo;
    }
  }, {
    key: "getValor",
    value: function getValor() {
      return this.valor;
    }
  }, {
    key: "getAmbito",
    value: function getAmbito() {
      return this.ambito;
    }
  }, {
    key: "getFila",
    value: function getFila() {
      return this.fila;
    }
  }, {
    key: "getColumna",
    value: function getColumna() {
      return this.columna;
    }
  }]);

  return Simbolo;
}();