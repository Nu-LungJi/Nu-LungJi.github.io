**"상속"은 공통된 자료형을 하나로 묶어 데이터를 유기적으로 관리하기 위한 OOP 속성이다.** 하나의 클래스가 다른 클래스의 속성을 물려받고 활용하기 위한 목적을 가진다.

장점 : 재사용성 향상, 유지 보수성, 확장 용이

### 가상 상속

나중에 정리하자
### 다중 상속

-> C++에서는 두 가지 이상의 상위 클래스를 상속 받을 수 있다. 유연성과 확장성이 더욱 증가하지만, 반면에 복잡도가 더 증가한다. 또한 '다이아몬드 문제'가 있을 수 있는데, 이때는 상속을 '가상 상속'으로 받으면 함수 호출의 모호성이 사라져 해결된다.

※ 원인
``` cpp
class A { 
public: 
	void Render(){};
}; 

class B : public A { };
class C : public A { };
class D : public B, public C{ };

 int main(){ 
	 D dd; 
	 dd.Render(); // 모호성 발생 
}
```

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
	 dd.Render(); // 모호성 발생 
}
```