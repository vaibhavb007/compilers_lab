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
    x = y; 
    x = z; 
}
