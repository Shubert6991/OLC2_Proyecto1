/*---------------------------IMPORTS-------------------------------*/
%{

%}

/*----------------------------LEXICO-------------------------------*/
%lex

%%
"int"                           %{ console.log("tipo de dato:"+yytext);  return 'tk_tint'; %}

[0-9]+                          %{ console.log("numero entero:"+yytext);  return 'tk_entero';%}


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

I: I tk_tint tk_entero
  |tk_tint tk_entero;
