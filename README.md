# Ejemplos libro

## Ejemplo 1

La primera parte del código inicializa algunas variables contadoras. Se usa el lenguaje C para estas instrucciones y se genera dentro de %{ %}

```
%{
int chars = 0;
int words = 0;
int lines = 0;
%}
```

%% se usan como separación de secciones, ya que, para poder ejecutar el código de manera correcta, primero se deben declarar las variables y después se establecen las reglas que van a aplicar.

```
%%
[a-zA-Z]+ { words++; chars += strlen(yytext);}
\n {chars++; lines++}
. {chars++}
```

En esta parte, la primera línea busca los caracteres que estén en el rango establecido (de la a a la z en minúsculas y de la A a la Z en mayúsculas). Además, se agregó el + para indicar que puede haber una o más repeticiones después del patrón anterior.
Si se encuentra esta coincidencia en la entrada, se suma 1 a la variable words y se acumula la cantidad de caracteres de la palabra en la variable chars.
La siguiente línea, al detectar \n, reconoce un salto de línea. En ese caso, suma uno a la variable chars y otro a lines.
Finalmente, el punto reconoce cualquier carácter que no esté previamente definido, sumando una unidad a la variable chars.

```
%%

main(int argc, char **argv)
{
	yylex();
	print("%8d%8d%8d\n", lines, words, chars);
}
```

La parte del main recibe dos valores:
- int argc, que representa la cantidad de argumentos.
- char **argv, que se interpreta como la ruta o nombre del programa por defecto, almacenado en un arreglo de char, de ahí el doble asterisco.
Después se encuentra la función yylex(), propia de Flex, donde se empieza a analizar el léxico y a reconocer los patrones establecidos en las reglas.
Finalmente, se imprime el resultado con printf, mostrando enteros (%d) con un ancho de 8 caracteres cada uno, seguido de un salto de línea.

Para ejecutar el código, es necesario seguir las siguientes instrucciones en la terminal de Linux:


```
$ flex fb1-1.l
```
Aca se lee el archivo donde esta el archivo de C, e inmediatamente se genera un archivo llamado lex.yy.c

```
$ cc lex.yy.c -lfl
```
En esta linea de codigo, se compila toda la información y se genera la ejecución de las ordenes que alli se encuentran

```
$ ./a.out
```
Finalmente, aca se ingresa el texto a analizar, donde es el siguiente:


**The boy stood on the burning deck shelling peanuts by the peck**


Donde la salida del mismo da como resultado

```
2   12   63
```

Modificando el código y la manera en que se ejecuta, se obtiene la siguiente variación:

```
$gcc lex.yy.c -lfl -o wc_flex
```

En este código:
- gcc representa el compilador GNU.
- lex.yy.c es el archivo generado.
- -lfl es la librería auxiliar necesaria.
- -o wc_flex reemplaza el ejecutable a.out por defecto, permitiendo reutilizarlo para leer archivos externos.

### fb1-1.l
```
%{
int chars = 0;
int words = 0;
int lines = 0;
%}

%%

[a-zA-Z]+  { words++; chars += strlen(yytext); }
\n { chars++; lines++; }
.  { chars++; }

%%

int main(int argc, char **argv)
{
  yylex();
  printf("%8d%8d%8d\n", lines, words, chars);
  return 0;
}
```

## Ejemplo 2

```
%%
"colour" { printf("color"); }
"flavour" { printf("flavor"); }
"clever" { printf("smart"); }
"smart" { printf("elegant"); }
"conservative" { printf("liberal"); }
```
En este apartado, el codigo establece una serie de palabras que se pueden reemplazar si se detecta la misma serie
```
. { printf("%s", yytext); }
%%
```

El punto representa cualquier otro caracter no reconocido en el lexico anterior, donde si se cumple la condicion de no reconocer, imprime la lista del char que esta en la terminal o archivo
```
flex fb1-2.l
gcc lex.yy.c -lfl -o wc_flex
./wc_flex < archivo.txt
```

Se siguen los mimsmo comando en la carpeta donde se encuentra el archivo

Por otro lado, la salida despues de ejecutar el codigo de la manera previamente indicada, se muestra el siguiente resultado.

```
color
elegant
```
En este caso, el archivo solo tenia 2 valores que reconcia, entonces la salida corresponde a la traduccion directa

### fb1-2.l
```
%%
"colour" { printf("color"); }
"flavour" { printf("flavor"); }
"clever" { printf("smart"); }
"smart" { printf("elegant"); }
"conservative" { printf("liberal"); }
. { printf("%s", yytext); }
%%
```

## Ejemplo 3

```
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
```
Se establecen los parametros que se tienen en cuenta para este codigo en C, donde se establece un simbolo y una accion directa
```
flex fb1-3.l

cc lex.yy.c -lfl
```
Se compila y se ejecuta de manera similar a los anteriores ejemplos.
```
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
```

Se obtienen los valores requeridos, especifica lo que se va ahacer y la salida correponde a lo esperado, incluso con el valor desconocido.
```
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
```
Desde el punto con el archivo externo, se obtiene los resultados esperado, solo que hubo un error , ya que al restar, se buscaba un valor diferente, ya que deberia dar un negativo

### fb1-3.l

```
%%
"+"    { printf("PLUS\n"); }
"-"    { printf("MINUS\n"); }
"*"    { printf("TIMES\n"); }
"/"    { printf("DIVIDE\n"); }
"|"    { printf("ABS\n"); }
[0-9]+ { printf("NUMBER %s\n", yytext); }
\n     { printf("NEWLINE\n"); }
[ \t]  { }
.      { printf("Mystery character %s\n", yytext); }
%%
```

## Ejemplo 4
```
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
```
Asignaciones de valores por parte numeros que directamente van a influir en la ejecucion de los valores donde se busca identificar los patrones relacionados
```
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
```
Por este lado, se obtiene que las reglas seran en busqueda de que tipo de busqueda y reglas se quieren generar, por lo tanto, retorna los valores que se validaron anteriormente.
```

main(int argc, char **argv)
{
  int tok;
  while ( (tok = yylex()) ) {
    printf("%d", tok);
    if (tok == NUMBER) printf(" = %d\n", yylval);
    else printf("\n");
  }
}
```
La funcion se genera entorno a que la variable Tok vangenerando lo que manda la funcion yylex, para hacer la comparacion y se busca una igualdad con los valores que esten dentro del ciclo While
```
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
```
En este caso, la salida se va a dar en el orden que se da en el orden y sigue el algoritmo final

### fb1-4.l
```
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
main(int argc, char **argv)
{
  int tok;
  while ( (tok = yylex()) ) {
    printf("%d", tok);
    if (tok == NUMBER) printf(" = %d\n", yylval);
    else printf("\n");
  }
}
```

## Ejemplo 5

En este ejemplo, se implementa Bison para el analisis sintactico de acuerdo a las expresiones y reglas que se establezcan.
```
 %{
     #include <stdio.h>
 %}

 %token NUMBER
 %token ADD SUB MUL DIV ABS
 %token EOL
```

Inicialmente, se generan las librerias necesarias de C para poder ejecutar la calcualdora, por otro lado, se generan los tokens, los cuales se producen por medio de Flex

```
 %%

calclist:                  
 | calclist exp EOL { printf("= %d\n", $1); } 
 ;

exp: factor       
default $$ = $1 
 | exp ADD factor { $$ = $1 + $3; }
 | exp SUB factor { $$ = $1 - $3; }
 ;

factor: term       
default $$ = $1 
 | factor MUL term { $$ = $1 * $3; }
 | factor DIV term { $$ = $1 / $3; }
 ;
 term: NUMBER  default $$ = $1 
 | ABS term   { $$ = $2 >= 0? $2 : - $2; }
 ;
```
Calclist se encarga de mostrar los resultados una vez se finalice la linea, por otro lado, exp da las reglas necesarias para poder ejecutar las sumas o las restas, factor se encarga de las multiplicaciones y divisiones, por otro lado, term se encarga de obtener el valor asboluto de cada numero.
```
 %%

 main(int argc, char **argv)
 {
    yyparse();
    }
        yyerror(char *s)
    {
    fprintf(stderr, "error: %s\n", s);
 }

```
La función main se encarga de implementar el yyparse, el cual analiza la sintaxis de cada linea, en caso de que algo falle, esta yyerror, el cual se encarga de en caso de ser requerido, muestra un error e interrumpe el funcionamiento del algoritmo.

### fb1-5.y
```
 %{
     #include <stdio.h>
 %}

 %token NUMBER
 %token ADD SUB MUL DIV ABS
 %token EOL

 %%

calclist:                  
 | calclist exp EOL { printf("= %d\n", $1); } 
 ;

exp: factor       
default $$ = $1 
 | exp ADD factor { $$ = $1 + $3; }
 | exp SUB factor { $$ = $1 - $3; }
 ;

factor: term       
default $$ = $1 
 | factor MUL term { $$ = $1 * $3; }
 | factor DIV term { $$ = $1 / $3; }
 ;
 term: NUMBER  default $$ = $1 
 | ABS term   { $$ = $2 >= 0? $2 : - $2; }
 ;
 
 %%

 main(int argc, char **argv)
 {
    yyparse();
    }
        yyerror(char *s)
    {
    fprintf(stderr, "error: %s\n", s);
 }
```

# Ejercicios
## Pregunta 1
### ¿Aceptará la calculadora una línea que solo contenga un comentario? ¿Por qué no? ¿Sería más fácil solucionar esto en el escáner o en el analizador?
Respuesta: 
La calculadora no acepta lineas que contengan comentarios, esto porque  la gramática exige calclist : calclist exp EOL, y exp no puede estar vacío, por tanto, si la línea solo tiene un comentario, el parser espera una expresión declarada anteriormente y falla al analizar el comentario.
Esto se puede solucionar antes de que llegue al parser, en el escaner, donde se implemente como un EOL y siga la ejecución de manera común.

```
"//".*            ;          /* ignora comentarios hasta fin de línea */
[\t ]+            ;          /* ignora espacios/tabs */
\n                { return EOL; }   /* línea vacía o solo comentario */
```

## Pregunta 2
### Convierte la calculadora en una calculadora hexadecimal que acepte números hexadecimales y decimales. En el escáner, añade un patrón como 0x[a-f0-9]+ para que coincida con un número hexadecimal y, en el código de acción, usa strtol para convertir la cadena en un número que almacenas en yylval; luego, devuelve un token NUMBER. Ajusta la salida printf para imprimir el resultado tanto en decimal como en hexadecimal.
Respuesta:
Se estableceran inicialmente los valores del 0 al 9 como se hizo desdes un inicio, pero con el diferencial de que al encontrar un numero seguido de una letra, se analizara el valor y se convierten en base 16 como se muestra en el siguiente codigo
### Ej2-h.l
```
%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include "Ej1-hex.tab.h"
%}

%%

[0-9]+          { yylval.num = strtol(yytext, NULL, 10); return NUMBER; }
0[xX][0-9a-fA-F]+ { yylval.num = strtol(yytext, NULL, 16); return NUMBER; }

[ \t\r]         ;                        
\n              { return EOL; }
.               { return *yytext; }    

%%

```

En el paser se cambia int yylval por long yylval para soportar hex de 32/64 bits y la impresión ahora muestra decimal y hexadecimal

### Ej2-h.y

```
%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%union {
    long num;          
}

%token <num> NUMBER
%token EOL
%left '+' '-'
%left '*' '/'
%left '|'       

%%
calclist:
    | calclist exp EOL   { printf("= %ld (0x%lX)\n", $2, $2); }
    ;

exp: factor
   | exp '+' factor  { $$ = $1 + $3; }
   | exp '-' factor  { $$ = $1 - $3; }
   | exp '*' factor  { $$ = $1 * $3; }
   | exp '/' factor  { $$ = $1 / $3; }
   ;

factor: NUMBER
      | '|' factor    { $$ = $2 >= 0 ? $2 : -$2; }
      ;
%%

void yyerror(const char *s) { fprintf(stderr, "error: %s\n", s); }
int main(void) { yyparse(); return 0; }
```

Para compilar se usa la misma estructura
```
flex Ej2-h.l
bison -d Ej2-h.y
gcc -o Ej2-h Ej2-h.tab.c lex.yy.c
Ej2-h < texto.txt
```

Donde las operaciones a realizar seran

### texto.txt
```
0x2A + 10\n0xFF / 15\n| -0xA

```
Y la salida es: 
```
= 52 (0x34)
= 17 (0x11)
= 10 (0xA)
```

## Ejercicio 3
### Añade operadores de bits como AND y OR a la calculadora. El operador obvio para OR es una barra vertical, pero este ya es el operador de valor absoluto unario. ¿Qué ocurre si también lo usas como operador OR binario, por ejemplo, exp factor ABS?
Respuesta:
Se establece el "&" como AND, "|" es Or y "||" es ABS

### Ej3.l
```
%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include "Ej1-bit.tab.h"
%}

%%

[0-9]+          { yylval.num = strtol(yytext, NULL, 10); return NUMBER; }
0[xX][0-9a-fA-F]+ { yylval.num = strtol(yytext, NULL, 16); return NUMBER; }

[ \t\r]         ;
\n              { return EOL; }
"&"             { return AND; }
"|"             { return OR;  }
"||"            { return ABS; } 
"+"|"-"|"*"|"/" { return *yytext; }  
.               { return BAD; }

%%
```

### Ej3.y
```
%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%union { long num; }

%token <num> NUMBER
%token EOL
%token AND OR ABS
%left '+' '-'
%left '*' '/'
%left AND OR          /* menor precedencia */
%right ABS            /* mayor precedencia (unario) */

%%
calclist:
    | calclist exp EOL   { printf("= %ld (0x%lX)\n", $2, $2); }
    ;

exp: factor
   | exp '+' factor      { $$ = $1 + $3; }
   | exp '-' factor      { $$ = $1 - $3; }
   | exp '*' factor      { $$ = $1 * $3; }
   | exp '/' factor      { $$ = $1 / $3; }
   | exp AND factor      { $$ = $1 & $3; }
   | exp OR  factor      { $$ = $1 | $3; }
   ;

factor: NUMBER
      | ABS factor       { $$ = $2 >= 0 ? $2 : -$2; }
      ;
%%
```

Para compilar se usa

```
flex Ej3.l
bison -d Ej3.y
gcc -o Ej3 Ej3.tab.c lex.yy.c
Ej3 < texto.txt
```


El texto a analizar sera
### texto.txt
```
0xF & 0xA\n0xF | 0xA\n|| -5\n
```

Y la salida es:
```
= 10 (0xA)
= 15 (0xF)
= 5 (0x5)
```

## Ejericio 4
### ¿La versión manuscrita del escáner del Ejemplo 1-4 reconoce exactamente los mismos tokens que la versión flexible?
Respuesta: 
No, ya que cuenta con diferencias muy marcadas, las cuales son:
- Los comentarios no estan establecidos en el 1-4
- El retorno, flex lo interpreta como un espacio, el cual puede ser ignorado
- La longitud de numeros se debe establecer en flex, sin embargo, esto puede dar problemas al limitarse con repeticiones o no
- Los operadores se establecen de manera manual

## Ejercicio 5
### ¿Puedes pensar en lenguajes para los cuales Flex no sería una buena herramienta para escribir un escáner?
Respuesta:
De acuerdo a la limitaciones de diferentes lenguajes con temas de memoria, flex podria ser conflictivo con lenguajes como: 
- Python: El manejo de memoria en Python puede generar problemas en codigos de gran complejidas al
- PHP: Flex no puede recordar la cadena literal del delimitador, el cual es parte fundamental de PHP
- Perl: Flex solo maneja estados finitos sin memoria adicional.

## Ejercicio 6
### Reescribe el programa de conteo de palabras en C. Ejecuta archivos grandes en ambas versiones. ¿Es la versión en C notablemente más rápida? ¿Cuánto más difícil fue depurarla?
Respuesta: 
El contador en C se veria algo asi
```
/* wc_c.c – contador de palabras (líneas, palabras, bytes) */
#include <stdio.h>
#include <ctype.h>

int main(void) {
    int c;
    long lines = 0, words = 0, bytes = 0;
    int in_word = 0;

    while ((c = getchar()) != EOF) {
        ++bytes;
        if (c == '\n')
            ++lines;
        if (isspace(c)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            ++words;
        }
    }
    printf("%8ld %8ld %8ld\n", lines, words, bytes);
    return 0;
}
```

Para compilar se requiere unicamente la siguiente linea 
```
gcc -O2 Ej6.c -o Ej6
```

Ahora, ponemos un texto extenso en un archivo txt y ejecutamos ambos archivos con el mismo texto
```
time ./fb1-1 < texto.txt

time ./Ej6 < texto.txt
```

Dentro de los resultados, contando mas de 8000 lineas de texto, se obtiene
```
C = 0.043 s
Flex = 0.085 s	 
```

Esto nos indica que C es mucho mas rapido en la ejecución de este tipo de ejercicio, sin embargo, cabe resaltar que depende mucho del tamaño del archivo, ya que puede ser mucho mas rapido.
