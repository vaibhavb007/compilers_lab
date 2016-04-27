#include <iostream>
#include <string>
#include <vector>
#include <fstream>

using namespace std;

class abstract_astnode
{
public:
    virtual void print () = 0;
    virtual void gencode(vector<global_entry> gst, funTable* current, bool islhs) = 0;
    location = 0;
    string type = "null";
    bool lvalue;
// virtual std::string generate_code(const symbolTable&) = 0;
// virtual basic_types getType() = 0;
// virtual bool checkTypeofAST() = 0;
// protected:
// virtual void setType(basic_types) = 0;
// private:
// typeExp astnode_type;
};

// enum structorfun{STRUC, FUN};
// enum paramorlocal{PARAM, LOCAL};

class fun_entry{
public:
    string symbol_name;
    bool isparam; //1 is it is local variable, 0 if it is a parameter
    string type;
    int size;
    int offset;
    fun_entry(string a, bool b, string c, int d, int e);
    void print();
};

class funTable{
public:
    vector<fun_entry> local_table;
    void addEntry(fun_entry f);
    void print();
};

class global_entry{
public:
    bool gl;    //1 if it is function otherwise 0
    string symbol_name;
    string ret_type;
    funTable* symtab;
    int size;
    global_entry(bool a, string b, string c, funTable* d);
    global_entry(bool a, string b, funTable*d);
    void update_size(int a);
    void print();
};

class Empty : public abstract_astnode
{
public:
    Empty();
    void print();
};

class Seq : public abstract_astnode
{
public:
    Seq();
    void add_node(abstract_astnode * a);
    vector<abstract_astnode*> stmtlist;
    void print();
};


class Ass : public abstract_astnode
{
public:
    Ass(abstract_astnode* x, abstract_astnode* y);
    void print();
    string s = "(Ass";
    abstract_astnode* a;
    abstract_astnode* b;
};

class Return : public abstract_astnode
{
public:
    Return(abstract_astnode* a);
    void print();
    abstract_astnode* ret;
};

class If : public abstract_astnode
{
public:
    If(abstract_astnode* a, abstract_astnode* b, abstract_astnode* c);
    abstract_astnode* cond;
    abstract_astnode* compound;
    void print();
    abstract_astnode* elsecompound;
};

class While : public abstract_astnode
{
public:
    While(abstract_astnode* a, abstract_astnode* b);
    void print();
    abstract_astnode* cond;
    abstract_astnode* compound;
};

class For : public abstract_astnode
{
public:
    For(abstract_astnode* a, abstract_astnode* b, abstract_astnode*c, abstract_astnode* d);
    void print();
    abstract_astnode* iter1;
    abstract_astnode* iter2;
    abstract_astnode* iter3;
    abstract_astnode* compound;
};

class opdual : public abstract_astnode
{
public:
    opdual(string optype, abstract_astnode* a, abstract_astnode* b);
    void print();
    abstract_astnode* op1;
    abstract_astnode* op2;
    string op;
};

class opsingle : public abstract_astnode
{
public:
    void print();
    opsingle(string type, abstract_astnode* a);
    string optype;
    abstract_astnode* op;
};

class FloatConst : public abstract_astnode
{
public:
    FloatConst(float a);
    void print();
    float cons;
};

class IntConst : public abstract_astnode
{
public:
    IntConst(int a);
    void print();
    int cons;
};

class StringConst : public abstract_astnode
{
public:
    StringConst(string a);
    void print();
    string cons;
};

class Identifier : public abstract_astnode
{
public:
    Identifier(string a);
    void print();
    string id;
};

class ArrayRef : public abstract_astnode
{
public:
    ArrayRef(abstract_astnode* a, abstract_astnode* b);
    void print();
    abstract_astnode* id;
    abstract_astnode* arr;
};

class Pointer : public abstract_astnode
{
public:
    Pointer(abstract_astnode* a);
    void print();
    abstract_astnode* pt;
};

class Deref : public abstract_astnode
{
public:
    Deref(abstract_astnode* a);
    void print();
    abstract_astnode* deref;
};

class Arrow : public abstract_astnode
{
public:
    Arrow(abstract_astnode* a, abstract_astnode* b);
    void print();
    abstract_astnode* lexpr;
    abstract_astnode*id;
};

class Member : public abstract_astnode
{
public:
    Member(abstract_astnode* a, abstract_astnode* id);
    void print();
    abstract_astnode* lexpr;
    abstract_astnode* id;
};

class un_operator:public abstract_astnode{
public:
    un_operator(string s);
    string op_type;
    void print();
};

class fncall: public abstract_astnode
{
public:
    fncall(abstract_astnode* idef);
    fncall(abstract_astnode* idef, vector<abstract_astnode*> v);
    abstract_astnode* id;
    void print();
    vector<abstract_astnode*> exprList;
};

class Args : public abstract_astnode
{
public:
    Args(abstract_astnode* a);
    void add_arg(abstract_astnode* a);
    vector<abstract_astnode*> args;
    void print();
};

string compatible(string a, string b);

string compute_type(vector<string> a, string b);

extern vector<global_entry> gst;
extern funTable* current;
extern string type, old_type, fun_type;
extern bool isstruct;
extern bool islocal;
extern int size, last_offset, type_size, curr_size;
extern string name, fun_name;
extern bool prim_expr;
extern vector<string> type_store;
