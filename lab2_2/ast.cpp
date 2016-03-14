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

bool compatible(string a, string b){
    if(a == b) return true;
    if(a == "INT" && b == "FLOAT") return true;
    if(b == "INT" && a == "FLOAT") return true;
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