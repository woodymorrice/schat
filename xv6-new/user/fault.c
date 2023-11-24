int main() {
  char* p;

  p = (char*)0xdeadbeef;

  *p = 0xff;

  exit(0);
}
