%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%union {
    long num;          /* ahora almacenamos long */
}

%token <num> NUMBER
%token EOL
%left '+' '-'
%left '*' '/'
%left '|'        /* valor absoluto */

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