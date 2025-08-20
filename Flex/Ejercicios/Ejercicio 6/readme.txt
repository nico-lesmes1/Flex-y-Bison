%{
int chars = 0;
int words = 0;
int lines = 0;
%}

"La primera parte del código inicializa algunas variables contadoras, se usa el lenguaje C para estas instrucciones y se genera adentro de %{ %}
 
%%
 "%% Se usan como una separación de secciones, ya que, para poder ejecutar el código de manera correcta, primero se deben declarar las variables y después se establecen as reglas que van a aplicar.

[a-zA-Z]+ { words++; chars += strlen(yytext);}
\n {chars++; lines++}
. {chars++}

"En esta parte, se obtiene que en la primera liena va a buscar los caracteres que esten en el rango establecido, en este caso, va a buscar los caracteres desde la a hasta la z, en minusculas y en mayusculas, adicional, se agrego el + para que tenga en cuenta que pueden haber una o mas repeticiones despues del patron anterior. Seguido paso, si encuentra esta concidencia en la entrada, suma 1 a la variable words, y acomula la cantidad de caracteres que tiene la palabra para sumarla a la variabel chars. La siguiente linea, al ver \n, se infiere directamente que es un salto de linea, por lo cual, al detectar que se cumple esta regla, suma  uno a la varible chars y otra unidad a la variable lines. Finalmente, el punto reconoce cualquier caracter que no este previamente definido, dando como resultado, la suma de una unidad a la variable chars.

%%

main(int argc, char **argv)
{
	yylex();
	print("%8d%8d%8d\n", lines, words, chars);
}


"La parte del main, recibe dos valores que se definen como int argc, el cual recibe la cantidad de reglas que se generaron previamente. Por otro lado, el char **argv se puede interpretar como la ruta o nombre del programa por defecto, lo cual se guarda en un arreglo de chars, es por eso que el codigo tiene doble asterisco. Seguido a esto, se encuentra la funcion yylex, la cual representa una funcion propia de flex, y es donde se empizaa analizar el lexico y a reconocer los patrones establecidos por las reglas previamente propuestas, para finalmente imprimir los resultados, donde se logra ver que se espra un int (%d) y que es de maximo 8 caracteres en todas la variables, para posteiormente hacer un salto de linea.

//////////////////////////////////////////////////////////////////////////////////

"Al momento de la ejecución, se usan los siguientes comandos"

$ flex fb1-1.l
"Aca se lee el archivo donde esta el archivo de C, e inmediatamente se genera un archivo llamado lex.yy.c"


$ cc lex.yy.c -lfl
"En esta linea de codigo, se compila toda la información y se genera la ejecución de las ordenes que alli se encuentran"

$ ./a.out
"Finalmente, aca se ingresa el texto a analizar, donde es el siguiente":

The boy stood on the burning deck
shelling peanuts by the peck
^D

"Donde la salida del mismo da como resultado"
2   12   63

"Modificando el codigo y la manera en la que este se ejecuta, se obtiene la siguiente variación"
$gcc lex.yy.c -lfl -o wc_flex

"En este codigo, el gcc representa el compilador direccionado por GNU", lex.yy.c es el archivo generado por el codigo anteriormente ejecutado"
"-lfl es una libreria auxiliar necesario para poder ejecutar el valor y -o wc_flex es una funcion que reemplaza el a.out que viene por defecto, para poder leer archivos externos"
