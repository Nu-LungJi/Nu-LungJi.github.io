**"Stack"** 은 한 쪽 끝에서만 데이터를 넣고 뺄 수 있는 후입선출(LIFO - Last In First Out)의 선형 자료구조 입니다.

주로 '프링글스'를 예를 들어 설명하는데, 프링글스는 밑을 억지로 뜯지 않는 이상, 맨 위에 있는 감자칩만 꺼내서 먹을 수 있습니다. 즉, Stack은 맨 위(Top)에 있는 데이터에만 접근이 가능하고, 그 외에는 Top에서 계속 꺼낸 후에 접근이 가능하다는 특징을 가지고 있습니다. 

### Function
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
		<td style="width: 200px; padding: 0 0 0 15px; line-height: 1.2; vertical-align: middle;">swap( std::stack<T>)</td> 
		<td style="padding: 0 0 0 20px; line-height: 1.2; vertical-align: middle;"> <font color="#595959">[수정자] </font>다른 Stack과 데이터 전체 교환</td>
		<td style="width: 100px; line-height: 1.2; vertical-align: middle; text-align: center;"> X </td> 
	</tr> 
</table>
### STL Stack

``` cpp
#include <stack>

int main() {
	stack<Chip> Pringles;
}
```
C++ STL에서는 include만 해주면