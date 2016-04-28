ofstream code ("gen.s", ofstream::out);
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

void Empty :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

}

Seq :: Seq(){
	stmtlist.resize(0);
}

void Seq :: add_node(abstract_astnode* a){
	stmtlist.push_back(a);
}

void Seq :: print(){
	cout<<"(Block [";
	cerr<<"printed\n";
	for(int i=0; i<stmtlist.size(); i++){
		cout<<endl;
		stmtlist[i]->print();
	}
	cout<<"])";
}

void Seq :: gencode(vector<global_entry> gst, funTable* current, bool islhs){
	code<<gst[gst.size()-1].symbol_name<<":\n";
	for(int i = 0; i<this->stmtlist.size(); i++){
		stmtlist[i]->gencode(gst, current, islhs);
	}
	code<<"jr $ra\n";
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
	for(int i=0; i<exprList.size(); i++){
		cout<<endl;
		exprList[i]->print();
	}
	cout<<"])";
	cout<<")";
}

void fncall :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

}

Ass :: Ass(abstract_astnode* x, abstract_astnode* y){
	a = x;
	b = y;
}

void Ass :: print(){
	cout<<s;
	a->print();
	b->print();
	cout<<")";
}

void Ass :: gencode(vector<global_entry> gst, funTable* current, bool islhs){
	a->gencode(gst, current, true);
	b->gencode(gst, current, false);
	code<<"addi $sp, $sp, 8\n";
	code<<"lw $s0, -4($sp)\n";
	code<<"lw $s1, -8($sp)\n";
	code<<"sw $s1, 0($s0)\n";
}

Return :: Return(abstract_astnode* a){
	ret = a;
}

void Return :: print(){
	cout<<"(Return";
	ret->print();
	cout<<")";
}

void Return :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

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

void If :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

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

void While :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

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

void For :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

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

void opdual :: gencode(vector<global_entry> gst, funTable* current, bool islhs){
	op1->gencode(gst, current, false);
	op2->gencode(gst, current, false);
	//Not finalised code yet. Nothing assumed to be correct.
	if(type == "PLUS-INT"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"add $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "PLUS-FLOAT"){

	}
	else if(type == "MINUS-INT"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"sub $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "MINUS-FLOAT"){

	}
	else if(type == "MULT-INT"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"mul $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "MULT-FLOAT"){

	}
	else if(type == "DIV-INT"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"div $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "DIV-FLOAT"){

	}
	else if(type == "LT-INT"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"slt $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "LT-FLOAT"){

	}
	else if(type == "GT-INT"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"slt $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "GT-FLOAT"){

	}
	else if(type == "LE_OP-INT"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"and $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "LE_OP-FLOAT"){

	}
	else if(type == "GE_OP-INT"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"slt $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "GE_OP-FLOAT"){

	}
	else if(type == "OR_OP"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"or $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "AND_OP"){
		code<<"addi $sp, $sp, 8\n";
		code<<"lw $s0, 8($sp)\n";
		code<<"lw $s1, 4($sp)\n";
		code<<"and $s0, $s0, $s1\n";
		code<<"addi $sp, $sp, -4\n";
		code<<"sw $s0, 0($sp)\n";
	}
	else if(type == "EQ_OP"){

	}
	else if(type == "NE_OP"){

	}

}

opsingle :: opsingle(string type, abstract_astnode* a){
	op = a;
	optype = type;
}

void opsingle :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

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

void FloatConst :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

}

IntConst ::	IntConst(int a){
	cons = a;
}

void IntConst :: print(){
	cout<<"(IntConst "<<cons<<")";
}

void IntConst :: gencode(vector<global_entry> gst, funTable* current, bool islhs){
	code<<"#pushing "<<this->cons<<" on stack\n";
	code<<"li $s0, "<<this->cons<<endl;
	code<<"addi $sp, $sp, -4\n";
	code<<"sw $s0, 0($sp)\n";
}

StringConst :: StringConst(string a){
	cons = a;
}

void StringConst :: print(){
	cout<<"(StringConst "<<cons<<")";
}

void StringConst :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

}

Identifier :: Identifier(string a){
	id = a;
}

void Identifier :: print(){
	cout<<"(Identifier "<<id<<")";
}

void Identifier :: gencode(vector<global_entry> gst, funTable* current, bool islhs){
	int i;
	bool inlst = false;
	std::cerr<<"gencode for Identifier "<<this->id<<" called"<<endl;
	for(i = 0; i<current->local_table.size(); i++){
		if(current->local_table[i].symbol_name == this->id){
			inlst = true;
			break;
		}
	}
	if(inlst){
		if(islhs){
			code<<"addi $s1, $fp, "<<current->local_table[i].offset<<endl;
			code<<"addi $sp, $sp, -4\n";
			code<<"sw $s1, 0($sp)\n";
		}
		else{
			if(this->type == "INT"){
				code<<"lw $s1,"<<current->local_table[i].offset<<"($fp)"<<endl;
				code<<"addi $sp, $sp, -4\n";
				code<<"sw $s1, 0($sp)\n";
			}
			else{

			}
		}
	}
	else{
		bool ingst = false;
		for(i == 0; i<gst.size(); i++){
			if(gst[i].gl && gst[i].symbol_name == this->id){
				ingst = true;
				break;
			}
		}
		if(ingst){

		}
	}
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

void ArrayRef :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

}

Pointer :: Pointer(abstract_astnode* a){
	pt = a;
}

void Pointer :: print(){
	cout<<"(Pointer";
	pt->print();
	cout<<")";
}

void Pointer :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

}

Deref :: Deref(abstract_astnode* a){
	deref = a;
}

void Deref :: print(){
	cout<<"(Deref";
	deref->print();
	cout<<")";
}

void Deref :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

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

void Member :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

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

void Arrow :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

}

un_operator :: un_operator(string s){
	op_type = s;
}

void un_operator :: print(){

}

void un_operator :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

}

Args :: Args(abstract_astnode* a){
	args.push_back(a);
}

void Args :: print(){

}

void Args :: add_arg(abstract_astnode* a){
	args.push_back(a);
}

void Args :: gencode(vector<global_entry> gst, funTable* current, bool islhs){

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
			ret = "20" + a;
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
		if(compatible(s1,s2) != "NOPE"){
			string s3 = compatible(s1,s2);
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

	// s1 = a.substr(0,5);
	// s2 = b.substr(0,5);
	//
	// if(s1=="array" && s2=="pointer"){
	// 	// cout<<"here\n";
	// 	s2 = b.substr(8,b.length() - 9);
	//
	// 	s1 = a.substr(0,a.length() - 1);
	//
	// 	std::size_t pos = s1.find(",");
	// 	s1 = s1.substr(pos);
	// 	s1 = s1.substr(1,s1.length() - 1);
	// 	// cout<<s1<<" "<<s2<<endl;
	// 	string s3 = compatible(s1,s2);
	// 	if(s3.substr(0,2) == ){
	// 		ret = "00" + a;
	// 		return ret;
	// 	}
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
int size, last_offset, type_size, curr_size, fun_local=0;
//size->cumulative sum of variables used uptil now
//type_size-> size of int/float/..
//curr_size-> updated size of current variable
string name, fun_name;
bool prim_expr;
vector<string> type_store;
