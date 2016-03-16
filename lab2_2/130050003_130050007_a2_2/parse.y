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
            std::cout<<"\n";
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
        : STRUCT IDENTIFIER '{'
        {
            current = new funTable();
            isstruct = true;
            last_offset = 0;
            size = 0;
            global_entry a(0, $2, current);
            gst.push_back(a);
        }
        declaration_list '}' ';'
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
        : VOID                   // that gets associated with each identifier
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
            type = "STRUCT " + $2;
            old_type = type;
        }
        ;

fun_declarator
    : IDENTIFIER '(' parameter_list ')'
    {
        bool flag = true;
        for(int i=0; i<gst.size(); i++){
            if(gst[i].symbol_name == $1 && gst[i].gl){
                flag = false;
                break;
            }
        }
        if(!flag){
            std::cerr<<ParserBase::lineNr<<": Error: conflicting types for '"<<$1<<"'\n";
            exit(0);
        }
        fun_name = $1;

    }
    | IDENTIFIER '(' ')'
    {
        bool flag = true;
        for(int i=0; i<gst.size(); i++){
            if(gst[i].symbol_name == $1 && gst[i].gl){
                flag = false;
                break;
            }
        }
        if(!flag){
            std::cerr<<ParserBase::lineNr<<": Error: conflicting types for '"<<$1<<"'\n";
            exit(0);
        }
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
        type = compute_type(type_store, type);
        fun_entry a (name, 0, type, curr_size, size);
        a.print();
        current->addEntry(a);
        type = old_type;
        curr_size = type_size;
        type_store.resize(0);
    }
    ;

declarator
    : IDENTIFIER
    {
        bool flag = true;
            for(int i=0; i<current->local_table.size(); i++){
                if(current->local_table[i].symbol_name == $1){
                    flag = false;
                    break;
                }
            }
            if(!flag){
                extern int yylineno;
                std::cerr<<ParserBase::lineNr<<": Error: The variable '"<<$1<<"' is already declared\n";
                exit(0);
            }
        name = $1;
    }
    | declarator '[' primary_expression']' // check separately that it is a constant
    {
        if(prim_expr && $3->type == "INT"){
            type_store.push_back("array("+ std::to_string(((IntConst*)$3)->cons) + ",");
            curr_size = curr_size * ((IntConst*)$3)->cons;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: the size of array '"<<name<<"' has non-integer type\n";
            exit(0);
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
            prim_expr = false;
            bool flag = false;
            for(int i=0; i<current->local_table.size(); i++){
                if(current->local_table[i].symbol_name == $1){
                    flag = true;
                    $$->type = current->local_table[i].type;
                    $$->lvalue = true;
                    break;
                }
            }
            if(!flag){
                std::cerr<<ParserBase::lineNr<<": Error: The variable "<<$1<<" is not defined\n";
                exit(0);
            }
        }
        | INT_CONSTANT
        {
            $$ = new IntConst($1);
            $$->type = "INT";
            $$->lvalue = false;
            prim_expr = true;
        }
        | FLOAT_CONSTANT
        {
            $$ = new FloatConst($1);
            $$->type = "FLOAT";
            $$->lvalue = false;
            prim_expr = false;
        }
        | STRING_LITERAL
        {
            $$ = new StringConst($1);
            $$->type = "STRING";
            $$->lvalue = false;
            prim_expr = false;
        }
        | '(' expression ')'
        {
            $$ = $2;
            $$->type = $2->type;
            $$->lvalue = $2->lvalue;
            if($2->type == "INT"){
                prim_expr = true;
            }
            else{
                prim_expr = false;
            }
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
        std::cout<<fun_name<<" statement list \n";
        $$ -> print();
    }
    | '{' declaration_list statement_list '}'
    {
        $$ = $3;
        std::cout<<fun_name<<" declaration_list statement list \n";
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
            if(fun_type == "VOID"){
                std::cerr<<ParserBase::lineNr<<": ‘return’ with a value, in function returning void.\n";
                exit(0);
            }
            string t = compatible(fun_type, $2->type);
            if(t == "NOPE"){
                std::cerr<<ParserBase::lineNr<<": Error: incompatible type for return\n";
                std::cerr<<ParserBase::lineNr<<": Note: expected ‘"<<fun_type<<"' but argument is of type '"<<($2)->type<<"'\n";
                exit(0);
            }
            else if(t.substr(0,2)=="00"){
                $$ = new Return($2);
            }
            else if(t.substr(0,2)=="20"){
                string s = t.substr(2,t.length() - 2);
                s = "TO-" + s;
                opsingle*a = new opsingle(s, $2);
                string type = ($2)->type;
                bool lvalue = ($2)->lvalue;
                $2 = a;
                ($2)->type = type;
                ($2)->lvalue = lvalue;
                $$ = new Return($2);
            }
            else if(t.substr(0,2)=="10"){
                t  = t.substr(2,t.length() -2);
                string s = t.substr(0,5);
                if(s == "array"){
                    // s = t;
                    // s = "TO-" + t;
                    // opsingle*a = new opsingle(s, $2);
                    string type = ($2)->type;
                    bool lvalue = ($2)->lvalue;
                    // $2 = a;
                    ($2)->type = type;
                    ($2)->lvalue = lvalue;
                    $$ = new Return($2);
                }
                s = t.substr(0,3);
                if(fun_type == "INT" && t == "FLOAT"){
                    opsingle*a = new opsingle("TO-INT", $2);
                    string type = ($2)->type;
                    bool lvalue = ($2)->lvalue;
                    $2 = a;
                    ($2)->type = type;
                    ($2)->lvalue = lvalue;
                    $$ = new Return($2);
                }
                s = t.substr(0,7);
                if(s == "pointer"){
                    if(($2)->type.substr(0,5) == "array"){
                        s = t;
                        s = "TO-" + s;
                        opsingle*a = new opsingle(s, $2);
                        string type = ($2)->type;
                        bool lvalue = ($2)->lvalue;
                        $2 = a;
                        ($2)->type = type;
                        ($2)->lvalue = lvalue;
                        $$ = new Return($2);
                    }
                    if(($2)->type.substr(0,5) == "point"){
                        s = "TO-" + t;
                        opsingle*a = new opsingle(s, $2);
                        string type = ($2)->type;
                        bool lvalue = ($2)->lvalue;
                        $2 = a;
                        ($2)->type = type;
                        ($2)->lvalue = lvalue;
                        $$ = new Return($2);
                    }
                }
            }
            else{
                std::cerr<<ParserBase::lineNr<<": Error: incompatible type for argument return\n";
                std::cerr<<ParserBase::lineNr<<": Note: expected '"<<fun_type<<"' but argument is of type '"<<($2)->type<<"'\n";
                exit(0);
            }
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
        |  unary_expression '=' expression   // l_expression has been replaced by unary_expression.
        {
            string s1;
            if($1->lvalue){
                string t = compatible($1->type, $3->type);
                if(t.substr(0,2) == "00"){
                    $$ = new Ass($1,$3);
                    $$->lvalue = false;
                }
                else if(t == "NOPE"){
                    std::cerr<<ParserBase::lineNr<<": Error: incompatible type for '"<<$1->type<<"’\n";
                    std::cerr<<ParserBase::lineNr<<": Note: expected ‘"<<$1->type<<"' but argument is of type '"<<$3->type<<"'\n";
                    exit(0);
                }
                else if(t.substr(0,2)=="20"){
                    string s = t.substr(2,t.length() - 2);
                    s1 = "-TO-" + s;
                    s = "TO-" + s;
                    opsingle*a = new opsingle(s, $3);
                    string type = $3->type;
                    bool lvalue = $3->lvalue;
                    $3 = a;
                    $3->type = type;
                    $3->lvalue = lvalue;
                    $$ = new Ass($1,$3);
                    ((Ass*)$$)->s += s1;
                    $$->lvalue = false;
                }
                else if(t.substr(0,2)=="10"){
                    t  = t.substr(2,t.length() -2);
                    string s = t.substr(0,5);
                    if(s == "array"){
                        // s = t;
                        // s1 = "-TO-" + t;
                        // s = "TO-" + s;
                        // opsingle*a = new opsingle(s, $3);
                        string type = ($3)->type;
                        bool lvalue = ($3)->lvalue;
                        // $3 = a;
                        ($3)->type = type;
                        ($3)->lvalue = lvalue;
                        $$ = new Ass($1,$3);
                        ((Ass*)$$)->s += s1;
                        $$->lvalue = false;
                    }
                    s = t.substr(0,3);
                    if($1->type == "INT" && t == "FLOAT"){
                        opsingle*a = new opsingle("TO-INT", $3);
                        s1 = "-TO-" + t;
                        string type = ($3)->type;
                        bool lvalue = ($3)->lvalue;
                        $3 = a;
                        ($3)->type = type;
                        ($3)->lvalue = lvalue;
                        $$ = new Ass($1,$3);
                        ((Ass*)$$)->s += s1;
                        $$->lvalue = false;
                    }
                    s = t.substr(0,7);
                    if(s == "pointer"){
                        if(($3)->type.substr(0,5) == "array"){
                            s = t;
                            s1 = "-TO-" + s;
                            s = "TO-" + s;
                            opsingle*a = new opsingle(s, $3);
                            string type = ($3)->type;
                            bool lvalue = ($3)->lvalue;
                            $3 = a;
                            ($3)->type = type;
                            ($3)->lvalue = lvalue;
                            $$ = new Ass($1,$3);
                            ((Ass*)$$)->s += s1;
                            $$->lvalue = false;
                        }
                        if(($3)->type.substr(0,5) == "point"){
                            s1 = "-TO-" + t;
                            s = "TO-" + t;
                            opsingle*a = new opsingle(s, $3);
                            string type = ($3)->type;
                            bool lvalue = ($3)->lvalue;
                            $3 = a;
                            ($3)->type = type;
                            ($3)->lvalue = lvalue;
                            $$ = new Ass($1,$3);
                            ((Ass*)$$)->s += s1;
                            $$->lvalue = false;
                        }
                    }
                }


                else{
                    std::cerr<<ParserBase::lineNr<<": Error: incompatible types when assigning to type '"<<$1->type<<"' from type '"<<$3->type<<"'\n";
                    exit(0);
                }
            }
            else{
                std::cerr<<ParserBase::lineNr<<": Error: lvalue required as left operand of assignment\n";
                exit(0);
            }
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
        if(($1->type == "INT" || $1->type == "FLOAT") && ($3->type == "INT" || $3->type == "FLOAT")){
            $$ = new opdual("OR_OP",$1,$3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: Invalid operands to binary "<<OR_OP<<"\n";
            exit(0);
        }
    }
    ;
logical_and_expression
        : equality_expression
        {
            $$ = $1;
        }
        | logical_and_expression AND_OP equality_expression
        {
            if(($1->type == "INT" || $1->type == "FLOAT") && ($3->type == "INT" || $3->type == "FLOAT")){
            $$ = new opdual("AND_OP",$1,$3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: Invalid operands to binary "<<AND_OP<<"\n";
            exit(0);
        }
        }
    ;

equality_expression
    : relational_expression
    {
        $$ = $1;
    }
    | equality_expression EQ_OP relational_expression
    {
        if(($1->type == "INT" || $1->type == "FLOAT") && ($3->type == "INT" || $3->type == "FLOAT")){
            $$ = new opdual("EQ_OP",$1,$3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: Invalid operands to binary "<<EQ_OP<<"\n";
            exit(0);
        }
    }
    | equality_expression NE_OP relational_expression
    {
        if(($1->type == "INT" || $1->type == "FLOAT") && ($3->type == "INT" || $3->type == "FLOAT")){
            $$ = new opdual("NE_OP",$1,$3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: Invalid operands to binary "<<NE_OP<<"\n";
            exit(0);
        }
    }
    ;
relational_expression
    : additive_expression
    {
        $$ = $1;
    }
    | relational_expression '<' additive_expression
    {
        if($1->type == "INT" && $3->type == "INT"){
            $$ = new opdual("LT-INT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "FLOAT"){
            $$ = new opdual("LT-FLOAT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "INT" && $3->type == "FLOAT"){
            opsingle*a = new opsingle("TO-FLOAT", $1);
            $$ = new opdual("LT-FLOAT", a, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "INT"){
            opsingle*a = new opsingle("TO-FLOAT", $3);
            $$ = new opdual("LT-FLOAT", $1, a);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: invalid operands to binary < \n";
            exit(0);
        }
    }
    | relational_expression '>' additive_expression
    {
        if($1->type == "INT" && $3->type == "INT"){
            $$ = new opdual("GT-INT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "FLOAT"){
            $$ = new opdual("GT-FLOAT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "INT" && $3->type == "FLOAT"){
            opsingle*a = new opsingle("TO-FLOAT", $1);
            $$ = new opdual("GT-FLOAT", a, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "INT"){
            opsingle*a = new opsingle("TO-FLOAT", $3);
            $$ = new opdual("GT-FLOAT", $1, a);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: invalid operands to binary > \n";
            exit(0);
        }
    }
    | relational_expression LE_OP additive_expression
    {
        if($1->type == "INT" && $3->type == "INT"){
            $$ = new opdual("LE_OP-INT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "FLOAT"){
            $$ = new opdual("LE_OP-FLOAT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "INT" && $3->type == "FLOAT"){
            opsingle*a = new opsingle("TO-FLOAT", $1);
            $$ = new opdual("LE_OP-FLOAT", a, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "INT"){
            opsingle*a = new opsingle("TO-FLOAT", $3);
            $$ = new opdual("LE_OP-FLOAT", $1, a);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: invalid operands to binary "<<LE_OP<<"\n";
            exit(0);
        }
    }
    | relational_expression GE_OP additive_expression
    {
        if($1->type == "INT" && $3->type == "INT"){
            $$ = new opdual("GE_OP-INT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "FLOAT"){
            $$ = new opdual("GE_OP-FLOAT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "INT" && $3->type == "FLOAT"){
            opsingle*a = new opsingle("TO-FLOAT", $1);
            $$ = new opdual("GE_OP-FLOAT", a, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "INT"){
            opsingle*a = new opsingle("TO-FLOAT", $3);
            $$ = new opdual("GE_OP-FLOAT", $1, a);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: invalid operands to binary "<<GE_OP<<"\n";
            exit(0);
        }
    }
    ;

additive_expression
    : multiplicative_expression
    {
        $$ = $1;
    }
    | additive_expression '+' multiplicative_expression
    {
        if($1->type == "INT" && $3->type == "INT"){
            $$ = new opdual("PLUS-INT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "FLOAT"){
            $$ = new opdual("PLUS-FLOAT", $1, $3);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else if($1->type == "INT" && $3->type == "FLOAT"){
            opsingle*a = new opsingle("TO-FLOAT", $1);
            $$ = new opdual("PLUS-FLOAT", a, $3);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "INT"){
            opsingle*a = new opsingle("TO-FLOAT", $3);
            $$ = new opdual("PLUS-FLOAT", $1, a);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: invalid operands to binary + \n";
            exit(0);
        }
    }
    | additive_expression '-' multiplicative_expression
    {
        if($1->type == "INT" && $3->type == "INT"){
            $$ = new opdual("MINUS-INT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "FLOAT"){
            $$ = new opdual("MINUS-FLOAT", $1, $3);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else if($1->type == "INT" && $3->type == "FLOAT"){
            opsingle*a = new opsingle("TO-FLOAT", $1);
            $$ = new opdual("MINUS-FLOAT", a, $3);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "INT"){
            opsingle*a = new opsingle("TO-FLOAT", $3);
            $$ = new opdual("MINUS-FLOAT", $1, a);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: invalid operands to binary - \n";
            exit(0);
        }
    }
    ;

multiplicative_expression
    : unary_expression
    {
        $$ = $1;
    }
    | multiplicative_expression '*' unary_expression
    {
        if($1->type == "INT" && $3->type == "INT"){
            $$ = new opdual("MULT-INT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "FLOAT"){
            $$ = new opdual("MULT-FLOAT", $1, $3);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else if($1->type == "INT" && $3->type == "FLOAT"){
            opsingle*a = new opsingle("TO-FLOAT", $1);
            $$ = new opdual("MULT-FLOAT", a, $3);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "INT"){
            opsingle*a = new opsingle("TO-FLOAT", $3);
            $$ = new opdual("MULT-FLOAT", $1, a);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: invalid operands to binary * \n";
            exit(0);
        }
    }
    | multiplicative_expression '/' unary_expression
    {
        if($1->type == "INT" && $3->type == "INT"){
            $$ = new opdual("DIV-INT", $1, $3);
            $$->type = "INT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "FLOAT"){
            $$ = new opdual("DIV-FLOAT", $1, $3);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else if($1->type == "INT" && $3->type == "FLOAT"){
            opsingle*a = new opsingle("TO-FLOAT", $1);
            $$ = new opdual("DIV-FLOAT", a, $3);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else if($1->type == "FLOAT" && $3->type == "INT"){
            opsingle*a = new opsingle("TO-FLOAT", $3);
            $$ = new opdual("DIV-FLOAT", $1, a);
            $$->type = "FLOAT";
            $$->lvalue = false;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: invalid operands to binary / \n";
            exit(0);
        }
    }
    ;
unary_expression
    : postfix_expression
    {
        $$ = $1;
    }
    | unary_operator unary_expression
    {
        if(((un_operator*)$1)->op_type == "STAR"){
            string s = $2->type;
            if(s.substr(0,4) == "VOID"){
                std::cerr<<ParserBase::lineNr<<": Error: dereferencing ‘void *’ pointer\n";
                exit(0);
            }
            else if(s.substr(0,5) == "array"){
                $$ = new opsingle(((un_operator*)$1)->op_type, $2);
                $$->lvalue = true;
                s = s.substr(0,s.length() - 1);
                std::size_t pos = s.find(",");
                s = s.substr(pos);
                s = s.substr(1,s.length() - 1);
                $$->type = s;
            }
            else if(s.substr(0,7) == "pointer"){
                $$ = new opsingle(((un_operator*)$1)->op_type, $2);
                $$->lvalue = true;
                string s = $2->type;
                s = s.substr(8, s.length()-9);
                $$->type = s;
            }
            else{
                std::cerr<<ParserBase::lineNr<<": Error: invalid type argument of unary ‘*’ (have '"<<$2->type<<"’)\n";
                exit(0);
            }
        }
        else if(((un_operator*)$1)->op_type == "AND"){
            if($2->lvalue){
                string s = $2->type;
                s = "pointer("+s+")";
                $$ = new opsingle(((un_operator*)$1)->op_type, $2);
                $$->lvalue = false;
                $$->type = s;
            }
            else{
                std::cerr<<ParserBase::lineNr<<": Error: lvalue required as unary ‘&’ operand\n";
                exit(0);
            }
        }
        else if(((un_operator*)$1)->op_type == "UMINUS"){
            if($2->type == "INT" || $2->type == "FLOAT"){
                $$ = new opsingle(((un_operator*)$1)->op_type, $2);
                $$->lvalue = 0;
                $$->type = $2->type;
            }
            else{
                std::cerr<<ParserBase::lineNr<<": Error: wrong type argument to unary minus\n";
                exit(0);
            }
        }
        else if(((un_operator*)$1)->op_type == "NOT"){
            if($2->type == "INT" || $2->type == "FLOAT" || $2->lvalue){
                $$ = new opsingle(((un_operator*)$1)->op_type, $2);
                $$->lvalue = 0;
                $$->type = $2->type;
            }
            else{
                std::cerr<<ParserBase::lineNr<<": Error: wrong type argument to unary exclamation mark\n";
                exit(0);
            }
        }
        //$$ = new opsingle(((un_operator*)$1)->op_type, $2);
    }
                                        // unary_operator can only be '*' on the LHS of '='
    ;                                     // you have to enforce this during semantic analysis

postfix_expression
    : primary_expression
    {
        $$ = $1;
    }
    | IDENTIFIER '(' ')'                    // Cannot appear on the LHS of '='. Enforce this.
    {
        int count = 0;
        string s;
        bool flag = false;
        for(int i=0; i<gst.size(); i++){
            if(gst[i].gl && gst[i].symbol_name == $1){
                flag = true;
                for(int j=0; j<(gst[i].symtab)->local_table.size(); j++){
                    if(!(gst[i].symtab)->local_table[j].isparam){
                        count++;
                    }
                }
                s = gst[i].ret_type;
            }
        }
        if(!count && flag){
            Identifier*a = new Identifier($1);
            $$ = new fncall(a);
            $$->lvalue = false;
            $$->type = s;
        }
        else{
            if(!flag){
                std::cerr<<ParserBase::lineNr<<": Error: undefined reference to '"<<$1<<"'\n";
                exit(0);
            }
            else{
                std::cerr<<ParserBase::lineNr<<": Error: too few arguments to function '"<<$1<<"' \n";
                exit(0);
            }
        }
    }
    | IDENTIFIER '(' expression_list ')'    // Cannot appear on the LHS of '='  Enforce this.
    {
        int countargs=0, actualargs=((Args*)$3)->args.size();
        string s;
        bool flag = false;
        funTable *curr;
        for(int i=0; i<gst.size(); i++){
            if(gst[i].gl && gst[i].symbol_name == $1){
                for(int j=0; j<(gst[i].symtab)->local_table.size(); j++){
                    if(!(gst[i].symtab)->local_table[j].isparam) countargs++;
                }
                s = gst[i].ret_type;
                curr = gst[i].symtab;
                flag = true;
                break;
            }
        }
        if(flag){
            if(countargs == actualargs){
                bool sign = true;
                for(int i=0; i<countargs; i++){
                    string t = compatible(curr->local_table[i].type, (((Args*)$3)->args[i])->type);
                    if(t == "NOPE"){
                        sign = false;
                        std::cerr<<ParserBase::lineNr<<": Error: incompatible type for argument "<<i+1<<" of '"<<$1<<"’\n";
                        std::cerr<<ParserBase::lineNr<<": Note: expected ‘"<<curr->local_table[i].type<<"' but argument is of type '"<<(((Args*)$3)->args[i])->type<<"'\n";
                        exit(0);
                    }
                    else if(t.substr(0,2)=="00"){

                    }
                    else if(t.substr(0,2)=="20"){
                        string s = t.substr(2,t.length() - 2);
                        s = "TO-" + s;
                        opsingle*a = new opsingle(s, ((Args*)$3)->args[i]);
                        string type = (((Args*)$3)->args[i])->type;
                        bool lvalue = (((Args*)$3)->args[i])->lvalue;
                        ((Args*)$3)->args[i] = a;
                        (((Args*)$3)->args[i])->type = type;
                        (((Args*)$3)->args[i])->lvalue = lvalue;
                    }
                    else if(t.substr(0,2)=="10"){
                        t  = t.substr(2,t.length() -2);
                        string s = t.substr(0,5);
                        if(s == "array"){
                            // s = t;
                            // s = "TO-" + s;
                            // opsingle*a = new opsingle(s, ((Args*)$3)->args[i]);
                            string type = (((Args*)$3)->args[i])->type;
                            bool lvalue = (((Args*)$3)->args[i])->lvalue;
                            // ((Args*)$3)->args[i] = a;
                            (((Args*)$3)->args[i])->type = type;
                            (((Args*)$3)->args[i])->lvalue = lvalue;
                        }
                        s = t.substr(0,3);
                        if(curr->local_table[i].type == "INT" && t == "FLOAT"){
                            opsingle*a = new opsingle("TO-INT", ((Args*)$3)->args[i]);
                            string type = (((Args*)$3)->args[i])->type;
                            bool lvalue = (((Args*)$3)->args[i])->lvalue;
                            ((Args*)$3)->args[i] = a;
                            (((Args*)$3)->args[i])->type = type;
                            (((Args*)$3)->args[i])->lvalue = lvalue;
                        }
                        s = t.substr(0,7);
                        if(s == "pointer"){
                            if((((Args*)$3)->args[i])->type.substr(0,5) == "array"){
                                s = t;
                                s = "TO-" + s;
                                opsingle*a = new opsingle(s, ((Args*)$3)->args[i]);
                                string type = (((Args*)$3)->args[i])->type;
                                bool lvalue = (((Args*)$3)->args[i])->lvalue;
                                ((Args*)$3)->args[i] = a;
                                (((Args*)$3)->args[i])->type = type;
                                (((Args*)$3)->args[i])->lvalue = lvalue;
                            }
                            if((((Args*)$3)->args[i])->type.substr(0,5) == "point"){
                                s = "TO-" + t;
                                opsingle*a = new opsingle(s, ((Args*)$3)->args[i]);
                                string type = (((Args*)$3)->args[i])->type;
                                bool lvalue = (((Args*)$3)->args[i])->lvalue;
                                ((Args*)$3)->args[i] = a;
                                (((Args*)$3)->args[i])->type = type;
                                (((Args*)$3)->args[i])->lvalue = lvalue;
                            }
                        }
                    }
                    else{
                        sign = false;
                        std::cerr<<ParserBase::lineNr<<": Error: incompatible type for argument "<<i+1<<" of '"<<$1<<"’\n";
                        std::cerr<<ParserBase::lineNr<<": Note: expected '"<<curr->local_table[i].type<<"' but argument is of type '"<<(((Args*)$3)->args[i])->type<<"'\n";
                        exit(0);
                    }
                }
                if(sign){
                    Identifier*a = new Identifier($1);
                    $$ = new fncall(a,((Args*)$3)->args);
                    $$->lvalue = false;
                    $$->type = s;
                }
            }
            else{
                if(countargs<actualargs){
                    std::cerr<<ParserBase::lineNr<<": Error: too many arguments to function '"<<$1<<"' \n";
                    exit(0);
                }
                else{
                    std::cerr<<ParserBase::lineNr<<": Error: too few arguments to function '"<<$1<<"' \n";
                    exit(0);
                }
            }
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: undefined reference to '"<<$1<<"'\n";
            exit(0);
        }
    }
    | postfix_expression '[' expression ']'         //NEW STUFF HERE. PLEASE WRITE LATER.
    {
        std::string s = $1->type.substr(0,5);
        if (s=="array" && $3->type == "INT"){
            s = $1->type;
            s = s.substr(0,s.length() - 1);
            std::size_t pos = s.find(",");
            s = s.substr(pos);
            s = s.substr(1,s.length() - 1);
            $$ = new ArrayRef($1,$3);
            $$->type = s;
            if(s.substr(0,5) == "array") $$->lvalue = false;
            else $$->lvalue = true; 
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: array subscript is not an integer\n";
            exit(0);
        }
    }
    | postfix_expression '.' IDENTIFIER
    {
        string s = ($1->type).substr(0,6);
        bool flag = false;
        if(s == "STRUCT"){
            string ident = ($1->type).substr(7, ($1->type).size()-7);
            for(int i=0; i<gst.size(); i++){
                if(!gst[i].gl && gst[i].symbol_name == ident){
                    for(int j=0; j<(gst[i].symtab)->local_table.size(); j++){
                        if((gst[i].symtab)->local_table[j].symbol_name == $3){
                            Identifier* a = new Identifier($3);
                            $$ = new Member($1, a);
                            $$->lvalue = true;
                            $$->type = (gst[i].symtab)->local_table[j].type;
                            flag = true;
                        }
                    }
                }
            }
            if(!flag){
                std::cerr<<ParserBase::lineNr<<": Error: request for member '"<<$3<<"' in something not a structure or union\n";
                exit(0);
            }
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: request for member ‘"<<$3<<"’ in something not a structure or union\n";
            exit(0);
        }

    }
    | postfix_expression PTR_OP IDENTIFIER
    {
        bool flag = false;
        string s = $1->type;
        string t;
        s = s.substr(0, 14);
        if(s == "pointer(STRUCT"){
            s = $1->type;
            t = s.substr(15, s.size()-16);
            for(int i=0; i<gst.size(); i++){
                if(!gst[i].gl && gst[i].symbol_name == t){
                    for(int j=0; j<(gst[i].symtab)->local_table.size(); j++){
                        if((gst[i].symtab)->local_table[j].symbol_name == $3){
                            Identifier* a = new Identifier($3);
                            $$ = new Arrow($1, a);
                            $$->lvalue = true;
                            $$->type = (gst[i].symtab)->local_table[j].type;
                            flag = true; break;
                        }
                    }
                }
            }
            if(!flag){
                std::cerr<<ParserBase::lineNr<<": Error: 'struct "<<t<<"' has no member named '"<<$3<<"'\n";
                exit(0);
            }
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error: invalid type argument of '->'\n";
            exit(0);
        }
    }
    | postfix_expression INC_OP            // Cannot appear on the LHS of '='   Enforce this
    {
        if($1->lvalue){
            opsingle * a = new opsingle("PP", $1);
            a->lvalue = false;
            a->type = ($1)->type;
            $$ = a;
        }
        else{
            std::cerr<<ParserBase::lineNr<<": Error:  lvalue required as increment operand \n";
            exit(0);
        }
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
        $$ = $1;
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
        | declaration_list declaration;

declaration
    : type_specifier declarator_list';' ;

declarator_list
    : declarator
    {
        size += curr_size;
         if(type.substr(0, 6) != "pointer"){
            if(type.substr(0,6) == "STRUCT"){
                bool flag = false;
                string s = type.substr(7, type.size()-7);
                for(int i=0; i<gst.size()-1; i++){
                    if(!gst[i].gl && gst[i].symbol_name == s){
                        flag = true;
                        type_size = gst[i].size;
                        curr_size = type_size;
                        break;
                    }
                }
                if(!flag){
                    std::cerr<<ParserBase::lineNr<<": Error: The struct "<<s<<" is not defined\n";
                    exit(0);
                }
            }
            else if(type.substr(0,4) == "VOID"){
                std::cerr<<ParserBase::lineNr<<": Error: variable or field '"<<name<<"' declared void\n";
                exit(0);
            }
        }
        type = compute_type(type_store, type);
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
        type_store.resize(0);
        curr_size = type_size;
    }
    | declarator_list ',' declarator
    {
        size += curr_size;
        if(type.substr(0, 6) != "pointer"){
            if(type.substr(0,6) == "STRUCT"){
                bool flag = false;
                string s = type.substr(7, type.size()-7);
                for(int i=0; i<gst.size()-1; i++){
                    if(!gst[i].gl && gst[i].symbol_name == s){
                        flag = true;
                        type_size = gst[i].size;
                        curr_size = type_size;
                        break;
                    }
                }
                if(!flag){
                    std::cerr<<ParserBase::lineNr<<": Error:The struct "<<s<<" is not declared\n";
                    exit(0);
                }
            }
        }
        type = compute_type(type_store, type);
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
        type_store.resize(0);
        curr_size = type_size;
    }
    ;
