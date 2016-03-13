%debug
%scanner Scanner.h
%scanner-token-function d_scanner.lex()
%token VOID INT FLOAT FLOAT_CONSTANT INT_CONSTANT AND_OP OR_OP EQ_OP NE_OP GE_OP LE_OP STRING_LITERAL IF ELSE WHILE FOR RETURN STRUCT IDENTIFIER INC_OP PTR_OP
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

primary_expression              // The smallest expressions, need not have a l_value

        : IDENTIFIER            // primary expression has IDENTIFIER now
        {
			$$ = $1;
		}
        | INT_CONSTANT
        {
        	$$ = new IntConst($1);
        }
        | FLOAT_CONSTANT
        {
			$$ = new FloatConst($1);
		}
        | STRING_LITERAL
        {
        	$$ = new StringConst($1);
        }
        | '(' expression ')'
        {
			$$ = $2;
		}
        ;

compound_statement
	: '{' '}'
    {
		$$ = new Empty();
		$$ -> print();
	}
	| '{' statement_list '}'
    {
		$$ = $2;
		$$ -> print();
	}
    | '{' declaration_list statement_list '}'
    {
    	$$ = $3;
    	$$ -> print();
    }
	;

statement_list
	: statement
    {
		Seq * obj = new Seq();
		obj->add_node($1);
		$$ = obj;
	}
    | statement_list statement
    {
    	((Seq*)$1)->add_node($2);
    	$$ = $1;
    }
	;

statement
        : '{' statement_list '}'
        {
        	$$ = $2;
        }
        | selection_statement
        {
        	$$ = $1;
        }
        | iteration_statement
        {
        	$$ = $1;
        }
    	| assignment_statement
        {
            $$ = $1;
        }
        | RETURN expression ';'
        {
        	$$ = new Return($2);
        }
        ;

assignment_statement
	: ';'
    {
		$$ = new Empty();
	}
	|  expression ';'
    {
		$$ = $1;
	}
	;

expression                                   //assignment expressions are right associative
        :  logical_or_expression
        {
    		$$ = $1;
    	}
//      |  l_expression '=' expression       // This is the most significant change --
        |  unary_expression '=' expression   // l_expression has been replaced by unary_expression.
        {
            $$ = new Ass($1,$3);
        }

        ;                                    // This may generate programs that are syntactically incorrect.
                                             // Eliminate them during semantic analysis.

logical_or_expression            // The usual hierarchy that starts here...
	: logical_and_expression
    {
        $$ = $1;
    }
    | logical_or_expression OR_OP logical_and_expression
    {
        $$ = new opdual("OR_OP",$1,$3);
    }
	;
logical_and_expression
        : equality_expression
        {
        	$$ = $1;
        }
        | logical_and_expression AND_OP equality_expression
        {
        	$$ = new opdual("AND_OP", $1, $3);
        }
	;

equality_expression
	: relational_expression
    {
		$$ = $1;
	}
    | equality_expression EQ_OP relational_expression
    {
        $$ = new opdual("EQ_OP", $1, $3);
    }
	| equality_expression NE_OP relational_expression
    {
		$$ = new opdual("NE_OP", $1, $3);
	}
	;
relational_expression
	: additive_expression
    {
		$$ = $1;
	}
    | relational_expression '<' additive_expression
    {
    	$$ = new opdual("LT", $1, $3);
	}
	| relational_expression '>' additive_expression
    {
		$$ = new opdual("GT", $1, $3);
	}
	| relational_expression LE_OP additive_expression
    {
		$$ = new opdual("LE_OP", $1, $3);
	}
    | relational_expression GE_OP additive_expression
    {
        $$ = new opdual("GE_OP", $1, $3);
    }
	;

additive_expression
	: multiplicative_expression
    {
		$$ = $1;
	}
	| additive_expression '+' multiplicative_expression
    {
		$$ = new opdual("PLUS", $1, $3);
	}
	| additive_expression '-' multiplicative_expression
    {
		$$ = new opdual("MINUS", $1, $3);
	}
	;

multiplicative_expression
	: unary_expression
    {
		$$ = $1;
	}
	| multiplicative_expression '*' unary_expression
    {
		$$ = new opdual("MULT", $1, $3);
	}
	| multiplicative_expression '/' unary_expression
    {
		$$ = new opdual("DIV", $1, $3);
	}
	;
unary_expression
	: postfix_expression
    {
		$$ = $1;
	}
	| unary_operator unary_expression
    {
		$$ = new opsingle(((un_operator*)$1)->op_type, $2);
	}
                                        // unary_operator can only be '*' on the LHS of '='
	;                                     // you have to enforce this during semantic analysis

postfix_expression
	: primary_expression
    {
		$$ = $1;
	}
    | IDENTIFIER '(' ')' 				    // Cannot appear on the LHS of '='. Enforce this.
    {
        Identifier*a = new Identifier($1);
        $$ = new fncall(a);
    }
    | IDENTIFIER '(' expression_list ')'    // Cannot appear on the LHS of '='  Enforce this.
    {
		Identifier*a = new Identifier($1);
		$$ = new fncall(a,((Args*)$3)->args);
	}
    | postfix_expression '[' expression ']'         //NEW STUFF HERE. PLEASE WRITE LATER.
    {
        $$ = new ArrayRef($1,$3);
    }
    | postfix_expression '.' IDENTIFIER
    {
        Identifier* a = new Identifier($3);
        $$ = new Member($1, a);
    }
    | postfix_expression PTR_OP IDENTIFIER
    {
        Identifier* a = new Identifier($3);
        $$ = new Arrow($1, a);
    }
    | postfix_expression INC_OP 	       // Cannot appear on the LHS of '='   Enforce this
    {
		$$ = new opsingle("PP", $1);
	}
	;

// There used to be a set of productions for l_expression at this point.

expression_list
    : expression
    {
    $$ = new Args($1);
    }
    | expression_list ',' expression
    {
    	((Args*)$1)->add_arg($3);
    	$$ = $3;
    }
	;

unary_operator
    : '-'
    {
    	$$ = new un_operator("UMINUS");
    }
	| '!'
    {
    	$$ = new un_operator("NOT");
    }
    | '&'
    {
    	$$ = new un_operator("AND");           //CHECK THESE
    }
    | '*'
    {
    	$$ = new un_operator("STAR");
    }
	;

selection_statement
        : IF '(' expression ')' statement ELSE statement
        {
        	$$ = new If($3,$5,$7);
        }
	;

iteration_statement
	: WHILE '(' expression ')' statement
    {
		$$ = new While($3,$5);
	}
	| FOR '(' expression ';' expression ';' expression ')' statement  //modified this production
    {
		$$ = new For($3,$5,$7,$9);
	}
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
