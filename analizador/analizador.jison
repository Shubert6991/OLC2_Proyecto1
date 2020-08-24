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

"true"                          %{ console.log("boolean:"+yytext);  return 'tk_t_boolean'; %}
"false"                         %{ console.log("boolean:"+yytext);  return 'tk_t_boolean'; %}

[0-9]+"."[0-9]+                 %{ console.log("numero decimal:"+yytext);  return 'tk_t_decimal'; %}
[0-9]+                          %{ console.log("numero entero:"+yytext);  return 'tk_t_entero'; %}

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

I: I tk_entero
  |tk_entero;
