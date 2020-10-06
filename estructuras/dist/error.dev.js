"use strict";

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var Error =
/*#__PURE__*/
function () {
  function Error(tipo, descripcion, linea, columna, ambito) {
    _classCallCheck(this, Error);

    this.tipo = tipo;
    this.descripcion = descripcion;
    this.linea = linea;
    this.columna = columna;
    if (ambito == null) this.ambito = "ANALISIS";else this.ambito = ambito;
  }

  _createClass(Error, [{
    key: "getTipo",
    value: function getTipo() {
      return this.tipo;
    }
  }, {
    key: "getDescripcion",
    value: function getDescripcion() {
      return this.descripcion;
    }
  }, {
    key: "getLinea",
    value: function getLinea() {
      return this.linea;
    }
  }, {
    key: "getColumna",
    value: function getColumna() {
      return this.columna;
    }
  }, {
    key: "getAmbito",
    value: function getAmbito() {
      return this.ambito;
    }
  }]);

  return Error;
}();