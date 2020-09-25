//funcion para ejecutar codigo
const ejecutar = (ast,entorno,errores) => {
  if(ast != null){
    let tipo = ast.getTipo();
    console.log(tipo);
    switch (tipo) {
      case "S":
        ejecutar(ast.getListaNodos()[0],entorno,errores);
        break;
      case "I":
        ejecutar(ast.getListaNodos()[0],entorno,errores);
        ejecutar(ast.getListaNodos()[1],entorno,errores);
        break;
      case "DECLARACION":
        //ejecutar declaracion;
        declaracion(ast,entorno,errores);
        break;
      default:
        console.error("todavia no he programado eso -> "+tipo);
        break;
    }
  }
}