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