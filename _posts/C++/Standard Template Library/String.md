→ **정의 :** C스타일 에서는 char, char*, wchar_t 등을 사용해서 배열을 만들고, 배열 한 칸당 한 문자 씩 넣어주어, 하나의 "**문자열**"을 만들었다. 다만, 이는 불편했고, 신경써야 할 것들이 많았는데, NULL(\0)문자로 끝마침이 포함되어야 하고, 문자열의 길이를 알기 힘들거나, 메모리 수동 관리 등. 다루기에 힘들뿐더러, 신경써야 할 부분이 개발자에게 너무 많았다. 이를 사용하게 쉽도록 인터페이스화 시켜 만든 것이 C++ STL의 **string**이다.

→ **basic_string / char_trait :** string도 C++버전이 진화하면서 종류가 다양해졌다. string, wstring, u16string 등등, 다 다른 클래스로 보이지만, 내부는 이렇다.
``` cpp
using string  = basic_string<char, char_traits<char>, allocator<char>>;  
using wstring = basic_string<wchar_t, char_traits<wchar_t>, allocator<wchar_t>>;  
using u8string = basic_string<char8_t, char_traits<char8_t>, allocator<char8_t>>;  
using u16string = basic_string<char16_t, char_traits<char16_t>, allocator<char16_t>>;  
using u32string = basic_string<char32_t, char_traits<char32_t>, allocator<char32_t>>;
```

basic_string과 char_traits이 원본이면서, template의 타입 매개변수만 다르고 전부 basic_string이 메인 클래스로 활용되고 있다. basic_string은 실제로 문자열의 포인터와 size_t 형의 길이, 용량을 담는다. STL의 vector의 메타데이터와 실데이터가 분리되어 있듯이 이것 또한 비슷하다.
char_traits은 기능을 제공해주는 인터페이스와 같은 역할이다. 내부에는 데이터가 없고, find, compare 등 string에서 사용할 수 있는 기능들을 여기에 구현한다.

→ **UTF 호환 :** u8string, u16string, u32string 이 세 개의 string은 OS에 종속되지 않고, 크기를 유지하는 string이다. 

### SSO(Short String Optimization) 최적화 기법

string에서 큰 병목은 '동적 할당'이다. C에서 문자열을 만들려면, 단 몇 문자라도 동적 할당이 필요한데, string은 조금 다르게 동작한다. string은 보통 짧은 문자열(보통 15자 이하)은 힙 할당 대신, string 객체 안에 있는 내부 버퍼에 저장한다. 성능 최적화를 위한 방법으로, 힙 할당으로 인한 오버헤드를 줄여주고, string에서는 이것을 배열로 관리하므로, 캐시 히트율도 높일 수 있다. 
[GCC] : 15자 이하, [MSVC] : 15자 이하, [Clang] : 22자 이하.

