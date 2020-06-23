%{
	#include "stdio.h"
	#include "string.h"
	
	/*2dimensional arrays for the boolean functions... we can use the input values as az index^^*/
	int and[2][2] = {{0,0},{0,1}};//and func
	int or[2][2] = {{0,1},{1,1}};//or function
	int impl[2][2] = {{1,1},{0,1}};//implication function
	int eq[2][2] = {{1,0},{0,1}};//equalization function
	int not[2] = {1,0};//not function
	int solveerror = 0;
	/*Structure for storing variables*/
	struct variables {
		struct variables * prev;
		char name[2];
		int value;
		struct variables * next;
	};
	
	struct variables* head = NULL;//First element of linked list for the variables
	#include "functions.y"
%}

%union
{
	int value;
	char varhelper[2];
}

%token NUMBER
%token AND
%token OR
%token NOT
%token EQ
%token IMP
%token VARIABLE
%token LISTVARIABLES
%token DELETEVARIABLE
%token SOLVE
%token INVALID

%type<value> NUMBER firstlevel secondlevel thirdlevel fourthlevel fifthlevel sixthlevel
%type<varhelper> VARIABLE

%%
			/* Add variable or change the value of an existing variable */
circle		: VARIABLE '=' NUMBER '\n' { addVariable($1, $3); } circle
			/* List existing variables */
			| LISTVARIABLES '\n' { listVariables(); } circle
			/* Delete an existing variable */
			| DELETEVARIABLE VARIABLE '\n' { deleteVariable($2); } circle
			/* Solve the given boolean algorithm */
			| SOLVE firstlevel '\n' { solveresult($2); } circle
			| 
			;			

/* Language for the boolean algorithm: equalization, implication, or, and, not */
firstlevel	: firstlevel EQ secondlevel {$$ = eq[$1][$3];}
			| secondlevel {$$ = $1;}
			;
			
secondlevel	: secondlevel IMP thirdlevel {$$ = impl[$1][$3];}
			| thirdlevel {$$ = $1;}
			;
			
thirdlevel	: thirdlevel OR fourthlevel {$$ = $1 || $3;}/* $$ = or[$1][$3]; */
			| fourthlevel {$$ = $1;}
			;
			
fourthlevel	: fourthlevel AND fifthlevel {$$ = $1 && $3;}/* $$ = and[$1][$3]; */
			| fifthlevel {$$ = $1;}
			;

fifthlevel	: NOT sixthlevel {$$ = not[$2];}
			| sixthlevel {$$ = $1;}
			;
			
sixthlevel	: '(' firstlevel ')' {$$ = $2;}
			| VARIABLE { $$ = findVariable($1); }
			| NUMBER {$$ = $1;}
			;
%%


int main()
{
	yyparse();
	return 0;
}