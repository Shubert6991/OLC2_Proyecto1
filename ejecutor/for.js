const ejecutarFor = (nodo,entorno,errores) => {
    //3 hijos
    //hijo1 = Declaracion/Asigncion
    //hijo2 = condicion
    //hijo3 = incremento/decremento
    //hijo4 = sentencias

    var h1 = nodo.getListaNodos()[0];
    var tipo = h1.getTipo();
    var val = 0;
    switch(tipo){
        case "DECLARACION":
            declaracion(h1,entorno,errores);
            val = getValor(h1.getListaNodos()[1],entorno,errores);
            break;
        case "ASIGNACION":
            asignacion(h1,entorno,errores);
            val = getValor(h1.getListaNodos()[1],entorno,errores);
            break;
        default:
            return;
            break;
    }
    var cond = getValor(nodo.getListaNodos()[1],entorno,errores);
    while(cond){
        ejecutar(nodo.getListaNodos()[3],entorno,errores);
        ejecutar(nodo.getListaNodos()[2],entorno,errores);
        cond = getValor(nodo.getListaNodos()[1],entorno,errores);
    }

} 