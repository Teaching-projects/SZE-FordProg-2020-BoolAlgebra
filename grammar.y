%{
	#include "stdio.h"
	#include "string.h"
	int yylex();
	int yyerror(char* message)
	{
        return 1;
	}
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

circle			: VARIABLE '=' NUMBER '\n' /* Add variable or change the value of an existing variable */
				{
					if(head == NULL)
					{
						head = (struct variables*)malloc(sizeof(struct variables));
						strcpy(head->name, $1);
						head->value = $3;
						head->next = NULL;
						head->prev = NULL;
						printf("Variable %s added with value %d\n", $1, $3);
					}
					else
					{
						struct variables* ll = head;
						while (ll != NULL)
						{
							if(strcmp(ll->name, $1) == 0)
							{
								ll->value = $3;
								printf("Variable %s changed to value %d\n", ll->name, ll->value);
								break;
							}
							else if (ll->next == NULL)
							{
								struct variables* temp = (struct variables*)malloc(sizeof(struct variables));
								temp->prev = ll;
								ll->next = temp;
								strcpy(temp->name, $1);
								temp->value = $3;
								temp->next = NULL;
								printf("Variable %s added with value %d\n", $1, $3);
								break;
							}
							ll = ll->next;
						}
					}
				} circle
			| LISTVARIABLES '\n' /* List existing variables */
				{
					if(head == NULL)
					{
						printf("There are no stored variables yet\n");
					}
					else
						{
						struct variables* ll = head;
						while (ll != NULL)
						{
							printf("Variable %s has value %d\n", ll->name, ll->value);
							ll = ll->next;
						}
					}
				} circle
			| DELETEVARIABLE VARIABLE '\n' /* Delete an existing variable */
				{
					struct variables* ll = head;
					int found = 0;
					while (ll != NULL)
					{
						if(strcmp(ll->name, $2) == 0)
						{
							if(ll == head)
							{
								
								head = ll->next;
							}
							else if (ll->next == NULL)
							{
								ll->prev->next = NULL;
							}
							else
							{
								ll->prev->next = ll->next;
								ll->next->prev = ll->prev;
								
							}
							printf("Deleted %s with value %d\n", ll->name, ll->value);
							ll = NULL;
						}
						else
						{
							ll = ll->next;
						}
					}
					
				} circle
			| SOLVE firstlevel '\n' /* Solve the given boolean algorithm */
					{
						if(solveerror == 1)
						{
							printf("Errors happened while tried to solve the function.\n");
							solveerror = 0;
						}
						else
						{
							printf("Finished solving. Result: %d\n",$2 );
						}
					} circle
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
			| VARIABLE
				{
					struct variables* ll = head;
					int found = 0;
					while (ll != NULL)
					{
						if(strcmp(ll->name, $1) == 0)
						{
							$$ = ll->value;
							found = 1;
						}
						ll = ll->next;
					}
					if(found == 0)
					{
						printf("Error: Couldn't find %s\n", $1);
						solveerror = 1;
						$$ = 0;
					}
				}
			| NUMBER {$$ = $1;}
			;
%%


int main()
{
	yyparse();
	return 0;
}