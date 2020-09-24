"use strict";

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var Entorno =
/*#__PURE__*/
function () {
  function Entorno(nombre, anterior) {
    _classCallCheck(this, Entorno);

    this.nombre = nombre;
    this.anterior = anterior;
    this.tablaSimbolos = new TablaSimbolos();
  }

  _createClass(Entorno, [{
    key: "addSimbolo",
    value: function addSimbolo(simbolo) {
      //ver si ya esta en la tabla de simbolor
      var tmp = this.tablaSimbolos.getTabla();

      for (var index = 0; index < tmp.length; index++) {
        if (tmp[index].getNombre() === simbolo.getNombre()) {
          console.error("la variable -> " + simbolo.getNombre() + " ya existe;"); //error semantico

          return false;
        }
      }

      this.tablaSimbolos.addSimbolo(simbolo);
      return true;
    }
  }, {
    key: "getSimbolo",
    value: function getSimbolo(nombre) {
      var ent = this;

      while (ent != null) {
        var tmp = ent.tablaSimbolos.getTabla();

        for (var index = 0; index < tmp.length; index++) {
          if (tmp[index].getNombre() === nombre) {
            return element;
          }
        }

        ent = ent.anterior;
      }

      return false;
    }
  }, {
    key: "updateSimbolo",
    value: function updateSimbolo(simbol) {
      var ent = this;

      while (ent != null) {
        var tmp = ent.tablaSimbolos.getTabla();

        for (var index = 0; index < tmp.length; index++) {
          if (tmp[index].getNombre() === simbol.getNombre()) {
            tmp[index] = simbol;
            return true;
          }
        }

        ent = ent.anterior;
      }

      return false;
    }
  }, {
    key: "printTablaSimbolos",
    value: function printTablaSimbolos() {
      var ent = this;

      while (ent != null) {
        var tmp = ent.tablaSimbolos.getTabla();
        tmp.forEach(function (element) {
          console.log(element);
        });
        ent = ent.anterior;
      }
    }
  }, {
    key: "getTablaSimbolos",
    value: function getTablaSimbolos() {
      var ent = this;
      var simb = new Array();

      while (ent != null) {
        var tmp = ent.tablaSimbolos.getTabla();
        tmp.forEach(function (element) {
          simb.push(element);
        });
        ent = ent.anterior;
      }

      return simb;
    }
  }]);

  return Entorno;
}();