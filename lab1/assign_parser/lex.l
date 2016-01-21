

// There may be some flexer directives here

%%
[ \t\n]                                    //skip
[ \b]									 //skip
INT|int										return Parser::INT;
FLOAT|float									return Parser::FLOAT;
VOID|void									return Parser::VOID;
([1-9][0-9]*)|(0[bB][01]*)|(0[0-7]*)|(0[xX][0-9a-fA-F]*)	return Parser::INT_CONSTANT;
([1-9][0-9]*|0)"."([0-9]+)(([eE]([-+]?)[1-9][0-9]*)?)		return Parser::FLOAT_CONSTANT;
RETURN|return								return Parser::RETURN;
IF|if 										return Parser::IF;
ELSE|else 									return Parser::ELSE;
WHILE|while									return Parser::WHILE;
FOR|for										return Parser::FOR;
[[:alpha:]][[:alnum:]]*                     return Parser::IDENTIFIER;
"\""([^"\\""\""]*["\\"|"\""|"\\t"|"\\n"]*)*"\""				return Parser::STRING_LITERAL;
">="										return Parser::GE_OP;
"<="										return Parser::LE_OP;
"=="										return Parser::EQ_OP;
"!="										return Parser::NE_OP;
"||"										return Parser::OR_OP;
"&&"										return Parser::AND_OP;
"++"										return Parser::INC_OP;
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
.                                           return Parser::OTHERS;                                          

