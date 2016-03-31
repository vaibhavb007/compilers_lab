struct s {
    int a;
    float b[5][5];
};

struct t{
    struct s x[10];
};

int main() {
    int b[10][10];
    struct s x;
    struct t y;
    int i;
    y.x[i].b[2] = x.b[1];
}
