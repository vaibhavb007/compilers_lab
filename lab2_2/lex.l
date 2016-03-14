

// There may be some flexer directives here

%%
[ \t]                                    //skip
[ \b]									 //skip
[ \n]                                       {ParserBase::lineNr++;}
INT|int										return Parser::INT;
STRUCT|struct                               return Parser::STRUCT;
FLOAT|float									return Parser::FLOAT;
VOID|void									return Parser::VOID;
\"([^\\"]*([\\][\\|"|t|n])*)*\"				 {Parser::d_val__ = std::string (matched());   return ParserBase::STRING_LITERAL;}
([1-9][0-9]*|0)|(0[bB][01]*)|(0[0-7]*)|(0[xX][0-9a-fA-F]*)	 {Parser::d_val__ = std::stoi(std::string(matched()));   return ParserBase::INT_CONSTANT;}
([0-9]+|0)"."([0-9]*)(([eE]([-+]?)[1-9][0-9]*)?)		 {Parser::d_val__ = std::stof(std::string(matched()));   return ParserBase::FLOAT_CONSTANT;}
RETURN|return								{Parser::d_val__ = std::string (matched());   return ParserBase::RETURN;}
IF|if 										{Parser::d_val__ = std::string (matched());   return ParserBase::IF;}
ELSE|else 									{Parser::d_val__ = std::string (matched());   return ParserBase::ELSE;}
WHILE|while									{Parser::d_val__ = std::string (matched());   return ParserBase::WHILE;}
FOR|for										{Parser::d_val__ = std::string (matched());   return ParserBase::FOR;}
[[:alpha:]][[:alnum:]]*    {Parser::d_val__ = std::string (matched());   return ParserBase::IDENTIFIER;}
">="										{Parser::d_val__ = std::string (matched());   return ParserBase::GE_OP;}
"<="										{Parser::d_val__ = std::string (matched());   return ParserBase::LE_OP;}
"=="										{Parser::d_val__ = std::string (matched());   return ParserBase::EQ_OP;}
"!="										{Parser::d_val__ = std::string (matched());   return ParserBase::NE_OP;}
"||"										{Parser::d_val__ = std::string (matched());   return ParserBase::OR_OP;}
"&&"										{Parser::d_val__ = std::string (matched());   return ParserBase::AND_OP;}
"++"										{Parser::d_val__ = std::string (matched());   return ParserBase::INC_OP;}
"->"                                        {Parser::d_val__ = std::string (matched());   return ParserBase::PTR_OP;}
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
"]"											return ']';
"."											return '.';
.
