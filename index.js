console.log("index.js");
var editor = document.getElementById("textInput")
var mirrorEditor = CodeMirror.fromTextArea(editor, {
  lineNumbers: true,
  matchBrackets: true,
  styleActiveLine: true,
  theme: "dracula",
  mode: "text/javascript",
  smartIndent: true,
  lineWrapping: false
});
mirrorEditor.setSize("100%","500");
var res = document.getElementById("area_result")
var resEditor = CodeMirror.fromTextArea(res, {
  lineNumbers: true,
  matchBrackets: true,
  styleActiveLine: true,
  theme: "dracula",
  mode: "text/javascript",
  smartIndent: true,
  lineWrapping: false,
  readOnly: true
});
resEditor.setSize("100%","500");
var cons = document.getElementById("consola")
var consMirror = CodeMirror.fromTextArea(cons, {
  lineNumbers: true,
  matchBrackets: true,
  styleActiveLine: true,
  theme: "dracula",
  mode: "text",
  smartIndent: true,
  lineWrapping: false,
  readOnly: true
});
consMirror.setSize("100%","300");



const analizarTexto = () => {
  //analizar y ejecutar
  editor.value = mirrorEditor.getValue();
  let texto = document.getElementById("textInput").value
  try {
    let result = analizador.parse(texto);
    // console.log("test");
    //imprimir traduccion
    escribirTraduccion(result.traduccion);
    //reporte ast
    reporteAST(result.ast);
    //ejecutar ast,pasar lista errores
    ejecutar(result.ast,new Entorno("GLOBAL",null),result.listaErrores);
    //reporte lista de errores
    reportErrores(result.listaErrores);
  } catch (error) {
    console.log(error);
  }
}

//funcion para escribir traduccion
const escribirTraduccion = (texto) => {
  let area = document.getElementById("area_result");
  resEditor.setValue(texto);
  area.value = texto;
}

//funcion para boton reportes
const descargarReportes = () => {
  var x = document.getElementById("rowReportes");
  if (x.style.display === "none") {
    x.style.display = "block";
  }
  window.location.href = "#rowReportes";
}

//funcion para regresar reportes
const regresarReportes = () => {
  var x = document.getElementById("rowReportes");
  if (x.style.display != "none") {
    x.style.display = "none";
    document.getElementById("reportes").innerHTML = '';
  }
  window.location.href = "#home";
}

document.getElementById("reportesBtn").addEventListener("click",descargarReportes);
document.getElementById("analizarBtn").addEventListener("click",analizarTexto);
document.getElementById("regresarBtn").addEventListener("click",regresarReportes);