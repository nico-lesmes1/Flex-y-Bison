%%
"+"    { printf("PLUS\n"); }
"-"    { printf("MINUS\n"); }
"*"    { printf("TIMES\n"); }
"/"    { printf("DIVIDE\n"); }
"|"    { printf("ABS\n"); }
[0-9]+ { printf("NUMBER %s\n", yytext); }
\n     { printf("NEWLINE\n"); }
[ \t]  { /* ignorar espacios */ }
.      { printf("Mystery character %s\n", yytext); }
%%

"Se establecen los parametros que se tienen en cuenta para este codigo en C, donde se establece un simbolo y una accion directa"

flex fb1-3.l

cc lex.yy.c -lfl
"Se compila y se ejecuta de manera similar a los anteriores ejemplos."

./a.out
12+34
NUMBER 12
PLUS
NUMBER 34
NEWLINE
 5 6 / 7q
NUMBER 5
NUMBER 6
DIVIDE
NUMBER 7
Mystery character q

"Se obtienen los valores requeridos, especifica lo que se va ahacer y la salida correponde a lo esperado, incluso con el valor desconocido."

gcc lex.yy.c -lfl -o wc_flex
./wc_flex < archivo.txt
NUMBER 34
MINUS
NUMBER 70
NEWLINE
NEWLINE
ABS
MINUS
NUMBER 11
ABS
NEWLINE
NEWLINE
NUMBER 58
PLUS
NUMBER 88
NEWLINE

"Desde el punto con el archivo externo, se obtiene los resultados esperado, solo que hubo un error , ya que al restar, se buscaba un valor diferente, ya que deberia dar un negativo"