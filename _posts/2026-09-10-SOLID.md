개념 : 객체 지향 프로그래밍 설계의 다섯 가지 기본 원칙.
효과 : 코드 확장의 유연성 향상, 유지 보수성 향상, 불필요한 복잡성 감소 -> 생산성 증가

### 단일 책임 원칙 : SRP(Single Responsibility Principle)
> [!NOTE] 단일 책임 원칙 : SRP(Single Responsibility Principle)
> **객체는 오직 하나의 책임을 가져야 한다.**

즉, 하나의 클래스가 하나의 역할을 하도록 분리하는 원칙.
-> SRP가 지켜지지 않는 경우, 수정 사항이 생겼을 때, 많은 코드에 영향을 끼치게 된다. 이는 추가적인 수정 사항/오류를 발생시키는 위험이 있고, 코드가 더 복잡해지게 만든다.

그렇기에, **SRP**는 곧 '**구조 단순화**'와 '**유지 보수**'의 효율을 높이는 설계 방법이다.
### 개방 폐쇄 원칙 : OCP(Open-Closed Principle)
> [!NOTE] 개방 폐쇄 원칙 : OCP(Open-Closed Principle)
> **확장에 개방적이어야 하며, 수정에는 폐쇄적이어야 한다.**

클래스 설계 시에는 기존의 코드를 수정하는 대신 새로운 코드 추가를 통해서 기능 확장을 하는 구조여야 한다는 것이다. 그러한 구조를 설계하기 위해서, 대표적으로 인터페이스를 많이 쓴다.
``` cpp
class Attackable {
	virtual void Attack() = 0;
};
class Movable {
	virtual void Move() = 0;
};
class Flyable {
	virtual void Fly() = 0;
};
class Dragon : public Attackable, public Flyable  {
	void Attack() override { ... }
	void Fly() override { ... }
};

class Goblin : public Attackable, public Movable {
	void Attack() override { ... }
	void Move() override { ... }
};

class CombatSystem {
	void Combat(Attackable* _Attackable) { _Attackable->Attack(); }
};
```
몬스터를 추가(기능 확장)할 때, 클래스를 만들고 인터페이스를 상속받아 구현하는 것이 끝이다. 인터페이스가 변경되지 않는 이상, CombatSystem도 변경될 일이 없게 된다.
OOP의 핵심 개념인 '추상화'를 통해 코드를 확장하여 생산성을 증가시키는 중요 원칙이다.

### 리스코프 치환 원칙 : LSP(Liskov Substitution Principle)
> [!NOTE] 리스코프 치환 원칙 : LSP(Liskov Substitution Principle)
> **하위 클래스는 상위 클래스에 대해 완전하게 대체할 수 있어야 한다.**

대표적으로 '직사각형 - 정사각형 예시'가 이 원칙을 위반하는 사례를 잘 보여주는데,
``` cpp
class Rectangle {
protected:
    double width;
    double height;
    
public:
	virtual double area() { return width * height; }
	virtual void setWidth(double width) {
		this->width = width;
	}
	virtual void setHeight(double height) {
		this->height = height;
	}
};

class Square : public Rectangle {
	void setWidth(double width) {
        this->width = width;
        this->height = width;
    }
    void setHeight(double height) {
        this->width = height;
        this->height = height;
    }
};

void Process(Rectangle& _Rect){
	_Rect.setWidth(5);
	_Rect.setHeight(4);
	assert(_Rect.area() == 20);  // _Rect가 Square 객체라면, 결과가 16, 오류 발생!
}
```
만약 Process 함수에 Rectangle 클래스 객체가 들어오면 assert에 걸리지 않게 된다. 하지만 Square 클래스 객체가 들어온다면, 결과가 16이 되어 assert에 걸려 에러를 발생시킨다. 중요한 문제는 이 **오류가 런타임에 발생**한다는 것인데, 이는 작업의 효율을 늦추게 만드는 잠재적 원인이 된다.

LSP는 이런 '다형성'을 부적절하게 설계하는 문제를 막기 위한 원칙이다. 이를 만족하기 위해서는 인터페이스 클래스로 공통 분모를 나누는 게 좋다.

### 인터페이스 분리 원칙 : ISP(Interface Segregation Principle)
> [!NOTE] 인터페이스 분리 원칙 : ISP(Interface Segregation Principle)
> **클라이언트가 사용하지 않는 메서드에 의존하게 만들면 안 된다.**

인터페이스 클래스를 상속받은 클래스가 사용하지도 않을 메서드의 구현을 강제해선 안된다는 생각을 기반으로, 인터페이스를 분리하도록 만드는 원칙이다. 반드시 그런 건 아니지만, 인터페이스 클래스가 비대해지는 것은 위에 다뤘던 SRP가 지켜지지 않을 확률이 높고, OCP에서도 불리해질 수 있다. 

그렇기에 비대한 인터페이스보다는 메서드가 하나만 있더라도 가벼운 인터페이스가 선호된다.
이 가벼운 인터페이스는 클라이언트가 불필요한 의존성을 가지는 경우를 줄이게 하고, SRP와 OCP를 지키기 쉽게 한다. 또한 불필요한 메서드 구현이 필요 없어지고, 의존성도 줄일 수 있다.
``` cpp
// 이런 인터페이스 클래스를 사용하는 대신
class Machine {
    virtual void print() = 0;
    virtual void scan() = 0;
    virtual void fax() = 0;
};

// 최소한의 기능만 가진 인터페이스로 만들자 
class Printer {
    virtual void print() = 0;
};
class Scanner {
    virtual void scan() = 0;
};
class Fax {
    virtual void fax() = 0;
};
```
### 의존성 역전 원칙 : DIP(Dependency Inversion Principle)
> [!NOTE] 의존성 역전 원칙 : DIP(Dependency Inversion Principle)
> **상위 모듈은 하위 모듈에 의존해선 안 되며, '추상화'에 의존해야 한다.** 

클라이언트는 인터페이스를 상속받은 구체적인 클래스에 의존하면 안 되고, 인터페이스에 의존해야 한다. 또한 구체적인 클래스도 인터페이스에 의존해야 한다. 결국 상위 모듈은 하위 모듈의 구체적인 구현을 알 필요가 없다. 아래 코드로 이해하면 더 쉽다.
``` cpp
class PaymentService {  // interface
	virtual void pay() = 0;
};

class NaverPay : public PaymentService {
	void pay() override { ... }
};

class Client { 
public:
	void OrderProduct(PaymentService* _Payment) {
		_Payment->pay();
	}
};
```
여기서 Client는 '상위 모듈', NaverPay가 '하위 모듈'이 된다. PaymentService라는 추상화에 의존하여 결제 수단이 많아져도 Client의 수정이 없고 클래스 추가밖에 없으므로 확장성이 좋다.

### 정리 & 회고
SOLID 원칙은 하나의 원칙이 다른 원칙의 목적 달성에도 영향을 준다. 이는 곧 설계를 잘못했을 때, 생산성 저하로 이어진다고 볼 수 있기에, 성공적인 소프트웨어를 개발하려면 SOLID 원칙이 기본이 되어야 하고, 설계에 대해 끊임없이 연구해야 한다고 생각한다.

본인도 이전까지 프로젝트를 할 때, 파일이 많아지면 찾기가 어려우니까 적은 클래스로 하나의 클래스가 역할을 크게 가져가도록 만들었었다. 지금 생각해보면 그건 설계라기보다 편의에 가까웠기에, 고쳐야 할 점이라고 이 글을 쓰면서 느꼈다. 그리고 다형성을 위한 설계를 습관화하려면, 무작정 클래스 먼저 만들고 나중에 고치기보다, 먼저 노트나 패드에 설계도를 그리는 시간을 갖는 게 효율적이었다는 것을 체감한다.