%scanner Scanner.h
%scanner-token-function d_scanner.lex()
%token VOID INT FLOAT INT_CONSTANT FLOAT_CONSTANT RETURN IF ELSE WHILE FOR IDENTIFIER STRING_LITERAL
%token GE_OP LE_OP EQ_OP NE_OP OR_OP AND_OP INC_OP STRUCT PTR_OP
%polymorphic Int : int; Float : float; String : std::string; ast : abstract_astnode*
%type <Int> INT_CONSTANT
%type <Float> FLOAT_CONSTANT
%type <String> STRING_LITERAL, IDENTIFIER
%type <ast> compound_statement, statement_list, statement, assignment_statement, expression, logical_and_expression, equality_expression, relational_expression, additive_expression, multiplicative_expression, unary_expression, postfix_expression, primary_expression, l_expression, expression_list, selection_statement, iteration_statement, declaration_list, declaration, declarator_list, unary_operator

%%

translation_unit
        :  struct_specifier
 	| function_definition
 	| translation_unit function_definition
        | translation_unit struct_specifier
        ;

struct_specifier
        : STRUCT IDENTIFIER '{' declaration_list '}' ';'
        ;

function_definition
	: type_specifier fun_declarator compound_statement
	;

type_specifier                   // This is the information
        : VOID 	                 // that gets associated with each identifier
        | INT
	| FLOAT
        | STRUCT IDENTIFIER
        ;

fun_declarator
	: IDENTIFIER '(' parameter_list ')'
	| IDENTIFIER '(' ')'
        | '*' fun_declarator  //The * is associated with the
	;                      //function name


parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: type_specifier declarator
        ;

declarator
	: IDENTIFIER
	| declarator '[' primary_expression']' // check separately that it is a constant
        | '*' declarator
        ;

primary_expression
        : l_expression
        | INT_CONSTANT
        | FLOAT_CONSTANT
        | STRING_LITERAL
        | '(' expression ')'
        ;

compound_statement
	: '{' '}'
	| '{' statement_list '}'
        | '{' declaration_list statement_list '}'
	;

statement_list
	: statement
        | statement_list statement
	;

statement
        : '{' statement_list '}'
        | selection_statement
        | iteration_statement
	| assignment_statement
        | RETURN expression ';'
        ;

assignment_statement
	: ';'
	|  expression ';'
	;

expression             //assignment expressions are right associative
        :  logical_or_expression
        |  l_expression '=' expression
        ;

logical_or_expression            // The usual hierarchy that starts here...
	: logical_and_expression
        | logical_or_expression OR_OP logical_and_expression
	;
logical_and_expression
        : equality_expression
        | logical_and_expression AND_OP equality_expression
	;

equality_expression
	: relational_expression
        | equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;
relational_expression
	: additive_expression
        | relational_expression '<' additive_expression
	| relational_expression '>' additive_expression
	| relational_expression LE_OP additive_expression
        | relational_expression GE_OP additive_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

multiplicative_expression
	: unary_expression
	| multiplicative_expression '*' unary_expression
	| multiplicative_expression '/' unary_expression
	;
unary_expression
	: postfix_expression
	| unary_operator postfix_expression
	;

postfix_expression
	: primary_expression
        | IDENTIFIER '(' ')'
	| IDENTIFIER '(' expression_list ')'
        | postfix_expression '[' expression ']'
        | postfix_expression '.' IDENTIFIER
        | postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP 	// ... and ends here
	;

l_expression                // A separate non-terminal for l_expressions
        : IDENTIFIER
        | l_expression '[' expression ']'
        | '*' l_expression
        | l_expression '.' IDENTIFIER
        | l_expression PTR_OP IDENTIFIER
        | '(' l_expression ')'
        ;

expression_list
        : expression
        | expression_list ',' expression
	;

unary_operator
        : '-'
	| '!'
        | '&'
        | '*'
	;

selection_statement
        : IF '(' expression ')' statement ELSE statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	| FOR '(' expression ';' expression ';' expression ')' statement  //modified this production
        ;

declaration_list
        : declaration
        | declaration_list declaration
	;

declaration
	: type_specifier declarator_list';'
	;

declarator_list
	: declarator
	| declarator_list ',' declarator
 	;
