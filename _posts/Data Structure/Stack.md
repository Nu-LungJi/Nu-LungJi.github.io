**"Stack"** 은 한 쪽 끝에서만 데이터를 넣고 뺄 수 있는 후입선출(LIFO - Last In First Out)의 선형 자료구조 입니다.

주로 '프링글스'를 예를 들어 설명하는데, 프링글스는 밑을 억지로 뜯지 않는 이상, 맨 위에 있는 감자칩만 꺼내서 먹을 수 있다. 즉, Stack은 맨 위(Top)에 있는 데이터에만 접근이 가능하고, 그 외에는 Top에서 계속 꺼낸 후에 접근이 가능하다는 특징을 가지고 있다. 

### STL Stack

``` cpp

#include <stack>

int main() {

	stack<Chip> Pringles;

}
```

C++ STL에서는 include만 해주면 stack\<T\> 자료형으로 사용이 가능하다.
cppreference에서 Stack의 메서드는 Member functions으로 다음과 같이 소개한다.

<table style="width: 100%; border-collapse: collapse;">
	<tr style="height: 50px; border-bottom: 1px solid #ddd; vertical-align: middle;"> 
		<td style="width: 200px; padding: 0 0 0 15px; line-height: 1.2; vertical-align: middle;"> top()</td> 
		<td style="padding: 0 0 0 20px; line-height: 1.2; vertical-align: middle;"> <font color="#595959">[원소 접근] </font>최 상단 원소 접근 </td>
		<td style="width: 100px; line-height: 1.2; vertical-align: middle; text-align: center;"> T </td> 
	</tr> 
</table>
<table style="width: 100%; border-collapse: collapse;">

	<tr style="height: 50px; border-bottom: 1px solid #ddd; vertical-align: middle;"> 

		<td style="width: 200px; padding: 0 0 0 15px; line-height: 1.2; vertical-align: middle;"> empty()</td> 

		<td style="padding: 0 0 0 20px; line-height: 1.2; vertical-align: middle;"> <font color="#595959">[용량 확인] </font>Stack이 비어있는지 확인 </td>

		<td style="width: 100px; line-height: 1.2; vertical-align: middle; text-align: center;">Boolean </td> 

	</tr> 

</table>
<table style="width: 100%; border-collapse: collapse;">

	<tr style="height: 50px; border-bottom: 1px solid #ddd; vertical-align: middle;"> 

		<td style="width: 200px; padding: 0 0 0 15px; line-height: 1.2; vertical-align: middle;"> size()</td> 

		<td style="padding: 0 0 0 20px; line-height: 1.2; vertical-align: middle;"> <font color="#595959">[용량 확인] </font>원소 갯수 확인 </td>

		<td style="width: 100px; line-height: 1.2; vertical-align: middle; text-align: center;"> size_type </td> 

	</tr> 

</table>
<table style="width: 100%; border-collapse: collapse;">

	<tr style="height: 50px; border-bottom: 1px solid #ddd; vertical-align: middle;"> 

		<td style="width: 200px; padding: 0 0 0 15px; line-height: 1.2; vertical-align: middle;"> push(T)</td> 

		<td style="padding: 0 0 0 20px; line-height: 1.2; vertical-align: middle;"> <font color="#595959">[수정자] </font>최 상단에 원소 삽입</td>

		<td style="width: 100px; line-height: 1.2; vertical-align: middle; text-align: center;">X </td> 

	</tr> 

</table>
<table style="width: 100%; border-collapse: collapse;">

	<tr style="height: 50px; border-bottom: 1px solid #ddd; vertical-align: middle;"> 

		<td style="width: 200px; padding: 0 0 0 15px; line-height: 1.2; vertical-align: middle;"> emplace(T)</td> 

		<td style="padding: 0 0 0 20px; line-height: 1.2; vertical-align: middle;"> <font color="#595959">[수정자] </font>객체 생성 후, 최 상단에 원소 삽입</td>

		<td style="width: 100px; line-height: 1.2; vertical-align: middle; text-align: center;">X </td> 

	</tr> 

</table>
<table style="width: 100%; border-collapse: collapse;">

	<tr style="height: 50px; border-bottom: 1px solid #ddd; vertical-align: middle;"> 

		<td style="width: 200px; padding: 0 0 0 15px; line-height: 1.2; vertical-align: middle;"> pop()</td> 

		<td style="padding: 0 0 0 20px; line-height: 1.2; vertical-align: middle;"> <font color="#595959">[수정자] </font>최 상단 원소 제거</td>

		<td style="width: 100px; line-height: 1.2; vertical-align: middle; text-align: center;">X </td> 

	</tr> 

</table>
<table style="width: 100%; border-collapse: collapse;">

	<tr style="height: 50px; border-bottom: 1px solid #ddd; vertical-align: middle;"> 

		<td style="width: 200px; padding: 0 0 0 15px; line-height: 1.2; vertical-align: middle;">swap(std::stack<T>)</td> 

		<td style="padding: 0 0 0 20px; line-height: 1.2; vertical-align: middle;"> <font color="#595959">[수정자] </font>다른 Stack과 데이터 전체 교환</td>

		<td style="width: 100px; line-height: 1.2; vertical-align: middle; text-align: center;"> X </td> 

	</tr> 

</table>

NonMember Functions(operator)으로는 '\==', '!=', '<', '<=', '>', '>=' 을 지원하고, 기본 std에서 제공하는 swap으로 std::swap(std::stack, std::stack)도 가능하다.

### Stack = Deque
CPPReference에서 상단에는 이렇게 선언이 되어 있다.

``` cpp
template<class T, class Container = std::deque<T>> 
class stack;
```

두 번째 Parameter로 class Container = std::deque<\T>가 있는데, STL Stack은 기본적으로 deque기반의 Container Adapter이다. 즉, 메모리 저장 방식은 deque를 기반으로 하되, Stack이라는 interface를 사용한다고 보면 된다. 이 Container에는 Sequence Container가 올 수 있는데, 우리가 조건만 만족한다면 상황에 따라서 바꿀 수도 있다. 조건은 Sequence Container에서 `back() { = top() }`, `push_back() { = push(T) }`, `pop_back() { = pop() }` 이 3개의 함수를 사용할 수 있어야 한다. 즉, `vector<T>`, `deque<T>`, `list<T>`가 들어갈 수 있다. 사용법은 이와 같다.

``` cpp
int main() { 
	std::list<int> BC_List = { 100, 200, 300 }; 
	std::stack<int, std::list<int>> IC_ListStack(BC_List); 
	// 100 > 200 > 300(top) 순으로 저장
	
	std::vector<int> BC_Vector = { 10, 20, 30 }; 
	std::stack<int, std::vector<int>> IC_VectorStack(BC_Vector); 
	// 10 > 20 > 30(top) 순으로 저장
		
	std::deque<int> BC_Deque = { 1, 2, 3 }; // Stack의 기본 Sequence Container
	std::stack<int, std::deque<int>> IC_DequeStack(BC_Deque);
	// 1 > 2 > 3(top) 순으로 저장
}
```

하지만 사실 이렇게 Sequence Container의 interface를 바꾸는 일은 LIFO규칙을 부여하고 싶을 때? 또는 인터페이스의 정리?단순화? 외에는 딱히 할 만한 이유를 못 찾았다. 그래서 본인은 Sequence Container 그대로 사용하는게 더 빠르고, 간단하다 생각한다.

### 실제 구현

---
**동적 배열 기반 Stack**
``` cpp
#define MAX_STACK_SIZE 100  

template <typename T>  
class DynamicStack {  
public:  
    DynamicStack();  
    DynamicStack(uint32_t size);  
    
public:  
    void push(T element);  
    void pop();  
    
    T top() const;  
        
    bool IsEmpty() const;  
    size_t size() const;  
    size_t capacity() const;  
    
private:  
    std::vector<T> StackArray;
};  
  
template <typename T>  
DynamicStack<T>::DynamicStack()  {  
    StackArray.reserve(MAX_STACK_SIZE);  
}  
  
template <typename T>  
DynamicStack<T>::DynamicStack(uint32_t size)  {  
    StackArray.reserve(size);  
}  
  
template <typename T>  
void DynamicStack<T>::push(T element)  {  
    StackArray.push_back(element);  
}  
  
template <typename T>  
void DynamicStack<T>::pop()  {  
    if (!StackArray.empty())  
        StackArray.pop_back();  
}  
  
template <typename T>  
bool DynamicStack<T>::IsEmpty() const  {  
    return StackArray.empty();  
}  
  
template <typename T>  
T DynamicStack<T>::top() const  {  
    return StackArray.empty() ? T{} : StackArray.back();  
}  
  
template <typename T>  
size_t DynamicStack<T>::size() const  {  
    return StackArray.size();  
}  
  
template <typename T>  
size_t DynamicStack<T>::capacity() const {  
    return StackArray.capacity();  
}
```


Ref. https://en.cppreference.com/cpp/container/stack
