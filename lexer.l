%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
extern char *strdup(const char *);

int yycolumn = 1;
%}

%option noyywrap
%option yylineno

DIGIT       [0-9]
LETTER      [a-zA-Z_]
NUMBER      {DIGIT}+
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*

%%

({DIGIT})+ {
    yylval.intValue = atoi(yytext);
    return INTEGER;
}

({LETTER})({LETTER}|{DIGIT})* {
    yylval.stringValue = strdup(yytext);
    return IDENTIFIER;
}

"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return TIMES; }
"/"     { return DIVIDE; }
"="     { return ASSIGN; }
"("     { return LPAREN; }
")"     { return RPAREN; }
";"     { return SEMICOLON; }

[ \t]   { /* Skip space */ }
\n      {  yycolumn = 1; ++yylineno; }
.       {
            /*  error message */
            fprintf(stderr, "Line %d, Column %d: Error: Unexpected character '%s'\n", yylineno, yycolumn, yytext);
            ++yycolumn;
        }

%%

/*
int main(int argc, char **argv) {
    while (yylex());
    return 0;
}
*/
