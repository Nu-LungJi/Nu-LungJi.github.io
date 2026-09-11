"추상화"는 **객체의 공통적인 속성과 행위를 묶어 정의하는 기능**을 말한다.
### 추상 클래스
하위 클래스가 공통적으로 가지는 속성과 기능을 정의하는 클래스로, 일부 기능을 하위 클래스에서 구현하게 한다. 객체의 통일화를 위한 목적의 추상층으로, C++에서는 순수 가상 함수가 하나 이상 있는 클래스를 말한다.
``` cpp
class Person {  // Abstract
protected:
	int Age;
	float Weight;
	
public:
	void Eat() { ... }
	virtual void Sound() = 0;
}
```

### 인터페이스
추상 클래스의 일종으로, 객체가 무엇을 해야하는지 '규약'을 정의하는 목적의 클래스이다. 클래스의 기능들만 정의하고, 구체적인 것은 인터페이스를 받는 클래스가 담당한다. C++에서는 순수 가상 함수만 사용하여 선언.
``` cpp
class Vehicle {  // interface
public:
	virtual void Move() = 0;
	virtual void Stop() = 0;
}
// Vehicle을 상속받는 클래스는 Move, Stop을 구현하도록 강제 된다.
```

