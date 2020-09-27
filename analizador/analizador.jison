/*---------------------------IMPORTS-------------------------------*/
%{
  let valcadena = ""; 
  let resultado = "";
  let errores = new ListaErrores();
  let id_anidadas = "";
  let trad_func = "";
%}

/*----------------------------LEXICO-------------------------------*/
%lex
%x comentarios
%x comentariomulti
%x tstring
%x tstring2
%x ttstring

%%
"//"                            %{ this.begin("comentarios"); %}
<comentarios>[\n]               %{ this.popState(); %}
<comentarios>[^\n]              %{ %}
<comentarios><<EOF>>            %{ this.popState(); return 'EOF'; %}

"/*"												    %{ this.begin("comentariomulti"); %}
<comentariomulti>"*/"						%{ this.popState(); %}
<comentariomulti>.							%{  %}
<comentariomulti>[ \t\r\n\f]		%{  %}

["]                             %{ this.begin("tstring"); %}   
<tstring>["]                    %{ 
                                    this.popState(); 
                                    console.log("cadena: "+valcadena); 
                                    yytext=valcadena; valcadena=""; 
                                    return 'tk_t_string';
                                %} 
<tstring>"\\n"                  %{ valcadena +='\n'; %}
<tstring>"\\t"                  %{ valcadena +='\t'; %}
<tstring>"\\\\"                 %{ valcadena +='\\'; %}
<tstring>"\\r"                  %{ valcadena +='\r'; %}
<tstring>"\\\""                 %{ valcadena +='\"'; %}
<tstring>.                      %{ valcadena += yytext; %}

[']                             %{ this.begin("tstring2"); %}   
<tstring2>[']                   %{ 
                                    this.popState(); 
                                    console.log("cadena: "+valcadena); 
                                    yytext=valcadena; valcadena=""; 
                                    return 'tk_t_string';
                                %} 
<tstring2>"\\n"                 %{ valcadena +='\n'; %}
<tstring2>"\\t"                 %{ valcadena +='\t'; %}
<tstring2>"\\\\"                %{ valcadena +='\\'; %}
<tstring2>"\\r"                 %{ valcadena +='\r'; %}
<tstring2>"\\\""                %{ valcadena +='\"'; %}
<tstring2>.                     %{ valcadena += yytext; %}

[`]                             %{ this.begin("ttstring"); %}   
<ttstring>[`]                   %{ 
                                    this.popState(); 
                                    console.log("cadena: "+valcadena); 
                                    yytext=valcadena; valcadena=""; 
                                    return 'tk_t_string';
                                %} 
<ttstring>"\\n"                 %{ valcadena +='\n'; %}
<ttstring>"\\t"                 %{ valcadena +='\t'; %}
<ttstring>"\\\\"                %{ valcadena +='\\'; %}
<ttstring>"\\r"                 %{ valcadena +='\r'; %}
<ttstring>"\\\""                %{ valcadena +='\"'; %}
<ttstring>.                     %{ valcadena += yytext; %}

"\\\""                          %{ console.log("secuencia de escape:"+yytext);  return 'tk_comilladoble'; %}
"\\\\"                          %{ console.log("secuencia de escape:"+yytext);  return 'tk_barrainvertida'; %}
"\\n"                           %{ console.log("secuencia de escape:"+yytext);  return 'tk_salto'; %}
"\\r"                           %{ console.log("secuencia de escape:"+yytext);  return 'tk_retorno'; %}
"\\t"                           %{ console.log("secuencia de escape:"+yytext);  return 'tk_tab'; %}

"string"                        %{ console.log("tipo de dato:"+yytext);  return 'tk_string'; %}
"number"                        %{ console.log("tipo de dato:"+yytext);  return 'tk_number'; %}
"boolean"                       %{ console.log("tipo de dato:"+yytext);  return 'tk_boolean'; %}
"void"                          %{ console.log("tipo de dato:"+yytext);  return 'tk_void'; %}
"type"                          %{ console.log("tipo de dato:"+yytext);  return 'tk_type'; %}

"Array"                         %{ console.log("inicio array:"+yytext);  return 'tk_array'; %}
"Push"                          %{ console.log("accion array:"+yytext);  return 'tk_push'; %}
"Pop"                           %{ console.log("accion array:"+yytext);  return 'tk_pop'; %}
"Lenght"                        %{ console.log("accion array:"+yytext);  return 'tk_lenght'; %}

"let"                           %{ console.log("declaracion:"+yytext);  return 'tk_let'; %}
"const"                         %{ console.log("declaracion:"+yytext);  return 'tk_const'; %}

"true"                          %{ console.log("boolean:"+yytext);  return 'tk_t_boolean'; %}
"false"                         %{ console.log("boolean:"+yytext);  return 'tk_t_boolean'; %}

"if"                            %{ console.log("sentencias:"+yytext);  return 'tk_if'; %}
"else"                          %{ console.log("sentencias:"+yytext);  return 'tk_else'; %}
"switch"                        %{ console.log("sentencias:"+yytext);  return 'tk_switch'; %}
"case"                          %{ console.log("sentencias:"+yytext);  return 'tk_case'; %}
"default"                       %{ console.log("sentencias:"+yytext);  return 'tk_default'; %}
"while"                         %{ console.log("sentencias:"+yytext);  return 'tk_while'; %}
"do"                            %{ console.log("sentencias:"+yytext);  return 'tk_do'; %}
"for"                           %{ console.log("sentencias:"+yytext);  return 'tk_for'; %}
"in"                            %{ console.log("sentencias:"+yytext);  return 'tk_in'; %}
"of"                            %{ console.log("sentencias:"+yytext);  return 'tk_of'; %}

"break"                         %{ console.log("transferencia:"+yytext);  return 'tk_break'; %}
"continue"                      %{ console.log("transferencia:"+yytext);  return 'tk_continue'; %}
"return"                        %{ console.log("transferencia:"+yytext);  return 'tk_return'; %}

"function"                      %{ console.log("funcion:"+yytext);  return 'tk_fn'; %}
"console.log"                   %{ console.log("funcion:"+yytext);  return 'tk_console'; %}
"graficar_ts"                   %{ console.log("funcion:"+yytext);  return 'tk_graficar'; %}

"**"                            %{ console.log("arimetica:"+yytext); return 'tk_exp'; %}
"++"                            %{ console.log("arimetica:"+yytext); return 'tk_inc'; %}
"--"                            %{ console.log("arimetica:"+yytext); return 'tk_dec'; %}
"+"                             %{ console.log("arimetica:"+yytext); return 'tk_suma'; %}
"-"                             %{ console.log("arimetica:"+yytext); return 'tk_resta'; %}
"*"                             %{ console.log("arimetica:"+yytext); return 'tk_mult'; %}
"/"                             %{ console.log("arimetica:"+yytext); return 'tk_div'; %}
"%"                             %{ console.log("arimetica:"+yytext); return 'tk_mod'; %}

">="                            %{ console.log("relacional:"+yytext); return 'tk_mayorigual'; %}
"<="                            %{ console.log("relacional:"+yytext); return 'tk_menorigual'; %}
"=="                            %{ console.log("relacional:"+yytext); return 'tk_igualdad'; %}
"!="                            %{ console.log("relacional:"+yytext); return 'tk_diferente'; %}
">"                             %{ console.log("relacional:"+yytext); return 'tk_mayor'; %}
"<"                             %{ console.log("relacional:"+yytext); return 'tk_menor'; %}

"&&"                            %{ console.log("Logica:"+yytext); return 'tk_and'; %}
"||"                            %{ console.log("Logica:"+yytext); return 'tk_or'; %}
"!"                             %{ console.log("Logica:"+yytext); return 'tk_not'; %}

"?"                             %{ console.log("ternario:"+yytext); return 'tk_ternario'; %}

"["                             %{ console.log("simbolo:"+yytext); return 'tk_llaveca'; %}
"]"                             %{ console.log("simbolo:"+yytext); return 'tk_llavecc'; %}
":"                             %{ console.log("simbolo:"+yytext); return 'tk_dospuntos'; %}
"="                             %{ console.log("simbolo:"+yytext); return 'tk_igual'; %}
";"                             %{ console.log("simbolo:"+yytext); return 'tk_puntoycoma'; %}
"{"                             %{ console.log("simbolo:"+yytext); return 'tk_llavea'; %}
"}"                             %{ console.log("simbolo:"+yytext); return 'tk_llavec'; %}
","                             %{ console.log("simbolo:"+yytext); return 'tk_coma'; %}
"("                             %{ console.log("simbolo:"+yytext); return 'tk_pabierto'; %}
")"                             %{ console.log("simbolo:"+yytext); return 'tk_pcerrado'; %}

[0-9]+"."[0-9]+                 %{ console.log("numero decimal:"+yytext);  return 'tk_t_decimal'; %}
[0-9]+                          %{ console.log("numero entero:"+yytext);  return 'tk_t_entero'; %}
[[a-zA-ZñÑáéíóúÁÉÍÓÚ]["_"0-9a-zA-ZñÑáéíóúÁÉÍÓÚ]*|["_"]+[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ]["_"0-9a-zA-ZñÑáéíóúÁÉÍÓÚ]*] %{  console.log("id:"+yytext); return 'tk_id'; %}

[ \t\n\r\f] 										%{ /*se ignoran*/ %}

<<EOF>>     										%{  return 'EOF';  %}

.           										%{  
                                    console.error("Error Lexico:"+yytext); 
                                    var error = new Error("Lexico",yytext,+yylineno+1,yylloc.last_column)
                                    errores.addError(error);
                                %}

/lex

/*-------------------------SINTACTICO------------------------------*/
/*-----ASOCIACION Y PRECEDENCIA-----*/
%left tk_or
%left tk_and
%left tk_igualdad tk_diferente
%left tk_menorigual tk_mayorigual tk_mayor tk_menor
%left tk_suma tk_resta 
%right tk_inc tk_dec
%left tk_mult tk_div tk_mod
%left tk_exp
%right tk_not
%left tk_pabierto tk_pcerrado
/*----------ESTADO INICIAL----------*/
%start S
%% 
%locations
/*-------------GRAMATICA------------*/
S: I EOF{
          var nodo = new Nodo("S","S",+yylineno+1,+@1.first_column+1)
          nodo.addHijo($1)
          var texto = ""
          if($1.trad){
            texto = $1.trad;
          }
          var trad = new Traduccion(nodo,texto,errores.getLista()); 
          errores.limpiar();
          return trad;
        }
  |EOF{
        var trad = new Traduccion(new Nodo("S","S",+yylineno+1,+@1.first_column+1),"",errores.getLista()); 
        errores.limpiar();
        return trad;
      };

I: I DECLARACION{
                  var nodo = new Nodo("I","I",+yylineno+1,+@1.first_column+1);
                  nodo.addHijo($1);
                  nodo.addHijo($2);
                  $$ = nodo;
                  $$.trad = $1.trad + $2.trad;
                }
  |I ASIGNACION {
                  var nodo = new Nodo("I","I",+yylineno+1,+@1.first_column+1);
                  nodo.addHijo($1);
                  nodo.addHijo($2);
                  $$ = nodo;
                  $$.trad = $1.trad + $2.trad;
                }
  |I IF {
          var nodo = new Nodo("I","I",+yylineno+1,+@1.first_column+1);
          nodo.addHijo($1);
          nodo.addHijo($2);
          $$ = nodo;
          $$.trad = $1.trad + $2.trad;
        }
  |I SWITCH {
              var nodo = new Nodo("I","I",+yylineno+1,+@1.first_column+1);
              nodo.addHijo($1);
              nodo.addHijo($2);
              $$ = nodo;
              $$.trad = $1.trad + $2.trad;
            }
  |I WHILE{
            var nodo = new Nodo("I","I",+yylineno+1,+@1.first_column+1);
            nodo.addHijo($1);
            nodo.addHijo($2);
            $$ = nodo;
            $$.trad = $1.trad + $2.trad;
          }
  |I DOWHILE{
              var nodo = new Nodo("I","I",+yylineno+1,+@1.first_column+1);
              nodo.addHijo($1);
              nodo.addHijo($2);
              $$ = nodo;
              $$.trad = $1.trad + $2.trad;
            }
  |I FOR{
          var nodo = new Nodo("I","I",+yylineno+1,+@1.first_column+1);
          nodo.addHijo($1);
          nodo.addHijo($2);
          $$ = nodo;
          $$.trad = $1.trad + $2.trad;
        }
  |I FESP {
            var nodo = new Nodo("I","I",+yylineno+1,+@1.first_column+1);
            nodo.addHijo($1);
            nodo.addHijo($2);
            $$ = nodo;
            $$.trad = $1.trad + $2.trad;
          }
  |I FUNCION{
              //imprimir cola de funciones
              console.log("Funciones Desanidadas!!!!")
              console.log(id_anidadas)
              console.log(trad_func)
              console.log("##########################")
              //limpiar cola
              id_anidadas = "";
              trad_func = "";
            }
  |DECLARACION { $$ = $1; $$.trad = $1.trad; }
  |ASIGNACION { $$ = $1; $$.trad = $1.trad; }
  |IF { $$ = $1; $$.trad = $1.trad; }
  |SWITCH { $$ = $1; $$.trad = $1.trad; }
  |WHILE { $$ = $1; $$.trad = $1.trad; }
  |DOWHILE { $$ = $1; $$.trad = $1.trad; }
  |FOR { $$ = $1; $$.trad = $1.trad; }
  |FESP { $$ = $1; $$.trad = $1.trad; }
  |FUNCION  {
              //imprimir cola de funciones
              console.log("Funciones Desanidadas!!!!")
              console.log(id_anidadas)
              console.log(trad_func)
              console.log("##########################")
              //limpiar cola
              id_anidadas = "";
              trad_func = "";
            }
  |error{
          console.error("Error sintactico: "+$1+" Desconocido Inicio");
          var error = new Error("Sintactico","Encontrado: "+$1+" Se esperaba -> DECLARACION || ASIGNACION || IF || SWITCH || WHILE || DOWHILE || FOR || console.log || graficar_ts",+yylineno+1,+@1.last_column+1)
          errores.addError(error);
          $$ = new Nodo("","")
          $$.trad = "";
        }; 

DECLARACION: tk_let tk_id tk_dospuntos TIPOV2 tk_igual VALOR tk_puntoycoma{ 
                                                                            var nodo = new Nodo("DECLARACION","LET",+yylineno+1,+@1.first_column+1);
                                                                            var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                                            nodo.addHijo(id);
                                                                            nodo.addHijo($4); //tipo
                                                                            nodo.addHijo($6); //valor
                                                                            $$ = nodo;
                                                                            $$.trad = $1+" "+$2+$3+" "+$4.trad+" "+$5+" "+$6.trad+$7+"\n";
                                                                          }
          | tk_let tk_id tk_dospuntos TIPOV2 tk_igual VALOR error {
                                                                    console.error("Error Sintactico: "+$7+ " falto punto y coma");
                                                                    var error = new Error("Sintactico","Encontrado: \""+$7+"\" Se esperaba -> ;",+yylineno+1,+@1.last_column+1)
                                                                    errores.addError(error);

                                                                    var nodo = new Nodo("DECLARACION","LET",+yylineno+1,+@1.first_column+1);
                                                                    var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                                    nodo.addHijo(id);
                                                                    nodo.addHijo($4); //tipo
                                                                    nodo.addHijo($6); //valor
                                                                    $$ = nodo;
                                                                    $$.trad = $1+" "+$2+$3+" "+$4.trad+" "+$5+" "+$6.trad+";\n";
                                                                  }  
          | tk_const tk_id tk_dospuntos TIPOV2 tk_igual VALOR tk_puntoycoma {
                                                                              var nodo = new Nodo("DECLARACION","CONST",+yylineno+1,+@1.first_column+1);
                                                                              var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                                              nodo.addHijo(id);
                                                                              nodo.addHijo($4); //tipo
                                                                              nodo.addHijo($6); //valor
                                                                              $$ = nodo;
                                                                              $$.trad = $1+" "+$2+$3+" "+$4.trad+" "+$5+" "+$6.trad+$7+"\n";
                                                                            }
          | tk_const tk_id tk_dospuntos TIPOV2 tk_igual VALOR error {
                                                                      console.error("Error Sintactico: "+$7+ " falto punto y coma");
                                                                      var error = new Error("Sintactico","Encontrado: "+$7+" Se esperaba -> ;",+yylineno+1,+@7.last_column+1)
                                                                      errores.addError(error);

                                                                      var nodo = new Nodo("DECLARACION","CONST",+yylineno+1,+@1.first_column+1);
                                                                      var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                                      nodo.addHijo(id);
                                                                      nodo.addHijo($4); //tipo
                                                                      nodo.addHijo($6); //valor
                                                                      $$ = nodo;
                                                                      $$.trad = $1+" "+$2+$3+" "+$4.trad+" "+$5+" "+$6.trad+";\n";
                                                                    }  
          | tk_let tk_id tk_igual VALOR tk_puntoycoma {
                                                        var nodo = new Nodo("DECLARACION","LET",+yylineno+1,+@1.first_column+1);
                                                        var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                        nodo.addHijo(id);
                                                        nodo.addHijo($4);
                                                        $$ = nodo;
                                                        $$.trad = $1+" "+$2+" "+$3+" "+$4.trad+$5+"\n";
                                                      }
          | tk_let tk_id tk_igual VALOR error {
                                                console.error("Error Sintactico: "+$5+ " falto punto y coma");
                                                var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> ;",+yylineno+1,+@5.last_column+1)
                                                errores.addError(error);

                                                var nodo = new Nodo("DECLARACION","LET",+yylineno+1,+@1.first_column+1);
                                                var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                nodo.addHijo(id);
                                                nodo.addHijo($4);
                                                $$ = nodo;
                                                $$.trad = $1+" "+$2+" "+$3+" "+$4.trad+";\n";
                                              } 
          | tk_const tk_id tk_igual VALOR tk_puntoycoma {
                                                          var nodo = new Nodo("DECLARACION","CONST",+yylineno+1,+@1.first_column+1);
                                                          var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                          nodo.addHijo(id);
                                                          nodo.addHijo($4);
                                                          $$ = nodo;
                                                          $$.trad = $1+" "+$2+" "+$3+" "+$4.trad+$5+"\n";
                                                        }
          | tk_const tk_id tk_igual VALOR error {
                                                  console.error("Error Sintactico: "+$5+ " falto punto y coma");
                                                  var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> ;",+yylineno+1,+@5.last_column+1)
                                                  errores.addError(error);

                                                  var nodo = new Nodo("DECLARACION","CONST",+yylineno+1,+@1.first_column+1);
                                                  var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                  nodo.addHijo(id);
                                                  nodo.addHijo($4);
                                                  $$ = nodo;
                                                  $$.trad = $1+" "+$2+" "+$3+" "+$4.trad+";\n";
                                                }  
          | tk_let tk_id tk_dospuntos TIPOV2 tk_puntoycoma{
                                                            var nodo = new Nodo("DECLARACION","LET",+yylineno+1,+@1.first_column+1);
                                                            var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                            nodo.addHijo(id);
                                                            nodo.addHijo($4);
                                                            $$ = nodo;
                                                            $$.trad = $1+" "+$2+$3+" "+$4.trad+$5+"\n";
                                                          }
          | tk_let tk_id tk_dospuntos TIPOV2 error{
                                                    console.error("Error Sintactico: "+$5+ " falto punto y coma");
                                                    var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> ;",+yylineno+1,+@5.last_column+1)
                                                    errores.addError(error);

                                                    var nodo = new Nodo("DECLARACION","LET",+yylineno+1,+@1.first_column+1);
                                                    var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                    nodo.addHijo(id);
                                                    nodo.addHijo($4);
                                                    $$ = nodo;
                                                    $$.trad = $1+" "+$2+$3+" "+$4.trad+";\n";
                                                  } 
          | tk_let tk_id tk_puntoycoma{
                                        var nodo = new Nodo("DECLARACION","LET",+yylineno+1,+@1.first_column+1);
                                        var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                        nodo.addHijo(id);
                                        $$ = nodo;
                                        $$.trad = $1+" "+$2+$3+"\n";
                                      }  
          | tk_let tk_id error{
                                console.error("Error Sintactico: "+$3+ " falto punto y coma");
                                var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> ;",+yylineno+1,+@3.last_column+1)
                                errores.addError(error);

                                var nodo = new Nodo("DECLARACION","LET",+yylineno+1,+@1.first_column+1);
                                var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                nodo.addHijo(id);
                                $$ = nodo;
                                $$.trad = $1+" "+$2+";\n";
                              }  
          | TYPES {
                    $$ = $1;
                    $$.trad = $1.trad;
                  }
          | tk_id tk_inc tk_puntoycoma{
                                        var nodo = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@1.first_column+1);
                                        var id = new Nodo("ID",$1,+yylineno+1,+@2.first_column+1);
                                        nodo.addError(id);
                                        $$ = nodo;
                                        $$.trad = $1+$2+$3+"\n";
                                      }
          | tk_id tk_inc error{
                                console.error("Error Sintactico: "+$3+ " falto punto y coma");
                                var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> ;",+yylineno+1,+@3.last_column+1)
                                errores.addError(error);

                                var nodo = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@1.first_column+1);
                                var id = new Nodo("ID",$1,+yylineno+1,+@2.first_column+1);
                                nodo.addError(id);
                                $$ = nodo;
                                $$.trad = $1+$2+";\n";
                              } 
          | tk_id tk_dec tk_puntoycoma{
                                        var nodo = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@1.first_column+1);
                                        var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
                                        nodo.addHijo(id);
                                        $$ = nodo;
                                        $$.trad = $1+$2+$3+"\n";
                                      }
          | tk_id tk_dec error{
                                console.error("Error Sintactico: "+$3+ " falto punto y coma");
                                var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> ;",+yylineno+1,+@3.last_column+1)
                                errores.addError(error);

                                var nodo = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@1.first_column+1);
                                var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
                                nodo.addHijo(id);
                                $$ = nodo;
                                $$.trad = $1+$2+";\n";
                              }
          | tk_let error{
                          console.error("Error Sintactico: "+$2+" error de declaracion");
                          var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> incremento o decremento",+yylineno+1,+@2.last_column+1);
                          errores.addError(error);

                          $$ = new Nodo("","")
                          $$.trad = "";
                        }
          | tk_const error{
                            console.error("Error Sintactico: "+$2+" error de declaracion");
                            var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> incremento o decremento",+yylineno+1,+@2.last_column+1);
                            errores.addError(error);

                            $$ = new Nodo("","")
                            $$.trad = "";
                          }
          | tk_id error {
                          console.error("Error Sintactico: "+$2+" error de declaracion");
                          var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> incremento o decremento",+yylineno+1,+@2.last_column+1);
                          errores.addError(error);

                          $$ = new Nodo("","")
                          $$.trad = "";
                        };

TIPOV: tk_string{
                  var nodo = new Nodo("TIPO","STRING",+yylineno+1,+@1.first_column+1); 
                  $$ = nodo;
                  $$.trad = $1; 
                }
      |tk_number{
                  var nodo = new Nodo("TIPO","NUMBER",+yylineno+1,+@1.first_column+1); 
                  $$ = nodo;
                  $$.trad = $1; 
                }
      |tk_boolean {
                    var nodo = new Nodo("TIPO","BOOLEAN",+yylineno+1,+@1.first_column+1); 
                    $$ = nodo;
                    $$.trad = $1; 
                  }
      |tk_void{
                var nodo = new Nodo("TIPO","VOID",+yylineno+1,+@1.first_column+1); 
                $$ = nodo;
                $$.trad = $1; 
              }
      |tk_id{
              var nodo = new Nodo("TIPO","ID",+yylineno+1,+@1.first_column+1);
              var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
              nodo.addHijo(id); 
              $$ = nodo;
              $$.trad = $1; 
            }
      |error{
              console.error("Error sintactico: "+$1+" error tipo");
              var error = new Error("Sintactico","Encontrado: "+$1+" Se esperaba -> un tipo de dato",+yylineno+1,+@1.last_column+1);
              errores.addError(error);
              $$ = new Nodo("","")
              $$.trad = "";
            };

TIPOV2:TIPOV{ 
              $$ = $1;
              $$.trad = $1.trad; 
            }
      |ARRAY{ 
              $$ = $1;
              $$.trad = $1.trad; 
            };

VALOR: ASIGTYPE { 
                  $$ = $1;
                  $$.trad = $1.trad; 
                }
      |VARRAY { 
                $$ = $1;
                $$.trad = $1.trad; 
              }
      |T{ 
          $$ = $1;
          $$.trad = $1.trad;
        }
      |VALARRAY { 
                  $$ = $1;
                  $$.trad = $1.trad;
                }
      |VALFUNCION { 
                    $$ = $1;
                    $$.trad = $1.trad;
                  }
      |tk_id tk_inc { 
                      var nodo = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@1.first_column+1);
                      var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1)
                      nodo.addHijo(id);
                      $$ = nodo;
                      $$.trad = $1 + $2;
                    }
      |tk_id tk_dec { 
                      var nodo = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@1.first_column+1);
                      var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1)
                      nodo.addHijo(id);
                      $$ = nodo;
                      $$.trad = $1 + $2;
                    }
      |error{
              console.error("Error sintactico: "+$1+" error valor");
              var error = new Error("Sintactico","Encontrado: "+$1+" Se esperaba -> un valor o operacion",+yylineno+1,+@1.last_column+1);
              errores.addError(error);
              $$ = new Nodo("","")
              $$.trad = "";
            };

TYPES: tk_type tk_id tk_llavea LTYPE tk_llavec tk_puntoycoma{
                                                              var nodo = new Nodo("DECLARACION","TYPE",+yylineno+1,+@1.first_column+1);
                                                              var id = new Nodo("ID",$2,+yylineno+1,+@1.first_column+1);
                                                              nodo.addHijo(id);
                                                              nodo.addHijo($4); //lista
                                                              $$ = nodo;
                                                              $$.trad = $1 + " " + $2 + $3 + "\n" + $4.trad + $5 + $6 + "\n";  
                                                            }
     | tk_type tk_id tk_llavea LTYPE tk_llavec error{
                                                      console.error("Error sintantico: "+$6+" error types");
                                                      var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> ;",+yylineno+1,+@6.last_column+1)
                                                      errores.addError(error);

                                                      var nodo = new Nodo("DECLARACION","TYPE",+yylineno+1,+@1.first_column+1);
                                                      var id = new Nodo("ID",$2,+yylineno+1,+@1.first_column+1);
                                                      nodo.addHijo(id);
                                                      nodo.addHijo($4); //lista
                                                      $$ = nodo;
                                                      $$.trad = $1 + " " + $2 + $3 + "\n" + $4.trad + $5 + ";\n";
                                                    };

LTYPE: LTYPE TIPOV2 tk_dospuntos tk_id tk_puntoycoma{
                                                      var nodo = new Nodo("LISTATIPO","LISTATIPO",+yylineno+1,+@1.first_column+1);
                                                      nodo.addHijo($1);
                                                      nodo.addHijo($2);
                                                      var id = new Nodo("ID",$4,+yylineno+1,+@4.first_column+1);
                                                      nodo.addHijo(id);
                                                      $$ = nodo;
                                                      $$.trad = $1.trad + $2.trad + $3 + " " + $4 + $5 + "\n";
                                                    }
      | LTYPE TIPOV2 tk_dospuntos tk_id error {
                                                console.error("Error sintantico: "+$5+" error types");
                                                var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> ;",+yylineno+1,+@5.last_column+1)
                                                errores.addError(error);
                                                
                                                var nodo = new Nodo("LISTATIPO","LISTATIPO",+yylineno+1,+@1.first_column+1);
                                                nodo.addHijo($1);
                                                nodo.addHijo($2);
                                                var id = new Nodo("ID",$4,+yylineno+1,+@4.first_column+1);
                                                nodo.addHijo(id);
                                                $$ = nodo;
                                                $$.trad = $1.trad + $2.trad + $3 + " " + $4 + ";\n";
                                              }
      | TIPOV2 tk_dospuntos tk_id tk_puntoycoma {
                                                  var nodo = new Nodo("LISTATIPO","LISTATIPO",+yylineno+1,+@1.first_column+1);
                                                  nodo.addHijo($1);
                                                  var id = new Nodo("ID",$3,+yylineno+1,+@3.first_column+1);
                                                  nodo.addHijo(id);
                                                  $$ = nodo;
                                                  $$.trad = $1.trad + $2 + " " + $3 + $4 + "\n";
                                                }
      | TIPOV2 tk_dospuntos tk_id error {
                                          console.error("Error sintantico: "+$4+" error types");
                                          var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> ;",+yylineno+1,+@4.last_column+1)
                                          errores.addError(error);

                                          var nodo = new Nodo("LISTATIPO","LISTATIPO",+yylineno+1,+@1.first_column+1);
                                          nodo.addHijo($1);
                                          var id = new Nodo("ID",$3,+yylineno+1,+@3.first_column+1);
                                          nodo.addHijo(id);
                                          $$ = nodo;
                                          $$.trad = $1.trad + $2 + " " + $3 + ";\n";
                                        };

ASIGTYPE: tk_llavea LASIGTYPE tk_llavec {
                                          var nodo = new Nodo("VALOR","ASIGNACION_TIPO",+yylineno+1,+@1.first_column+1);
                                          nodo.addHijo($2);
                                          $$ = nodo;
                                          $$.trad = $1 + "\n" + $2.trad + $3;
                                        }
        | tk_llavea error tk_llavec {
                                      console.error("Error sintactico: "+$2+" error valor");
                                      var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> una lista de valores",+yylineno+1,+@2.last_column+1);
                                      errores.addError(error);

                                      var nodo = new Nodo("VALOR","ASIGNACION_TIPO",+yylineno+1,+@1.first_column+1);
                                      $$ = nodo;
                                      $$.trad = $1 + "\n" + $3;
                                    };

LASIGTYPE: LASIGTYPE tk_id tk_dospuntos VALOR tk_puntoycoma {
                                                              var nodo = new Nodo("LISTATYPE","LISTATYPE",+yylineno+1,+@1.first_column+1);
                                                              var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                              nodo.addHijo($1);
                                                              nodo.addHijo(id);
                                                              nodo.addHijo($4);
                                                              $$ = nodo;
                                                              $$.trad = $1.trad + $2 + $3 + " " + $4.trad + $5 + "\n";
                                                            }
          | LASIGTYPE tk_id tk_dospuntos VALOR error{
                                                      console.error("Error sintactico: "+$5+" error valor");
                                                      var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> ;",+yylineno+1,+@5.last_column+1);
                                                      errores.addError(error);

                                                      var nodo = new Nodo("LISTATYPE","LISTATYPE",+yylineno+1,+@1.first_column+1);
                                                      var id = new Nodo("ID",$2,+yylineno+1,+@2.first_column+1);
                                                      nodo.addHijo($1);
                                                      nodo.addHijo(id);
                                                      nodo.addHijo($4);
                                                      $$ = nodo;
                                                      $$.trad = $1.trad + $2 + $3 + " " + $4.trad +";\n";
                                                    }
          | tk_id tk_dospuntos VALOR tk_puntoycoma{
                                                    var nodo = new Nodo("LISTATYPE","LISTATYPE",+yylineno+1,+@1.first_column+1);
                                                    var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
                                                    nodo.addHijo(id);
                                                    nodo.addHijo($3);
                                                    $$ = nodo;
                                                    $$.trad = $1 + $2 + $3.trad + $4 + "\n";
                                                  }
          | tk_id tk_dospuntos VALOR error{
                                            console.error("Error sintactico: "+$4+" error valor");
                                            var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> ;",+yylineno+1,+@4.last_column+1);
                                            errores.addError(error);

                                            var nodo = new Nodo("LISTATYPE","LISTATYPE",+yylineno+1,+@1.first_column+1);
                                            var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
                                            nodo.addHijo(id);
                                            nodo.addHijo($3);
                                            $$ = nodo;
                                            $$.trad = $1 + $2 + $3.trad +";\n";
                                          };

ARRAY: tk_string tk_llaveca tk_llavecc {
                                          var nodo = new Nodo("TIPO","ARRAY_STRING",+yylineno+1,+@1.first_column+1);
                                          $$ = nodo;
                                          $$.trad = $1+$2+$3;
                                       }
     | tk_number tk_llaveca tk_llavecc{
                                        var nodo = new Nodo("TIPO","ARRAY_NUMBER",+yylineno+1,+@1.first_column+1);
                                        $$ = nodo;
                                        $$.trad = $1+$2+$3;
                                      }
     | tk_boolean tk_llaveca tk_llavecc{
                                        var nodo = new Nodo("TIPO","ARRAY_BOOLEAN",+yylineno+1,+@1.first_column+1);
                                        $$ = nodo;
                                        $$.trad = $1+$2+$3;
                                       }
     | tk_id tk_llavecc tk_llavecc{
                                    var nodo = new Nodo("TIPO","ARRAY_ID",+yylineno+1,+@1.first_column+1);
                                    var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
                                    nodo.addHijo(id)
                                    $$ = nodo;
                                    $$.trad = $1+$2+$3;
                                  }
     | tk_array tk_menor TIPOV tk_mayor {
                                          var nodo = new Nodo("TIPO","ARRAY_TIPO",+yylineno+1,+@1.first_column+1);
                                          nodo.addHijo($3)
                                          $$ = nodo;
                                          $$.trad = $1+$2+$3.trad+$4;
                                        };

VARRAY: tk_llaveca LVALARRAY tk_llavecc {
                                          var nodo = new Nodo("VALOR","ASIGNACION_ARRAY",+yylineno+1,+@1.first_column+1);
                                          var larray = $2;
                                          nodo.addHijo(larray);
                                          $$ = nodo;
                                          $$.trad = $1 + $2.trad + $3;
                                        };

LVALARRAY: LVALARRAY tk_coma VALOR {
                                      var nodo = new Nodo("LISTA_ARRAY","LISTA_ARRAY",+yylineno+1,+@1.first_column+1);
                                      nodo.addHijo($1);
                                      nodo.addHijo($3);
                                      $$ = nodo;
                                      $$.trad = $1.trad + $2 + " " + $3.trad;
                                   }
        | LVALARRAY error VALOR {
                                  console.error("Error sintactico: "+$2+" error valor");
                                  var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> ,",+yylineno+1,+@2.last_column+1);
                                  errores.addError(error);

                                  var nodo = new Nodo("LISTA_ARRAY","LISTA_ARRAY",+yylineno+1,+@1.first_column+1);
                                  nodo.addHijo($1);
                                  nodo.addHijo($3);
                                  $$ = nodo;
                                  $$.trad = $1.trad + ", " + $3.trad;
                                }
        | VALOR {
                  $$ = $1;
                  $$.trad = $1.trad;
                };

VALARRAY: tk_id tk_llaveca A tk_llavecc {
                                          var nodo = new Nodo("VALOR","ARRAY_ITEM",+yylineno+1,+@1.first_column+1);
                                          var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
                                          nodo.addHijo(id);
                                          nodo.addHijo($3);
                                          $$ = nodo;
                                          $$.trad = $1 + $2 + $3.trad + $4;
                                        }
          |tk_id tk_llaveca error tk_llavecc{
                                              console.error("Error sintactico: "+$2+" error valor");
                                              var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> Operacion aritmetica || primitivo",+yylineno+1,+@2.last_column+1);
                                              errores.addError(error);

                                              var nodo = new Nodo("VALOR","ARRAY_ITEM",+yylineno+1,+@1.first_column+1);
                                              var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
                                              nodo.addHijo(id);
                                              $$ = nodo;
                                              $$.trad = $1 + $2 + " " + $4;
                                            };

ASIGNACION: tk_id tk_igual VALOR tk_puntoycoma{
                                                var nodo = new Nodo("ASIGNACION","ASIGNACION",+yylineno+1,+@1.first_column+1);
                                                var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
                                                nodo.addHijo($1);
                                                nodo.addHijo($3);
                                                $$ = $1+" "+$2+" "+$3.trad+$4+"\n";
                                              }
          | tk_id tk_igual VALOR error{
                                        console.log("Error Sintactico "+$4+"Error falto punto y coma");
                                        var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> ;",+yylineno+1,+@4.last_column+1);
                                        errores.addError(error);

                                        var nodo = new Nodo("ASIGNACION","ASIGNACION",+yylineno+1,+@1.first_column+1);
                                        var id = new Nodo("ID",$1,+yylineno+1,+@1.first_column+1);
                                        nodo.addHijo($1);
                                        nodo.addHijo($3);
                                        $$ = $1+" "+$2+" "+$3.trad+";\n";
                                      }
          | VALARRAY tk_igual VALOR tk_puntoycoma {
                                                    var nodo = new Nodo("ASIGNACION","ASIGNACION",+yylineno+1,+@1.first_column+1);
                                                    nodo.addHijo($1);
                                                    nodo.addHijo($3);
                                                    $$ = nodo;
                                                    $$.trad = $1.trad+" "+$2+" "+$3.trad+$4+"\n";
                                                  }
          | VALARRAY tk_igual VALOR error {
                                            console.log("Error Sintactico "+$4+"Error falto punto y coma");
                                            var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> ;",+yylineno+1,+@4.last_column+1);
                                            errores.addError(error);

                                            var nodo = new Nodo("ASIGNACION","ASIGNACION",+yylineno+1,+@1.first_column+1);
                                            nodo.addHijo($1);
                                            nodo.addHijo($3);
                                            $$ = nodo;
                                            $$.trad = $1.trad+" "+$2+" "+$3.trad+";\n";
                                          };

T: L tk_ternario L tk_dospuntos L {
                                    var nodo = new Nodo("T","T",+yylineno+1,+@1.first_column+1);
                                    nodo.addHijo($1);
                                    nodo.addHijo($3);
                                    nodo.addHijo($5);
                                    $$ = nodo;
                                    $$.trad = $1.trad + " " + $2 + " " + $3.trad +$4+$5.trad;
                                  }
  |L{ 
      $$ = $1; 
      $$.trad = $1.trad; 
    };

L: L tk_and L {
                var nodo = new Nodo("L","AND",+yylineno+1,+@1.first_column+1);
                nodo.addHijo($1);
                nodo.addHijo($3);
                $$ = nodo;
                $$.trad = $1.trad + " " + $2 + " " + $3.trad;
              }
  |L tk_or L{
              var nodo = new Nodo("L","OR",+yylineno+1,+@1.first_column+1);
              nodo.addHijo($1);
              nodo.addHijo($3);
              $$ = nodo;
              $$.trad = $1.trad + " " + $2 + " " + $3.trad;
            }
  |tk_not L {
              var nodo = new Nodo("L","NOT",+yylineno+1,+@1.first_column+1);
              nodo.addHijo($2);
              $$ = nodo;
              $$.trad = $1 + " " + $2.trad;
            }
  |tk_t_boolean {
                  var nodo = new Nodo("BOOLEAN",$1,+yylineno+1,+@1.first_column+1);
                  $$ = nodo;
                  $$.trad = $1
                }
  |R {
       $$=$1;
       $$.trad = $1.trad;
     };

R: A tk_mayor A {
                  var nodo = new Nodo("R","MAYOR",$1,+yylineno+1,+@1.first_column+1);
                  nodo.addHijo($1);
                  nodo.addHijo($3);
                  $$ = nodo;
                  $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                }
  |A tk_menor A {
                  var nodo = new Nodo("R","MENOR",$1,+yylineno+1,+@1.first_column+1);
                  nodo.addHijo($1);
                  nodo.addHijo($3);
                  $$ = nodo;
                  $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                }
  |A tk_mayorigual A{
                      var nodo = new Nodo("R","MAYORIGUAL",$1,+yylineno+1,+@1.first_column+1);
                      nodo.addHijo($1);
                      nodo.addHijo($3);
                      $$ = nodo;
                      $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                    }
  |A tk_menorigual A{
                      var nodo = new Nodo("R","MENORIGUAL",$1,+yylineno+1,+@1.first_column+1);
                      nodo.addHijo($1);
                      nodo.addHijo($3);
                      $$ = nodo;
                      $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                    }
  |A tk_igualdad A {
                      var nodo = new Nodo("R","IGUALDAD",$1,+yylineno+1,+@1.first_column+1);
                      nodo.addHijo($1);
                      nodo.addHijo($3);
                      $$ = nodo;
                      $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                   }
  |A tk_diferente A {
                      var nodo = new Nodo("R","DESIGUALDAD",$1,+yylineno+1,+@1.first_column+1);
                      nodo.addHijo($1);
                      nodo.addHijo($3);
                      $$ = nodo;
                      $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                    }
  |A{
      $$ = $1;
      $$.trad = $1.trad;
    };

A:A tk_suma A {
                var nodo = new Nodo("A","SUMA",$1,+yylineno+1,+@1.first_column+1);
                nodo.addHijo($1);
                nodo.addHijo($3);
                $$ = nodo;
                $$.trad = $1.trad + " " + $2 + " " + $3.trad;
              }
 |A tk_resta A{
                var nodo = new Nodo("A","RESTA",$1,+yylineno+1,+@1.first_column+1);
                nodo.addHijo($1);
                nodo.addHijo($3);
                $$ = nodo;
                $$.trad = $1.trad + " " + $2 + " " + $3.trad;
              }
 |A tk_mult A {
                var nodo = new Nodo("A","MULTI",$1,+yylineno+1,+@1.first_column+1);
                nodo.addHijo($1);
                nodo.addHijo($3);
                $$ = nodo;
                $$.trad = $1.trad + " " + $2 + " " + $3.trad;
              }
 |A tk_div A{
              var nodo = new Nodo("A","DIV",$1,+yylineno+1,+@1.first_column+1);
              nodo.addHijo($1);
              nodo.addHijo($3);
              $$ = nodo;
              $$.trad = $1.trad + " " + $2 + " " + $3.trad;
            }
 |A tk_exp A{
              var nodo = new Nodo("A","EXP",$1,+yylineno+1,+@1.first_column+1);
              nodo.addHijo($1);
              nodo.addHijo($3);
              $$ = nodo;
              $$.trad = $1.trad + " " + $2 + " " + $3.trad;
            }
 |A tk_mod A{
              var nodo = new Nodo("A","MOD",$1,+yylineno+1,+@1.first_column+1);
              nodo.addHijo($1);
              nodo.addHijo($3);
              $$ = nodo;
              $$.trad = $1.trad + " " + $2 + " " + $3.trad;
            }
 |tk_pabierto A tk_pcerrado {
                              $$ = $2;
                              $$.trad = $1 + " " + $2.trad + " " + $3
                            }
 |tk_resta A {
                var nodo = new Nodo("NEGATIVO",$2,$1,+yylineno+1,+@1.first_column+1);
                $$ = nodo;
                $$.trad = $1 + $2.trad;
             }
 |tk_t_string {
                var nodo = new Nodo("STRING",$1,$1,+yylineno+1,+@1.first_column+1);
                $$ = nodo;
                $$.trad = $1;
              }
 |tk_t_entero {
                var nodo = new Nodo("ENTERO",$1,$1,+yylineno+1,+@1.first_column+1);
                $$ = nodo;
                $$.trad = $1;
              }
 |tk_t_decimal{
                var nodo = new Nodo("DECIMAL",$1,$1,+yylineno+1,+@1.first_column+1);
                $$ = nodo;
                $$.trad = $1;
              }
 |tk_id {
          var nodo = new Nodo("ID",$1,$1,+yylineno+1,+@1.first_column+1);
          $$ = nodo;
          $$.trad = $1;
        };

BSENTENCIAS: tk_llavea SENTENCIAS tk_llavec {
                                              $$ = $2;
                                              $$.trad = $1+"\n"+$2.trad+$3+"\n";
                                            }
            |tk_llavea FUNCION tk_llavec{
                                          //aqui puede venir anidada
                                          //console.log("Func en bsentencias")
                                          //guardar funcion en cola
                                          //console.log(trad_func)
                                          //trad_func+="{}\n"
                                          $$ = new Nodo("","")
                                          $$.trad = "{}\n"
                                        }
            |tk_llavea tk_llavec{
                                  $$ = new Nodo("","");
                                  $$.trad = $1+$2+"\n";
                                };

SENTENCIAS: SENTENCIAS DECLARACION {
                                      var nodo = new Nodo("SENTENCIAS","SENTENCIAS",+yylineno+1,+@1.first_column+1);
                                      nodo.addHijo($1);
                                      nodo.addHijo($2);
                                      $$ = nodo;
                                      $$.trad = $1.trad + $2.trad;
                                   }
          | SENTENCIAS ASIGNACION {
                                    var nodo = new Nodo("SENTENCIAS","SENTENCIAS",+yylineno+1,+@1.first_column+1);
                                    nodo.addHijo($1);
                                    nodo.addHijo($2);
                                    $$ = nodo;
                                    $$.trad = $1.trad + $2.trad;
                                  }
          | SENTENCIAS IF {
                            var nodo = new Nodo("SENTENCIAS","SENTENCIAS",+yylineno+1,+@1.first_column+1);
                            nodo.addHijo($1);
                            nodo.addHijo($2);
                            $$ = nodo;
                            $$.trad = $1.trad + $2.trad;
                          }
          | SENTENCIAS SWITCH {
                                var nodo = new Nodo("SENTENCIAS","SENTENCIAS",+yylineno+1,+@1.first_column+1);
                                nodo.addHijo($1);
                                nodo.addHijo($2);
                                $$ = nodo;
                                $$.trad = $1.trad + $2.trad;
                              }
          | SENTENCIAS WHILE{
                              var nodo = new Nodo("SENTENCIAS","SENTENCIAS",+yylineno+1,+@1.first_column+1);
                              nodo.addHijo($1);
                              nodo.addHijo($2);
                              $$ = nodo;
                              $$.trad = $1.trad + $2.trad;
                            }
          | SENTENCIAS DOWHILE{
                                var nodo = new Nodo("SENTENCIAS","SENTENCIAS",+yylineno+1,+@1.first_column+1);
                                nodo.addHijo($1);
                                nodo.addHijo($2);
                                $$ = nodo;
                                $$.trad = $1.trad + $2.trad;
                              }
          | SENTENCIAS FOR{
                            var nodo = new Nodo("SENTENCIAS","SENTENCIAS",+yylineno+1,+@1.first_column+1);
                            nodo.addHijo($1);
                            nodo.addHijo($2);
                            $$ = nodo;
                            $$.trad = $1.trad + $2.trad;
                          }
          | SENTENCIAS ST {  
                            var nodo = new Nodo("SENTENCIAS","SENTENCIAS",+yylineno+1,+@1.first_column+1);
                            nodo.addHijo($1);
                            nodo.addHijo($2);
                            $$ = nodo;
                            $$.trad = $1.trad + $2.trad;
                          }
          | SENTENCIAS FESP {  
                              var nodo = new Nodo("SENTENCIAS","SENTENCIAS",+yylineno+1,+@1.first_column+1);
                              nodo.addHijo($1);
                              nodo.addHijo($2);
                              $$ = nodo;
                              $$.trad = $1.trad + $2.trad;
                            }
          | DECLARACION { $$ = $1; $$.trad = $1.trad; }
          | ASIGNACION { $$ = $1; $$.trad = $1.trad; }
          | IF { $$ = $1; $$.trad = $1.trad; }
          | SWITCH { $$ = $1; $$.trad = $1.trad; }
          | WHILE { $$ = $1; $$.trad = $1.trad; }
          | DOWHILE { $$ = $1; $$.trad = $1.trad; }
          | FOR { $$ = $1; $$.trad = $1.trad; }
          | ST { $$ = $1; $$.trad = $1.trad; }
          | FESP { $$ = $1; $$.trad = $1.trad; }
          | error {
                    console.error("Error sintactico: "+$1+" Desconocido Sentencias");
                    var error = new Error("Sintactico","Encontrado: "+$1+" Se esperaba -> DECLARACION||ASIGNACION||IF||SWITCH||WHILE||DO WHILE||SENTENCIAS DE TRANSFARENCIA||console.log()||graficar_ts()",+yylineno+1,+@1.last_column+1);
                    errores.addError(error);
                    $$ = new Nodo("","");
                    $$.trad = "";
                  };

IF: tk_if tk_pabierto L tk_pcerrado BSENTENCIAS ELSE{
                                                      var nodo = new Nodo("IF","IF",+yylineno+1,+@1.first_column+1);
                                                      nodo.addHijo($3); //condicion
                                                      nodo.addHijo($5); //sentencias
                                                      nodo.addHijo($6); //else
                                                      $$ = nodo;
                                                      $$.trad = $1+$2+$3.trad+$4+$5.trad+$6.trad;
                                                    }
  | tk_if tk_pabierto L tk_pcerrado BSENTENCIAS {
                                                  var nodo = new Nodo("IF","IF",+yylineno+1,+@1.first_column+1);
                                                  nodo.addHijo($3); //condicion
                                                  nodo.addHijo($5); //sentencias
                                                  $$ = nodo;
                                                  $$.trad = $1+$2+$3.trad+$4+$5.trad;
                                                }
  | tk_if error L tk_pcerrado BSENTENCIAS {
                                            console.error("Error Sintactico: "+$2+" Error parametros en if")
                                            var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                            errores.addError(error);

                                            var nodo = new Nodo("IF","IF",+yylineno+1,+@1.first_column+1);
                                            nodo.addHijo($3); //condicion
                                            nodo.addHijo($5); //sentencias
                                            $$ = nodo;
                                            $$.trad = $1+"("+$3.trad+$4+$5.trad;
                                          }
  | tk_if tk_pabierto L error BSENTENCIAS {
                                            console.error("Error Sintactico: "+$4+" Error parametros en if")
                                            var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> )",+yylineno+1,+@4.last_column+1);
                                            errores.addError(error);

                                            var nodo = new Nodo("IF","IF",+yylineno+1,+@1.first_column+1);
                                            nodo.addHijo($3); //condicion
                                            nodo.addHijo($5); //sentencias
                                            $$ = nodo;
                                            $$.trad = $1+$2+$3.trad+")"+$5.trad;
                                          }
  | tk_if error BSENTENCIAS {
                              console.error("Error Sintactico: "+$2+" Error parametros en if")
                              var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> Condicion en if",+yylineno+1,+@2.last_column+1);
                              errores.addError(error);

                              $$ = new Nodo("","");
                              $$.trad = "";
                            };

ELSE: tk_else BSENTENCIAS {
                            var nodo = new Nodo("ELSE","ELSE",+yylineno+1,+@1.first_column+1)
                            nodo.addHijo($2);

                            $$ = nodo;
                            $$.trad = $1+" "+$2.trad;
                          }
    | tk_else IF{
                  var nodo = new Nodo("ELSE","ELSE",+yylineno+1,+@1.first_column+1)
                  nodo.addHijo($2);

                  $$ = nodo;
                  $$.trad = $1+" "+$2.trad;
                };

SWITCH: tk_switch tk_pabierto L tk_pcerrado BSWITCH {
                                                      var nodo = new Nodo("SWITCH","SWITCH",+yylineno+1,+@1.first_column+1);
                                                      nodo.addHijo($3);
                                                      nodo.addHijo($5);
                                                      $$ = nodo;
                                                      $$.trad = $1+" "+$2+$3.trad+$4+$5.trad;
                                                    }
      | tk_switch error L tk_pcerrado BSWITCH {
                                                console.error("Error Sintactico: "+$2+" Error parametros en switch")
                                                var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                errores.addError(error);

                                                var nodo = new Nodo("SWITCH","SWITCH",+yylineno+1,+@1.first_column+1);
                                                nodo.addHijo($3);
                                                nodo.addHijo($5);
                                                $$ = nodo;
                                                $$.trad = $1+" ("+$3.trad+$4+$5.trad;
                                              }
      | tk_switch tk_pabierto L error BSWITCH {
                                                console.error("Error Sintactico: "+$4+" Error parametros en switch")
                                                var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> )",+yylineno+1,+@4.last_column+1);
                                                errores.addError(error);

                                                var nodo = new Nodo("SWITCH","SWITCH",+yylineno+1,+@1.first_column+1);
                                                nodo.addHijo($3);
                                                nodo.addHijo($5);
                                                $$ = nodo;
                                                $$.trad = $1+" "+$2+$3.trad+")"+$5.trad;
                                              }
      | tk_switch error BSWITCH { 
                                  console.error("Error Sintactico: "+$2+" Error parametros en switch")
                                  var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> condicion del switch",+yylineno+1,+@2.last_column+1);
                                  errores.addError(error);

                                  $$ = new Nodo("","");
                                  $$.trad = "";
                                };

BSWITCH: tk_llavea CASE DEFAULT tk_llavec {
                                            var nodo = new Nodo("BSWITCH","BSWITCH",+yylineno+1,+@1.first_column+1);
                                            nodo.addHijo($2);
                                            nodo.addHijo($3);
                                            $$ = nodo;
                                            $$.trad = $1+"\n"+$2.trad+$3.trad+$4+"\n";
                                          }
      |tk_llavea CASE tk_llavec {
                                  var nodo = new Nodo("BSWITCH","BSWITCH",+yylineno+1,+@1.first_column+1);
                                  nodo.addHijo($2);
                                  $$ = nodo;
                                  $$.trad = $1+"\n"+$2.trad+$3+"\n";
                                }
      |tk_llavea tk_llavec{
                            var nodo = new Nodo("BSWITCH","BSWITCH",+yylineno+1,+@1.first_column+1);
                            $$ = nodo;
                            $$.trad = $1+"\n"+$2+"\n";
                          }
      |tk_llavea error tk_llavec{ 
                                  console.error("Error Sintactico: "+$2+" Error Cases en switch");
                                  var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> CASE o DEFAULT",+yylineno+1,+@2.last_column+1);
                                  errores.addError(error);

                                  var nodo = new Nodo("BSWITCH","BSWITCH",+yylineno+1,+@1.first_column+1);
                                  $$ = nodo;
                                  $$.trad = $1+"\n"+$3+"\n";
                                };

CASE: CASE tk_case L tk_dospuntos SENTENCIAS{
                                              var nodo = new Nodo("CASE","CASE",+yylineno+1,+@1.first_column+1);
                                              nodo.addHijo($1);
                                              nodo.addHijo($3);
                                              nodo.addHijo($5);
                                              $$ = nodo;
                                              $$.trad = $1.trad+$2+" "+$3.trad+$4+"\n"+$5.trad;
                                            }
    | CASE tk_case error tk_dospuntos SENTENCIAS{
                                                  console.error("Error Sintactico: "+$3+" Error Cases en switch");
                                                  var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> Parametro case",+yylineno+1,+@3.last_column+1);
                                                  errores.addError(error);

                                                  $$ = $1;
                                                  $$.trad = $1.trad;
                                                }
    | CASE tk_case L tk_dospuntos BSENTENCIAS {
                                                var nodo = new Nodo("CASE","CASE",+yylineno+1,+@1.first_column+1);
                                                nodo.addHijo($1);
                                                nodo.addHijo($3);
                                                nodo.addHijo($5);
                                                $$ = nodo;
                                                $$.trad = $1.trad+$2+" "+$3.trad+$4+$5.trad;
                                              }
    | CASE tk_case error tk_dospuntos BSENTENCIAS{
                                                    console.error("Error Sintactico: "+$3+" Error Cases en switch");
                                                    var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> Parametro case",+yylineno+1,+@3.last_column+1);
                                                    errores.addError(error);

                                                    $$ = $1;
                                                    $$.trad = $1.trad;
                                                 }                                      
    | CASE tk_case L tk_dospuntos {
                                    var nodo = new Nodo("CASE","CASE",+yylineno+1,+@1.first_column+1);
                                    nodo.addHijo($1);
                                    nodo.addHijo($3);
                                    $$ = nodo;
                                    $$.trad = $1.trad+$2+" "+$3.trad+$4+"\n";
                                  }
    | CASE tk_case error tk_dospuntos {
                                        console.error("Error Sintactico: "+$3+" Error Cases en switch");
                                        var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> Parametro case",+yylineno+1,+@3.last_column+1);
                                        errores.addError(error);

                                        $$ = $1;
                                        $$.trad = $1.trad;
                                      }
    | tk_case L tk_dospuntos SENTENCIAS {
                                          var nodo = new Nodo("CASE","CASE",+yylineno+1,+@1.first_column+1);
                                          nodo.addHijo($2);
                                          nodo.addHijo($4);
                                          $$ = nodo;
                                          $$.trad = $1+" "+$2.trad+$3+"\n"+$4.trad;
                                        }
    | tk_case error tk_dospuntos SENTENCIAS {
                                              console.error("Error Sintactico: "+$2+" Error Cases en switch");
                                              var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> Parametro case",+yylineno+1,+@2.last_column+1);
                                              errores.addError(error);

                                              $$ = new Nodo("","");
                                              $$.trad = "";
                                            }
    | tk_case L tk_dospuntos BSENTENCIAS{
                                          var nodo = new Nodo("CASE","CASE",+yylineno+1,+@1.first_column+1);
                                          nodo.addHijo($2);
                                          nodo.addHijo($4);
                                          $$ = nodo;
                                          $$.trad = $1+" "+$2.trad+$3+$4.trad;
                                        }
    | tk_case error tk_dospuntos BSENTENCIAS{
                                              console.error("Error Sintactico: "+$2+" Error Cases en switch");
                                              var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> Parametro case",+yylineno+1,+@2.last_column+1);
                                              errores.addError(error);

                                              $$ = new Nodo("","");
                                              $$.trad = "";
                                            }
    | tk_case L tk_dospuntos{
                              var nodo = new Nodo("CASE","CASE",+yylineno+1,+@1.first_column+1);
                              nodo.addHijo($2);
                              $$ = nodo;
                              $$.trad = $1+" "+$2.trad+$3+"\n";
                            }
    | tk_case error tk_dospuntos{ 
                                  console.error("Error Sintactico: "+$2+" Error Cases en switch");
                                  var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> Parametro case",+yylineno+1,+@2.last_column+1);
                                  errores.addError(error);

                                  $$ = new Nodo("","");
                                  $$.trad = "";
                                };

DEFAULT: tk_default tk_dospuntos SENTENCIAS {
                                              var nodo = new Nodo("DEFAULT","DEFAULT",+yylineno+1,+@1.last_column+1);
                                              nodo.addHijo($3);
                                              $$ = nodo;
                                              $$.trad = $1+$2+"\n"+$3.trad;
                                            }
        |tk_default tk_dospuntos BSENTENCIAS{
                                              var nodo = new Nodo("DEFAULT","DEFAULT",+yylineno+1,+@1.last_column+1);
                                              nodo.addHijo($3);
                                              $$ = nodo;
                                              $$.trad = $1+$2+$3.trad;
                                            }
        |tk_default tk_dospuntos{
                                  var nodo = new Nodo("DEFAULT","DEFAULT",+yylineno+1,+@1.last_column+1);
                                  $$ = nodo;
                                  $$.trad = $1+$2+"\n";
                                };

WHILE: tk_while tk_pabierto L tk_pcerrado BSENTENCIAS {
                                                        var nodo = new Nodo("WHILE","WHILE",+yylineno+1,+@1.last_column+1);
                                                        nodo.addHijo($3);
                                                        nodo.addHijo($5);
                                                        $$ = nodo;
                                                        $$.trad = $1+$2+$3.trad+$4+$5.trad;
                                                      }
      |tk_while error L tk_pcerrado BSENTENCIAS {
                                                  console.error("Error Sintactico: "+$2+" Error en While");
                                                  var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                  errores.addError(error);

                                                  var nodo = new Nodo("WHILE","WHILE",+yylineno+1,+@1.last_column+1);
                                                  nodo.addHijo($3);
                                                  nodo.addHijo($5);
                                                  $$ = nodo;
                                                  $$.trad = $1+"("+$3.trad+$4+$5.trad;
                                                }
      |tk_while tk_pabierto error tk_pcerrado BSENTENCIAS {
                                                            console.error("Error Sintactico: "+$3+" Error en While");
                                                            var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> (",+yylineno+1,+@3.last_column+1);
                                                            errores.addError(error);

                                                            $$ = new Nodo("","");
                                                            $$.trad = "";
                                                          }
      |tk_while tk_pabierto L error BSENTENCIAS {
                                                  console.error("Error Sintactico: "+$4+" Error en While");
                                                  var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> (",+yylineno+1,+@4.last_column+1);
                                                  errores.addError(error);

                                                  var nodo = new Nodo("WHILE","WHILE",+yylineno+1,+@1.last_column+1);
                                                  nodo.addHijo($3);
                                                  nodo.addHijo($5);
                                                  $$ = nodo;
                                                  $$.trad = $1+$2+$3.trad+")"+$5.trad;
                                                }
      |tk_while error BSENTENCIAS {
                                    console.error("Error Sintactico: "+$3+" Error en While");
                                    var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> Parametros While",+yylineno+1,+@3.last_column+1);
                                    errores.addError(error);

                                    $$ = new Nodo("","");
                                    $$.trad = "";
                                  };

DOWHILE: tk_do BSENTENCIAS tk_while tk_pabierto L tk_pcerrado tk_puntoycoma {
                                                                              var nodo = new Nodo("DOWHILE","DOWHILE",+yylineno+1,+@1.last_column+1);
                                                                              nodo.addHijo($2);
                                                                              nodo.addHijo($5);
                                                                              $$ = nodo;
                                                                              $$.trad = $1+$2.trad+$3+$4+$5.trad+$6+$7+"\n";
                                                                            }
        |tk_do BSENTENCIAS tk_while error L tk_pcerrado tk_puntoycoma {
                                                                        console.error("Error Sintactico: "+$4+" Error en do While");
                                                                        var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> (",+yylineno+1,+@4.last_column+1);
                                                                        errores.addError(error);

                                                                        var nodo = new Nodo("DOWHILE","DOWHILE",+yylineno+1,+@1.last_column+1);
                                                                        nodo.addHijo($2);
                                                                        nodo.addHijo($5);
                                                                        $$ = nodo;
                                                                        $$.trad = $1+$2.trad+"("+$4+$5.trad+$6+$7+"\n";
                                                                      }
        |tk_do BSENTENCIAS tk_while tk_pabierto error tk_pcerrado tk_puntoycoma {
                                                                                  console.error("Error Sintactico: "+$5+" Error en do While");
                                                                                  var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> Parametros do While",+yylineno+1,+@5.last_column+1);
                                                                                  errores.addError(error);
                                                                                  
                                                                                  $$ = new Nodo("","");
                                                                                  $$.trad = "";
                                                                                }
        |tk_do BSENTENCIAS tk_while tk_pabierto L error tk_puntoycoma {
                                                                        console.error("Error Sintactico: "+$6+" Error en do While");
                                                                        var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> )",+yylineno+1,+@6.last_column+1);
                                                                        errores.addError(error);

                                                                        var nodo = new Nodo("DOWHILE","DOWHILE",+yylineno+1,+@1.last_column+1);
                                                                        nodo.addHijo($2);
                                                                        nodo.addHijo($5);
                                                                        $$ = nodo;
                                                                        $$.trad = $1+$2.trad+$3+$4+$5.trad+")"+$7+"\n";
                                                                      }
        |tk_do BSENTENCIAS tk_while tk_pabierto L tk_pcerrado error {
                                                                      console.error("Error Sintactico: "+$7+" Error en do While");
                                                                      var error = new Error("Sintactico","Encontrado: "+$7+" Se esperaba -> ;",+yylineno+1,+@7.last_column+1);
                                                                      errores.addError(error);

                                                                      var nodo = new Nodo("DOWHILE","DOWHILE",+yylineno+1,+@1.last_column+1);
                                                                      nodo.addHijo($2);
                                                                      nodo.addHijo($5);
                                                                      $$ = nodo;
                                                                      $$.trad = $1+$2.trad+$3+$4+$5.trad+$6+";\n";
                                                                    };

FOR: tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                        var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                        var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                        var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                        inc.addHijo(id2);
                                                                                                                        nodo.addHijo(id1);
                                                                                                                        nodo.addHijo($6);
                                                                                                                        nodo.addHijo($8);
                                                                                                                        nodo.addHijo(inc);
                                                                                                                        nodo.addHijo($13);
                                                                                                                        $$ = nodo;
                                                                                                                        $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                                      }
  | tk_for error tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS {  
                                                                                                                  console.error("Error Sintactico: "+$2+" Error en for");
                                                                                                                  var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                                                                                  errores.addError(error);

                                                                                                                  var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                  var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                  var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                  var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                  inc.addHijo(id2);
                                                                                                                  nodo.addHijo(id1);
                                                                                                                  nodo.addHijo($6);
                                                                                                                  nodo.addHijo($8);
                                                                                                                  nodo.addHijo(inc);
                                                                                                                  nodo.addHijo($13);
                                                                                                                  $$ = nodo;
                                                                                                                  $$.trad = $1+"("+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                                }
  | tk_for tk_pabierto error tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                                      console.error("Error Sintactico: "+$3+" Error en do While");
                                                                                                                      var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> let",+yylineno+1,+@3.last_column+1);
                                                                                                                      errores.addError(error);

                                                                                                                      var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                      var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                      var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                      var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                      inc.addHijo(id2);
                                                                                                                      nodo.addHijo(id1);
                                                                                                                      nodo.addHijo($6);
                                                                                                                      nodo.addHijo($8);
                                                                                                                      nodo.addHijo(inc);
                                                                                                                      nodo.addHijo($13);
                                                                                                                      $$ = nodo;
                                                                                                                      $$.trad = $1+$2+"let"+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;    
                                                                                                                    }
  | tk_for tk_pabierto tk_let error tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS {
                                                                                                                        console.error("Error Sintactico: "+$4+" Error en do While");
                                                                                                                        var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> id",+yylineno+1,+@4.last_column+1);
                                                                                                                        errores.addError(error);

                                                                                                                        $$ = new Nodo("","");
                                                                                                                        $$.trad = "";
                                                                                                                      }
  | tk_for tk_pabierto tk_let tk_id error VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                                    console.error("Error Sintactico: "+$5+" Error en do While");
                                                                                                                    var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> =",+yylineno+1,+@5.last_column+1);
                                                                                                                    errores.addError(error);

                                                                                                                    var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                    var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                    var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                    var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                    inc.addHijo(id2);
                                                                                                                    nodo.addHijo(id1);
                                                                                                                    nodo.addHijo($6);
                                                                                                                    nodo.addHijo($8);
                                                                                                                    nodo.addHijo(inc);
                                                                                                                    nodo.addHijo($13);
                                                                                                                    $$ = nodo;
                                                                                                                    $$.trad = $1+$2+$3+" "+$4+"="+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                                  }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR error L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                                console.error("Error Sintactico: "+$7+" Error en do While");
                                                                                                                var error = new Error("Sintactico","Encontrado: "+$7+" Se esperaba -> ;",+yylineno+1,+@7.last_column+1);
                                                                                                                errores.addError(error);

                                                                                                                var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                inc.addHijo(id2);
                                                                                                                nodo.addHijo(id1);
                                                                                                                nodo.addHijo($6);
                                                                                                                nodo.addHijo($8);
                                                                                                                nodo.addHijo(inc);
                                                                                                                nodo.addHijo($13);
                                                                                                                $$ = nodo;
                                                                                                                $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+";"+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                              }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma error tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS {
                                                                                                                            console.error("Error Sintactico: "+$8+" Error en do While");
                                                                                                                            var error = new Error("Sintactico","Encontrado: "+$8+" Se esperaba -> Condicion For",+yylineno+1,+@8.last_column+1);
                                                                                                                            errores.addError(error);

                                                                                                                            $$ = new Nodo("","");
                                                                                                                            $$.trad = "";
                                                                                                                          }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L error tk_id tk_inc tk_pcerrado BSENTENCIAS {
                                                                                                                console.error("Error Sintactico: "+$9+" Error en do While");
                                                                                                                var error = new Error("Sintactico","Encontrado: "+$9+" Se esperaba -> ;",+yylineno+1,+@9.last_column+1);
                                                                                                                errores.addError(error);

                                                                                                                var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                inc.addHijo(id2);
                                                                                                                nodo.addHijo(id1);
                                                                                                                nodo.addHijo($6);
                                                                                                                nodo.addHijo($8);
                                                                                                                nodo.addHijo(inc);
                                                                                                                nodo.addHijo($13);
                                                                                                                $$ = nodo;
                                                                                                                $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+";"+$10+$11+$12+$13.trad;
                                                                                                              }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma error tk_inc tk_pcerrado BSENTENCIAS {
                                                                                                                        console.error("Error Sintactico: "+$10+" Error en do While");
                                                                                                                        var error = new Error("Sintactico","Encontrado: "+$10+" Se esperaba -> id",+yylineno+1,+@2.last_column+1);
                                                                                                                        errores.addError(error);

                                                                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                        var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                        var id2 = new Nodo("ID",$4,+yylineno+1,+@10.last_column+1);
                                                                                                                        var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                        inc.addHijo(id2);
                                                                                                                        nodo.addHijo(id1);
                                                                                                                        nodo.addHijo($6);
                                                                                                                        nodo.addHijo($8);
                                                                                                                        nodo.addHijo(inc);
                                                                                                                        nodo.addHijo($13);
                                                                                                                        $$ = nodo;
                                                                                                                        $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$4+$11+$12+$13.trad;
                                                                                                                      }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id error tk_pcerrado BSENTENCIAS{
                                                                                                                      console.error("Error Sintactico: "+$11+" Error en do While");
                                                                                                                      var error = new Error("Sintactico","Encontrado: "+$11+" Se esperaba -> ++||--",+yylineno+1,+@11.last_column+1);
                                                                                                                      errores.addError(error);

                                                                                                                      var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                      var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                      var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                      var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                      inc.addHijo(id2);
                                                                                                                      nodo.addHijo(id1);
                                                                                                                      nodo.addHijo($6);
                                                                                                                      nodo.addHijo($8);
                                                                                                                      nodo.addHijo(inc);
                                                                                                                      nodo.addHijo($13);
                                                                                                                      $$ = nodo;
                                                                                                                      $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+"++"+$12+$13.trad;
                                                                                                                    }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc error BSENTENCIAS {
                                                                                                                  console.error("Error Sintactico: "+$12+" Error en do While");
                                                                                                                  var error = new Error("Sintactico","Encontrado: "+$12+" Se esperaba -> )",+yylineno+1,+@12.last_column+1);
                                                                                                                  errores.addError(error);

                                                                                                                  var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                  var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                  var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                  var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                  inc.addHijo(id2);
                                                                                                                  nodo.addHijo(id1);
                                                                                                                  nodo.addHijo($6);
                                                                                                                  nodo.addHijo($8);
                                                                                                                  nodo.addHijo(inc);
                                                                                                                  nodo.addHijo($13);
                                                                                                                  $$ = nodo;
                                                                                                                  $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                                }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado error {
                                                                                                                  console.error("Error Sintactico: "+$13+" Error en do While");
                                                                                                                  var error = new Error("Sintactico","Encontrado: "+$13+" Se esperaba -> SENTENCIAS",+yylineno+1,+@13.last_column+1);
                                                                                                                  errores.addError(error);

                                                                                                                  var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                  var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                  var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                  var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                  inc.addHijo(id2);
                                                                                                                  nodo.addHijo(id1);
                                                                                                                  nodo.addHijo($6);
                                                                                                                  nodo.addHijo($8);
                                                                                                                  nodo.addHijo(inc);
                                                                                                                  $$ = nodo;
                                                                                                                  $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+"{}\n";
                                                                                                                }

  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS {
                                                                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                        var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                        var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                        var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                        inc.addHijo(id2);
                                                                                                                        nodo.addHijo(id1);
                                                                                                                        nodo.addHijo($6);
                                                                                                                        nodo.addHijo($8);
                                                                                                                        nodo.addHijo(inc);
                                                                                                                        nodo.addHijo($13);
                                                                                                                        $$ = nodo;
                                                                                                                        $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                                      }
  | tk_for error tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS {  
                                                                                                                  console.error("Error Sintactico: "+$2+" Error en for");
                                                                                                                  var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                                                                                  errores.addError(error);

                                                                                                                  var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                  var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                  var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                  var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                  inc.addHijo(id2);
                                                                                                                  nodo.addHijo(id1);
                                                                                                                  nodo.addHijo($6);
                                                                                                                  nodo.addHijo($8);
                                                                                                                  nodo.addHijo(inc);
                                                                                                                  nodo.addHijo($13);
                                                                                                                  $$ = nodo;
                                                                                                                  $$.trad = $1+"("+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                                }
  | tk_for tk_pabierto error tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                                      console.error("Error Sintactico: "+$3+" Error en do While");
                                                                                                                      var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> let",+yylineno+1,+@3.last_column+1);
                                                                                                                      errores.addError(error);

                                                                                                                      var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                      var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                      var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                      var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                      inc.addHijo(id2);
                                                                                                                      nodo.addHijo(id1);
                                                                                                                      nodo.addHijo($6);
                                                                                                                      nodo.addHijo($8);
                                                                                                                      nodo.addHijo(inc);
                                                                                                                      nodo.addHijo($13);
                                                                                                                      $$ = nodo;
                                                                                                                      $$.trad = $1+$2+"let"+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;    
                                                                                                                    }
  | tk_for tk_pabierto tk_let error tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS {
                                                                                                                        console.error("Error Sintactico: "+$4+" Error en do While");
                                                                                                                        var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> id",+yylineno+1,+@4.last_column+1);
                                                                                                                        errores.addError(error);

                                                                                                                        $$ = new Nodo("","");
                                                                                                                        $$.trad = "";
                                                                                                                      }
  | tk_for tk_pabierto tk_let tk_id error VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                                    console.error("Error Sintactico: "+$5+" Error en do While");
                                                                                                                    var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> =",+yylineno+1,+@5.last_column+1);
                                                                                                                    errores.addError(error);

                                                                                                                    var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                    var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                    var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                    var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                    inc.addHijo(id2);
                                                                                                                    nodo.addHijo(id1);
                                                                                                                    nodo.addHijo($6);
                                                                                                                    nodo.addHijo($8);
                                                                                                                    nodo.addHijo(inc);
                                                                                                                    nodo.addHijo($13);
                                                                                                                    $$ = nodo;
                                                                                                                    $$.trad = $1+$2+$3+" "+$4+"="+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                                  }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR error L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS {
                                                                                                                console.error("Error Sintactico: "+$7+" Error en do While");
                                                                                                                var error = new Error("Sintactico","Encontrado: "+$7+" Se esperaba -> ;",+yylineno+1,+@7.last_column+1);
                                                                                                                errores.addError(error);

                                                                                                                var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                inc.addHijo(id2);
                                                                                                                nodo.addHijo(id1);
                                                                                                                nodo.addHijo($6);
                                                                                                                nodo.addHijo($8);
                                                                                                                nodo.addHijo(inc);
                                                                                                                nodo.addHijo($13);
                                                                                                                $$ = nodo;
                                                                                                                $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+";"+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                              }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma error tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS {
                                                                                                                            console.error("Error Sintactico: "+$8+" Error en do While");
                                                                                                                            var error = new Error("Sintactico","Encontrado: "+$8+" Se esperaba -> Condicion For",+yylineno+1,+@8.last_column+1);
                                                                                                                            errores.addError(error);

                                                                                                                            $$ = new Nodo("","");
                                                                                                                            $$.trad = "";
                                                                                                                          } 
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L error tk_id tk_dec tk_pcerrado BSENTENCIAS {
                                                                                                                        console.error("Error Sintactico: "+$9+" Error en do While");
                                                                                                                        var error = new Error("Sintactico","Encontrado: "+$9+" Se esperaba -> ;",+yylineno+1,+@9.last_column+1);
                                                                                                                        errores.addError(error);

                                                                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                        var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                        var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                        var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                        inc.addHijo(id2);
                                                                                                                        nodo.addHijo(id1);
                                                                                                                        nodo.addHijo($6);
                                                                                                                        nodo.addHijo($8);
                                                                                                                        nodo.addHijo(inc);
                                                                                                                        nodo.addHijo($13);
                                                                                                                        $$ = nodo;
                                                                                                                        $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+";"+$10+$11+$12+$13.trad;
                                                                                                                      } 
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma error tk_dec tk_pcerrado BSENTENCIAS {
                                                                                                                        console.error("Error Sintactico: "+$10+" Error en do While");
                                                                                                                        var error = new Error("Sintactico","Encontrado: "+$10+" Se esperaba -> id",+yylineno+1,+@2.last_column+1);
                                                                                                                        errores.addError(error);

                                                                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                        var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                        var id2 = new Nodo("ID",$4,+yylineno+1,+@10.last_column+1);
                                                                                                                        var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                        inc.addHijo(id2);
                                                                                                                        nodo.addHijo(id1);
                                                                                                                        nodo.addHijo($6);
                                                                                                                        nodo.addHijo($8);
                                                                                                                        nodo.addHijo(inc);
                                                                                                                        nodo.addHijo($13);
                                                                                                                        $$ = nodo;
                                                                                                                        $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$4+$11+$12+$13.trad;
                                                                                                                      }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec error BSENTENCIAS {
                                                                                                                  console.error("Error Sintactico: "+$12+" Error en do While");
                                                                                                                  var error = new Error("Sintactico","Encontrado: "+$12+" Se esperaba -> )",+yylineno+1,+@12.last_column+1);
                                                                                                                  errores.addError(error);

                                                                                                                  var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                  var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                  var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                  var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                  inc.addHijo(id2);
                                                                                                                  nodo.addHijo(id1);
                                                                                                                  nodo.addHijo($6);
                                                                                                                  nodo.addHijo($8);
                                                                                                                  nodo.addHijo(inc);
                                                                                                                  nodo.addHijo($13);
                                                                                                                  $$ = nodo;
                                                                                                                  $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+$13.trad;
                                                                                                                }
  | tk_for tk_pabierto tk_let tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado error {
                                                                                                                  console.error("Error Sintactico: "+$13+" Error en do While");
                                                                                                                  var error = new Error("Sintactico","Encontrado: "+$13+" Se esperaba -> SENTENCIAS",+yylineno+1,+@13.last_column+1);
                                                                                                                  errores.addError(error);

                                                                                                                  var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                  var id1 = new Nodo("ID",$4,+yylineno+1,+@4.last_column+1);
                                                                                                                  var id2 = new Nodo("ID",$10,+yylineno+1,+@10.last_column+1);
                                                                                                                  var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                  inc.addHijo(id2);
                                                                                                                  nodo.addHijo(id1);
                                                                                                                  nodo.addHijo($6);
                                                                                                                  nodo.addHijo($8);
                                                                                                                  nodo.addHijo(inc);
                                                                                                                  $$ = nodo;
                                                                                                                  $$.trad = $1+$2+$3+" "+$4+$5+$6.trad+$7+$8.trad+$9+$10+$11+$12+"{}\n";
                                                                                                                }

  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                                var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                                var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                                var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                inc.addHijo(id2);
                                                                                                                nodo.addHijo(id1);
                                                                                                                nodo.addHijo($5);
                                                                                                                nodo.addHijo($7);
                                                                                                                nodo.addHijo(inc);
                                                                                                                nodo.addHijo($12);
                                                                                                                $$ = nodo;
                                                                                                                $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+$8+$9+$10+$11+$12.trad;
                                                                                                              }
  | tk_for error tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                          console.error("Error Sintactico: "+$2+" Error en for");
                                                                                                          var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                                                                          errores.addError(error);

                                                                                                          var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                          var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                          var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                          var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                          inc.addHijo(id2);
                                                                                                          nodo.addHijo(id1);
                                                                                                          nodo.addHijo($5);
                                                                                                          nodo.addHijo($7);
                                                                                                          nodo.addHijo(inc);
                                                                                                          nodo.addHijo($12);
                                                                                                          $$ = nodo;
                                                                                                          $$.trad = $1+"("+$3+$4+$5.trad+$6+$7.trad+$8+$9+$10+$11+$12.trad;
                                                                                                        }
  | tk_for tk_pabierto error tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                                console.error("Error Sintactico: "+$3+" Error en for");
                                                                                                                var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> id",+yylineno+1,+@2.last_column+1);
                                                                                                                errores.addError(error);

                                                                                                                $$ = new Nodo("","");
                                                                                                                $$.trad = "";
                                                                                                              }
  | tk_for tk_pabierto tk_id error VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                              console.error("Error Sintactico: "+$4+" Error en for");
                                                                                                              var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> =",+yylineno+1,+@4.last_column+1);
                                                                                                              errores.addError(error);

                                                                                                              var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                              var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                              var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                              var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                              inc.addHijo(id2);
                                                                                                              nodo.addHijo(id1);
                                                                                                              nodo.addHijo($5);
                                                                                                              nodo.addHijo($7);
                                                                                                              nodo.addHijo(inc);
                                                                                                              nodo.addHijo($12);
                                                                                                              $$ = nodo;
                                                                                                              $$.trad = $1+$2+$3+"="+$5.trad+$6+$7.trad+$8+$9+$10+$11+$12.trad;
                                                                                                            }
  | tk_for tk_pabierto tk_id tk_igual VALOR error L tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                        console.error("Error Sintactico: "+$6+" Error en for");
                                                                                                        var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> ;",+yylineno+1,+@6.last_column+1);
                                                                                                        errores.addError(error);

                                                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                        var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                        var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                        var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                        inc.addHijo(id2);
                                                                                                        nodo.addHijo(id1);
                                                                                                        nodo.addHijo($5);
                                                                                                        nodo.addHijo($7);
                                                                                                        nodo.addHijo(inc);
                                                                                                        nodo.addHijo($12);
                                                                                                        $$ = nodo;
                                                                                                        $$.trad = $1+$2+$3+$4+$5.trad+";"+$7.trad+$8+$9+$10+$11+$12.trad;
                                                                                                      }
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma error tk_puntoycoma tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                                    console.error("Error Sintactico: "+$7+" Error en for");
                                                                                                                    var error = new Error("Sintactico","Encontrado: "+$7+" Se esperaba -> condicion for",+yylineno+1,+@6.last_column+1);
                                                                                                                    errores.addError(error);

                                                                                                                    $$ = new Nodo("","");
                                                                                                                    $$.trad = "";
                                                                                                                  } 
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L error tk_id tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                        console.error("Error Sintactico: "+$8+" Error en for");
                                                                                                        var error = new Error("Sintactico","Encontrado: "+$8+" Se esperaba -> ;",+yylineno+1,+@8.last_column+1);
                                                                                                        errores.addError(error);

                                                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                        var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                        var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                        var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                        inc.addHijo(id2);
                                                                                                        nodo.addHijo(id1);
                                                                                                        nodo.addHijo($5);
                                                                                                        nodo.addHijo($7);
                                                                                                        nodo.addHijo(inc);
                                                                                                        nodo.addHijo($12);
                                                                                                        $$ = nodo;
                                                                                                        $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+";"+$9+$10+$11+$12.trad;
                                                                                                      }
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma error tk_inc tk_pcerrado BSENTENCIAS{
                                                                                                                console.error("Error Sintactico: "+$9+" Error en for");
                                                                                                                var error = new Error("Sintactico","Encontrado: "+$9+" Se esperaba -> id",+yylineno+1,+@9.last_column+1);
                                                                                                                errores.addError(error);

                                                                                                                var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                                var id2 = new Nodo("ID",$3,+yylineno+1,+@10.last_column+1);
                                                                                                                var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                inc.addHijo(id2);
                                                                                                                nodo.addHijo(id1);
                                                                                                                nodo.addHijo($5);
                                                                                                                nodo.addHijo($7);
                                                                                                                nodo.addHijo(inc);
                                                                                                                nodo.addHijo($12);
                                                                                                                $$ = nodo;
                                                                                                                $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+$8+$3+$10+$11+$12.trad;
                                                                                                              }
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id error tk_pcerrado BSENTENCIAS {  
                                                                                                                console.error("Error Sintactico: "+$10+" Error en for");
                                                                                                                var error = new Error("Sintactico","Encontrado: "+$10+" Se esperaba -> ++||--",+yylineno+1,+@10.last_column+1);
                                                                                                                errores.addError(error);

                                                                                                                var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                                var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                                var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                inc.addHijo(id2);
                                                                                                                nodo.addHijo(id1);
                                                                                                                nodo.addHijo($5);
                                                                                                                nodo.addHijo($7);
                                                                                                                nodo.addHijo(inc);
                                                                                                                nodo.addHijo($12);
                                                                                                                $$ = nodo;
                                                                                                                $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+$8+$9+"++"+$11+$12.trad;
                                                                                                              }
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc error BSENTENCIAS{  
                                                                                                          console.error("Error Sintactico: "+$11+" Error en for");
                                                                                                          var error = new Error("Sintactico","Encontrado: "+$11+" Se esperaba -> )",+yylineno+1,+@11.last_column+1);
                                                                                                          errores.addError(error);

                                                                                                          var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                          var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                          var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                          var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                          inc.addHijo(id2);
                                                                                                          nodo.addHijo(id1);
                                                                                                          nodo.addHijo($5);
                                                                                                          nodo.addHijo($7);
                                                                                                          nodo.addHijo(inc);
                                                                                                          nodo.addHijo($12);
                                                                                                          $$ = nodo;
                                                                                                          $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+$8+$9+$10+")"+$12.trad;
                                                                                                        }
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_inc tk_pcerrado error{  
                                                                                                          console.error("Error Sintactico: "+$12+" Error en for");
                                                                                                          var error = new Error("Sintactico","Encontrado: "+$12+" Se esperaba -> Sentencias",+yylineno+1,+@11.last_column+1);
                                                                                                          errores.addError(error);

                                                                                                          var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                          var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                          var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                          var inc = new Nodo("INCREMENTO","INCREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                          inc.addHijo(id2);
                                                                                                          nodo.addHijo(id1);
                                                                                                          nodo.addHijo($5);
                                                                                                          nodo.addHijo($7);
                                                                                                          nodo.addHijo(inc);
                                                                                                          $$ = nodo;
                                                                                                          $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+$8+$9+$10+$11+"{}\n";
                                                                                                        }

  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                                var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                                var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                                var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                inc.addHijo(id2);
                                                                                                                nodo.addHijo(id1);
                                                                                                                nodo.addHijo($5);
                                                                                                                nodo.addHijo($7);
                                                                                                                nodo.addHijo(inc);
                                                                                                                nodo.addHijo($12);
                                                                                                                $$ = nodo;
                                                                                                                $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+$8+$9+$10+$11+$12.trad;
                                                                                                              }
  | tk_for error tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                          console.error("Error Sintactico: "+$2+" Error en for");
                                                                                                          var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                                                                          errores.addError(error);

                                                                                                          var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                          var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                          var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                          var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                          inc.addHijo(id2);
                                                                                                          nodo.addHijo(id1);
                                                                                                          nodo.addHijo($5);
                                                                                                          nodo.addHijo($7);
                                                                                                          nodo.addHijo(inc);
                                                                                                          nodo.addHijo($12);
                                                                                                          $$ = nodo;
                                                                                                          $$.trad = $1+"("+$3+$4+$5.trad+$6+$7.trad+$8+$9+$10+$11+$12.trad;
                                                                                                        }
  | tk_for tk_pabierto error tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                                console.error("Error Sintactico: "+$3+" Error en for");
                                                                                                                var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> id",+yylineno+1,+@2.last_column+1);
                                                                                                                errores.addError(error);

                                                                                                                $$ = new Nodo("","");
                                                                                                                $$.trad = "";
                                                                                                              }
  | tk_for tk_pabierto tk_id error VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                              console.error("Error Sintactico: "+$4+" Error en for");
                                                                                                              var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> =",+yylineno+1,+@4.last_column+1);
                                                                                                              errores.addError(error);

                                                                                                              var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                              var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                              var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                              var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                              inc.addHijo(id2);
                                                                                                              nodo.addHijo(id1);
                                                                                                              nodo.addHijo($5);
                                                                                                              nodo.addHijo($7);
                                                                                                              nodo.addHijo(inc);
                                                                                                              nodo.addHijo($12);
                                                                                                              $$ = nodo;
                                                                                                              $$.trad = $1+$2+$3+"="+$5.trad+$6+$7.trad+$8+$9+$10+$11+$12.trad;
                                                                                                            }
  | tk_for tk_pabierto tk_id tk_igual VALOR error L tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                        console.error("Error Sintactico: "+$6+" Error en for");
                                                                                                        var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> ;",+yylineno+1,+@6.last_column+1);
                                                                                                        errores.addError(error);

                                                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                        var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                        var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                        var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                        inc.addHijo(id2);
                                                                                                        nodo.addHijo(id1);
                                                                                                        nodo.addHijo($5);
                                                                                                        nodo.addHijo($7);
                                                                                                        nodo.addHijo(inc);
                                                                                                        nodo.addHijo($12);
                                                                                                        $$ = nodo;
                                                                                                        $$.trad = $1+$2+$3+$4+$5.trad+";"+$7.trad+$8+$9+$10+$11+$12.trad;
                                                                                                      }
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma error tk_puntoycoma tk_id tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                                    console.error("Error Sintactico: "+$7+" Error en for");
                                                                                                                    var error = new Error("Sintactico","Encontrado: "+$7+" Se esperaba -> condicion for",+yylineno+1,+@6.last_column+1);
                                                                                                                    errores.addError(error);

                                                                                                                    $$ = new Nodo("","");
                                                                                                                    $$.trad = "";
                                                                                                                  } 
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L error tk_id tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                        console.error("Error Sintactico: "+$8+" Error en for");
                                                                                                        var error = new Error("Sintactico","Encontrado: "+$8+" Se esperaba -> ;",+yylineno+1,+@8.last_column+1);
                                                                                                        errores.addError(error);

                                                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                        var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                        var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                        var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                        inc.addHijo(id2);
                                                                                                        nodo.addHijo(id1);
                                                                                                        nodo.addHijo($5);
                                                                                                        nodo.addHijo($7);
                                                                                                        nodo.addHijo(inc);
                                                                                                        nodo.addHijo($12);
                                                                                                        $$ = nodo;
                                                                                                        $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+";"+$9+$10+$11+$12.trad;
                                                                                                      }
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma error tk_dec tk_pcerrado BSENTENCIAS{
                                                                                                                console.error("Error Sintactico: "+$9+" Error en for");
                                                                                                                var error = new Error("Sintactico","Encontrado: "+$9+" Se esperaba -> id",+yylineno+1,+@9.last_column+1);
                                                                                                                errores.addError(error);

                                                                                                                var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                                var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                                var id2 = new Nodo("ID",$3,+yylineno+1,+@10.last_column+1);
                                                                                                                var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                                inc.addHijo(id2);
                                                                                                                nodo.addHijo(id1);
                                                                                                                nodo.addHijo($5);
                                                                                                                nodo.addHijo($7);
                                                                                                                nodo.addHijo(inc);
                                                                                                                nodo.addHijo($12);
                                                                                                                $$ = nodo;
                                                                                                                $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+$8+$3+$10+$11+$12.trad;
                                                                                                              }
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec error BSENTENCIAS{  
                                                                                                          console.error("Error Sintactico: "+$11+" Error en for");
                                                                                                          var error = new Error("Sintactico","Encontrado: "+$11+" Se esperaba -> )",+yylineno+1,+@11.last_column+1);
                                                                                                          errores.addError(error);

                                                                                                          var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                          var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                          var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                          var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                          inc.addHijo(id2);
                                                                                                          nodo.addHijo(id1);
                                                                                                          nodo.addHijo($5);
                                                                                                          nodo.addHijo($7);
                                                                                                          nodo.addHijo(inc);
                                                                                                          nodo.addHijo($12);
                                                                                                          $$ = nodo;
                                                                                                          $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+$8+$9+$10+")"+$12.trad;
                                                                                                        }
  | tk_for tk_pabierto tk_id tk_igual VALOR tk_puntoycoma L tk_puntoycoma tk_id tk_dec tk_pcerrado error{  
                                                                                                          console.error("Error Sintactico: "+$12+" Error en for");
                                                                                                          var error = new Error("Sintactico","Encontrado: "+$12+" Se esperaba -> Sentencias",+yylineno+1,+@11.last_column+1);
                                                                                                          errores.addError(error);

                                                                                                          var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                                                          var id1 = new Nodo("ID",$3,+yylineno+1,+@3.last_column+1);
                                                                                                          var id2 = new Nodo("ID",$9,+yylineno+1,+@10.last_column+1);
                                                                                                          var inc = new Nodo("DECREMENTO","DECREMENTO",+yylineno+1,+@9.last_column+1);
                                                                                                          inc.addHijo(id2);
                                                                                                          nodo.addHijo(id1);
                                                                                                          nodo.addHijo($5);
                                                                                                          nodo.addHijo($7);
                                                                                                          nodo.addHijo(inc);
                                                                                                          $$ = nodo;
                                                                                                          $$.trad = $1+$2+$3+$4+$5.trad+$6+$7.trad+$8+$9+$10+$11+"{}\n";
                                                                                                        }

  | tk_for tk_pabierto tk_id tk_in tk_id tk_pcerrado BSENTENCIAS{
                                                                  var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                  var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                                  var id1 = new Nodo("ID",$3);
                                                                  var id2 = new Nodo("ID",$5);
                                                                  fin.addHijo(id1);
                                                                  fin.addHijo(id2);
                                                                  nodo.addHijo(fin);
                                                                  nodo.addHijo($7);
                                                                  $$ = nodo;
                                                                  $$.trad = $1+$2+$3+" "+$4+" "+$5+$6+$7.trad;
                                                                }
  | tk_for error tk_id tk_in tk_id tk_pcerrado BSENTENCIAS{
                                                            console.error("Error Sintactico: "+$2+" Error en for");
                                                            var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                            errores.addError(error);

                                                            var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                            var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                            var id1 = new Nodo("ID",$3);
                                                            var id2 = new Nodo("ID",$5);
                                                            fin.addHijo(id1);
                                                            fin.addHijo(id2);
                                                            nodo.addHijo(fin);
                                                            nodo.addHijo($7);
                                                            $$ = nodo;
                                                            $$.trad = $1+"("+$3+" "+$4+" "+$5+$6+$7.trad;
                                                          }
  | tk_for tk_pabierto error tk_in tk_id tk_pcerrado BSENTENCIAS{
                                                                  console.error("Error Sintactico: "+$3+" Error en for");
                                                                  var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> id",+yylineno+1,+@3.last_column+1);
                                                                  errores.addError(error);

                                                                  $$ = new Nodo("","")
                                                                  $$.trad = "";
                                                                }
  | tk_for tk_pabierto tk_id tk_in error tk_pcerrado BSENTENCIAS{
                                                                  console.error("Error Sintactico: "+$5+" Error en for");
                                                                  var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> id",+yylineno+1,+@5.last_column+1);
                                                                  errores.addError(error);

                                                                  $$ = new Nodo("","")
                                                                  $$.trad = "";
                                                                }
  | tk_for tk_pabierto tk_id tk_in tk_id error BSENTENCIAS{
                                                            console.error("Error Sintactico: "+$6+" Error en for");
                                                            var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> )",+yylineno+1,+@6.last_column+1);
                                                            errores.addError(error);

                                                            var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                            var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                            var id1 = new Nodo("ID",$3);
                                                            var id2 = new Nodo("ID",$5);
                                                            fin.addHijo(id1);
                                                            fin.addHijo(id2);
                                                            nodo.addHijo(fin);
                                                            nodo.addHijo($7);
                                                            $$ = nodo;
                                                            $$.trad = $1+$2+$3+" "+$4+" "+$5+")"+$7.trad;
                                                          }
  | tk_for tk_pabierto tk_id tk_in tk_id tk_pcerrado error{
                                                            console.error("Error Sintactico: "+$6+" Error en for");
                                                            var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> Sentencias",+yylineno+1,+@6.last_column+1);
                                                            errores.addError(error);

                                                            var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                            var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                            var id1 = new Nodo("ID",$3);
                                                            var id2 = new Nodo("ID",$5);
                                                            fin.addHijo(id1);
                                                            fin.addHijo(id2);
                                                            nodo.addHijo(fin);
                                                            nodo.addHijo($7);
                                                            $$ = nodo;
                                                            $$.trad = $1+$2+$3+" "+$4+" "+$5+")"+$7.trad;
                                                          }

  | tk_for tk_pabierto tk_let tk_id tk_in tk_id tk_pcerrado BSENTENCIAS {
                                                                          var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                          var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                                          var dec = new Nodo("DECLARACION","LET");
                                                                          var id1 = new Nodo("ID",$3);
                                                                          var id2 = new Nodo("ID",$6);
                                                                          dec.addHijo(id1);
                                                                          fin.addHijo(dec);
                                                                          fin.addHijo(id2);
                                                                          nodo.addHijo(fin);
                                                                          nodo.addHijo($8);
                                                                          $$ = nodo;
                                                                          $$.trad = $1+$2+$3+" "+$4+" "+$5+" "+$6+$7+$8.trad;
                                                                        }                                                                        
  | tk_for error tk_let tk_id tk_in tk_id tk_pcerrado BSENTENCIAS {
                                                                    console.error("Error Sintactico: "+$2+" Error en for");
                                                                    var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                                    errores.addError(error);

                                                                    var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                    var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                                    var dec = new Nodo("DECLARACION","LET");
                                                                    var id1 = new Nodo("ID",$3);
                                                                    var id2 = new Nodo("ID",$6);
                                                                    dec.addHijo(id1);
                                                                    fin.addHijo(dec);
                                                                    fin.addHijo(id2);
                                                                    nodo.addHijo(fin);
                                                                    nodo.addHijo($8);
                                                                    $$ = nodo;
                                                                    $$.trad = $1+"("+$3+" "+$4+" "+$5+" "+$6+$7+$8.trad;
                                                                  }  
  | tk_for tk_pabierto error tk_id tk_in tk_id tk_pcerrado BSENTENCIAS{
                                                                        console.error("Error Sintactico: "+$3+" Error en for");
                                                                        var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> let",+yylineno+1,+@3.last_column+1);
                                                                        errores.addError(error);

                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                        var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                                        var dec = new Nodo("DECLARACION","LET");
                                                                        var id1 = new Nodo("ID",$3);
                                                                        var id2 = new Nodo("ID",$6);
                                                                        dec.addHijo(id1);
                                                                        fin.addHijo(dec);
                                                                        fin.addHijo(id2);
                                                                        nodo.addHijo(fin);
                                                                        nodo.addHijo($8);
                                                                        $$ = nodo;
                                                                        $$.trad = $1+$2+"let"+" "+$4+" "+$5+" "+$6+$7+$8.trad;
                                                                      } 
  | tk_for tk_pabierto tk_let error tk_in tk_id tk_pcerrado BSENTENCIAS {
                                                                          console.error("Error Sintactico: "+$4+" Error en for");
                                                                          var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> id",+yylineno+1,+@3.last_column+1);
                                                                          errores.addError(error);

                                                                          $$ = new Nodo("","");
                                                                          $$.trad = "";
                                                                        }
  | tk_for tk_pabierto tk_let tk_id error tk_id tk_pcerrado BSENTENCIAS {
                                                                          console.error("Error Sintactico: "+$5+" Error en for");
                                                                          var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> in, of",+yylineno+1,+@5.last_column+1);
                                                                          errores.addError(error);

                                                                          $$ = new Nodo("","");
                                                                          $$.trad = "";
                                                                        }
  | tk_for tk_pabierto tk_let tk_id tk_in error tk_pcerrado BSENTENCIAS {
                                                                          console.error("Error Sintactico: "+$6+" Error en for");
                                                                          var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> id",+yylineno+1,+@6.last_column+1);
                                                                          errores.addError(error);

                                                                          $$ = new Nodo("","");
                                                                          $$.trad = "";
                                                                        }
  | tk_for tk_pabierto tk_let tk_id tk_in tk_id error BSENTENCIAS {
                                                                    console.error("Error Sintactico: "+$7+" Error en for");
                                                                    var error = new Error("Sintactico","Encontrado: "+$7+" Se esperaba -> )",+yylineno+1,+@7.last_column+1);
                                                                    errores.addError(error);

                                                                    var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                    var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                                    var dec = new Nodo("DECLARACION","LET");
                                                                    var id1 = new Nodo("ID",$3);
                                                                    var id2 = new Nodo("ID",$6);
                                                                    dec.addHijo(id1);
                                                                    fin.addHijo(dec);
                                                                    fin.addHijo(id2);
                                                                    nodo.addHijo(fin);
                                                                    nodo.addHijo($8);
                                                                    $$ = nodo;
                                                                    $$.trad = $1+$2+$3+" "+$4+" "+$5+" "+$6+")"+$8.trad;
                                                                  }
  | tk_for tk_pabierto tk_let tk_id tk_in tk_id tk_pcerrado error {
                                                                    console.error("Error Sintactico: "+$8+" Error en for");
                                                                    var error = new Error("Sintactico","Encontrado: "+$8+" Se esperaba -> Sentencias",+yylineno+1,+@8.last_column+1);
                                                                    errores.addError(error);

                                                                    var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                    var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                                    var dec = new Nodo("DECLARACION","LET");
                                                                    var id1 = new Nodo("ID",$3);
                                                                    var id2 = new Nodo("ID",$6);
                                                                    dec.addHijo(id1);
                                                                    fin.addHijo(dec);
                                                                    fin.addHijo(id2);
                                                                    nodo.addHijo(fin);
                                                                    $$ = nodo;
                                                                    $$.trad = $1+$2+$3+" "+$4+" "+$5+" "+$6+$7+"{}\n";
                                                                  }

  | tk_for tk_pabierto tk_id tk_of tk_id tk_pcerrado BSENTENCIAS{
                                                                  var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                  var fin = new Nodo("OF","OF",+yylineno+1,+@4.last_column+1);
                                                                  var id1 = new Nodo("ID",$3);
                                                                  var id2 = new Nodo("ID",$5);
                                                                  fin.addHijo(id1);
                                                                  fin.addHijo(id2);
                                                                  nodo.addHijo(fin);
                                                                  nodo.addHijo($7);
                                                                  $$ = nodo;
                                                                  $$.trad = $1+$2+$3+" "+$4+" "+$5+$6+$7.trad;
                                                                }
  | tk_for error tk_id tk_of tk_id tk_pcerrado BSENTENCIAS{
                                                            console.error("Error Sintactico: "+$2+" Error en for");
                                                            var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                            errores.addError(error);

                                                            var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                            var fin = new Nodo("OF","OF",+yylineno+1,+@4.last_column+1);
                                                            var id1 = new Nodo("ID",$3);
                                                            var id2 = new Nodo("ID",$5);
                                                            fin.addHijo(id1);
                                                            fin.addHijo(id2);
                                                            nodo.addHijo(fin);
                                                            nodo.addHijo($7);
                                                            $$ = nodo;
                                                            $$.trad = $1+"("+$3+" "+$4+" "+$5+$6+$7.trad;
                                                          }
  | tk_for tk_pabierto error tk_of tk_id tk_pcerrado BSENTENCIAS{
                                                                  console.error("Error Sintactico: "+$3+" Error en for");
                                                                  var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> id",+yylineno+1,+@3.last_column+1);
                                                                  errores.addError(error);

                                                                  $$ = new Nodo("","")
                                                                  $$.trad = "";
                                                                }
  | tk_for tk_pabierto tk_id error tk_id tk_pcerrado BSENTENCIAS{
                                                                  console.error("Error Sintactico: "+$4+" Error en for");
                                                                  var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> in||of",+yylineno+1,+@4.last_column+1);
                                                                  errores.addError(error);

                                                                  $$ = new Nodo("","")
                                                                  $$.trad = "";
                                                                }
  | tk_for tk_pabierto tk_id tk_of error tk_pcerrado BSENTENCIAS{
                                                                  console.error("Error Sintactico: "+$5+" Error en for");
                                                                  var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> id",+yylineno+1,+@5.last_column+1);
                                                                  errores.addError(error);

                                                                  $$ = new Nodo("","")
                                                                  $$.trad = "";
                                                                }
  | tk_for tk_pabierto tk_id tk_of tk_id error BSENTENCIAS{
                                                            console.error("Error Sintactico: "+$6+" Error en for");
                                                            var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> )",+yylineno+1,+@6.last_column+1);
                                                            errores.addError(error);

                                                            var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                            var fin = new Nodo("OF","OF",+yylineno+1,+@4.last_column+1);
                                                            var id1 = new Nodo("ID",$3);
                                                            var id2 = new Nodo("ID",$5);
                                                            fin.addHijo(id1);
                                                            fin.addHijo(id2);
                                                            nodo.addHijo(fin);
                                                            nodo.addHijo($7);
                                                            $$ = nodo;
                                                            $$.trad = $1+$2+$3+" "+$4+" "+$5+")"+$7.trad;
                                                          }
  | tk_for tk_pabierto tk_id tk_of tk_id tk_pcerrado error{
                                                            console.error("Error Sintactico: "+$6+" Error en for");
                                                            var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> Sentencias",+yylineno+1,+@6.last_column+1);
                                                            errores.addError(error);

                                                            var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                            var fin = new Nodo("IN","IN",+yylineno+1,+@4.last_column+1);
                                                            var id1 = new Nodo("ID",$3);
                                                            var id2 = new Nodo("ID",$5);
                                                            fin.addHijo(id1);
                                                            fin.addHijo(id2);
                                                            nodo.addHijo(fin);
                                                            nodo.addHijo($7);
                                                            $$ = nodo;
                                                            $$.trad = $1+$2+$3+" "+$4+" "+$5+")"+$7.trad;
                                                          }

  | tk_for tk_pabierto tk_let tk_id tk_of tk_id tk_pcerrado BSENTENCIAS {
                                                                          var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                          var fin = new Nodo("OF","OF",+yylineno+1,+@4.last_column+1);
                                                                          var dec = new Nodo("DECLARACION","LET");
                                                                          var id1 = new Nodo("ID",$3);
                                                                          var id2 = new Nodo("ID",$6);
                                                                          dec.addHijo(id1);
                                                                          fin.addHijo(dec);
                                                                          fin.addHijo(id2);
                                                                          nodo.addHijo(fin);
                                                                          nodo.addHijo($8);
                                                                          $$ = nodo;
                                                                          $$.trad = $1+$2+$3+" "+$4+" "+$5+" "+$6+$7+$8.trad;
                                                                        } 
  | tk_for error tk_let tk_id tk_of tk_id tk_pcerrado BSENTENCIAS {
                                                                    console.error("Error Sintactico: "+$2+" Error en for");
                                                                    var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> (",+yylineno+1,+@2.last_column+1);
                                                                    errores.addError(error);

                                                                    var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                    var fin = new Nodo("OF","OF",+yylineno+1,+@4.last_column+1);
                                                                    var dec = new Nodo("DECLARACION","LET");
                                                                    var id1 = new Nodo("ID",$3);
                                                                    var id2 = new Nodo("ID",$6);
                                                                    dec.addHijo(id1);
                                                                    fin.addHijo(dec);
                                                                    fin.addHijo(id2);
                                                                    nodo.addHijo(fin);
                                                                    nodo.addHijo($8);
                                                                    $$ = nodo;
                                                                    $$.trad = $1+"("+$3+" "+$4+" "+$5+" "+$6+$7+$8.trad;
                                                                  } 
  | tk_for tk_pabierto error tk_id tk_of tk_id tk_pcerrado BSENTENCIAS{
                                                                        console.error("Error Sintactico: "+$3+" Error en for");
                                                                        var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> let",+yylineno+1,+@3.last_column+1);
                                                                        errores.addError(error);

                                                                        var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                        var fin = new Nodo("OF","OF",+yylineno+1,+@4.last_column+1);
                                                                        var dec = new Nodo("DECLARACION","LET");
                                                                        var id1 = new Nodo("ID",$3);
                                                                        var id2 = new Nodo("ID",$6);
                                                                        dec.addHijo(id1);
                                                                        fin.addHijo(dec);
                                                                        fin.addHijo(id2);
                                                                        nodo.addHijo(fin);
                                                                        nodo.addHijo($8);
                                                                        $$ = nodo;
                                                                        $$.trad = $1+$2+"let"+" "+$4+" "+$5+" "+$6+$7+$8.trad;
                                                                      } 
  | tk_for tk_pabierto tk_let error tk_of tk_id tk_pcerrado BSENTENCIAS {
                                                                          console.error("Error Sintactico: "+$4+" Error en for");
                                                                          var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> id",+yylineno+1,+@4.last_column+1);
                                                                          errores.addError(error);

                                                                          $$ = new Nodo("","");
                                                                          $$.trad = "";
                                                                        }
  | tk_for tk_pabierto tk_let tk_id tk_of error tk_pcerrado BSENTENCIAS {
                                                                          console.error("Error Sintactico: "+$6+" Error en for");
                                                                          var error = new Error("Sintactico","Encontrado: "+$6+" Se esperaba -> id",+yylineno+1,+@6.last_column+1);
                                                                          errores.addError(error);

                                                                          $$ = new Nodo("","");
                                                                          $$.trad = "";
                                                                        }
  | tk_for tk_pabierto tk_let tk_id tk_of tk_id error BSENTENCIAS {
                                                                    console.error("Error Sintactico: "+$7+" Error en for");
                                                                    var error = new Error("Sintactico","Encontrado: "+$7+" Se esperaba -> )",+yylineno+1,+@7.last_column+1);
                                                                    errores.addError(error);

                                                                    var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                    var fin = new Nodo("OF","OF",+yylineno+1,+@4.last_column+1);
                                                                    var dec = new Nodo("DECLARACION","LET");
                                                                    var id1 = new Nodo("ID",$3);
                                                                    var id2 = new Nodo("ID",$6);
                                                                    dec.addHijo(id1);
                                                                    fin.addHijo(dec);
                                                                    fin.addHijo(id2);
                                                                    nodo.addHijo(fin);
                                                                    nodo.addHijo($8);
                                                                    $$ = nodo;
                                                                    $$.trad = $1+$2+$3+" "+$4+" "+$5+" "+$6+")"+$8.trad;
                                                                  }
  | tk_for tk_pabierto tk_let tk_id tk_of tk_id tk_pcerrado error {
                                                                    console.error("Error Sintactico: "+$8+" Error en for");
                                                                    var error = new Error("Sintactico","Encontrado: "+$8+" Se esperaba -> Sentencias",+yylineno+1,+@8.last_column+1);
                                                                    errores.addError(error);

                                                                    var nodo = new Nodo("FOR","FOR",+yylineno+1,+@1.last_column+1);
                                                                    var fin = new Nodo("OF","OF",+yylineno+1,+@4.last_column+1);
                                                                    var dec = new Nodo("DECLARACION","LET");
                                                                    var id1 = new Nodo("ID",$3);
                                                                    var id2 = new Nodo("ID",$6);
                                                                    dec.addHijo(id1);
                                                                    fin.addHijo(dec);
                                                                    fin.addHijo(id2);
                                                                    nodo.addHijo(fin);
                                                                    $$ = nodo;
                                                                    $$.trad = $1+$2+$3+" "+$4+" "+$5+" "+$6+$7+"{}\n";
                                                                  }

  | tk_for tk_pabierto error tk_pcerrado BSENTENCIAS{ 
                                                      console.error("Error Sintactico: "+$3+" Error en for");
                                                      var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> Sentencias",+yylineno+1,+@3.last_column+1);
                                                      errores.addError(error);

                                                      $$ = new Nodo("","")
                                                      $$.trad = "";
                                                    }
  | tk_for error BSENTENCIAS{
                              console.error("Error Sintactico: "+$2+" Error parametros for");
                              var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> Sentencias",+yylineno+1,+@2.last_column+1);
                              errores.addError(error);

                              $$ = new Nodo("","")
                              $$.trad = "";
                            }; 

ST: tk_break tk_puntoycoma{
                            var nodo = new Nodo("BREAK","BREAK",+yylineno+1,+@1.last_column+1);
                            $$ = nodo;
                            $$.trad = $1+$2+"\n";
                          }
  | tk_break error{
                    console.error("Error Sintactico: "+$2+" Error break");
                    var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> ;",+yylineno+1,+@2.last_column+1);
                    errores.addError(error);

                    var nodo = new Nodo("BREAK","BREAK",+yylineno+1,+@1.last_column+1);
                    $$ = nodo;
                    $$.trad = $1+";\n";
                  }
  | tk_continue tk_puntoycoma {
                                var nodo = new Nodo("CONTINUE","CONTINUE",+yylineno+1,+@1.last_column+1);
                                $$ = nodo;
                                $$.trad = $1+$2+"\n";
                              }
  | tk_continue error {
                        console.error("Error Sintactico: "+$2+" Error continue");
                        var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> ;",+yylineno+1,+@2.last_column+1);
                        errores.addError(error);

                        var nodo = new Nodo("CONTINUE","CONTINUE",+yylineno+1,+@1.last_column+1);
                        $$ = nodo;
                        $$.trad = $1+";\n";
                      }
  | tk_return tk_puntoycoma {
                              var nodo = new Nodo("RETURN","RETURN",+yylineno+1,+@1.last_column+1);
                              $$ = nodo;
                              $$.trad = $1+$2+"\n";
                            }
  | tk_return error {
                      console.error("Error Sintactico: "+$2+" Error return");
                      var error = new Error("Sintactico","Encontrado: "+$2+" Se esperaba -> ;",+yylineno+1,+@2.last_column+1);
                      errores.addError(error);

                      var nodo = new Nodo("RETURN","RETURN",+yylineno+1,+@1.last_column+1);
                      $$ = nodo;
                      $$.trad = $1+";\n";
                    }
  | tk_return VALOR tk_puntoycoma {
                                    var nodo = new Nodo("RETURN","RETURN",+yylineno+1,+@1.last_column+1);
                                    nodo.addHijo($2);
                                    $$ = nodo;
                                    $$.trad = $1+" "+$2.trad+$3+"\n";
                                  }
  | tk_return VALOR error {
                            console.error("Error Sintactico: "+$3+" Error return");
                            var error = new Error("Sintactico","Encontrado: "+$3+" Se esperaba -> ;",+yylineno+1,+@3.last_column+1);
                            errores.addError(error);

                            var nodo = new Nodo("RETURN","RETURN",+yylineno+1,+@1.last_column+1);
                            nodo.addHijo($2);
                            $$ = nodo;
                            $$.trad = $1+" "+$2.trad+";\n";
                          }
  | tk_return ASIGNACION{
                          var nodo = new Nodo("RETURN","RETURN",+yylineno+1,+@1.last_column+1);
                          nodo.addHijo($2);
                          $$ = nodo;
                          $$.trad = $1+" "+$2.trad;
                        };

FUNCION: tk_fn tk_id tk_pabierto tk_pcerrado tk_dospuntos TIPOV2 BSENTENCIAS{ 
                                                                              console.log("FUNCION")
                                                                              //guardar traduccion en cola
                                                                              if(id_anidadas == ""){
                                                                                trad_func += $1+" "+$2+$3+$4+$5+$6.trad+" "+$7.trad;
                                                                                id_anidadas = "_"+$2;
                                                                              } else {
                                                                                trad_func += $1+" "+$2+"_"+id_anidadas+$3+$4+$5+$6.trad+" "+$7.trad;
                                                                                id_anidadas = $2+id_anidadas;
                                                                              }
                                                                            }
      | tk_fn tk_id tk_pabierto PARFUNC tk_pcerrado tk_dospuntos TIPOV2 BSENTENCIAS {
                                                                                      console.log("FUNCION")
                                                                                      //console.log("func ant");
                                                                                      //console.log($$.func);
                                                                                      //guardar traduccion en cola
                                                                                    }
      | tk_fn tk_id error BSENTENCIAS {
                                        //error
                                      }
      | tk_fn error {
                      //error
                    };

PARFUNC: PARFUNC tk_coma tk_id tk_dospuntos TIPOV2{}
        | tk_id tk_dospuntos TIPOV2{};
        
VALFUNCION: tk_id tk_pabierto tk_pcerrado{} 
          | tk_id tk_pabierto LPAR tk_pcerrado{};

LPAR: LPAR tk_coma VALOR{}
    | VALOR{};

FESP: tk_console tk_pabierto VALOR tk_pcerrado tk_puntoycoma{
                                                              var nodo = new Nodo("CONSOLE","CONSOLE",+yylineno+1,+@1.last_column+1);
                                                              nodo.addHijo($3);
                                                              $$ = nodo;
                                                              $$.trad = $1+$2+$3.trad+$4+$5+"\n";
                                                            }
    | tk_console tk_pabierto VALOR tk_pcerrado error{
                                                      console.error("Error Sintactico: "+$5+" Error console");
                                                      var error = new Error("Sintactico","Encontrado: "+$5+" Se esperaba -> ;",+yylineno+1,+@5.last_column+1);
                                                      errores.addError(error);

                                                      var nodo = new Nodo("CONSOLE","CONSOLE",+yylineno+1,+@1.last_column+1);
                                                      nodo.addHijo($3);
                                                      $$ = nodo;
                                                      $$.trad = $1+$2+$3.trad+$4+";\n";
                                                    }
    | tk_graficar tk_pabierto tk_pcerrado tk_puntoycoma {
                                                          var nodo = new Nodo("GRAFICAR","GRAFICAR",+yylineno+1,+@1.last_column+1);
                                                          $$ = nodo;
                                                          $$.trad = $1+$2+$3+$4+"\n";
                                                        }
    | tk_graficar tk_pabierto tk_pcerrado error { 
                                                  console.error("Error Sintactico: "+$4+" Error graficar");
                                                  var error = new Error("Sintactico","Encontrado: "+$4+" Se esperaba -> ;",+yylineno+1,+@4.last_column+1);
                                                  errores.addError(error);

                                                  var nodo = new Nodo("GRAFICAR","GRAFICAR",+yylineno+1,+@1.last_column+1);
                                                  $$ = nodo;
                                                  $$.trad = $1+$2+$3+";\n";
                                                };
