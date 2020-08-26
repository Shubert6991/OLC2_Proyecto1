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

"["                             %{ console.log("simbolo:"+yytext); return 'tk_llaveca'; %}
"]"                             %{ console.log("simbolo:"+yytext); return 'tk_llavecc'; %}
":"                             %{ console.log("simbolo:"+yytext); return 'tk_dospuntos'; %}
"="                             %{ console.log("simbolo:"+yytext); return 'tk_igual'; %}
";"                             %{ console.log("simbolo:"+yytext); return 'tk_puntoycoma'; %}
"{"                             %{ console.log("simbolo:"+yytext); return 'tk_llavea'; %}
"}"                             %{ console.log("simbolo:"+yytext); return 'tk_llavec'; %}
","                             %{ console.log("simbolo:"+yytext); return 'tk_coma'; %}
"<"                             %{ console.log("simbolo:"+yytext); return 'tk_menor'; %}
">"                             %{ console.log("simbolo:"+yytext); return 'tk_mayor'; %}

[0-9]+"."[0-9]+                 %{ console.log("numero decimal:"+yytext);  return 'tk_t_decimal'; %}
[0-9]+                          %{ console.log("numero entero:"+yytext);  return 'tk_t_entero'; %}
[[a-zA-ZñÑáéíóúÁÉÍÓÚ]["_"0-9a-zA-ZñÑáéíóúÁÉÍÓÚ]*|["_"]+[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ]["_"0-9a-zA-ZñÑáéíóúÁÉÍÓÚ]*] %{  console.log("id:"+yytext); return 'tk_id'; %}

[ \t\r\n\f] 										%{ /*se ignoran*/ %}

<<EOF>>     										%{  return 'EOF';  %}

.           										%{  console.log("error:"+yytext); %}

/lex

/*-------------------------SINTACTICO------------------------------*/

/*-----ASOCIACION Y PRECEDENCIA-----*/

/*----------ESTADO INICIAL----------*/
%start S
%% 

/*-------------GRAMATICA------------*/
S: I EOF 
	|EOF;

I: I DECLARACION
  |I ASIGNACION
  |DECLARACION
  |ASIGNACION;

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

VALOR: tk_t_string
      |tk_t_entero
      |tk_t_decimal
      |tk_t_boolean
      |tk_id
      |ASIGTYPE
      |VARRAY;

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

ASIGNACION: tk_id tk_igual VALOR tk_puntoycoma;

A:A + A
 |A - A
 |A * A
 |A / A
 |!A;