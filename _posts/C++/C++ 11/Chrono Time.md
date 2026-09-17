C++11에 추가된 시간 측정 라이브러리, \<chrono>를 알아보겠다. 

과거에 게임에서 DeltaTime을 측정하려면 \<windows.h>를 #include 하여 `GetTickCount(), GetTickCount64()`를 호출하여 시간을 측정했었다. 하지만, `GetTickCount()`의 대망의 49.7일 문제와, 정밀도면에서 부족한 점이 많아, 게임 개발에 사용하기엔 부적합했었다. 

그 이후에 `QueryPerformanceCounter`가 제공되면서 보다 정확한 시간 측정이 가능했고, **다중 프로세서 시스템, 다중 코어 시스템**에서도 안정적인 퍼포먼스를 보여준다. 게임 개발에는 충분한 시간 측정 모듈이지만, "**운영체제에 종속적인 문제**"를 갖고 있었다. 즉, Windows운영체제 외에는 사용이 불가한 모듈이기에, 각 운영체제에 맞는 시간 함수를 쓰면서 분기를 나눠야 했다.

C++11에서 \<chrono>는 이 문제를 해결하면서, QPC의 인터페이스를 더 개선한 라이브러리이다.

### Function

\<chrono>의 기능은 C++ 버전별로 조금씩 추가되다, 20에서 크게 변했는데, 11기준으로 먼저 소개하고, C++20에 추가된 기능들은 마지막에 설명하겠다.

**Duration :** 시간의 간격을 나타내는 템플릿 클래스로 '시간(hour) 단위' 부터 '나노초(Seconds)'까지 지원한다. std::chrono 의 namespace에서 사용이 가능하고, 예시로 thread를 대기시키는 용도로 사용이 가능한데, 아래와 같다.
``` cpp
  // 사용
	std::chrono::nanoseconds  = std::chrono::duration<long long, std::nano>;
	// 나노세컨드 1초 / 10억
	std::chrono::microseconds = std::chrono::duration<long long, std::micro>;
	// 마이크로 세컨드 1초 / 100만
	std::chrono::milliseconds = std::chrono::duration<long long, std::milli>;
	// 밀리 세컨드 1초 / 1천
	std::chrono::seconds = std::chrono::duration<long long, std::ratio<1, 1>>;
	// 초
	std::chrono::minutes = std::chrono::duration<long long, std::ratio<60, 1>>;
	// 분
	std::chrono::hours = std::chrono::duration<long long, std::ratio<3600, 1>>;
	// 시
	
	// 기본적으로 템플릿 인자 단위가 long long, 2번째 인자는 ratio<1, 1> default
	
	std::chrono::duration<double, std::micro> MicroSec(15.5); // 15.5μs
	// <데이터 타입, 시간 단위> 
	
	std::cout << "us : " << MicroSec.count() << "\n"; // ms : 15.5

	// 사용 예시
	std::this_thread::sleep_for(std::chrono::microseconds(3));
	std::this_thread::sleep_until(std::chrono::steady_clock::now() + std::chrono::seconds(3));
		// 스레드를 3초간 잠재우고, 실행

```
duration을 사용할 때, 형 변환에 주의해야 하는데, 상위 단위에서 하위 단위로(ex. seconds => microseconds) 형 변환 할 경우, 자동으로 가능하지만, 하위 단위에서 상위 단위는 `duration_cast`를 통해서 변환해야 한다.(자동으로 변환 시도할 경우, Compile Erro가 발생한다.) 또한 template 첫번째 인자로 자료형을 정해줬었는데, 다른 자료형으로 바꿀 때, 자동으로 변환된다.
``` cpp
std::chrono::milliseconds ms(2500); 
// std::chrono::seconds sec_val = ms; // Compile Error
auto sec = std::chrono::duration_cast<std::chrono::seconds>(ms);

std::chrono::duration<double> sec_double = ms; // long long > double (자동 형변환)
```

**Clock :** \<chrono>에는 3개의 시계 클래스가 있는데, `system_clock, steady_clock, high_resolution_clock`이 있다.
- `system_clock` : OS 시스템의 시각을 반환 시키는 시계 클래스이다. OS의 날짜/시간 설정을 변경하면, system_clock도 설정에 맞춰 시각을 반환 시킨다. 
- `steady_clock` : 시간이 역행하지 않고, 일정한 증가량으로 흐르는 시계이다. OS의 설정에 영향을 받지 않기에, 시간 측정에 쓰기 좋고 안정적인 시계로 게임 DeltaTime용, 스킬 쿨타임, 성능 측정 등 게임에서는 시간 개념이 중요하기 때문에, 자주 사용되는 시계이다.
- `high_resolution_clock` : 시스템에서 제공하는 '**가장 정밀도 높은 시계**' 이다. 사실 `high_resolution_clock`은 가장 짧은 Tick Period를 나타내는 시계를 구현체가 결정하여typedef 하는데, 대체로 하드웨어 성능을 최대로 사용하는`steady_clock`을 typedef를 한다. 하지만, 이는 또 바뀔 수 있는데, 차후에 생길 더 고성능인 시계를 반영할 떄 typedef할 타겟만 변경하게 만들기 위한 타입인 것이다. 그렇기에, 지금이던 나중에던 '**가장 정밀도 높은 시계**'라고 할 수 있다.

**time_point :** time_point는 '특정 시각'을 나타내는 템플릿 클래스인데, 기본형은 아래와 같다.
``` cpp
template <class Clock, class Duration = typename Clock::duration>
class time_point;
```
time_point는 "기준 시점"이라는 뜻의 epoch라는 용어를 쓴다. Clock의 시작 시간이 epoch가 되는데, Clock마다 epoch가 다르다. `system_clock`은 C++20부터 규정되어 '1970년 1월 1일 (UTC)'를 기준으로 하고, `steady_clock`은 C++ 표준에서 규정하지 않아, 구현체가 결정하기에 시점이 달라질 수 있다. 그렇기에, 두 Clock 간에 직접적인 연산/변환은 epoch가 다르기에 불가하다.
``` cpp
auto Start = std::chrono::steady_clock::now();
auto End   = std::chrono::steady_clock::now();

auto Elapsed = End - Start; // TimePoint
```

**C++20 변경점 :** C++20 이전 까지는 주로 단순히 시간 측정, 게임 DeltaTime용으로 chrono가 쓰여왔는데, 종합적인 날짜/시간 시스템이 되어 활용될 수 있게 되었다.
- **format 출력 :** C++20에서는 'format'이 추가되어 문자 포맷팅을 편하게 할 수 있었다. chrono에서 현재 시간이나 경과 시간을 출력하는 방법이 조금 복잡했는데, 이것이 chrono에도 적용되어 포맷팅을 쉽게 할 수 있게 되었다.
- **LocalTime 지원 :** chrono에서 `zoned_time`이란 타임존 변환도 가능해졌다. `system_clock`의 시점을 특정 지역에 맞춰 변환하여 LocalTime으로 표현이 가능해졌다.
- **표현 확장 :** chrono의 Duration에서 시간(Hour)표현이 최대였는데, Duration에 있는 시간 표현 외에도 chrono에서 '연', '월', '일', '요일'도 추가되어 날짜 표현이 가능해졌고, 직관적인 'Literal 타입'(ex. 2026y, 17d)이 가능해져 chrono를 보다 편하게 사용할 수 있게 되었다.

### 출력

chrono는 자료형을 따로 만들었다 보니 콘솔창 출력이나, string으로 만드는 법이 조금 복잡한데, \<ctime> 헤더까지 포함시켜 출력해야 한다. 하지만, 이는 대부분 C++20에서 해결되었다. 20에서 사용하는 방법도 11 다음 20 순으로 진행하겠다.

※ **C++11 : 현재 날짜 / 시간 출력**
``` cpp
#include <ctime> 

int main() {
	
	auto NowTime = std::chrono::system_clock::now();
	
	std::time_t tTime = std::chrono::system_clock::to_time_t(NowTime);
	std::cout << std::ctime(&tTime);
	
	// 출력 : Thu Sep 17 21:05:32 2026
	
	return 0;
}
```
※ **C++11 : 경과 시간 측정 (성능 측정)**
``` cpp
int main() {
	auto StartTime = std::chrono::steady_clock::now();
	///////////////////////////////
	// 작업
	///////////////////////////////
	auto EndTime = std::chrono::steady_clock::now();
	
	auto TimeGap = std::chrono::duration_cast<std::chrono::milliseconds>(EndTime - StartTime);
	
	std::cout << TimeGap.count() << "ms";
	
	// 출력 : 000000ms
	
	return 0;
}
```
※ **C++11 : string 변환**
``` cpp
#include <ctime>
#include <iomanip>
#include <sstream>
#include <string>

int main()
{
    auto NowTime = std::chrono::system_clock::now();
    std::time_t tTime = std::chrono::system_clock::to_time_t(NowTime);

    std::tm* LocalTime = std::localtime(&tTime);

    std::stringstream Stream;
    Stream << std::put_time(LocalTime, "%Y-%m-%d %H:%M:%S");

    std::string TimeString = Stream.str();

    std::cout << TimeString << '\n';

    return 0;
}
```

※ **C++20 : format 변환 출력**
``` cpp
#include <format>

int main()
{
    auto Now = std::chrono::system_clock::now();
    std::cout << std::format("{:%Y-%m-%d %H:%M:%S}", Now);
    
}
```
※ **C++20 : Local Time
``` cpp
#include <format>

int main()
{
	{   // 유형 1
		auto Now = std::chrono::system_clock::now();
	    auto LocalTime = std::chrono::current_zone()->to_local(Now);
	    // 시스템의 TimeZone을 가져와서 time_point를 KST로 변환
		std::cout << std::format("{:%Y-%m-%d %H:%M:%S}", LocalTime);
	}
	
	{   // 유형 2
		auto Now = std::chrono::system_clock::now();
		std::chrono::zoned_time LocalTime { std::chrono::current_zone(), Now };
		std::cout << std::format("{:%Y-%m-%d %H:%M:%S}", LocalTime);
	}
	
	return 0;
}
```
※ **C++20 : 표현 확장**
``` cpp
int main()
{
    using namespace std::chrono;

    year Y = 2026y;      // Literal 타입으로 숫자 + y : 연도 / + d : 일 ...
    month M = September;
    day D = 17d;

    std::cout << int(Y) << '\n';
    std::cout << unsigned(M) << '\n';
    std::cout << unsigned(D) << '\n';
}
```
