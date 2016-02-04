%scanner Scanner.h
%scanner-token-function d_scanner.lex()
%token VOID INT FLOAT INT_CONSTANT FLOAT_CONSTANT RETURN IF ELSE WHILE FOR IDENTIFIER STRING_LITERAL
%token GE_OP LE_OP EQ_OP NE_OP OR_OP AND_OP INC_OP


%%
translation_unit :  
    function_definition
    {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"translation_unit\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
    } 
  | translation_unit function_definition 
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"translation_unit\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << $2 << "\n";
  }
  ;


function_definition :  
          type_specifier fun_declarator compound_statement
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"function_definition\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << $2 << "\n";
            std::cout << $$ << " -> " << $3 << "\n";
          } 
          ;
  

type_specifier  : 
          VOID
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"type_specifier\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"VOID\"]\n";
          }  
        | INT
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"type_specifier\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"INT\"]\n";
        }   
  | FLOAT
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"type_specifier\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"FLOAT\"]\n";
  }
  | STRING_LITERAL
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"type_specifier\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"STRING_LITERAL\"]\n";
  } 
  ;
        

fun_declarator : 
          IDENTIFIER '(' parameter_list ')'
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"fun_declarator\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"IDENTIFIER\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"(\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\")\"]\n";
          } 
        | IDENTIFIER '(' ')'
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"fun_declarator\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"IDENTIFIER\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"(\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\")\"]\n";
        } 
  ;

parameter_list : 
    parameter_declaration
    {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"parameter_list\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
    } 
  | parameter_list ',' parameter_declaration
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"parameter_list\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"comma\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
  } 
  ;
  

parameter_declaration : 
          type_specifier declarator
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"parameter_declaration\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << $2 << "\n";
          } 
          ;
        

declarator : 
          IDENTIFIER
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"declarator\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"IDENTIFIER\"]\n";
          } 
  | declarator '[' constant_expression ']'
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"declarator\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"[\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"]\"]\n";
  } 
  ;
        

constant_expression : 
          INT_CONSTANT
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"constant_expression\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"INT_CONSTANT\"]\n";
          } 
        | FLOAT_CONSTANT 
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"constant_expression\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"FLOAT_CONSTANT\"]\n";
        }
        ;

compound_statement : 
          '{' '}'
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"compound_statement\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"{\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"}\"]\n";
          } 
  | '{' statement_list '}'
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"compound_statement\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"{\"]\n";
      std::cout << $$ << " -> " << $2 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"}\"]\n";
  } 
        | '{' declaration_list statement_list '}'
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"compound_statement\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"{\"]\n";
            std::cout << $$ << " -> " << $2 << "\n";
            std::cout << $$ << " -> " << $3 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"}\"]\n";
        } 
        ;
  

statement_list : 
          statement
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"statement_list\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }   
        | statement_list statement
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"statement_list\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << $2 << "\n";
        }  
        ;
  

statement : 
          '{' statement_list '}'  //a solution to the local decl problem
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"statement\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"{\"]\n";
            std::cout << $$ << " -> " << $2 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"}\"]\n";
          }
        | selection_statement
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"statement\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
        }   
        | iteration_statement
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"statement\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
        }   
  | assignment_statement
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"statement\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
  }  
        | RETURN expression ';'
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"statement\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"RETURN\"]\n";
            std::cout << $$ << " -> " << $2 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\";\"]\n";
        } 
        ;
        

assignment_statement : 
          ';'
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"assignment_statement\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\";\"]\n";
          }               
  |  l_expression '=' expression ';'
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"assignment_statement\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"=\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\";\"]\n";
  }  
  ;


expression : 
          logical_and_expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          } 
        | expression OR_OP logical_and_expression
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"OR_OP\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
        }
        ;


logical_and_expression : 
          equality_expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"logical_and_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }
        | logical_and_expression AND_OP equality_expression
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"logical_and_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"AND_OP\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
        } 
        ;


equality_expression : 
          relational_expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"equality_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          } 
        | equality_expression EQ_OP relational_expression
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"equality_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"EQ_OP\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
        }   
  | equality_expression NE_OP relational_expression
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"equality_expression\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"NE_OP\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
  }
  ;

relational_expression : 
          additive_expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"relational_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }
        | relational_expression '<' additive_expression
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"relational_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"<\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
        } 
  | relational_expression '>' additive_expression
  {
      $$ = ++nodecount;
            std::cout << $$ << "[label=\"relational_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\">\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
  } 
  | relational_expression LE_OP additive_expression
  {
      $$ = ++nodecount;
            std::cout << $$ << "[label=\"relational_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"LE_OP\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
  } 
        | relational_expression GE_OP additive_expression
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"relational_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"GE_OP\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
        } 
        ;
  

additive_expression : 
          multiplicative_expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"additive_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }
  | additive_expression '+' multiplicative_expression
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"additive_expression\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"+\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
  } 
  | additive_expression '-' multiplicative_expression
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"additive_expression\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"-\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
  } 
  ;
  

multiplicative_expression : 
          unary_expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"multiplicative_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }
  | multiplicative_expression '*' unary_expression
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"multiplicative_expression\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"*\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
  } 
  | multiplicative_expression '/' unary_expression
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"multiplicative_expression\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"/\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
  } 
  ;

unary_expression : 
          postfix_expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"unary_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }          
  | unary_operator postfix_expression
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"unary_expression\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << $2 << "\n";
  } 
  ;
  

postfix_expression : 
          primary_expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"postfix_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }
        | IDENTIFIER '(' ')'
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"postfix_expression\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"IDENTIFIER\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"(\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\")\"]\n";
        }
  | IDENTIFIER '(' expression_list ')'
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"postfix_expression\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"IDENTIFIER\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"(\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\")\"]\n";
  } 
  | l_expression INC_OP
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"postfix_expression\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"INC_OP\"]\n";
  }
  ;

primary_expression : 
          l_expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"primary_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }
        | l_expression '=' expression
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"primary_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"=\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
        } 
  | INT_CONSTANT
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"primary_expression\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"INT_CONSTANT\"]\n";
  }
  | FLOAT_CONSTANT
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"primary_expression\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"FLOAT_CONSTANT\"]\n";
  }
  | STRING_LITERAL
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"primary_expression\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"STRING_LITERAL\"]\n";
  }
  | '(' expression ')'
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"primary_expression\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"(\"]\n";
      std::cout << $$ << " -> " << $2 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\")\"]\n";
  }  
  ;

l_expression : 
          IDENTIFIER
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"l_expression\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"IDENTIFIER\"]\n";
          }
        | l_expression '[' expression ']'
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"l_expression\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"[\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"]\"]\n";
        }   
        ;

expression_list : 
          expression
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"expression_list\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }
        | expression_list ',' expression
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"expression_list\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\",\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
        }
        ;

unary_operator : 
          '-'
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"unary_operator\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"-\"]\n";
          } 
  | '!'
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"unary_operator\"]\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\"!\"]\n";
  }  
  ; 

selection_statement : 
          IF '(' expression ')' statement ELSE statement
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"selection_statement\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"IF\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"(\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\")\"]\n";
            std::cout << $$ << " -> " << $5 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"ELSE\"]\n";
            std::cout << $$ << " -> " << $7 << "\n";
          } 
          ;

iteration_statement : 
          WHILE '(' expression ')' statement
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"iteration_statement\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"WHILE\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"(\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\")\"]\n";
            std::cout << $$ << " -> " << $5 << "\n";
          }  
        | FOR '(' expression ';' expression ';' expression ')' statement
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"iteration_statement\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"FOR\"]\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\"(\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\";\"]\n";
            std::cout << $$ << " -> " << $5 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\";\"]\n";
            std::cout << $$ << " -> " << $7 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\")\"]\n";
            std::cout << $$ << " -> " << $9 << "\n";
        }
        ;

declaration_list : 
          declaration
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"declaration_list\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }           
        | declaration_list declaration
        {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"declaration_list\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << $2 << "\n";
        }
        ;

declaration : 
          type_specifier declarator_list';'
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"declaration\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << $2 << "\n";
            std::cout << $$ << " -> " << ++nodecount << "\n";
            std::cout << nodecount << "[label=\";\"]\n";
          }
          ;

declarator_list : 
          declarator
          {
            $$ = ++nodecount;
            std::cout << $$ << "[label=\"declarator_list\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
          }
  | declarator_list ',' declarator
  {
      $$ = ++nodecount;
      std::cout << $$ << "[label=\"declarator_list\"]\n";
      std::cout << $$ << " -> " << $1 << "\n";
      std::cout << $$ << " -> " << ++nodecount << "\n";
      std::cout << nodecount << "[label=\",\"]\n";
      std::cout << $$ << " -> " << $3 << "\n";
  } 
  ;