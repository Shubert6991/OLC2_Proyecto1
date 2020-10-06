//funcion para crear reporte de errores
const reportErrores = (lista) => {
  var div = document.createElement("div");
  var h3 = document.createElement("h3");
  h3.innerHTML="Tabla De Errores";
  var tablaErr = document.createElement("table");
  tablaErr.className = "table table-hover";
  var head = tablaErr.createTHead();
  head.className = "thead-dark";
  var row = head.insertRow();
  var cel = row.insertCell();
  cel.outerHTML = "<th>Tipo</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Descripcion</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Linea</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Columna</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Entorno</th>";
  //tbody
  var body = tablaErr.createTBody()
  lista.forEach(element => {
    console.log(element);
    var row = body.insertRow();
    var cel = row.insertCell();
    cel.innerHTML = element.getTipo();
    cel = row.insertCell();
    cel.innerHTML = element.getDescripcion();
    cel = row.insertCell();
    cel.innerHTML = element.getLinea();
    cel = row.insertCell();
    cel.innerHTML = element.getColumna();
    cel = row.insertCell();
    cel.innerHTML = element.getAmbito();
  });
  
  div.appendChild(h3);
  div.appendChild(tablaErr);
  document.getElementById("reportes").appendChild(div);
}

//funcion para crear reporte ast
const reporteAST = (ast) =>{
  console.log(ast);
  var div = document.createElement("div");
  div.className = "div-reporte";
  var h3 = document.createElement("h3");
  h3.innerHTML="Arbol de Analisis Sintactico(AST)";
  
  var result = recorrer(ast);
  let cadena = "digraph { ";
  //sacar nodos
  //cadena += "1[label=\"test\", fillcolor=\"lightskyblue\", style=\"filled\",shape=\"oval\"];"
  cadena += result.nodos;
  //sacar conexiones
  // cadena += "1 -> 2;";
  cadena += result.conexiones;
  cadena += "}";

  let viz = new Viz();

  console.log(cadena);
  viz.renderImageElement(cadena)
  .then(function(element) {
    div.appendChild(h3);
    element.className="img-fluid";
    div.appendChild(element);
    document.getElementById("reportes").appendChild(div);
    // document.body.appendChild(element);
  })
  .catch(error => {
    // Create a new Viz instance (@see Caveats page for more info)
    viz = new Viz();
    // Possibly display the error
    console.error(error);
  });
}

//funcion para obtener Nodos
const recorrer = (ast) => {
  var nodos = ""
  var conexiones = ""
  let res = recursivo(ast,nodos,conexiones,0);
  nodos = res.nodos;
  conexiones = res.conexiones;
  return {nodos,conexiones};
}

const recursivo = (ast,nodos,conexiones,cont) => {
  if(ast.getTipo() !== "" ){
    if(ast.getTipo() !== ast.getNombre()){
      nodos = nodos + cont + "[label=\""+ast.getTipo()+"("+ast.getNombre()+")"+"\"];\n";
    } else {
      nodos = nodos + cont + "[label=\""+ast.getTipo()+"\"];\n";
    }
    var aux = cont;
    if(ast.hijosCount() > 0){
      ast.getListaNodos().forEach(element => {
        cont++;
        if (element.getTipo() !== ""){
          conexiones = conexiones + aux + " -> " + cont +";\n";
        }
        var res = recursivo(element,nodos,conexiones,cont);
        nodos = res.nodos;
        conexiones = res.conexiones;
        cont = res.cont;
      });
    }
  } else {
    cont--;
  }
  return {nodos,conexiones,cont};
}

//funcion para crear reporte de tabla de simbolos
const reportSimbolos = (lista) => {
  var div = document.createElement("div");
  var h3 = document.createElement("h3");
  h3.innerHTML="Tabla De Simbolos";
  var tablaSim = document.createElement("table");
  tablaSim.className = "table table-hover";
  var head = tablaSim.createTHead();
  head.className = "thead-dark";
  var row = head.insertRow();
  var cel = row.insertCell();
  cel.outerHTML = "<th>Nombre</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Tipo</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Valor</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Ambito</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Fila</th>";
  cel = row.insertCell();
  cel.outerHTML = "<th>Columna</th>";
  //tbody
  var body = tablaSim.createTBody()
  lista.forEach(element => {
    console.log(element);
    var row = body.insertRow();
    var cel = row.insertCell();
    cel.innerHTML = element.nombre;
    cel = row.insertCell();
    cel.innerHTML = element.tipo;
    cel = row.insertCell();
    cel.innerHTML = element.valor;
    cel = row.insertCell();
    cel.innerHTML = element.ambito;
    cel = row.insertCell();
    cel.innerHTML = element.fila;
    cel = row.insertCell();
    cel.innerHTML = element.columna;
  });
  
  div.appendChild(h3);
  div.appendChild(tablaSim);
  document.getElementById("reportes").appendChild(div);
}