---
title: OOP - Polymorphism
excerpt:
date: 2026-09-20 17:10:00 +0900
last_modified_at: 2026-09-20
categories:
  - Design Principle
tags:
  - "#OOP"
  - "#Polymorphism"
toc: true
toc_sticky: true
published: true
---
"**다형성**"은 하나의 동일한 인터페이스에서, 객체에 따라서 다양한 동작을 할 수 있도록 하는 OOP의 핵심 특성. 다형성은 같은 이름의 함수가 다른 동작을 수행하지만, 그 기능을 일관되게 사용할 수 있다는 점에서 기능을 확장하거나 변경에 도움을 주고, “코드의 **재사용성**을 높이기 위한” 장점을 가지고 있다. 또한, '**코드의 간결성**', '**유지 보수성**'을 높이고, OOP의 특성 중 하나인 “추상화”를 더 강화시킨다.

- **정적 바인딩 :** **컴파일 타임**(프로그램 실행 전)에, 어떤 함수가 호출될지 '결정'되는 것.
    포인터 변수의 클래스 타입(클래스 자료형)에 따라 그 **타입에 맞는 함수를 호출**.
	컴파일 타임에 결정이 되므로, 속도가 빠르다.
- **동적 바인딩 :** **런타임**(프로그램이 실행하고 있는 중)에, 어떤 함수가 호출될지 '결정'되는 것.
    그렇기에 간접 호출 과정에서 비용이 발생하므로, 정적 바인딩보다 비용이 많이든다.
    (보통 `virtual` 키워드가 붙은 가상 함수에서 수행.)

→ **다형성의 구현 의도 :** 구체적인 객체 타입을 구분하지 않고, 같은 인터페이스에서, 실 객체에 맞는 구현이 선택되도록 하는 것이 다형성을 사용하는 이유이다. 그렇기에 보통, 부모에서 메서드를 선언 하면서 [선언부], 구체적인 세부 사항은 자식에게 담당시킨다. [구현부]

→ **바인딩** : 지금부터는 정적/동적의 바인딩 사례를 알아 볼건데, 바인딩(binding)은 메서드의 호출문이(함수가 호출됐을 때) 실제 메모리 주소로 매핑되는 것을 말한다. 이는 컴파일 단계에서도 일어나고, 프로그램 실행 중에도 일어나는데, 이를 정적/동적 바인딩으로 나눌 수 있다.
### 정적 바인딩

→ **오버로딩** : **같은 이름의 함수**를 “**매개변수의 개수/자료형**(리턴 타입은 무관)”에 따라 그에 맞는 함수를 호출하는 것. 기능을 동일한 이름으로 “**캡슐화**” 시킬 수 있고, 코드의 가독성을 향상 시킨다. 오버로딩의 예시를 밑 코드 블럭으로 만들어 보았다.
``` cpp
class Vector3D {
	Vector3D AddVector(int x, int y, int z) { ... }
	Vector3D AddVector(const Vector3D& _vec) { ... } 
	Vector3D AddVector(int xyz) { ... }
	
	Vector3D AddVector(float x, float y, float z) { ... }
	Vector3D AddVector(float xyz) { ... }
};
```
함수 명은 같게 하되, 매개변수 갯수나 자료형을 각각 다르게 해서 선언하고, 구현도 서로 다르게 만들 수도 있게 된다. 많이 쓰이는 클래스(수학, 유틸리티)일 수록, 사용자의 편의성이 급격히 높아지고, 가독성을 향상 시킬 것을 예측해볼 수 있다.

→ **template** : template 메서드를 사용하거나, template 객체를 만들 때, 개발자가 타입을 정해준다. 타입이 고정되므로, 컴파일 타임에 지정이 가능하다.
``` cpp
template <typename T>
T Add(T X, T Y) { return X + Y; }

int main() {
	int Result = Add<int>(3, 8);
}
```

### 동적 바인딩

→ **오버라이딩 : 상위 클래스의 메서드를 하위 클래스에서 재정의 하는 방식**. 다만, 조건이 붙는다.
	=> **오버라이딩 조건 :** 
		- 상위 클래스/하위 클래스가 모두 존재해야하고, '상속 관계'여야 한다.
		- Override 하고자 하는 메서드는 전부 “**완전히 일치**”하는 형태의 함수가 존재해야 한다.(리턴 타입, 매개변수, 함수 명) 같아야 한다. ('공변 반환형' 예외가 있는데, 밑에서 설명 예정)
		- 상위 클래스의 멤버 함수 앞에 “**virtual**” 키워드를 붙여, '**가상 함수화**' 시킨다.

→ **가상 소멸자 :** 오버라이드를 위해서, 상위 클래스 포인터 변수에 하위 클래스를 동적 할당 했더니, 하위 클래스의 소멸자가 불리지 않는 상황이 나온다. (밑에서 설명)
### 오버라이딩
``` cpp
class CBase {
public: 
	virtual void PrintMyName() { std::cout << "Name : Base" << "\n"; }
};
class CDerived : public CBase { 
public: 
	virtual void PrintMyName() override { std::cout << "Name : CDerived" << "\n"; }
}; 
int main() { 
	CBase* pDerived = new CDerived; 
	pDerived->PrintMyName();
	...
}
// 하위 클래스의 PrintMyName이 호출된다.
```
→ **런타임 다형성 활용 :** 상위 클래스 포인터 또는 참조를 통해 하위 클래스를 대상으로 참조한다.

→ **공변 반환형 :** 오버라이딩은 기본적으로 함수 선언은 상위 클래스와 하위 클래스 모두 동일해야 한다. 하지만 반환형에서 예외가 있는데, 상위 클래스의 가상 함수가 자신(Base)의 **포인터 또는 참조 타입**을 반환하고, 하위 클래스에서도 자신(Derived)의 **포인터 또는 참조 타입**을 반환하는 경우가 가능하다. 정확히는 상속 관계를 가지므로, 하위 클래스는 상위 클래스보다 더 구체적인 타입이면서, 상위 클래스의 반환형과 호환이 된다. 그렇기에 이러한 관계가 성립이 된다.

``` cpp
class Base {
public:
	virtual Base* GetThisPTR();
	virtual Base& GetThisRef();
};

class Derived : public Base {
public:
	virtual Derived* GetThisPTR() override;
	virtual Derived& GetThisRef() override;
};
```


### 가상 소멸자

<details markdown="1">
<summary><strong>※ 문제 상황</strong></summary>
```cpp
class CBase { 
public: 
    CBase() { cout << "부모 생성자 호출" << endl; }
    ~CBase(){ cout << "부모 소멸자 호출" << endl; }
}; 

class CDerived : public CBase { 
public: 
    CDerived() { cout << "자식 생성자 호출" << endl; } 
    ~CDerived() { cout << "자식 소멸자 호출" << endl; } 
}; 

int main() { 
    CBase* pDerived = new CDerived; 
    delete pDerived;
}

>//************** 결과 *****************//
>부모 생성자 호출
>자식 생성자 호출
>부모 소멸자 호출
>// 자식 소멸자가 불리지 않음( 하지만, 표준에서 보장된 행동이 아니다 )
```
</details>


<details markdown="1">
<summary><strong>※ 해결</strong></summary>
```cpp
class CBase { 
public: 
    CBase() { cout << "부모 생성자 호출" << endl; }
    virtual ~CBase(){ cout << "부모 소멸자 호출" << endl; }
}; 

class CDerived : public CBase { 
public: 
    CDerived() { cout << "자식 생성자 호출" << endl; } 
    ~CDerived() { cout << "자식 소멸자 호출" << endl; } 
}; 

int main() { 
    CBase* pDerived = new CDerived; 
    delete pDerived;
}
>//************** 결과 *****************//
>부모 생성자 호출
>자식 생성자 호출
>자식 소멸자 호출
>부모 소멸자 호출
```
</details>

상위 클래스의 포인터 자료형 변수의 실 객체는 하위 클래스이다. 그렇기에 객체 delete를 하게 되면, 컴파일러는 자동으로 소멸자를 결정하는데, 2가지 경우로 나눠진다는 것이다.
	 - **~BaseClass() :** 자료형을 기준으로 소멸자를 결정한다. 즉, 상위 클래스의 소멸자를 호출시키는 것이다. 비가상 소멸자로 하위 객체를 삭제시키는 작업은 C++ 표준에서 보장된 행동이 아니기에, 가상 소멸자로 전환시켜야 안전성이 보장된다.
	- **virtual ~BaseClass() :** 소멸자의 virtual을 확인하면서, 실제 객체(하위 클래스)의 가상 함수 정보를 확인 하면서 Child의 소멸자를 호출시킨다. 이후에, 컴파일러는 C++의 객체 소멸 순서 규율에 따라 부모의 소멸자도 호출시킨다.
그렇기에, 상위 클래스 포인터를 통해 하위 클래스 객체를 삭제할 가능성이 있다면 , 부모 가상 소멸자를 필수적으로 만들어야 한다.`virtual`키워드를 부모에 붙여주기만 해도 하위 클래스의 소멸자까지 자동으로 virtual이 붙는다.

### 가상 함수

→ **정의 :** virtual 키워드가 붙여진 함수. 일반 함수에 반해, 가상 함수 호출이 런타임의 비용을 발생시킬 수 있다. 하지만, '다형성'의 혜택을 위해선 '감안'하고 사용해야 하는 문법이다.

→ **가상 함수 포인터/테이블 :** 대부분의 컴파일러는 `vptr`과 `vtable`을 이용해 동적 바인딩을 구현한다. 객체의 [가상 함수 포인터(`vptr`)]가 [가상 함수 테이블(`vtable`)]에 접근해서 호출될 함수를 찾아내는 방식으로 동작을 한다. 일반적인 컴파일러 구현에서 가상 함수를 사용하는 객체에는 `vptr`이 존재하며, 해당 객체의 타입에 대응하는 `vtable`을 가리킨다. (상속을 포함해서, 가상 함수가 1개도 없다면 생기지 않음.)

- **가상 함수 포인터(vptr) :** 객체의 동적 타입에 대응하는 `vtable`을 가리킨다. 즉, 가상 함수를 찾아 호출 시키는 역할로, 객체 내부의 숨겨진 포인터이다. 그렇기에, 객체 크기에도 영향을 미친다.

- **가상 함수 테이블(vtbl) :** 가상 함수 호출을 위해서 함수 주소를 저장해두는 테이블. 객체 크기에 영향을 미치지 않는다.

→ **가상 함수의 상속/호출 :** 상위 클래스의 가상 함수는 하위 클래스에서도 가상 함수 성질을 유지한다. 하위 클래스에서 이 가상 함수를 재정의 하지 않을 경우, 상위 클래스의 함수가 최종 오버라이더가 된다. 예시로 아래 코드가 재정의로 인해 함수 호출을 달리 하는 것을 설명해준다.
``` cpp
class Base {
public:
	virtual void Update() { ... }
	virtual void Render() { ... }
};

class Derived : public Base {
public:
	virtual void Update() { ... }
	// Render를 Override하지 않음
};

int main() {
	Base* Object = new Derived;
	Object->Update(); // Derived -> Update()
	Object->Render(); // Base -> Render()
	
	return 0;
}
```
다음과 같은 관계일 때, 현재, 상위 클래스는 "Base", 하위 클래스는 "Derived"이고, Base의 상속을 받는 Derived라는 하위 클래스는 Render에 대한 구현이 되어 있지 않다. 

상위 클래스의 가상 함수 테이블에는 Update()와 Render() 함수가 가상 함수로 등록 되어 있을 것이다. 그렇다면, 하위 클래스는 Update만 재정의 하니까 하위 클래스의 가상 함수 테이블엔 Update만 등록되어 있을까? 위에서 말했듯이 상위 클래스에서 가상 함수는 하위 클래스에서도 가상 함수 성질을 유지한다. 즉, 하위 클래스에도 Render함수가 등록되어 있지만, 하위 클래스의 Render가 아닌 상위 클래스의 Render 함수를 가리키게 되는 것이다.

그러면, 호출은 어떻게 될까? 재정의가 없음에도 하위 클래스의 함수가 불릴까? 답은 재정의가 없는 경우, 상위 클래스의 함수가 호출된다. 즉, 외부에서 Update를 호출하면 Derived의 Update, Render를 호출하면 Base의 Render 함수가 호출된다.

함수를 재정의 하지 않아, Render의 최종적으로 Override 된 부분이 자동적으로 상위 클래스(Base)가 되므로, 상위 클래스의 함수가 호출이 되는 방식이다.

### 다운 캐스팅

→ **캐스팅 연산자 :** [ 연산자<형 변환 자료형>(형 변환 대상) ]

- **static_cast\<Type> :** '컴파일 타임'에 형 변환을 수행하는 캐스팅 연산자. 클래스의 상속 관계를 판단하여, 논리적인 형 변환은 수행하지만 실 객체의 동적 타입 검사는 X, 비 논리적인 형 변환은 지원하지 않는다.
- **dynamic_cast\<Type> :** '런타임'에 형 변환을 수행하는 캐스팅 연산자. 다형적 관계에서 타입 검사를 수행하는 연산자. 주로 안전한 "다운 캐스팅"(부모 클래스를 자식클래스로 캐스팅)에 사용된다. 상속 관계, 가상 함수 유/무에 따라 논리성 판단을 한다. 비논리적인 경우 지원하지 않는다. 

- **두 연산자의 차이 :** static_cast는 컴파일 타임에 논리성 판단을 마치므로, 런타임에 실 객체 타입을 확인하는 dynamic_cast보다 빠르다. 

``` cpp
Derived* scd = static_cast<Derived*>(base);

Derived* dcd = dynamic_cast<Derived*>(base);

if (dcd == nullptr) {
    // 포인터 캐스팅 실패
}

Base& baseRef = object;

try {
    Derived& Ref = dynamic_cast<Derived&>(baseRef);
}
catch (const std::bad_cast& exception) {
    // 참조 캐스팅 실패
}
```

→ **RTTI(Run Time Type Information) :** 런타임에 객체의 타입 정보를 식별할 수 있는 기능. 일반 타입에도 사용할 수 있지만, 상위 클래스 포인터/참조를 통해 실제 동적 타입을 식별하려면 상위 클래스가 가상 함수를 하나 이상 가진 다형적 클래스여야 한다.

→ **typeid :** 런타임에 참조 객체/포인터 타입을 `std::type_info` 형태로 반환하는 연산자.

```cpp
int main() { // 같은 타입 확인 로직
	 Derived* pd = new Derived;
	 Base* pb = pd;
	 
	typeid(pd)  // Derived*
	typeid(pb)  // Base*

	typeid(*pd) // Derived
	typeid(*pb) // Derived (Base 클래스가 다형적인 경우)
	 
	 if(typeid(*pd) == typeid(*pb)) cout << "Same Type!" << endl;
	 // "Same Type!" 출력
     
	 delete pd;
}
```

→ **type_info :** typeid가 반환시키는 객체를 말한다. 단순히 `==,` `!=` 연산과 .name(), .hash_code() 등의 타입 정보 비교 및 조회 기능을 제공한다.

### 지정자
→ `override` : 가상 함수가 적절하게 정의되었는지 확인용의 키워드.

→ **final class :** 상속을 받는 마지막 계층(더 이상 상속을 하지 않음.)을 강제시키는 키워드. 추가 상속이 금지되도록 만든다.
→ **final 함수 :** 해당 함수를 더 이상 override하지 않겠다는 것을 알리고 강제시키는 키워드.

→ **순수 가상 함수 :** 함수 끝에 " = 0 "을 붙여 순수 가상 함수로 만들 수 있다. 클래스에 이 함수가 하나라도 있는 경우, 해당 클래스는 추상 클래스가 되고, 독립적인 객체를 만들 수 없게 된다.
