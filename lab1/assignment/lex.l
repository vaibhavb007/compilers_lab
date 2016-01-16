

// There may be some flexer directives here

%%
[ \t]                                    //skip
[ \b]									 //skip
INT|FLOAT|VOID|int|float|void				return VARIABLE;
[[:digit:]]+ 								return INT_CONSTANT;
[[:digit:]]*'.'[[:digit:]]*					return FLOAT_CONSTANT;
RETURN|return								return RETURN;
IF|if 										return IF;
ELSE|else 									return ELSE;
WHILE|while									return WHILE;
FOR|for										return FOR;
[[:alpha:]][[:alnum:]]*                     return IDENTIFIER;
">="										return GE_OP;
"<="										return LE_OP;
"=="										return EQ_OP;
"!="										return NE_OP;
"||"										return OR_OP;
"&&"										return AND_OP;
"++"										return INC_OP;
"+"                                         return '+';
"-"											return '-';
"*"											return '*';
"/"											return '/';
"="                                         return '=';
"<"											return '<';
">"											return '>';
"!"											return '!';
","                                         return ',';
"("                                         return '(';
")"                                         return ')';
";"                                         return ';';
"}"											return '}';
"{"											return '{';
"["											return '[';
"]"											return '[';
"\n"                                        return '\n';
.                                           return OTHERS;                                          

