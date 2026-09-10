개념 : 객체 지향 프로그래밍 설계의 기본 5 원칙.
효과 : 코드 확장에 유연화, 유지보수, 복잡성 제거 -> 생산성 증가

### 단일 책임 원칙 : SRP(Single Responsibility Principle)

> [!NOTE] 단일 책임 원칙 : SRP(Single Responsibility Principle)
> **객체는 오직 하나의 책임을 가져야 한다.**

즉, 하나의 클래스가 하나의 역할을 하도록 분리하는 원칙.
-> SRP가 지켜지지 않는 경우, 수정 사항이 생겼을 때, 많은 코드에 영향을 끼치게 된다. 이는 추가적인 수정 사항/오류를 발생시키는 위험이 있고, 코드가 더 복잡해 지게 만든다.

그렇기에, **SRP**는 곧 '**구조 단순화**' 와 '**유지 보수**'의 효율을 높이는 설계 방법이다.
### 개방 폐쇄 법칙 : OCP(Open-Closed Principle)

> [!NOTE] 개방 폐쇄 법칙 : OCP(Open-Closed Principle)
> **확장에 개방적이어야 하며, 수정에는 폐쇄적이어야 한다.**

클래스 설계 시에는 기존의 코드를 수정하는 대신 새로운 코드 추가를 통해서 기능 확장을 하는 구조여야 한다는 것이다. 그러한 구조를 설계하기 위해선, 인터페이스를 쓰는게 좋다.
``` cpp
class Attackable {
	void Attack() = 0;
}
class Movable {
	void Move() = 0;
}

class Dragon : public Attackable, public Movable  {
	void Attack() override { ... }
	void Move() override { ... }
}

class Goblin : public Attackable, public Movable {
	void Attack() override { ... }
	void Move() override { ... }
}

class CombatSystem {
	void Combat(Attackable* _Attackable) { _Attackable->Attack(); }
}
```
몬스터를 추가(기능 확장)할 때, 클래스를 만들고 인터페이스를 상속 받아 구현하는 것이 끝이다. 인터페이스나 CombatSystem을 수정할 일(수정)은 없다.
OOP의 핵심 개념인 '추상화'를 통해 코드를 확장하여 생산성을 증가 시키는 중요 원칙이다.
### 리스코프 치환 법칙 : LSP(Liskov Substitution Principle)

### 인터페이스 분리 원칙 : ISP(Interface Segregation Principle)

### 의존성 역전 원칙 : DIP(Dependency Inversion Principle)