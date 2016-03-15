struct s {
    int a;
    float b;
};
struct t {
    int a;
    float b;
};
void f(int m, float n) {
    struct s x;
    struct s y;
    struct t z;
    int p;
    float q;
    void v; // Error. Cannot declare variable of type void
    struct u r; // Error. struct u undeclared
    x = y; // Allowed
    x = z; // Error. struct s and struct t are different types
    x.b = p; // Requires casting p to float
    a = b; // Error. Undeclared variables a and b
    q = 1.0 + z.a; // Requires casting z.a to float
    f(z.b, z.a); // Allowed as f has been declared. Cast z.b to int and z.a to float.
    g(1); // Error. Function g not declared
    return 0; // Error. Returning int in void function
}
struct u {
    struct s * a;
    struct t * b;
    struct u * c; // Allowed. Only the pointer to struct u is being used.
};
struct v {
    struct v a; // Error. struct v not completely declared.
};
int g(int a) {
    struct u x;
    float a; // Error. Redeclaration of variable a.
    a = f(1, 0.1); // Error. f returns void but it’s being assigned.
    return x; // Error. Return type is int but returning struct u.
}