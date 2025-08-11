%{
   enum yytokentype {
     NUMBER = 258,
     ADD = 259,
     SUB = 260,
     MUL = 261,
     DIV = 262,
     ABS = 263,
     EOL = 264
   };

   int yylval;   
%}

"Asignaciones de valores por parte numeros que directamente van a influir en la ejecucion de los valores donde se busca identificar los patrones relacionados"

%%
"+"    { return ADD; }
"-"    { return SUB; }
"*"    { return MUL; }
"/"    { return DIV; }
"|"    { return ABS; }
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
\n     { return EOL; }
[ \t]  { }
.      { printf("Mystery character %c\n", *yytext); }
%%

"Por este lado, se obtiene que las reglas seran en busqueda de que tipo de busqueda y reglas se quieren generar, por lo tanto, retorna los valores que se validaron anteriormente."

main(int argc, char **argv)
{
  int tok;
  while ( (tok = yylex()) ) {
    printf("%d", tok);
    if (tok == NUMBER) printf(" = %d\n", yylval);
    else printf("\n");
  }
}

"La funcion se genera entorno a que la variable Tok vangenerando lo que manda la funcion yylex, para hacer la comparacion y se busca una igualdad con los valores que esten dentro del ciclo While"

flex fb1-4.l


cc lex.yy.c -lfl


./a.out
a / 34 + | 45
Mystery character a
262
258 = 34
259
263
258 = 45
264

"En este caso, la salida se va a dar en el orden que se da en el orden y sigue el algoritmo final"
