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
          $$.trad = $1.trad;
        }; 

DECLARACION: tk_let tk_id tk_dospuntos TIPOV2 tk_igual VALOR tk_puntoycoma{ 
                                                                            var nodo = new Nodo("DECLARACION","LET");
                                                                            var id = new Nodo("ID",$2);
                                                                            var tipo = new Nodo("TIPO",$4,);
                                                                            var valor = new Nodo("VALOR",$6);
                                                                            nodo.addHijo(id);
                                                                            nodo.addHijo(tipo);
                                                                            nodo.addHijo(valor);
                                                                            $$ = nodo;
                                                                            $$.trad = $1+" "+$2+$3+" "+$4.trad+" "+$5+" "+$6.trad+$7+"\n";
                                                                          }
          | tk_let tk_id tk_dospuntos TIPOV2 tk_igual VALOR error {
                                                                    console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                                                    var nodo = new Nodo("DECLARACION","LET");
                                                                    var id = new Nodo("ID",$2);
                                                                    var tipo = new Nodo("TIPO",$4,);
                                                                    var valor = new Nodo("VALOR",$6);
                                                                    nodo.addHijo(id);
                                                                    nodo.addHijo(tipo);
                                                                    nodo.addHijo(valor);
                                                                    var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                                                    errores.addError(error);
                                                                    $$ = nodo;
                                                                    $$.trad = $1+" "+$2+$3+" "+$4.trad+" "+$5+" "+$6.trad+";"+"\n";
                                                                  }  
          | tk_const tk_id tk_dospuntos TIPOV2 tk_igual VALOR tk_puntoycoma {
                                                                              var nodo = new Nodo("DECLARACION","CONST");
                                                                              var id = new Nodo("ID",$2);
                                                                              var tipo = new Nodo("TIPO",$4,);
                                                                              var valor = new Nodo("VALOR",$6);
                                                                              nodo.addHijo(id);
                                                                              nodo.addHijo(tipo);
                                                                              nodo.addHijo(valor);
                                                                              $$ = nodo;
                                                                              $$.trad = $1+" "+$2+$3+" "+$4.trad+" "+$5+" "+$6.trad+$7+"\n";
                                                                            }
          | tk_const tk_id tk_dospuntos TIPOV2 tk_igual VALOR error {
                                                                      console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                                                      var nodo = new Nodo("DECLARACION","CONST");
                                                                      var id = new Nodo("ID",$2);
                                                                      var tipo = new Nodo("TIPO",$4,);
                                                                      var valor = new Nodo("VALOR",$6);
                                                                      nodo.addHijo(id);
                                                                      nodo.addHijo(tipo);
                                                                      nodo.addHijo(valor);
                                                                      var error = new Error("Sintactico","Encontrado: "+yytext+" Se esperaba -> ;",+yylineno+1,@1.last_column)
                                                                      errores.addError(error);
                                                                      $$ = nodo;
                                                                      $$.trad = $1+" "+$2+$3+" "+$4.trad ? $4.trad: ""+" "+$5+" "+$6.trad+";"+"\n";
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
                                                $$.trad = $1+" "+$2+" "+$3+" "+$4.trad+";"+"\n";
                                              } 
          | tk_const tk_id tk_igual VALOR tk_puntoycoma {
                                                          var nodo = new Nodo("DECLARACION","CONST");
                                                          var id = new Nodo("ID",$2);
                                                          var valor = new Nodo("VALOR",$4);
                                                          nodo.addHijo(id);
                                                          nodo.addHijo(valor);
                                                          $$ = nodo;
                                                          $$.trad = $1+" "+$2+" "+$3+" "+$4.trad+$5+"\n";
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
                                                  $$.trad = $1+" "+$2+" "+$3+" "+$4.trad+";"+"\n";
                                                }  
          | tk_let tk_id tk_dospuntos TIPOV2 tk_puntoycoma{

                                                          }
          | tk_let tk_id tk_dospuntos TIPOV2 error{
                                                    console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                                                  } 
          | tk_let tk_id tk_puntoycoma{

                                      }  
          | tk_let tk_id error{
                                console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                              }  
          | TYPES {

                  }
          | DECFUNCION {

                       }
          | tk_id tk_inc tk_puntoycoma{

                                      }
          | tk_id tk_inc error{
                                console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                              } 
          | tk_id tk_dec tk_puntoycoma{

                                      }
          | tk_id tk_dec error{
                                console.error("Error Sintactico: "+yytext+ " falto punto y coma");
                              }
          | tk_let error{

                        }
          | tk_const error{

                          }
          | tk_id error {

                        };

TIPOV: tk_string
      |tk_number
      |tk_boolean
      |tk_void
      |tk_id
      |error {console.error("Error sintactico: "+$1+" error tipo")};

TIPOV2:TIPOV
      |ARRAY;

VALOR: ASIGTYPE
      |VARRAY
      |T
      |VALARRAY
      |VALFUNCION
      |tk_id tk_inc
      |tk_id tk_dec
      |error {console.error("Error sintactico: "+$1+" error valor")};

TYPES: tk_type tk_id tk_llavea LTYPE tk_llavec tk_puntoycoma
     | tk_type tk_id tk_llavea LTYPE tk_llavec error {console.error("Error sintantico "+ $6+" error types")};

LTYPE: LTYPE TIPOV2 tk_dospuntos tk_id tk_puntoycoma
      | TIPOV2 tk_dospuntos tk_id tk_puntoycoma;

ASIGTYPE: tk_llavea LASIGTYPE tk_llavec;

LASIGTYPE: LASIGTYPE tk_id tk_dospuntos VALOR tk_puntoycoma
          | tk_id tk_dospuntos VALOR tk_puntoycoma;

ARRAY: tk_string tk_llaveca tk_llavecc
     | tk_number tk_llaveca tk_llavecc
     | tk_boolean tk_llaveca tk_llavecc
     | tk_void tk_llavecc tk_llavecc
     | tk_id tk_llavecc tk_llavecc
     | tk_array tk_menor TIPOV tk_mayor;

VARRAY: tk_llaveca LVALARRAY tk_llavecc;

LVALARRAY: LVALARRAY tk_coma VALOR
        | VALOR;

VALARRAY: tk_id tk_llaveca tk_t_entero tk_llavecc;

ASIGNACION: tk_id tk_igual VALOR tk_puntoycoma
          | tk_id tk_igual VALOR error {console.log("Error Sintactico "+$4+"Error falto punto y coma")}
          | VALARRAY tk_igual VALOR tk_puntoycoma
          | VALARRAY tk_igual VALOR error {console.log("Error Sintactico "+$4+"Error falto punto y coma")};

T: L tk_ternario L tk_dospuntos L
  |L;

L: L tk_and L
  |L tk_or L
  |tk_not L
  |tk_t_boolean
  |R;

R: A tk_mayor A
  |A tk_menor A
  |A tk_mayorigual A
  |A tk_menorigual A
  |A tk_igualdad A 
  |A tk_diferente A
  |A;

A:A tk_suma A
 |A tk_resta A
 |A tk_mult A
 |A tk_div A
 |A tk_exp A
 |A tk_mod A
 |tk_pabierto A tk_pcerrado
 |tk_resta A
 |tk_t_string
 |tk_t_entero
 |tk_t_decimal
 |tk_id;

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
