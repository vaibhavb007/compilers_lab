global_entry :: global_entry(bool a, string b, string c, funTable*d){
	gl = a;
	symbol_name = b;
	ret_type = c;
	symtab = d;
	size = 0;
}

global_entry :: global_entry(bool a, string b, funTable*d){
	gl = a;
	symbol_name = b;
	ret_type = "";
	symtab = d;
}

void global_entry :: update_size(int a){
	size = a;
}

fun_entry :: fun_entry(string a, bool b, string c, int d, int e){
	symbol_name = a;
	isparam = b;
	type = c;
	size = d;
	offset = e;
}

void funTable :: addEntry(fun_entry f){
	local_table.push_back(f);
}

void fun_entry :: print(){
	cout<<"symbol_name : "<<symbol_name<<"; PARAM/LOCAL : ";
	if(isparam) cout<<"LOCAL";
	else cout<<"PARAM";
	cout<<"; type : "<<type<<"; size : "<<size<<"; offset : "<<offset<<endl;
}

void funTable :: print(){
	for(int i=0; i<local_table.size(); i++){
		local_table[i].print();
	}
}

void global_entry :: print(){
	cout<<"symbol_name : "<<symbol_name<<"; STRUCT/FUN : ";
	if(gl)	cout<<"FUN";
	else cout<<"STRUCT";
	cout<<"; ret_type : "<<ret_type<<endl;
}

Empty :: Empty(){
}

void Empty :: print(){
	cout<<"(Empty)";
}

Seq :: Seq(){
		stmtlist.resize(0);
	}

void Seq :: add_node(abstract_astnode* a){
	stmtlist.push_back(a);
}

void Seq :: print(){
	cout<<"(Block [";
	stmtlist[0]->print();
	cerr<<"printed\n";
	for(int i=1; i<stmtlist.size(); i++){
		cout<<endl;
		stmtlist[i]->print();
	}
	cout<<"])";
}

fncall :: fncall(abstract_astnode* idef){
	id = idef;
}

fncall :: fncall(abstract_astnode* idef, vector<abstract_astnode*> v){
	id = idef;
	exprList = v;
}

void fncall :: print(){
	cout<<"(fncall";
	// cout<<
	cout<<"(Block [";
	exprList[0]->print();
	for(int i=1; i<exprList.size(); i++){
		cout<<endl;
		exprList[i]->print();
	}
	cout<<"])";
	cout<<")";
}

Ass :: Ass(abstract_astnode* x, abstract_astnode* y){
	a = x;
	b = y;
}

void Ass :: print(){
	cout<<"(Ass";
	a->print();
	b->print();
	cout<<")";
}

Return :: Return(abstract_astnode* a){
	ret = a;
}

void Return :: print(){
	cout<<"(Return";
	ret->print();
	cout<<")";
}

If :: If(abstract_astnode* a, abstract_astnode* b, abstract_astnode* c){
	cond = a;
	compound = b;
	elsecompound = c;
}

void If :: print(){
	cout<<"(If";
	cond->print();
	cout<<endl;
	compound->print();
	cout<<endl;
	elsecompound->print();
	cout<<")";
}

While :: While(abstract_astnode* a, abstract_astnode* b){
	cond = a;
	compound = b;
}

void While :: print(){
	cout<<"(While";
	cond->print();
	cout<<endl;
	compound->print();
	cout<<")";
}

For :: For(abstract_astnode* a, abstract_astnode* b, abstract_astnode*c, abstract_astnode* d){
	iter1 = a;
	iter2 = b;
	iter3 = c;
	compound = d;
}

void For ::	print(){
	cout<<"(For";
	iter1->print();
	cout<<endl;
	iter2->print();
	cout<<endl;
	iter3->print();
	cout<<endl;
	compound->print();
	cout<<")";
}

opdual :: opdual(string optype, abstract_astnode* a, abstract_astnode* b){
	op1 = a;
	op2 = b;
	op = optype;
}
void opdual :: print(){
	cout<<"("<<op;
	op1->print();
	cout<<endl;
	op2->print();
	cout<<")";
}

opsingle :: opsingle(string type, abstract_astnode* a){
	op = a;
	optype = type;
}

void opsingle :: print(){
	cout<<"("<<optype;
	op->print();
	cout<<")";
}


FloatConst :: FloatConst(float a){
	cons = a;
}

void FloatConst :: print(){
	cout<<"(FloatConst "<<cons<<")";
}

IntConst ::	IntConst(int a){
	cons = a;
}

void IntConst :: print(){
	cout<<"(IntConst "<<cons<<")";
}


StringConst :: StringConst(string a){
	cons = a;
}

void StringConst :: print(){
	cout<<"(StringConst "<<cons<<")";
}

Identifier :: Identifier(string a){
	id = a;
}

void Identifier :: print(){
	cout<<"(Identifier "<<id<<")";
}

ArrayRef :: ArrayRef(abstract_astnode* a, abstract_astnode* b){
	id = a;
	arr = b;
}
void ArrayRef :: print(){
	cout<<"(ArrayRef";
	id->print();
	arr->print();
	cout<<")";
}

Pointer :: Pointer(abstract_astnode* a){
	pt = a;
}

void Pointer :: print(){
	cout<<"(Pointer";
	pt->print();
	cout<<")";
}

Deref :: Deref(abstract_astnode* a){
	deref = a;
}
void Deref :: print(){
	cout<<"(Deref";
	deref->print();
	cout<<")";
}

Member :: Member(abstract_astnode*a, abstract_astnode* b){
	lexpr = a;
	id = b;
}

void Member :: print(){
	cout<<"(Member";
	lexpr->print();
	id->print();
	cout<<")";
}

Arrow :: Arrow(abstract_astnode*a, abstract_astnode*b){
	lexpr = a;
	id = b;
}

void Arrow :: print(){
	cout<<"(Arrow";
	lexpr->print();
	id->print();
	cout<<")";
}

un_operator :: un_operator(string s){
	op_type = s;
}

void un_operator :: print(){

}

Args :: Args(abstract_astnode* a){
	args.push_back(a);
}

void Args :: print(){

}

void Args :: add_arg(abstract_astnode* a){
	args.push_back(a);
}

string compatible(string a, string b){
	string ret;
    if(a == b){
		ret = "00" + a;
		return ret;
	}
    if(a == "INT" && b == "FLOAT"){
		ret ="10FLOAT";
		// cout<<"here2"<<" "<<ret<<endl;
		return ret;
	}
    if(b == "INT" && a == "FLOAT"){
		ret = "20FLOAT";
		return ret;

	}
	string s1 = a.substr(0,5);
	string s2 = b.substr(0,5);
	if(s1 == "array" && s2=="array"){
		s1 = a.substr(0,a.length() - 1);
		std::size_t pos = s1.find(",");
		s1 = s1.substr(pos);
		s1 = s1.substr(1,s1.length() - 1);

		s2 = b.substr(0,b.length() - 1);
		pos = s2.find(",");
		s2 = s2.substr(pos);
		s2 = s2.substr(1,s2.length() - 1);
		if(s1 == s2){
			ret = "00" + a;
			return ret;
		}
		else{
			ret = "NOPE";
			return ret;
		}
	}

	s1 = a.substr(0,6);
	s2 = b.substr(0,6);
	if(s1 == "STRUCT" && s2 == "STRUCT"){
		string s1 = a.substr(7,a.length() - 7);
		for(int i=0; i<s1.length();i++){
			if(s1[i] == ' '){
				s1 = s1.substr(0,i);
				break;
			}
		}

		string s2 = b.substr(7,b.length() - 7);
		for(int i=0; i<s2.length();i++){
			if(s2[i] == ' '){
				s2 = s2.substr(0,i);
				break;
			}
		}

		if(s1 == s2){
			ret = "00"+a;
			return ret;
		}
		else{
			ret = "NOPE";
			return ret;
		}
	}

	s1 = a.substr(0,7);
	s2 = b.substr(0,7);

	if(s1 == "pointer" && s2 == "pointer"){
		s1 = a.substr(8,a.length() - 9);
		s2 = b.substr(8,b.length() - 9);

		if(s1=="VOID"){
			ret = '2' + a;
			return ret;
		}
		else if(s2 == "VOID"){
			ret = "10" + b;
			return ret;
		}

		if(compatible(s1,s2) != "NOPE"){
			string s3 = s1.substr(0,7);
			string s4 = s2.substr(0,7);
			if(s3 == "pointer" || s2 == "pointer"){
				return "NOPE";
			}
			s3 = compatible(s1,s2);
			if(s3[0] == '0'){
				return "00" + a;
			}
			else if(s3[0] == '1'){
				s3 = s3.substr(2,s3.length() - 2);
				ret = + "10pointer(" + s3 + ")";
				return ret;
			}
			else{
				s3 = s3.substr(2,s3.length() - 2);
				ret = + "20pointer(" + s3 + ")";
				return ret;
			}
		}
	}

	s1 = a.substr(0,5);
	s2 = b.substr(0,5);

	if(s1=="point" && s2=="array"){
		// cout<<"here\n";
		s1 = a.substr(8,a.length() - 9);

		s2 = b.substr(0,b.length() - 1);

		std::size_t pos = s2.find(",");
		s2 = s2.substr(pos);
		s2 = s2.substr(1,s2.length() - 1);
		// cout<<s1<<" "<<s2<<endl;
		if(s1 == s2){
			ret = "20" + a;
			return ret;
		}
	}
	// s2 = a.substr(0,5);
	// s1 = b.substr(0,5);
	// if(s1=="point" && s2=="array"){
	// 	s1 = a.substr(7,a.length() - 8);
	// 	s2 = b.substr(0,b.length() - 1);
	// 	std::size_t pos = s2.find(",");
	// 	s2 = s2.substr(pos);
	// 	s2 = s2.substr(1,s2.length() - 1);
	// 	return s1==s2;
	// }

	return "NOPE";

}

string compute_type(vector<string> a, string b){
	if(a.size() == 0) return b;
	for(int i=a.size()-1; i>=0; i--){
		b = a[i] + b + ')';
	}
	return b;
}

vector<global_entry> gst;
funTable* current;
string type, old_type, fun_type;
bool isstruct; //if we are in struct or in a function
bool islocal;	//inside a function, if we are in a arguments or not
int size, last_offset, type_size, curr_size;
//size->cumulative sum of variables used uptil now
//type_size-> size of int/float/..
//curr_size-> updated size of current variable
string name, fun_name;
bool prim_expr;
vector<string> type_store;
