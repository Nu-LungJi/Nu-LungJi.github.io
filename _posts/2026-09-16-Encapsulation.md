---
title: OOP - Encapsulation
excerpt:
date: 2026-09-16 17:10:00 +0900
last_modified_at: 2026-09-14
categories:
  - Design Principle
tags:
  - "#OOP"
  - "#Encapsulation"
toc: true
toc_sticky: true
published: true
---
**"캡슐화"는 하나의 클래스가 특정 목적을 위해 연관된 속성과 기능을 하나로 묶어 관리하고, 외부에는 필요한 기능만 제공하여 내부 데이터와 기능을 보호하는 특성**을 "**캡슐화**"라고 말한다. 캡슐화를 적용하면, 연관된 기능과 데이터가 하나의 클래스에서 관리가 되므로, 코드 구조를 파악하는데 도움을 주면서 유지 보수를 용이하게 한다. 또한 클래스의 '접근 지정자'를 통해 외부에서 접근과 수정을 제한시키고, 필요한 기능만을 제공시킬 수 있다. 그렇기에, 외부에서는 클래스 내부 구현을 알 필요가 없도록 하고, 제공되는 기능만 사용하도록 만들 수 있다.

### 접근 지정자
C++ 기준으로 접근 지정자는 `public, protected, private` 총 3개 있다. 각각 기능을 제공하는 범위가 다르기 때문에 캡슐화를 적절하게 적용하려면 3개의 범위를 정확하게 알 필요가 있다.
- **public** : 해당 클래스 내부와 외부에서 모두 접근이 가능하고, 해당 클래스를 상속 받는 하위 클래스도 접근이 가능하다. 주로 외부에 제공하기 위한 기능이나 인터페이스를 public을 사용하여 제공한다.
- **protected** : 해당 클래스의 내부와 상속 받는 하위 클래스의 내부까지 접근이 가능하다. 외부에서는 접근이 불가하며, 주로 데이터, 기능의 보호와 상속을 목적으로 많이 쓰인다.
- **private** : 해당 클래스 내부에서만 사용이 가능하다. 즉, 상속/외부 전부 접근과 수정이 불가하다. 내부 데이터와 기능을 보호하고자 사용한다. (friend는 예외)
	- 해당 클래스를 상속받는 하위 클래스에도 상위 클래스에 해당하는 부분을 포함하고 있기에, 데이터와 기능은 존재하지만, private 멤버에 접근은 불가하다.

### Class & Struct
C++에는 Class와 Struct가 default로 접근 지정자가 선언이 되어 있다. 즉, 접근 지정자를 아예 선언하지 않고, 변수/함수를 선언하면, 자동으로 Class는 `private`, Struct는 `public`으로 지정된다.
``` cpp
struct BaseStruct {
	int  Data;		  // public
	void Get_Data();  // public
};

class BaseClass {
	int  Data;		  // private
	void Get_Data();  // private
};
```

### Getter / Setter

Getter / Setter는 데이터의 값을 읽거나 쓸 때 자주 쓰이는 함수로 대체로 외부에서 접근이 가능하게 만들 것이다. 데이터를 보호 하면서, 외부에서 접근할 수 있도록 만드는 브릿지 역할을 하기에, 많이 쓰일 것이다. (본인도 그렇다.) 하지만, 모든 데이터에 대해 Getter / Setter를 만들게 되면, 불필요하게 외부에 데이터를 노출시키고, 수정이 가능해져, 캡슐화의 효과가 약해지게 된다. 그렇기에, Getter / Setter가 '기능에 영향을 주는지', '꼭 필요한지' 다시 한 번 생각해보고, 만드는 것이 좋다. 또한 대안책으로 '행동 중심 기능'이 있다. 

예를 들어보자. { Monster는 HP를 가지고 있다. 공격을 받으면 HP가 감소하고, 일정 시간 지나면 최대 체력의 N% 회복 시킨다. } 이를 통해서 HP와 관련된 함수를 2개 만들어야 한다는 것을 알게 된다. Getter / Setter도 가능은 하지만, HP를 꼭 읽어와서 Damage만큼 빼준 후, Set을 하는 것 보다. 객체에 행동을 요청하는 방식으로, Damage를 넘겨주면 HP를 감소시키는 기능을 만드는 것이 **데이터 보호, 재사용성, 유지보수** 등에 더 좋을 것이다. 회복도 똑같다. N% 를 넘겨주면 HP가 회복되는 기능을 만드는 것이 여러 방면에서 이점을 준다. 

``` cpp

class Monster {
public:
	const float& GetHP()   { return HP; }
	void  SetHP(float _HP) { HP = _HP;  }
	
	const float& GetMaxHP() { return MaxHP; }
	
	void  TakeDamage(float _HP) { ... }
	void  Healing(float _Percentage) { ... }
	
private:
	float HP, MaxHP;
}

int main() {
	// Getter / Setter 만 사용할 때
	{
		Monster M1;
	
		float CurHP_A = M1.GetHP();
		M1.SetHP(CurHP_A - 10.f);
	
		float MaxHP = M1.GetMaxHP();
		float CurHP_B = M1.GetHP();
	
		M1.SetHP(CurHP_B + MaxHP * 0.05f);
	}
	
	// 행동 중심 기능을 사용할 때
	{
		Monster M2;
		
		M2.TakeDamage(10.f);
		
		M2.Healing(0.05f);
	}
	
	return 0;
}
```
위 코드와 같이 호출하는 쪽에서도 코드도 간단해지고, 의미도 명확해져, 가독성도 챙길 수 있다. 이렇게 행동 주체를 외부가 아닌 내부로 두면 되면, 코드의 의도를 표현하기도 수월해진다.
단순히 데이터를 감추고(private), Getter / Setter를 외부에 제공하는 것은 내부 구현 방식이나, 상태가 드러나기 때문에, 완전한 정보 은닉이라고 할 수 없다. 그렇기에, 기능의 로직은 내부에 감추고, 인터페이스만 외부에 제공하는 것이 진정한 정보 은닉이면서, 높은 수준의 캡슐화이다.

### 캡슐화 = 정보은닉?

캡슐화를 하면 정보은닉이 된다. 라고 하면 모든 데이터와 기능을 public으로 두면 성립하지 않는다. 캡슐화와 정보 은닉을 구분할 필요가 있는데, "캡슐화"는 연관된 속성과 기능을 하나로 묶어 관리하는 속성이고, "정보 은닉"은 외부에서 데이터 접근을 제한시키는 설계 기법이다. 그렇기에 캡슐화는 정보 은닉을 위한 **필요조건**이지만 **충분조건은 아니다.**

