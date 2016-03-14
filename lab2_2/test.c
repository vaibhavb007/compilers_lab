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
		int a[10];
		k.asd.a = 0;
		a[5] = 6;
}
