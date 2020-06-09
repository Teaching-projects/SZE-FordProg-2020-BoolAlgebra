%{
	#include "grammar.tab.h"
%}

%option noyywrap

%%

x[1-9][0-9]{0,1}			strcpy(yylval.varhelper,yytext); return VARIABLE;
list						return LISTVARIABLES;
delete						return DELETEVARIABLE;
solve						return SOLVE;
[0-1]						yylval.value=atoi(yytext); return NUMBER;
[\(\)\=]					return *yytext;
and|\&						return AND;
or|\|						return OR;
not|\-						return NOT;
eq|<\->						return EQ;
imp|->						return IMP;
\n							return '\n';
[ ]*  	   			
%%

