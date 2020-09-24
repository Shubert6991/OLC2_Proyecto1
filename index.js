console.log("index.js");
const analizarTexto = () => {
  //analizar y ejecutar
  let texto = document.getElementById("textInput").value
  try {
    let result = analizador.parse(texto)
    console.log(result);
    //imprimir traduccion
    escribirTraduccion(result.traduccion);
    //reporte lista de errores
    //reporte ast
    //ejecutar ast,pasar lista errores
  } catch (error) {
    console.log(error);
  }
}

//funcion para escribir traduccion
const escribirTraduccion = (texto) => {
  let area = document.getElementById("area_result");
  area.value = texto;
}

//funcion para crear reporte de errores


//funcion para boton reportes
const descargarReportes = () => {
  console.log("descargando reportes...");
}

document.getElementById("reportesBtn").addEventListener("click",descargarReportes);
document.getElementById("analizarBtn").addEventListener("click",analizarTexto);