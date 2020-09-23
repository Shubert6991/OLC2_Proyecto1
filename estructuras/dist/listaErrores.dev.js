"use strict";

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var ListaErrores =
/*#__PURE__*/
function () {
  function ListaErrores() {
    _classCallCheck(this, ListaErrores);

    this.lista = new Array();
  }

  _createClass(ListaErrores, [{
    key: "addError",
    value: function addError(error) {
      this.lista.push(error);
    }
  }, {
    key: "getLista",
    value: function getLista() {
      return this.lista;
    }
  }, {
    key: "limpiar",
    value: function limpiar() {
      this.lista = new Array();
    }
  }]);

  return ListaErrores;
}();