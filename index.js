console.log("index.js");
const analizarTexto = () => {
  //analizar y ejecutar
  let texto = document.getElementById("textInput").value
  try {
    let result = analizador.parse(texto);
    // console.log(result);
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