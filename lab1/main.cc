#include <iostream>
#include "Scanner.h"
using namespace std;
int main() {
	Scanner scanner;   // define a Scanner object
	while (int token = scanner.lex()) // get all tokens
	{
		string const &text = scanner.matched();
		switch (token) {
		case Scanner::SYMBOL:
			cout << "SYMBOL: " << text << '\n';
			break;
		case Scanner::NUMBER:
			cout << "NUMBER: " << text << '\n';
			break;
		case Scanner::IMMNUMBER:
			cout << "IMMNUMBER: " << text << '\n';
			break;
		case Scanner::MNEMONIC:
			cout << "MNEMONIC: " << text << '\n';
			break;
		case Scanner::REGISTER:
			cout << "REGISTER: " << text << '\n';
			break;
		case Scanner::IMMSYMBOL:
            cout << "IMMSYMBOL: " << text << '\n';
			break;
		case '+':
			cout << "plus: " << text << '\n';
			break;
		case ',':
			cout << "comma: " << text << '\n';
			break;
		case '(':
			cout << "lparen: " << text << '\n';
			break;
		case ')':
			cout << "rparen: " << text << '\n';
			break;
		case ':':
			cout << "colon: " << text << '\n';
			break;
		case Scanner::OTHERS:
			cout << "OTHERS: `" << text << "'\n";
		}
	}
}







/*#include <iostream>
#include "Scanner.h"
#include "Parser.h"
using namespace std;
int main(int argc, char** arg) {
	Parser parser;
	parser.parse();
}*/

