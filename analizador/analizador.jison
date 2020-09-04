/*---------------------------IMPORTS-------------------------------*/
%{
  var valcadena = "";
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
<tstring>["]                    %{ this.popState(); 
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
<tstring2>[']                   %{ this.popState(); 
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
<ttstring>[`]                   %{ this.popState(); 
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

[ \t\r\n\f] 										%{ /*se ignoran*/ %}

<<EOF>>     										%{  return 'EOF';  %}

.           										%{  console.log("error:"+yytext); %}

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

/*-------------GRAMATICA------------*/
S: I EOF 
  |EOF;

I: I DECLARACION
  |I ASIGNACION
  |I IF
  |I SWITCH
  |I WHILE
  |I DOWHILE
  |DECLARACION
  |ASIGNACION
  |IF
  |SWITCH
  |WHILE
  |DOWHILE;

DECLARACION: tk_let tk_id tk_dospuntos TIPOV2 tk_igual VALOR tk_puntoycoma
          | tk_const tk_id tk_dospuntos TIPOV2 tk_igual VALOR tk_puntoycoma
          | tk_let tk_id tk_igual VALOR tk_puntoycoma
          | tk_const tk_id tk_igual VALOR tk_puntoycoma
          | tk_let tk_id tk_dospuntos TIPOV2 tk_puntoycoma
          | tk_let tk_id tk_puntoycoma
          | TYPES;

TIPOV: tk_string
      |tk_number
      |tk_boolean
      |tk_void
      |tk_id;

TIPOV2:TIPOV
      |ARRAY;

VALOR: ASIGTYPE
      |VARRAY
      |T;

TYPES: tk_type tk_id tk_llavea LTYPE tk_llavec tk_puntoycoma;

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

ASIGNACION: tk_id tk_igual VALOR tk_puntoycoma
          | tk_id tk_inc tk_puntoycoma
          | tk_id tk_dec tk_puntoycoma;

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
 |A tk_inc
 |A tk_dec
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
          | DECLARACION
          | ASIGNACION
          | IF
          | SWITCH
          | WHILE
          | DOWHILE;

IF: tk_if tk_pabierto L tk_pcerrado BSENTENCIAS ELSE
  | tk_if tk_pabierto L tk_pcerrado BSENTENCIAS;

ELSE: tk_else BSENTENCIAS
    | tk_else IF;

SWITCH: tk_switch tk_pabierto L tk_pcerrado BSWITCH;

BSWITCH: tk_llavea CASE DEFAULT tk_llavec
      |tk_llavea CASE tk_llavec
      |tk_llavea tk_llavec;

CASE: CASE tk_case L tk_dospuntos SENTENCIAS
    | CASE tk_case L tk_dospuntos BSENTENCIAS
    | CASE tk_case L tk_dospuntos
    | tk_case L tk_dospuntos SENTENCIAS
    | tk_case L tk_dospuntos BSENTENCIAS
    | tk_case L tk_dospuntos;

DEFAULT: tk_default tk_dospuntos SENTENCIAS
        |tk_default tk_dospuntos BSENTENCIAS
        |tk_default tk_dospuntos;

WHILE: tk_while tk_pabierto L tk_pcerrado BSENTENCIAS;

DOWHILE: tk_do BSENTENCIAS tk_while tk_pabierto L tk_pcerrado;