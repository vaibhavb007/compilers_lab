struct hello {
	int a;
	float b[10][20];
};

struct cool{
	struct hello asd;
};

int main() {
		struct cool k;
		struct hello poi;
		k.asd.a = 0;
}