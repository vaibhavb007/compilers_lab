
%scanner-token-function d_scanner.lex()
%scanner Scanner.h
 
%token MNEMONIC SYMBOL IMMSYMBOL NUMBER 
%token IMMNUMBER REGISTER
 


%%
program: 
       instruction_list
       { 
	    $$ = ++nodeCount;
	    std::cout << $$ << "[label=\"program\"]\n";
	    std::cout << $$ << " -> " << $1 << "\n";
       } 
       ;

instruction_list: 
         instruction 
       { 
	    $$ = ++nodeCount;
	    std::cout << $$ << "[label=\"instruction_list\"]\n";
	    std::cout << $$ << " -> " << $1 << "\n";
       }

       | instruction_list '\n' instruction
       { 
	    $$ = ++nodeCount;
	    std::cout << $$ << "[label=\"instruction_list\"]\n";
	    std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
	    std::cout << nodeCount << "[label=\" newline \"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
       }
       ;

instruction:
         optional_label MNEMONIC 
       { 
	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"instruction\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
             std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"MNEMONIC\"]\n";
       }
       | optional_label MNEMONIC opnd
       { 
	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"instruction\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"MNEMONIC\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
       } 
       | optional_label MNEMONIC opnd ',' opnd
       { 
	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"instruction\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"MNEMONIC\"]\n";
            std::cout << $$ << " -> " << $3 << "\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\",\"]\n";
            std::cout << $$ << " -> " << $5 << "\n";
       } 
       ;

optional_label:
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"optional_label\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"epsilon\"]\n";
       }
       | SYMBOL':' '\n'
       {
	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"optional_label\"]\n";
	    std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"SYMBOL\"]\n";
	    std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\":\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"newline\"]\n";
       }
       ;

opnd:
         register_exp
       { 
	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"opnd\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
       }
       | exp
       { 
	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"opnd\"]\n";
            std::cout << $$ << " -> " << $1 << "\n";
       }
       ;
       
register_exp:
         REGISTER
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"register_exp\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"REGISTER\"]\n";
       }
       | '(' REGISTER ')'
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"register_exp\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"(\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"REGISTER\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\")\"]\n";

       }
       | NUMBER '(' REGISTER ')'
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"register_exp\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"NUMBER\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"(\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"REGISTER\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\")\"]\n";
       }
       ;

exp:
         SYMBOL
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"exp\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"SYMBOL\"]\n";
       }
       | IMMSYMBOL
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"exp\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"IMMSYMBOL\"]\n";
       }
       | NUMBER
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"exp\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"NUMBER\"]\n";
       }
       | IMMNUMBER
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"exp\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"IMMNUMBER\"]\n";
       }
       | SYMBOL '+' NUMBER
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"exp\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"SYMBOL\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"+\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"NUMBER\"]\n";
       }
       | IMMSYMBOL '+' NUMBER
       {
       	    $$ = ++nodeCount;
            std::cout << $$ << "[label=\"exp\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"IMMSYMBOL\"]\n";
	    std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"+\"]\n";
            std::cout << $$ << " -> " << ++nodeCount << "\n";
            std::cout << nodeCount << "[label=\"NUMBER\"]\n";
       }
       ;

