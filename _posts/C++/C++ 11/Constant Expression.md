`const` 키워드는 값 수정을 제한하고, 읽기용으로 사용하겠다는 의도를 가지고 있다고 했다. 동작 방식은 '런타임'/'컴파일 타임' 둘 다 가능한데, 초기화되는 값이 컴파일 타임에도 명확할 경우, '**컴파일 타임**'에 초기값이 결정된다. 하지만 그렇지 않는 경우, 프로그램이 실행되는 중간에 초기값이 결정된다. 이처럼 `const`는 값 수정을 제한 시켜주는 기능이 있지만, 초기화 시점을 보장하진 않는다. C++11에서 컴파일 타임에 평가 가능한 값인 것을 명시하고, 이를 보장하기 위한 `constexpr` 키워드가 추가되었다.
``` cpp
const size_t ArraySize = 10; // 컴파일 타임
const uint32_t MaxCount = 5; // 컴파일 타임

int main() {
	int a = 0;
	const int32_t MinCount = a; // a가 변수이므로 런타임
	
	return 0;
}
```

`constexpr` 키워드는 C++(11)에서 '**컴파일 타임 상수**' 라 불리고, 컴파일 타임에 상수 값이 결정되는 것을 일부 보장한다. 그렇기에, 초기화 시점에 변수 초기화나, 변수, 객체, 메서드 앞에 놓을 수 있고, 클래스 생성자에도 넣을 수 있다.

런타임에 초기값이 결정되는 방식에 비해 **컴파일 타임**에 값이 계산되도록 하여 성능과 자원 관리에서 이득을 볼 수 있다. 그렇기에, 가급적으로 `constexpr`를 쓰고, 런타임이 불가피하다면 `const`를 넣는게 좋다고 생각한다. 

``` cpp
int main() {
	int a = 20;
	
	const size_t ArraySize = 10;      // 컴파일 타임
	constexpr uint32_t MaxCount = 5;  // 컴파일 타임
	
	const int32_t MinCount = a;       // 런타임
	//constexpr int32_t AvgCount = a; // X ~ 변수 초기화 불가로 const로 변경해야 함
	
	return 0;
}
```

`constexpr` 는 C++ 11에서 도입이 되고 C++14에서 개선이 되었는데, 각 차이를 알아보자
### C++ 11 : 도입
C++11 도입 때에는 기능으로만 봤을 때, 좋은 기능이지만, 제약 조건이 많이 걸려있었다. 특히 `constexpr` 이 걸린 함수가 문제가 많았는데,

- **지역변수 선언 불가 :** 매개변수를 바로 연산하여 return하는 것은 가능하되, 중간에 지역변수를 거치거나, 연산하는 과정이 있다면 컴파일 에러를 일으킨다.
``` cpp
constexpr int SquareAndAdd(int a, int b) {
	int A = a * a; // 에러: 지역 변수 선언 불가 
	int B = b * b; // 에러: 지역 변수 선언 불가 
	return A + B;
} 
constexpr int SquareAndAdd11(int a, int b) {
	return (a * a) + (b * b); // 가능. 매개변수로 자체적으로 연산한 뒤 return
}
```
- `if / switch / for / while` **전부 사용 불가 :** 키워드를 적는 것조차 오류를 뱉는다. 그나마 if문은 삼항 연산자로 계산해서 바로 return 시키면 됐다.
- `return` 문 1개 제한 : `constexpr` 함수 안에서 return문을 한 번만 쓸 수 있다. 아마 컴파일 타임에 값을 확정 지으려고 막은 것 같다.

### C++14 : 개선
C++14로 넘어가면서 위에서 소개했던 제약들이 거의 완화 되었다. `return` 문을 여러 번 사용 가능하고, `if / switch / for / while` 전부 사용이 가능해졌다. 하지만 아직 제약이 몇 개 남아있었다.

- **지역변수 조건부 사용 가능 :** 지역변수 선언이 가능해졌다. 그리고 값 변경도 가능해졌다. 하지만, 선언과 동시에 초기화를 해줘야 사용이 가능하다는 조건이 생겼다.
- **동적 할당 불가 :** 컴파일 타임에는 동적 할당 관련된 연산이 불가하기에, STL 컨테이너같이 동적 할당 기반의 객체는 사용이 불가능했다.
- **가상 함수 불가 :** 가상 함수는 `constexpr`사용이 불가했다. 또한 내부에서 가상 함수 호출도 불가했다.
- **static 지역 변수는 불가 :** 함수 내부에서 정적 변수 선언은 불가했다.

또 이후에 C++17, C++20을 거치면서 개선이 되었고, C++20 버전 이상 에서 몇 개의 작은 제약을 제외하면, 자유롭게 쓸 수 있게 되었다. 그렇기에 `constexpr`를 쓰려면 최소 C++14를 쓰는게 정신건강에 좋다고 생각한다.

### 사용
`constexpr` **변수 사용** : 주로 [ #define ] 에서 불변하는 수를 쓰는 것처럼, 사용한다. 오히려 #define 보다 `constexpr` 변수가 더 추천되는데, 성능 차이는 없지만, #define은 텍스트 치환이라서 예상치 못한 형변환 연산이 추가되거나 오류가 발생할 수 있는데, `constexpr` 변수는 컴파일 타임에서 평가되므로, 사전에 오류나 오버헤드를 확인할 수 있다. 또한 디버깅에서도 차이가 있고, 이외 작은 이점들이 더 있기에 #define 대신에 사용할 가치가 있다.
``` cpp
constexpr int MaxCount = 99;
```

`constexpr` **함수 사용** : `constexpr` 가 함수에 붙으면 의미가 약간 달라진다. `constexpr`변수는 컴파일 타임이 강제되지만, 함수에서는, 컴파일 타임과 런타임 모두에서 실행할 수 있는데, 코드 문맥에 따라, 컴파일 타임에 평가가 보장되기도 한다. `constexpr` 함수로 좋은 기능들을 만들 수 있는데,
	- `constexpr` **생성자 :** 멤버들이 전부 '컴파일 타임 상수'로 초기화가 가능하다면, 컴파일 타임에 객체를 생성하고 초기화를 해줄 수 있게 한다. 그렇기에 내용이 단순한 객체들은 `constexpr` 생성자로 만들어 이득을 볼 수 있다.
	- **연산자 오버로딩 :** 연산자 오버로딩 함수를 `constexpr`로 선언하면, 컴파일 타임에 연산을 할 수 있는 기회을 만들 수 있기에 이득을 볼 수 있다. 그렇기에, 자주 쓰이는 간단한 함수를 오버로딩 시키면, 효율이 극대화 된다.
	- **문자열 해시 :** Tag같은 문자열ID를 컴파일 타임에 '정수 해시값'으로 변환시켜, 문자열 비교대신 정수 비교를 시킬 수 있게 하여, 성능을 향상 시킬 수 있다. **(FNV-1a 해시 알고리즘)**

``` cpp
constexpr int MaxCount = 99;

struct Vector2D { 
	float x, y; 
	
	constexpr Vector2D(float x, float y) : x(x), y(y) {} 
	// constexpr 생성자 
	
	constexpr Vector2D operator+(const Vector2D& rhs) const { 
		return { x + rhs.x, y + rhs.y }; 
	} 
	constexpr bool operator==(const Vector2D& rhs) const { 
		return x == rhs.x && y == rhs.y;
	} // 연산자 오버로딩
};

int main() {
	constexpr Vector2D v1{ 1.f, 2.f };
	constexpr Vector2D v2{ 3.f, 4.f };
	constexpr Vector2D v3 = v1 + v2;
	
	return 0;
}
```

```cpp
// FNV-1a 64비트 구현
constexpr uint64_t fnv1a_64(std::string_view data) {
    constexpr uint64_t FNV_OFFSET = 14695981039346656037ULL;
    constexpr uint64_t FNV_PRIME  = 1099511628211ULL;

    uint64_t hash = FNV_OFFSET;
    for (unsigned char c : data) {
        hash ^= static_cast<uint64_t>(c);
        hash *= FNV_PRIME;
    }
    return hash;
}

int main() {
	constexpr uint64_t PlayerTag = fnv1a_64("Player");
	...
	if (PlayerTag == fnv1a_64("Player")){
	...
	}
	return 0;
}
```
※ [FNV-1a 알고리즘 출처](https://text.ibetter.kr/cpp-ds-deep/part-08-%ED%95%B4%EC%8B%9C-%ED%85%8C%EC%9D%B4%EB%B8%94-%E2%80%94-std::unordered_map-%EB%82%B4%EB%B6%80/ch-01-%ED%95%B4%EC%8B%9C-%ED%95%A8%EC%88%98%EC%9D%98-%EC%9B%90%EB%A6%AC-%E2%80%94-std::hash,-fnv,-murmurhash,-xxhash)

위에서 `constexpr` 함수는 런타임에서도 실행이 가능하다고 했었는데, 이를 컴파일 타임에만 실행되도록 강제시킬 수도 있다. C++20 에서는 `consteval` 키워드로 가능한데, 이 문법은 C++20에서 다루겠다. `constexpr` 변수는 '컴파일 타임에서만 평가' 가능하다고 했다. 그렇기에 `constexpr` 함수에 return 값이 존재한다면, 해당 값을 `constexpr` 변수가 받을 때, 컴파일 타임을 보장 받을 수 있다.
``` cpp
constexpr int Multiply(int X, int Y) {
	return X * Y;
}

int main() {
	constexpr int ResultA = Multiply(20, 10);  // 컴파일 타임 평가 보장
	
	int Factor = 25;
	constexpr int ResultB = Multiply(Factor, 5); // 런타임 변수로 인해 오류 발생
	
	return 0;
}
```

### 정리 
이렇게 `constexpr` 키워드를 통해 '**컴파일 타임 중심 프로그래밍**'을 하여 성능에 이득을 볼 수 있다는 것을 알아보았다. 연장선으로 C++20에선 `consteval, constinit` 라는 키워드가 있는데, 카테고리부터가 C++11이니까 C++20에서 다시 다루겠다. `constexpr` 키워드로 최적화를 할 알고리즘이나 테크닉을 깊이 있게 찾아본 적이 없었는데, 이 기회에 문자열 해시 알고리즘을 알게 되니까 욕심이 생겨서 한 3-4시간 찾아봤던거 같다.