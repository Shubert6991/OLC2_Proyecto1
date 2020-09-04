console.log("index.js");
const analizarTexto = () => {
  let texto = document.getElementById("textInput").value
  try {
    let result = analizador.parse(texto)
    console.log(result);
  } catch (error) {
    console.log(error);
  }
  
}
document.getElementById("analizarBtn").addEventListener("click",analizarTexto);