console.log("index.js");
const analizarTexto = () => {
  //analizar y ejecutar
  let texto = document.getElementById("textInput").value
  try {
    let result = analizador.parse(texto)
    console.log(result);
    //imprimir traduccion
    console.log(result.traduccion);
    escribirTraduccion(result.traduccion);
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
//funcion para boton reportes
document.getElementById("analizarBtn").addEventListener("click",analizarTexto);