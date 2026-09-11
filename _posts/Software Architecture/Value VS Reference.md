### Call By Value
→ 원시 값이 복사되어 매개변수로 전달되는 방식. 매개변수의 값을 변경해도 원본은 영향이 없다. 원본은 보호하는 장점이 있지만, 복사본을 만들기 때문에, 구조체/클래스 크기가 크면 성능에 영향을 준다.
``` cpp
void AddOne(int _A){
	_A = _A + 1;
}

int main() {
	int TempA = 10;
	AddOne(TempA);
}
// TempA = 10
```

### Call By Reference
→ 값이 저장된 메모리 주소를 그대로 넘기는 방식. 매개변수의 값을 변경하면 원본도 같이 변하게된다. 메모리 주소만 넘기기에, 전달에는 효율적이지만, 원본을 변경하는 점에서 주의가 필요하다.
``` cpp
void AddOne(int& _A){
	_A = _A + 1;
}

int main() {
	int TempA = 10;
	AddOne(TempA);
}
// TempA = 11
```