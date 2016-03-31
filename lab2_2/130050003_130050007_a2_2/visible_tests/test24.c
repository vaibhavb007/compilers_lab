struct s {
    int a;
};
struct t {
    int a;
    int b;
};

int g() {
    struct s a, *p;
    struct t * b, **q;
    void * v;
    p = &a; 
    q = &b; 
    v = f(*q, &(p->a)); 
    return (*(*q)).b; 
}
