

// There may be some flexer directives here

%%
[ \t]                                    //skip
[ \b]									 //skip
INT|int										return INT;
FLOAT|float									return FLOAT;
VOID|void									return VOID;
([1-9][0-9]*)|(0[bB][01]*)|(0[0-7]*)|(0[xX][0-9a-fA-F]*)	return INT_CONSTANT;
([1-9][0-9]*|0)"."([0-9]+)(([eE]([-+]?)[1-9][0-9]*)?)		return FLOAT_CONSTANT;
RETURN|return								return RETURN;
IF|if 										return IF;
ELSE|else 									return ELSE;
WHILE|while									return WHILE;
FOR|for										return FOR;
[[:alpha:]][[:alnum:]]*                     return IDENTIFIER;
"\""([^"\\""\""]*["\\"|"\""|"\\t"|"\\n"]*)*"\""				return STRING_LITERAL;
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

