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
%left AND OR          
%right ABS            

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