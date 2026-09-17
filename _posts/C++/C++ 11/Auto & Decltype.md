`auto`키워드는 컴파일러가 자동으로 변수의 타입을 추론하고 확정 시킨다. 이를 통해 개발자가 타입 변경으로 인한 연쇄적인 수정이나 반복 작업을 막아주고, 코드 생성에 효율성과 생산성을 향상 시키는 키워드이다. 단, `auto`변수는 컴파일 타임에 타입 추론이 되어야 하기 때문에, 선언과 동시에 초기화를 해야 컴파일러가 오류를 만들지 않는다. 

``` cpp
int Add(int A, int B) { return A+B; }

auto Result = Add(1, 4);  // 만약 Add 함수가 float 반환으로 바뀌어도 수정할 필요가 없다.

vector<vector<vector<vector<uint32_t>>>> Trash;
auto Bin = Trash; // 코드도 줄일 수 있고, 자료형을 굳이 알 필요도 없다.
// VS에서는 auto에 마우스만 가져다 놓아도 추론된 자료형을 알 수 있게 해준다.
```

다만, `auto`도 추론하는 규칙이 있다. 예를 들면 초기화된 값이 "3.14f"라면 `float`, "3.14"라면 `double` 등등 가끔 예상치 못하는 오류를 만들 가능성을 염두 해야 한다.
``` cpp
int main() {
	

}
```
규칙을 완전히 외울 필요는 없지만, 추론 된 자료형을 확인하고, 사용해야 안전하게 사용이 가능하다. 다행히 대중화된 컴파일러는 변수에 마우스만 가져다 놓아도 추론 된 자료형을 확인할 수 있게 해준다.
( ← JetBrain Rider / → Visual Studio )
![[Pasted image 20260916181719.png|325]]![[Pasted image 20260916181820.png|359]]

`auto`키워드도 `const, Reference(&), Pointer(*)`가 붙을 수 있는데, 이를 적절하게 사용해야 성능 이득을 볼 수 있고, 오류를 피할 수 있다.

### Reference
`auto`는 **'값 타입 방식**으로 추론하기 때문에, `Reference(&) (+ 최상위 const)`가 유지되지 않는다. lvalue 초기화는 객체를 생성하고, 값을 복사하기 때문에, 비용이 발생하게 된다. 
``` cpp
int main() {
	std::vector<std::vector<double>> DoubleMatrix;
	....
	auto DMat = DoubleMatrix;  // 대량의 Matrix가 DMat으로 복사.
}
```
`auto&`로 만들어 참조를 하게 되면, 복사가 발생하지 않아, 성능의 이득을 볼 수 있다. 그러나 참조를 하게 되면 수정에 위험이 있으니 앞에 `const auto&`로, 복사도 방지하면서, 원본의 수정을 제한 시킬 수 있다.
또한 Reference는 `auto&&`일 때, 초기화가 특수하게 동작한다. 
``` cpp
int A = 10;

auto   B = A; // auto = int   → B: int
auto&  C = A; // auto = int   → C: int&
auto&& D = A; // auto = int&  → int& && → D: int& // lvalue
auto&& E = 10;// auto = int   → E: int&& // rvalue
```
B와 C는 위에서 다뤘던 내용이다. 하지만, D, E는 rvalue/lvalue에 따라 다르게 동작한다. lvalue의 경우에는 `auto&&`일 때, `auto = int&`로 추론 되고, rvalue는 `auto = int`로 추론 된다. `auto&&`는 특별히 템플릿의 `T&&`처럼 추론되기 때문에, 이렇게 된다고 볼 수 있고, forwarding reference, Reference Collapsing의 이유가 있지만, 이건 나중에 알아보도록 하자.
### Pointer
`auto`는 포인터까지 추론할 수 있다. 포인터 변수로 초기화 시에는 `auto = int*`로 처리가 되는데, 내가 내 코드를 보면서 헷갈리지 않으려면, `auto*`로 만들어 포인터임을 명시해주는 것이 좋다. 포인터 명시는 특히 강조가 되는 것이, 다음 코드의 문제점이 발생할 수 있기 때문이다.

``` cpp
int    Alpha = 10;
int*   AlphaPTR = &Alpha;

auto   AutoAlphaA = Alpha;     // AutoAlphaA : int
auto   AutoAlphaB = AlphaPTR   // AutoAlphaB : int*
auto   AutoAlphaC = &AlphaPTR  // AutoAlphaC : int**

auto   AutoAlphaD = Alpha;     // AutoAlphaD : int
auto*  AutoAlphaE = AlphaPTR   // AutoAlphaE : int*
auto** AutoAlphaF = &AlphaPTR  // AutoAlphaF : int**
```
AutoAlphaA, B, C까지 보면 `auto`로 `int, int*, int**` 까지 타입 추론이 가능하다. 다만 모든 자료형이 `auto`로 통일되기 때문에, 구분이 힘들다는 것이 단점이다. 그렇기에 AutoAlphaD, E, F 를 보면 포인터 기호를 붙여서 Value인지, Pointer인지 TwoPointer인지 알 수 있게 해준다. (auto에 포인터 기호를 붙이면 컴파일러가 포인터 기호까지 고려하여 `auto`를 추론하기 때문에, AutoAlphaF 경우에 `int****` 가 되지 않고, `int**`가 될 수 있는 것이다.) 이렇게 명시 해주면 초기화를 잘 못 했을 때, 컴파일러가 오류를 출력하기에, 디버깅에도 효율적이다. 그렇기에 남이 볼 때나 내가 봤을 때, 헷갈리게 만들지 않게 하려면, `auto*`의 `*` 명시는 추천이 아닌, 필수라고 생각한다.

### 사용
auto는 함수에서 반환형으로 사용된다. 사용하는 방법이 C++11이랑 C++14에서 각각 다른데,
C++11에서는 "후행 반환 형식"과 같이 사용하여 반환 타입을 알려줬어야 했는데, C++14는 컴파일러가 return 문을 보면서 반환 타입을 추론한다. 
``` cpp
auto Add(int A, int B) -> int // C++ 11
{
	return A + B;
}

auto Add(int A, int B) // C++ 14
{
	return A + B;
}
```
매개변수는 C++17까지 auto가 불가능 했었기에, template를 썼어야 했는데, C++20부터 'Abbreviated Function Template' 기능을 지원하면서 가능해졌다. (사용과 동작은 template와 동일.)


주로 잘 사용되는 경우는 반복문인데, STL같은 경우 순회해야 하는 경우가 많아, iterator나 range-based for문에서 자료형을 일일히 적어야 하는 불편함을 auto로 대체 하여 간단하게 만들 수 있다.
``` cpp
std::vector<int> NumberList;  
for (const auto& Element : NumberList)  
{  
    // ....  
}  
  
for (auto iter = NumberList.begin(); iter != NumberList.end();)  
{  
    // ....  
    ++iter;  
}
```
### Lambda Auto

Lambda 또한 C++11과 C++14를 거쳐 변화해왔다.
``` cpp


int main() {
	auto LambdaFunc11 = [](int a, int b) { // C++ 11
		return a + b;
	};

	auto LambdaFunc14 = [](auto a, auto b) { // C++ 14
		return a + b;
	};
	
	LambdaFunc11(1, 3);
	LambdaFunc11(10.f, 30.f); // int 매개변수 외에는 형변환 되거나, Error
	 
	LambdaFunc14(10, 5);
	LambdaFunc14(0.8f, 5);   // 매개변수는 내부 식이 성립만 한다면 아무 타입이나 가능.
	LambdaFunc14(0.8, 5.2f); // Template<T, U> 같이 사용이 가능해졌다.
	
	return 0;
}
```
C++11에서는 반환형은 추론 되지만, 매개변수 타입이 고정되어, 매개변수 타입과 다른 값은 형변환되거나, Compile Error가 발생한다. C++14 부터는 "Generic Lambda"라고 하는 기능이 추가되어, 매개변수 `auto`가 가능해져 마치 `template`처럼 사용할 수 있고, 실제로 Lambda의 `operator()` 가 `template`형태로 생성되어 `template`과 유사하게 동작한다. 
### Auto VS Decltype
우선 위에서 auto는 참조, const를 유지하지 않고, 값 형태로 타입을 추론하는 방식이라고 했었다. Decltype은 그와 반대로 선언된 타입을 기반으로 참조와 const를 유지하면서 타입을 얻는데, 여기에는 2가지 방식이 있다. 
1. Decltype(Variable) 에서 Variable이 단순 변수라면, Variable이 선언된 타입을 그대로 가져온다. 만약 `const string&` 변수라면 `const string&`을 가져오는 방식이다.
2. Decltype(Expr) 에서 Expr이 '표현식'이라면 Value를 확인하여 결정한다. lvalue는 T&, xvalue는 T&&, prvalue는 T. 

2번이 조금 복잡한데, `int A = 10;`이라고 해보자. Decltype(A)라고 하면 1번 규칙을 따라 int가 된다. 하지만 1번 규칙을 피하기 위해서 괄호 하나를 더 추가한다. Decltype((A)) 로 만들게 되면, 2번 방식에서 A는 lvalue이므로, `int&`가 되는 것을 알 수 있고, Decltype(10)을 넣으면 prvalue로 취급되어 `int`가 된다. prvalue는 단순 literal 뿐만 아니라 [ A + 1 ]같이 '새로운 값을 만들어 낸다면' prvalue로 취급된다.