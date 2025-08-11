%%
"colour" { printf("color"); }
"flavour" { printf("flavor"); }
"clever" { printf("smart"); }
"smart" { printf("elegant"); }
"conservative" { printf("liberal"); }

"En este apartado, el codigo establece una serie de palabras que se pueden reemplazar si se detecta la misma serie"

. { printf("%s", yytext); }

"El punto representa cualquier otro caracter no reconocido en el lexico anterior, donde si se cumple la condicion de no reconocer, imprime la lista del char que esta en la terminal o archivo"

%%

flex fb1-2.l

gcc lex.yy.c -lfl -o wc_flex

./wc_flex < archivo.txt

"Se siguen los mimsmo comando en la carpeta donde se encuentra el archivo"
color
elegant

"En este caso, el archivo solo tenia 2 valores que reconcia, entonces la salida corresponde a la traduccion directa"
