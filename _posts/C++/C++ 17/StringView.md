### string_view

C++17에 추가된 string_view는 string을 느슨하게 참조한다. 즉, 복사를 하지 않고, 문자열을 매개변수로 받아와 읽을 수 있다. 수정은 불가하기에(읽기 전용), `const string&` 과 유사한 역할을 한다. 참조만 하기에, 힙 할당이 없음을 보장하면서 복사 비용도 없어지게 된다. string의 암시적인 객체 생성을 막을 수 있다. string_view 외에도 wstring_view, u8string_view... 문자 자료형 종류마다 존재한다. 내부 기능은 string과 거의 같다. 더하여, \0 널 문자도 필요없고, 

→ **조건 :** string_view가 참조하는 대상(string or 문자열)인 원본은 string_view보다 수명이 더 길어야 한다. string_view는 '비소유'이기 때문에, 원본이 살아있어야 읽을 수 있기 때문이다.

→ **Null Terminated :** string_view는 포인터와, 길이만 가지고 있는 클래스이기 때문에, 문자열에서 \0 으로 문자열을 마치는 개념이 없다. 그렇기에 일부 함수(C API, printf)에서는 오류로 작동할 수 있기 때문에, 이는 string을 사용하는 것이 좋다.

→ **전략 :** 읽기 전용으로만 함수 파라미터로 받아온다면, string_view가 안정적이고, 빠른 속도를 낸다. (const string&은 복사가 될 수도 있기 때문.) 하지만, 함수 내부에서 string_view를 string으로 바꾸는 과정이 필요하다면, `const string&`이 차라리 더 낫다.

또한, 변하지 않는 파일 명 같은 문자열들은 `inline constexpr std::string_view`로 만드는 것이 힙 할당이 아예 없고, 컴파일 타임 평가, 무결성, 중복 정의 방지(여러 파일에 \#include되는 경우) 등을 유지시킬 수 있기에, 가능한 이렇게 만드는 것이, C++20까지 가장 추천되는 방법이다.



