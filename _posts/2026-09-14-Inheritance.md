---
title: OOP - Inheritance
excerpt:
date: 2026-09-14 17:10:00 +0900
last_modified_at: 2026-09-14
categories:
  - Design Principle
tags:
  - "#OOP"
  - "#Inheritance"
toc: true
toc_sticky: true
published: true
---
"**상속(Inheritance)**"은 기존 클래스의 속성/기능을 기반으로 새로운 클래스를 정의하는 OOP 기능이다. 하나의 클래스가 다른 클래스의 속성을 물려받고 활용하기 위한 목적을 가진다. 

[상속의 장점]
- **코드 재사용성** : 상속을 사용하면, 공통적인 속성이나 메서드를 계속 정의할 필요가 없다. 부모 클래스에서 최초 한 번 구현 후에는, 자식 클래스에서 물려받아 중복 구현을 줄일 수 있다.
- **유지보수에 용이** : 자식들의 공통된 로직을 부모 클래스에서 관리하므로, 동일한 코드를 각각 수정할 필요가 없어 빠른 수정이 가능하다.

[상속의 단점]
- **강한 결합도** : 상속 구조가 복잡해지면, 부모 클래스의 수정이 자식 클래스에게 예상치 못한 영향을 주게 된다.
- **캡슐화 약화** : 자식 클래스가 부모에 구현된 속성과 메서드에 의존하게 되는 경우, 부모의 구현 세부사항이 자식 클래스에서 노출되어, 캡슐화의 정보 은닉의 특성을 약화시키는 상황을 만든다. 
### 기본 상속

C++ 에서 상속을 받는 것은 '접근 제어 지시자'와 '부모 클래스 명' 만 붙여주면 된다.
``` cpp
class Cat : public Animal {  // Cat이 자식, Animal이 부모
	...
}
```

접근 제어 지시자는 클래스 속성이나 메서드에 대해 '외부 접근 범위'를 제한하는 용도로 쓰이는데, 이 '범위'를 자세하게 알 필요가 있다.

``` cpp
class Parent {
public:
	void PublicMethod() {}
protected:
	void ProtectedMethod() {}
private:
	void PrivateMethod() {}
};

class PublicChild : public Parent {
	// PublicMethod(), ProtectedMethod() 접근 가능 / PrivateMethod() 접근 불가
};
class ProtectedChild : protected Parent {
	// PublicMethod(), ProtectedMethod() 접근 가능 / PrivateMethod() 접근 불가
};
class PrivateChild : private Parent {
	// PublicMethod(), ProtectedMethod() 접근 가능 / PrivateMethod() 접근 불가
};

int main() {
	PublicChild PubC;
	PubC.PublicMethod();     // O
	// PubC.ProtectedMethod();   // X

	ProtectedChild ProC;
	// ProC.PublicMethod();     // X
	// ProC.ProtectedMethod();   // X
	
	PrivateChild PriC;
	// PriC.PublicMethod();     // X
	// PriC.ProtectedMethod();   // X

	return 0;
}
```

이 예시를 들어보면, public/protected/private 전부 부모의 public, protected에 접근이 가능하다. 하지만, 부모의 private는 오직 부모에서만 사용이 가능하다. 그렇기에 3개의 자식 클래스들은`PublicMethod(), ProtectedMethod()`만 사용이 가능한데, 여기서 또 주의를 해야 할 것이 '**자식이 어떻게 상속 받았는가**'이다. main함수에서 이 관계를 간단하게 보여주는데, 자세한건 밑에 표에서 확인할 수 있는데, '부모 접근 제어 지시자가 A고, 상속 타입이 B라면 자식에서 C가 된다.' 라는 순으로 표를 보면 된다.

<table border="1">
  <thead>
  <colgroup> 
	<col style="width: 30%;"> <col style="width: 40%;"> <col style="width: 50%;"></colgroup> 
    <tr>
      <th align="center">상속 타입</th>
      <th align="center">부모 접근 제어 지시자</th>
      <th align="center">자식 접근 제어 지시자</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="2" align="center" valign="middle">public</td>
      <td align="center">public</td>
      <td align="center">public</td>
    </tr>
    <tr>
      <td align="center">protected</td>
      <td align="center">protected</td>
    </tr>
    <tr>
      <td rowspan="2" align="center" valign="middle">protected</td>
      <td align="center">public</td>
      <td align="center">protected</td>
    </tr>
    <tr>
      <td align="center">protected</td>
      <td align="center">protected</td>
    </tr>
    <tr>
      <td rowspan="2" align="center" valign="middle">private</td>
      <td align="center">public</td>
      <td align="center">private</td>
    </tr>
    <tr>
      <td align="center">protected</td>
      <td align="center">private</td>
    </tr>
  </tbody>
</table>

다시 처음부터 정리해보면, **"부모의 private 멤버는 자식에서 접근할 수 없다."** 것이 **상속 관계의 조건.** 외부에서 부모/자식 멤버에 접근하려면 무조건 **"public 선언, public 상속."** 자식이 또 다른 자식에게 상속은 **"public/proteced 선언 & 상속"** 그 외는 private. 상속 후, 이것이 **접근 제어 지시자 전환.**
### 다중 상속

C++에서는 두 가지 이상의 상위 클래스를 상속 받을 수 있다. 따라서 여러 상위 클래스의 멤버들을 사용할 수 있어, 유연성과 확장성이 더욱 증가하지만, 반면에 복잡도가 배로 증가한다. 

``` cpp
class A {
public:
	void Update() {}
};
class B {
public:
	void Render() {}
};
class C : public A, public B {
public:
	void Main() {
		Update();
		Render();
	}
};
```
다중 상속은 장점도 크지만, 단점도 확실하기에 신중하게 써야한다. 그 중에 상속받는 상위 클래스의 '메서드 이름 충돌', '다이아몬드 문제'가 있을 수 있는데, '다이아몬드 문제'는 해결에 한 번 코드로 보겠다.

※ 원인
``` cpp
class A { 
public: 
	void Render(){};
}; 

class B : public A { };
class C : public A { };
class D : public B, public C{ };

//      A
//     / \
//    B   C
//     \ /
//      D

 int main(){ 
	 D dd; 
	 dd.Render(); // 에러 : 모호성 발생 
}
```

D객체 가 생성되고 상위 클래스인 B, C도 생성이 되면서 B에도 상위 객체A, C에도 상위 객체A가 생겨 중복이 된다. 생성에는 문제가 없지만, A에 있는 메서드를 사용하면서 어느 객체의 메서드를 사용해야 하는지 모호해지는 일이 발생하여 컴파일 오류를 내게된다.

``` cpp
D dd; 
dd.B::Render();
```
이런 방식으로 어떤 객체의 Render인지 명시해주면 해결은 되지만, 해당 멤버에 대한 접근 권한이 있어야 한다. 충돌한 메서드가 많이 없는 경우에는 괜찮지만, 외부에서는 변수거나 메서드가 public이 아닌 경우 이를 사용하지 못하게 된다.

그래서, 다이아몬드 상속이 발생하고, 부모를 하나만 공유해야 한다면, "**가상 상속**"을 사용 해야한다.

### 가상 상속

가상 상속은 다중 상속시에 상위 클래스들이 조상 클래스를 공통으로 가지고 있다면, 조상 클래스의 객체가 둘 이상 생겨 모호성이 발생하는데, 하위 클래스 객체에 동일한 조상 클래스 객체가 중복 생성되는 것을 막고, 하나만 공유하게 만드는 기능이다.

※ 해결
``` cpp
class A { 
public: 
	void Render(){};
}; 

class B : virtual public A { };  // virtual 키워드를 붙여 가상 상속
class C : virtual public A { };
class D : public B, public C{ };

 int main(){ 
	 D dd; 
	 dd.Render();  // O
}
```
위 코드 같이 객체가 중복으로 생기는 대상 클래스를 상속 받는 쪽에 `virtual` 키워드를 붙여 해결할 수 있다.

Q. 그러면 상속을 받는 모든 곳을 가상 상속을 시켜서 초기에 중복을 방지하면 되는거 아닌가?
했을 때, 답은 **"아니다."** 가상 상속의 단점은 "**복잡도**"와 "**오버헤드**"인데, 기본 상속은 상위 객체의 위치가 비교적 단순하게 정해지는 반면에, 가상 상속은 컴파일러가 상위 객체를 탐색하려고 추가적인 포인터 변수, 테이블이 필요할 수 있어 비효율적이다. 또한 '생성자 규칙'이 변하는데, 아래 코드에서 확인해보자.

``` cpp
class A  {  
public:  
    A(int value)  { cout << "A Constructor : " << value << endl; }  
    ~A()          { cout << "A Destructor" << endl; }
};  
  
class B : virtual public A  {  
public:  
    B() : A(10) { cout << "B Constructor" << endl; }  
    ~B()        { cout << "B Destructor"  << endl; }
};  

class C : virtual public A  {  
public:  
    C() : A(20) { cout << "C Constructor" << endl; }  
    ~C()        { cout << "C Destructor"  << endl; }
}; 

class D : public B, public C  {  
public:  
    D() : A(100), B(), C() { cout << "D Constructor" << endl; }  
    ~D()        { cout << "D Destructor" << endl; }
};  
  
int main()  
{  
    cout << "===== Create B =====" << endl;  
    { 
	    B b;  
    }  
    cout << endl;  
  
    cout << "===== Create C =====" << endl;  
    {        
	    C c;  
    }  
    cout << endl;  
  
    cout << "===== Create D =====" << endl;  
    {        
		D d;  
    }  
    
    return 0;  
}

//결과 :

//===== Create B =====
//A Constructor : 10
//B Constructor
//B Destructor
//A Destructor

//===== Create C =====
//A Constructor : 20
//C Constructor
//C Destructor
//A Destructor

//===== Create D =====
//A Constructor : 100
//B Constructor
//C Constructor
//D Constructor
//D Destructor
//C Destructor
//B Destructor
//A Destructor
```

가상 상속에서는 가장 먼저 공유되는 객체 A가 생성되고, 이후 B > C > D 순으로 생성된다. D클래스가 A클래스를 직접 생성하고 있다는 점에서, 가상 상속은 '**최종 자식 클래스가 가상 상위 클래스를 초기화한다.**' 라고 할 수 있다. 이런 '생성자 규칙' 변화로 인해 예상치 못하는 결과가 나올 수 있다는 위험이 따르기에, 가상 상속은 다중 상속에서 공통 객체를 공유해야 할 때, 쓰는 기능 정도로만 보면 좋을것 같다.