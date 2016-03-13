%scanner Scanner.h
%scanner-token-function d_scanner.lex()
%token VOID INT FLOAT INT_CONSTANT FLOAT_CONSTANT RETURN IF ELSE WHILE FOR IDENTIFIER STRING_LITERAL
%token GE_OP LE_OP EQ_OP NE_OP OR_OP AND_OP INC_OP STRUCT PTR_OP
%polymorphic Int : int; Float : float; String : std::string; ast : abstract_astnode*
%type <Int> INT_CONSTANT
%type <Float> FLOAT_CONSTANT
%type <String> STRING_LITERAL, IDENTIFIER
%type <ast> compound_statement, statement_list, statement, assignment_statement, expression, logical_and_expression, logical_or_expression, equality_expression, relational_expression, additive_expression, multiplicative_expression, unary_expression, postfix_expression, primary_expression, l_expression, expression_list, selection_statement, iteration_statement, declaration_list, declaration, declarator_list, unary_operator
%%

translation_unit:
    struct_specifier
 	| function_definition
 	| translation_unit function_definition
    {
        for(int i=0; i<gst.size(); i++){
            gst[i].print();
            std::cout<<"\n";
            std::cout<<"Symbol table for "<<gst[i].symbol_name<<"\n";
            gst[i].symtab->print();
            std::cout<<"\n";
        }
    }
    | translation_unit struct_specifier
    ;

struct_specifier 
        : STRUCT IDENTIFIER
        {
        	current = new funTable();
        	isstruct = true;
        	last_offset = 0;
            size = 0;
            global_entry a(0, $2, current);
            gst.push_back(a);
        }
        '{' declaration_list '}' ';'
        {
        	int i;
            for(i=0; i<gst.size(); i++){
                if(!gst[i].gl && gst[i].symbol_name == $2){
                    gst[i].update_size(size); break;
                }
            }
        }
        ;

function_definition
	: type_specifier
    {
        current = new funTable();
        isstruct = false;
        islocal = false;
        fun_type = type;
        size = 0;
    }
    fun_declarator
    {
        global_entry a(1, fun_name, fun_type, current);
        gst.push_back(a);
        islocal = true;
        size = 0;
    }
    compound_statement
	;

type_specifier                   // This is the information
        : VOID 	                 // that gets associated with each identifier
        {
        	type = "VOID";
            old_type = type;
            type_size = 4;
            curr_size = type_size;
        }
        | INT
        {
        	type = "INT";
            old_type = type;
            type_size = 4;
            curr_size = type_size;
        }
		| FLOAT
		{
			type = "FLOAT";
            old_type = type;
            type_size = 4;
            curr_size = type_size;
		}
        | STRUCT IDENTIFIER
        {
        	bool flag = false;
            for(int i=0; i<gst.size(); i++){
                if(!gst[i].gl && gst[i].symbol_name == $2){
                    flag = true;
                    type_size = gst[i].size;
                    curr_size = type_size;
                    break;
                }
            }
            if(!flag) std::cerr<<"Error:The struct is not defined\n";
            type = "STRUCT " + $2;
            old_type = type;
        }
        ;

fun_declarator
	: IDENTIFIER '(' parameter_list ')'
    {
        fun_name = $1;
    }
	| IDENTIFIER '(' ')'
    {
        fun_name = $1;
    }    
    | '*' fun_declarator  //The * is associated with the function name
    {
        fun_type = "pointer(" + fun_type +")";
    }
	;


parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: type_specifier declarator
    {
        
        size += curr_size;
        fun_entry a (name, 0, type, curr_size, size);
        current->addEntry(a);
        type = old_type;
        curr_size = type_size;
    }
    ;

declarator
	: IDENTIFIER
	{
        name = $1;
	}
	| declarator '[' primary_expression']' // check separately that it is a constant
    {
        if($3->type == "INT_CONSTANT"){
            type = "array("+ std::to_string(((IntConst*)$3)->cons) + "," + type +")";
            curr_size = curr_size * ((IntConst*)$3)->cons;
        }
    }
    | '*' declarator
    {
        type = "pointer(" + type +")";
        curr_size = 4;
    }
    ;

primary_expression              // The smallest expressions, need not have a l_value
        : IDENTIFIER            // primary expression has IDENTIFIER now
        {
            Identifier*a = new Identifier($1);
            $$ = a;
			bool flag = false;
            for(int i=0; i<current->local_table.size(); i++){
                if(current->local_table[i].symbol_name == $1){
                    flag = true;
                    $$->type = current->local_table[i].type;
                    break;
                }
            }
            if(!flag) std::cerr<<"Error: The variable "<<$1<<" is not defined\n";
		}
        | INT_CONSTANT
        {
        	$$ = new IntConst($1);
            $$->type = "INT_CONSTANT";
        }
        | FLOAT_CONSTANT
        {
			$$ = new FloatConst($1);
            $$->type = "FLOAT_CONSTANT";
		}
        | STRING_LITERAL
        {
        	$$ = new StringConst($1);
            $$->type = "STRING_LITERAL";
        }
        | '(' expression ')'
        {
			$$ = $2;
            $$->type = $2->type;
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
            $$->type = $1->type;
    	}
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
    {
        size += curr_size;
        if(isstruct){
            fun_entry a (name, 1, type, curr_size, -size);
            current->addEntry(a);
        }
        else{
            if(islocal){
                fun_entry b(name, 1, type, curr_size, -size);
                current->addEntry(b);
            }
            else{
                fun_entry b(name, 0, type, curr_size, size);
                current->addEntry(b);
            }
        }
        type = old_type;
        curr_size = type_size;
    }
	| declarator_list ',' declarator
    {
        size += curr_size;
        if(isstruct){
            fun_entry a (name, 1, type, curr_size, -size);
            current->addEntry(a);
        }
        else{
            if(islocal){
                fun_entry b(name, 1, type, curr_size, -size);
                current->addEntry(b);
            }
            else{
                fun_entry b(name, 0, type, curr_size, size);
                current->addEntry(b);
            }
        }
        type = old_type;
        curr_size = type_size;
    }
 	;
