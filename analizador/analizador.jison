/*---------------------------IMPORTS-------------------------------*/
%{
  let valcadena = ""; 
  let resultado = "";
  let errores = new ListaErrores();
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
          var nodo = new Nodo("S","S")
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
        var trad = new Traduccion(new Nodo("S","S"),"",errores.getLista()); 
        errores.limpiar();
        return trad;
      };

I: I DECLARACION{
                  var nodo = new Nodo("I","I");
                  nodo.addHijo($1);
                  nodo.addHijo($2);
                  $$ = nodo;
                  $$.trad = $1.trad + $2.trad;
                }
  |I ASIGNACION
  |I IF
  |I SWITCH
  |I WHILE
  |I DOWHILE
  |I FOR
  |I FESP
  |DECLARACION { $$ = $1; $$.trad = $1.trad; }
  |ASIGNACION
  |IF
  |SWITCH
  |WHILE
  |DOWHILE
  |FOR
  |FESP
  |error{
          console.error("Error sintactico: "+yytext+" Desconocido Inicio");
          var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> DECLARACION || ASIGNACION || IF || SWITCH || WHILE || DOWHILE || FOR || console.log || graficar_ts",+yylineno+1,@1.last_column)
          errores.addError(error);
        }; 

DECLARACION: tk_let tk_id tk_dospuntos TIPOV2 tk_igual VALOR tk_puntoycoma{ 
                                                                            var nodo = new Nodo("DECLARACION","LET");
                                                                            var id = new Nodo("ID",$2);
                                                                            var tipo = $4;
                                                                            var valor = $6;
                                                                            nodo.addHijo(id);
                                                                            nodo.addHijo(tipo);
                                                                            nodo.addHijo(valor);
                                                                            $$ = nodo;
                                                                            $$.trad = $1+" "+$2+$3+" "+$4.trad+" "+$5+" "+$6.trad+$7+"\n";
                                                                          }
          | tk_let tk_id tk_dospuntos TIPOV2 tk_igual VALOR error {
                                                                    console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                                                    var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                                                    errores.addError(error);
                                                                    var nodo = new Nodo("DECLARACION","LET");
                                                                    var id = new Nodo("ID",$2);
                                                                    var tipo = $4;
                                                                    var valor = $6;
                                                                    nodo.addHijo(id);
                                                                    nodo.addHijo(tipo);
                                                                    nodo.addHijo(valor);
                                                                    $$ = nodo;
                                                                    $$.trad = $1+" "+$2+$3+" "+$4.trad+" "+$5+" "+$6.trad+";\n";
                                                                  }  
          | tk_const tk_id tk_dospuntos TIPOV2 tk_igual VALOR tk_puntoycoma {
                                                                              var nodo = new Nodo("DECLARACION","CONST");
                                                                              var id = new Nodo("ID",$2);
                                                                              var tipo = new Nodo("TIPO",$4);
                                                                              var valor = new Nodo("VALOR",$6);
                                                                              nodo.addHijo(id);
                                                                              nodo.addHijo(tipo);
                                                                              nodo.addHijo(valor);
                                                                              $$ = nodo;
                                                                              $$.trad = $1+" "+$2+$3+" "+$4+" "+$5+" "+$6+$7+"\n";
                                                                            }
          | tk_const tk_id tk_dospuntos TIPOV2 tk_igual VALOR error {
                                                                      console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                                                      var nodo = new Nodo("DECLARACION","CONST");
                                                                      var id = new Nodo("ID",$2);
                                                                      var tipo = new Nodo("TIPO",$4);
                                                                      var valor = new Nodo("VALOR",$6);
                                                                      nodo.addHijo(id);
                                                                      nodo.addHijo(tipo);
                                                                      nodo.addHijo(valor);
                                                                      var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                                                      errores.addError(error);
                                                                      $$ = nodo;
                                                                      $$.trad = $1+" "+$2+$3+" "+$4+" "+$5+" "+$6+";"+"\n";
                                                                    }  
          | tk_let tk_id tk_igual VALOR tk_puntoycoma {
                                                        var nodo = new Nodo("DECLARACION","LET");
                                                        var id = new Nodo("ID",$2);
                                                        var valor = new Nodo("VALOR",$4);
                                                        nodo.addHijo(id);
                                                        nodo.addHijo(valor);
                                                        $$ = nodo;
                                                        $$.trad = $1+" "+$2+" "+$3+" "+$4.trad+$5+"\n";
                                                      }
          | tk_let tk_id tk_igual VALOR error {
                                                console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                                var nodo = new Nodo("DECLARACION","LET");
                                                var id = new Nodo("ID",$2);
                                                var valor = new Nodo("VALOR",$4);
                                                nodo.addHijo(id);
                                                nodo.addHijo(valor);
                                                var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                                errores.addError(error);
                                                $$ = nodo;
                                                $$.trad = $1+" "+$2+" "+$3+" "+$4+";"+"\n";
                                              } 
          | tk_const tk_id tk_igual VALOR tk_puntoycoma {
                                                          var nodo = new Nodo("DECLARACION","CONST");
                                                          var id = new Nodo("ID",$2);
                                                          var valor = new Nodo("VALOR",$4);
                                                          nodo.addHijo(id);
                                                          nodo.addHijo(valor);
                                                          $$ = nodo;
                                                          $$.trad = $1+" "+$2+" "+$3+" "+$4+$5+"\n";
                                                        }
          | tk_const tk_id tk_igual VALOR error {
                                                  console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                                  var nodo = new Nodo("DECLARACION","CONST");
                                                  var id = new Nodo("ID",$2);
                                                  var valor = new Nodo("VALOR",$4);
                                                  nodo.addHijo(id);
                                                  nodo.addHijo(valor);
                                                  var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                                  errores.addError(error);
                                                  $$ = nodo;
                                                  $$.trad = $1+" "+$2+" "+$3+" "+$4+";"+"\n";
                                                }  
          | tk_let tk_id tk_dospuntos TIPOV2 tk_puntoycoma{
                                                            var nodo = new Nodo("DECLARACION","LET");
                                                            var id = new Nodo("ID",$2);
                                                            var tipo = new Nodo("TIPO",$4);
                                                            nodo.addHijo(id);
                                                            nodo.addHijo(tipo);
                                                            $$ = nodo;
                                                            $$.trad = $1+" "+$2+$3+" "+$4+$5+"\n";
                                                          }
          | tk_let tk_id tk_dospuntos TIPOV2 error{
                                                    console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                                    var nodo = new Nodo("DECLARACION","LET");
                                                    var id = new Nodo("ID",$2);
                                                    var tipo = new Nodo("TIPO",$4);
                                                    nodo.addHijo(id);
                                                    nodo.addHijo(tipo);
                                                    var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                                    errores.addError(error);
                                                    $$ = nodo;
                                                    $$.trad = $1+" "+$2+$3+" "+$4+";\n";
                                                  } 
          | tk_let tk_id tk_puntoycoma{
                                        var nodo = new Nodo("DECLARACION","LET");
                                        var id = new Nodo("ID",$2);
                                        nodo.addHijo(id);
                                        $$ = nodo;
                                        $$.trad = $1+" "+$2+$3+"\n";
                                      }  
          | tk_let tk_id error{
                                console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                var nodo = new Nodo("DECLARACION","LET");
                                var id = new Nodo("ID",$2);
                                var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                errores.addError(error);
                                $$ = nodo;
                                $$.trad = $1+" "+$2+";\n"
                              }  
          | TYPES {
                    $$ = $1;
                    $$.trad = $1.trad;
                  }
          | DECFUNCION{
                        $$ = $1;
                        $$.trad = $1.trad;
                      }
          | tk_id tk_inc tk_puntoycoma{
                                        var nodo = new Nodo("INCREMENTO","");
                                        var id = new Nodo("ID",$1);
                                        nodo.addError(id);
                                        $$ = nodo;
                                        $$.trad = $1+$2+$3+"\n";
                                      }
          | tk_id tk_inc error{
                                console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                var nodo = new Nodo("INCREMENTO","");
                                var id = new Nodo("ID",$1);
                                nodo.addError(id);
                                var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                errores.addError(error);
                                $$ = nodo;
                                $$.trad = $1+$2+";\n";
                              } 
          | tk_id tk_dec tk_puntoycoma{
                                        var nodo = new Nodo("DECREMENTO","");
                                        var id = new Nodo("ID",$1);
                                        nodo.addHijo(id);
                                        $$ = nodo;
                                        $$.trad = $1+$2+$3+"\n";
                                      }
          | tk_id tk_dec error{
                                console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                var nodo = new Nodo("DECREMENTO","");
                                var id = new Nodo("ID",$1);
                                nodo.addHijo(id);
                                var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                errores.addError(error);
                                $$ = nodo;
                                $$.trad = $1+$2+";\n";
                              }
          | tk_let error{
                          console.error("Error Sintactico: "+yytext+" error de declaracion");
                          var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> declaracion con let",+yylineno+1,@1.last_column);
                          errores.addError(error);
                        }
          | tk_const error{
                            console.error("Error Sintactico: "+yytext+" error de declaracion");
                            var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> declaracion con const",+yylineno+1,@1.last_column);
                            errores.addError(error);
                          }
          | tk_id error {
                          console.error("Error Sintactico: "+yytext+" error de declaracion");
                          var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> incremento o decremento",+yylineno+1,@1.last_column);
                          errores.addError(error);
                        };

TIPOV: tk_string{
                  var nodo = new Nodo("TIPO","STRING"); 
                  $$ = nodo;
                  $$.trad = $1; 
                }
      |tk_number{
                  var nodo = new Nodo("TIPO","NUMBER"); 
                  $$ = nodo;
                  $$.trad = $1; 
                }
      |tk_boolean {
                    var nodo = new Nodo("TIPO","BOOLEAN"); 
                    $$ = nodo;
                    $$.trad = $1; 
                  }
      |tk_void{
                var nodo = new Nodo("TIPO","VOID"); 
                $$ = nodo;
                $$.trad = $1; 
              }
      |tk_id{
              var nodo = new Nodo("TIPO","ID");
              var id = new Nodo("ID",$1);
              nodo.addHijo(id); 
              $$ = nodo;
              $$.trad = $1; 
            }
      |error{
              console.error("Error sintactico: "+yytext+" error tipo");
              var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> un tipo de dato",+yylineno+1,@1.last_column);
              errores.addError(error);
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
                      var nodo = new Nodo("INCREMENTO",$1);
                      $$ = nodo;
                      $$.trad = $1 + $2;
                    }
      |tk_id tk_dec { 
                      var nodo = new Nodo("DECREMENTO",$1);
                      $$ = nodo;
                      $$.trad = $1 + $2;
                    }
      |error{
              console.error("Error sintactico: "+yytext+" error valor");
              var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> un valor o operacion",+yylineno+1,@1.last_column);
              errores.addError(error);
            };

TYPES: tk_type tk_id tk_llavea LTYPE tk_llavec tk_puntoycoma{
                                                              var nodo = new Nodo("DECLARACION","TIPO");
                                                              var id = new Nodo("ID",$2);
                                                              var par = new Nodo("LISTA",)
                                                            }
     | tk_type tk_id tk_llavea LTYPE tk_llavec error {console.error("Error sintantico "+ $6+" error types")};

LTYPE: LTYPE TIPOV2 tk_dospuntos tk_id tk_puntoycoma
      | TIPOV2 tk_dospuntos tk_id tk_puntoycoma;

ASIGTYPE: tk_llavea LASIGTYPE tk_llavec {
                                          var nodo = new Nodo("VALOR","ASIGNACION_TIPO");
                                          var sigtype = $2;
                                          nodo.addHijo(sigtype);
                                          $$ = nodo;
                                          $$.trad = $1 + "\n" + $2.trad + $3;
                                        }
        | tk_llavea error tk_llavec {
                                      console.error("Error sintactico: "+yytext+" error valor");
                                      var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> una lista de valores",+yylineno+1,@1.last_column);
                                      errores.addError(error);
                                      var nodo = new Nodo("VALOR","ASIGNACION_TIPO");
                                      $$ = nodo;
                                      $$.trad = $1 + "\n" + $3;
                                    };

LASIGTYPE: LASIGTYPE tk_id tk_dospuntos VALOR tk_puntoycoma {
                                                              var nodo = new Nodo("LISTATYPE","");
                                                              var h1 = $1;
                                                              var id = new Nodo("ID",$2);
                                                              var valor = $3;
                                                              nodo.addHijo(h1);
                                                              nodo.addHijo(id);
                                                              nodo.addHijo(valor);
                                                              $$ = nodo;
                                                              $$.trad = $1.trad + $2 + $3 + " " + $4.trad + $5 + "\n";
                                                            }
          | LASIGTYPE tk_id tk_dospuntos VALOR error{
                                                      console.error("Error sintactico: "+yytext+" error valor");
                                                      var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column);
                                                      errores.addError(error);
                                                      var nodo = new Nodo("LISTATYPE","");
                                                      var h1 = $1;
                                                      var id = new Nodo("ID",$2);
                                                      var valor = $3;
                                                      nodo.addHijo(h1);
                                                      nodo.addHijo(id);
                                                      nodo.addHijo(valor);
                                                      $$ = nodo;
                                                      $$.trad = $1.trad + $2 + $3 + " " + $4.trad +";\n";
                                                    }
          | tk_id tk_dospuntos VALOR tk_puntoycoma{
                                                    var nodo = new Nodo("LISTATYPE","");
                                                    var id = new Nodo("ID",$1);
                                                    var valor = $3;
                                                    nodo.addHijo(id);
                                                    nodo.addHijo(valor);
                                                    $$ = nodo;
                                                    $$.trad = $1 + $2 + $3.trad + $4 + "\n";
                                                  }
          | tk_id tk_dospuntos VALOR error{
                                            console.error("Error sintactico: "+yytext+" error valor");
                                            var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column);
                                            errores.addError(error);
                                            var nodo = new Nodo("LISTATYPE","");
                                            var id = new Nodo("ID",$1);
                                            var valor = $3;
                                            nodo.addHijo(id);
                                            nodo.addHijo(valor);
                                            $$ = nodo;
                                            $$.trad = $1 + $2 + $3.trad +";\n";
                                          };

ARRAY: tk_string tk_llaveca tk_llavecc {
                                          var nodo = new Nodo("TIPO","ARRAY_STRING");
                                          $$ = nodo;
                                          $$.trad = $1+$2+$3;
                                       }
     | tk_number tk_llaveca tk_llavecc{
                                        var nodo = new Nodo("TIPO","ARRAY_NUMBER");
                                        $$ = nodo;
                                        $$.trad = $1+$2+$3;
                                      }
     | tk_boolean tk_llaveca tk_llavecc{
                                        var nodo = new Nodo("TIPO","ARRAY_BOOLEAN");
                                        $$ = nodo;
                                        $$.trad = $1+$2+$3;
                                       }
     | tk_id tk_llavecc tk_llavecc{
                                    var nodo = new Nodo("TIPO","ARRAY_ID");
                                    var id = new Nodo("ID",$1);
                                    nodo.addHijo(id)
                                    $$ = nodo;
                                    $$.trad = $1+$2+$3;
                                  }
     | tk_array tk_menor TIPOV tk_mayor {
                                          var nodo = new Nodo("TIPO","ARRAY_TIPO");
                                          var tipo = $3;
                                          nodo.addHijo(tipo)
                                          $$ = nodo;
                                          $$.trad = $1+$2+$3.trad+$4;
                                        };

VARRAY: tk_llaveca LVALARRAY tk_llavecc {
                                          var nodo = new Nodo("VALOR","ASIGNACION_ARRAY");
                                          var larray = $2;
                                          nodo.addHijo(larray);
                                          $$ = nodo;
                                          $$.trad = $1 + $2.trad + $3;
                                        };

LVALARRAY: LVALARRAY tk_coma VALOR {
                                      var nodo = new Nodo("LISTA_ARRAY","");
                                      var larray = $1;
                                      var val = $3;
                                      nodo.addHijo(larray);
                                      nodo.addHijo(val);
                                      $$ = nodo;
                                      $$.trad = $1.trad + $2 + " " + $3.trad;
                                   }
        | LVALARRAY error VALOR {
                                  console.error("Error sintactico: "+yytext+" error valor");
                                  var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ,",+yylineno+1,@1.last_column);
                                  errores.addError(error);
                                  var nodo = new Nodo("LISTA_ARRAY","");
                                  nodo.addHijo($1);
                                  nodo.addHijo($3);
                                  $$ = nodo;
                                  $$.trad = $1.trad + ", " + $3.trad;
                                }
        | VALOR {
                  var nodo = new Nodo("LISTA_ARRAY","");
                  nodo.addHijo($1);
                  $$ = nodo;
                  $$.trad = $1.trad;
                };

VALARRAY: tk_id tk_llaveca tk_t_entero tk_llavecc;

ASIGNACION: tk_id tk_igual VALOR tk_puntoycoma
          | tk_id tk_igual VALOR error {console.log("Error Sintactico "+$4+"Error falto punto y coma")}
          | VALARRAY tk_igual VALOR tk_puntoycoma
          | VALARRAY tk_igual VALOR error {console.log("Error Sintactico "+$4+"Error falto punto y coma")};

T: L tk_ternario L tk_dospuntos L {
                                    var nodo = new Nodo("T","T");
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
                var nodo = new Nodo("L","AND");
                nodo.addHijo($1);
                nodo.addHijo($3);
                $$ = nodo;
                $$.trad = $1.trad + " " + $2 + " " + $3.trad;
              }
  |L tk_or L{
              var nodo = new Nodo("L","OR");
              nodo.addHijo($1);
              nodo.addHijo($3);
              $$ = nodo;
              $$.trad = $1.trad + " " + $2 + " " + $3.trad;
            }
  |tk_not L {
              var nodo = new Nodo("L","NOT");
              nodo.addHijo($2);
              $$ = nodo;
              $$.trad = $1 + " " + $2.trad;
            }
  |tk_t_boolean {
                  var nodo = new Nodo("L",$1);
                  $$ = nodo;
                  $$.trad = $1
                }
  |R {
       $$=$1;
       $$.trad = $1.trad;
     };

R: A tk_mayor A {
                  var nodo = new Nodo("R","MAYOR");
                  nodo.addHijo($1);
                  nodo.addHijo($3);
                  $$ = nodo;
                  $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                }
  |A tk_menor A {
                  var nodo = new Nodo("R","MENOR");
                  nodo.addHijo($1);
                  nodo.addHijo($3);
                  $$ = nodo;
                  $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                }
  |A tk_mayorigual A{
                      var nodo = new Nodo("R","MAYORIGUAL");
                      nodo.addHijo($1);
                      nodo.addHijo($3);
                      $$ = nodo;
                      $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                    }
  |A tk_menorigual A{
                      var nodo = new Nodo("R","MENORIGUAL");
                      nodo.addHijo($1);
                      nodo.addHijo($3);
                      $$ = nodo;
                      $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                    }
  |A tk_igualdad A {
                      var nodo = new Nodo("R","IGUALDAD");
                      nodo.addHijo($1);
                      nodo.addHijo($3);
                      $$ = nodo;
                      $$.trad = $1.trad + " " + $2 + " " + $3.trad;
                   }
  |A tk_diferente A {
                      var nodo = new Nodo("R","DESIGUALDAD");
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
                var nodo = new Nodo("A","SUMA");
                nodo.addHijo($1);
                nodo.addHijo($3);
                $$ = nodo;
                $$.trad = $1.trad + " " + $2 + " " + $3.trad;
              }
 |A tk_resta A{
                var nodo = new Nodo("A","RESTA");
                nodo.addHijo($1);
                nodo.addHijo($3);
                $$ = nodo;
                $$.trad = $1.trad + " " + $2 + " " + $3.trad;
              }
 |A tk_mult A {
                var nodo = new Nodo("A","MULTI");
                nodo.addHijo($1);
                nodo.addHijo($3);
                $$ = nodo;
                $$.trad = $1.trad + " " + $2 + " " + $3.trad;
              }
 |A tk_div A{
              var nodo = new Nodo("A","DIV");
              nodo.addHijo($1);
              nodo.addHijo($3);
              $$ = nodo;
              $$.trad = $1.trad + " " + $2 + " " + $3.trad;
            }
 |A tk_exp A{
              var nodo = new Nodo("A","EXP");
              nodo.addHijo($1);
              nodo.addHijo($3);
              $$ = nodo;
              $$.trad = $1.trad + " " + $2 + " " + $3.trad;
            }
 |A tk_mod A{
              var nodo = new Nodo("A","MOD");
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
                var nodo = new Nodo("NEGATIVO",$2);
                $$ = nodo;
                $$.trad = $1 + $2.trad;
             }
 |tk_t_string {
                var nodo = new Nodo("STRING",$1);
                $$ = nodo;
                $$.trad = $1;
              }
 |tk_t_entero {
                var nodo = new Nodo("ENTERO",$1);
                $$ = nodo;
                $$.trad = $1;
              }
 |tk_t_decimal{
                var nodo = new Nodo("DECIMAL",$1);
                $$ = nodo;
                $$.trad = $1;
              }
 |tk_id {
          var nodo = new Nodo("ID",$1);
          $$ = nodo;
          $$.trad = $1;
        };

BSENTENCIAS: tk_llavea SENTENCIAS tk_llavec
            |tk_llavea tk_llavec;

SENTENCIAS: SENTENCIAS DECLARACION
          | SENTENCIAS ASIGNACION
          | SENTENCIAS IF
          | SENTENCIAS SWITCH
          | SENTENCIAS WHILE
          | SENTENCIAS DOWHILE
          | SENTENCIAS FOR
          | SENTENCIAS ST
          | SENTENCIAS FESP
          | DECLARACION
          | ASIGNACION
          | IF
          | SWITCH
          | WHILE
          | DOWHILE
          | FOR
          | ST
          | FESP
          | error  {console.error("Error sintactico: "+yytext+" Desconocido Sentencias")};

IF: tk_if tk_pabierto L tk_pcerrado BSENTENCIAS ELSE
  | tk_if tk_pabierto L tk_pcerrado BSENTENCIAS
  | tk_if error BSENTENCIAS ELSE {console.error("Error Sintactico: "+$2+" Error parametros en if")}
  | tk_if error BSENTENCIAS {console.error("Error Sintactico: "+$2+" Error parametros en if")};

ELSE: tk_else BSENTENCIAS
    | tk_else IF;

SWITCH: tk_switch tk_pabierto L tk_pcerrado BSWITCH
      | tk_switch error BSWITCH { console.error("Error sintactico: "+$2+" Error parametros en switch") };

BSWITCH: tk_llavea CASE DEFAULT tk_llavec
      |tk_llavea CASE tk_llavec
      |tk_llavea tk_llavec
      |tk_llavea error tk_llavec { console.error("Error Sintactico: "+$2+" Error Cases en switch")};

CASE: CASE tk_case L tk_dospuntos SENTENCIAS
    | CASE tk_case L tk_dospuntos BSENTENCIAS
    | CASE tk_case L tk_dospuntos
    | tk_case L tk_dospuntos SENTENCIAS
    | tk_case L tk_dospuntos BSENTENCIAS
    | tk_case L tk_dospuntos;

DEFAULT: tk_default tk_dospuntos SENTENCIAS
        |tk_default tk_dospuntos BSENTENCIAS
        |tk_default tk_dospuntos;

WHILE: tk_while tk_pabierto L tk_pcerrado BSENTENCIAS
      |tk_while error BSENTENCIAS {console.error("Error Sintactico: "+$2+" Error parametros while")};

DOWHILE: tk_do BSENTENCIAS tk_while tk_pabierto L tk_pcerrado
       | tk_do BSENTENCIAS tk_while error {console.error("Error Sintactico: "+$2+" Error parametros doWhile")};

FOR: tk_for tk_pabierto DECLARACION L tk_puntoycoma L tk_pcerrado BSENTENCIAS
  | tk_for tk_pabierto ASIGNACION L tk_puntoycoma L tk_pcerrado BSENTENCIAS
  | tk_for tk_pabierto tk_id tk_in tk_id tk_pcerrado BSENTENCIAS
  | tk_for tk_pabierto tk_let tk_id tk_in tk_id tk_pcerrado BSENTENCIAS
  | tk for tk_pabierto tk_id tk_of tk_id tk_pcerrado BSENTENCIAS
  | tk_for tk_pabierto tk_let tk_id tk_of tk_id tk_pcerrado BSENTENCIAS
  | tk_for error BSENTENCIAS {console.error("Error Sintactico: "+$2+" Error parametros for")}; 

ST: tk_break tk_puntoycoma
  | tk_break error {console.error("Error Sintactico: "+$2+" falta punto y coma")}
  | tk_continue tk_puntoycoma
  | tk_continue error {console.error("Error Sintactico: "+$2+" falta punto y coma")}
  | tk_return tk_puntoycoma
  | tk_return error {console.error("Error Sintactico: "+$2+" falta punto y coma")}
  | tk_return VALOR tk_puntoycoma
  | tk_return VALOR error {console.error("Error Sintactico: "+$3+" falta punto y coma")}
  | tk_return ASIGNACION;

DECFUNCION: tk_fn tk_id tk_pabierto tk_pcerrado tk_dospuntos TIPOV2 BSENTENCIAS
          | tk_fn tk_id tk_pabierto PARFUNC tk_pcerrado tk_dospuntos TIPOV2 BSENTENCIAS
          | tk_fn error BSENTENCIAS{console.error("Error Sintactico: "+$2+" Error parametros funciones")};

VALFUNCION: tk_id tk_pabierto tk_pcerrado 
          | tk_id tk_pabierto LPAR tk_pcerrado;

PARFUNC: PARFUNC tk_coma tk_id tk_dospuntos TIPOV2
        | tk_id tk_dospuntos TIPOV2;
        
LPAR: LPAR tk_coma VALOR
    | VALOR;

FESP: tk_console tk_pabierto VALOR tk_pcerrado tk_puntoycoma
    | tk_console tk_pabierto VALOR tk_pcerrado error {console.error("Error Sintactico: "+$5+" falta punto y coma")}
    | tk_graficar tk_pabierto tk_pcerrado tk_puntoycoma
    | tk_graficar tk_pabierto tk_pcerrado error {console.error("Error Sintactico: "+$4+" falta punto y coma")};
