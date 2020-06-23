int yylex();
int yyerror(char* message)
{
    return 1;
}

void addVariable(char t1[2], int t2)
{
	if(head == NULL)
	{
		head = (struct variables*)malloc(sizeof(struct variables));
		strcpy(head->name, t1);
		head->value = t2;
		head->next = NULL;
		head->prev = NULL;
		printf("Variable %s added with value %d\n", t1, t2);
	}
	else
	{
		struct variables* ll = head;
		while (ll != NULL)
		{
			if(strcmp(ll->name, t1) == 0)
			{
				ll->value = t2;
				printf("Variable %s changed to value %d\n", ll->name, ll->value);
				break;
			}
			else if (ll->next == NULL)
			{
				struct variables* temp = (struct variables*)malloc(sizeof(struct variables));
				temp->prev = ll;
				ll->next = temp;
				strcpy(temp->name, t1);
				temp->value = t2;
				temp->next = NULL;
				printf("Variable %s added with value %d\n", t1, t2);
				break;
			}
			ll = ll->next;
		}
	}
}

void listVariables()
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
}

void deleteVariable(char t1[2])
{
	struct variables* ll = head;
	int found = 0;
	while (ll != NULL)
	{
		if(strcmp(ll->name, t1) == 0)
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
}

void solveresult(int t1)
{
	if(solveerror == 1)
	{
		printf("Errors happened while tried to solve the function.\n");
		solveerror = 0;
	}
	else
	{
		printf("Finished solving. Result: %d\n",t1 );
	}
}

int findVariable(char t1[2])
{
	struct variables* ll = head;
	int found = 0;
	while (ll != NULL)
	{
		if(strcmp(ll->name, t1) == 0)
		{
			return ll->value;
			found = 1;
		}
			ll = ll->next;
	}
	if(found == 0)
	{
		printf("Error: Couldn't find %s\n", t1);
		solveerror = 1;
		return 0;
	}
}