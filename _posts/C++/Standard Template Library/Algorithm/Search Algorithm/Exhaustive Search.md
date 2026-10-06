**※ 재귀 함수**
→ 자신의 함수 내부에서 자신의 함수를 호출하는 방식의 함수를 재귀 함수라고 부른다. 경우의 수를 찾기 위해서 사용하고, 탈출 조건이 필수적으로 있어야 한다. 
→ 재귀 함수가 많이 호출되면, 스택 오버플로우가 발생 할 수 있으니 주의해서 쓰고, for./while 반복문을 우선순위로 생각하는 것이 좋다. 

**※ 선형/비선형적 구조
- **선형적 구조 :** 순열/조합, 비트 마스크가 해당되고, 1차원적으로(배열로) 데이터가 나열된 형태
- **비선형적 구조 :** BFS/DFS, 백 트래킹이 해당된다. 보통 트리 구조로 표현이 가능. (백 트래킹은 비선형적 구조에만 적용 가능하다.)

---
## Brute Force
→ **개념 :** 모든 경우의 수를 탐색하는 알고리즘, 주로 for/while 반복문으로 모든 원소를 순회하면서 값을 도출한다.

→ 모든 원소를 예외 처리 없이 순회한다는 점에서 시간 복잡도 효율이 좋지는 않지만, 정답을 100% 보장하므로, 실제 사용보다는 검증/확인이 주가 되고, 데이터가 작은 경우에만 사용된다. 또한, 구현이 쉬워 직관적이고 버그 확인/디버깅이 수월하다.

→ **연관 기법 :** 단순 반복문, BFS/DFS, 순열, 비트마스크 등 (Back Tracking 제외) 전부 경우의 수를 전부 확인하는 탐색법이라고 볼 수 있다. Back Tracking 혹은 부가적인 예외 처리를 추가하여, 연산을 빠르게 끝내는 최적화를 할 수 있다.

Q. [BOJ : 2798 : 블랙잭] 카드의 개수 N, 임의의 정수 M이 주워질 때, 3장을 뽑아 M 미만이면서 M과 근접한 합을 도출하라.
``` cpp
int Solution(std::vector<int> Cards, int N, int M) {
	int Result = 0;
	for (int i = 0; i < N; ++i) {
		for (int j = i + 1; j < N; ++j) {
			for (int k = j + 1; k < N; ++k) {
				int Sum = Cards[i] + Cards[j] + Cards[k];
				if (Sum < M) Result = std::max(Result, Sum);
			}
		}
	}
	
	return Result;
}
```

## Back Tracking
→ **개념 :** '**가지치기(Pruning)**'라고 불리는데, 모든 경우의 수를 탐색하면서, 현재 경우의 수를 탐색하는 과정에서 **유망성(Promising)** 이 없다고 판단되는 경우에는, 진행을 중단하고, 이전 경로로 **되돌아가(BackTracking)** 다른 경우의 수를 탐색한다. 탐색의 범위를 축소 시켜, 유망성이 없는 경우의 수를 제외시키는 최적화 방법. 주로 '**재귀함수**' 통해서 구현.

→ Brute-Force의 전체 원소에 대한 탐색으로 인한 비효율성을 줄여주고, 필요한 경우의 수만 탐색하고 결과를 도출할 수 있어 최적화에 유용하다. 비선형적 구조의 완전 탐색 (BFS/DFS)에만 적용할 수 있다.

Q. 정수 N과 M이 주어졌을 때, 1부터 N까지의 자연수들 중, 길이가 M인 수열을 모두 구하는 프로그램을 작성. (중복 불가.)(1 <= N, M <= 8)
``` cpp
int N, M; int Result[9];
bool Visited[9];

void DFS(int Depth) {
	if (Depth == M) { 
		for (int i = 0; i < M; ++i) { 
			std::cout << Result[i] << " "; 
		} 
		std::cout << "\n"; return; 
	}
	
	for (int i = 1; i <= N; ++i) { 
		if (!Visited[i]) { 
			Result[Depth] = i; 
			
			Visited[i] = true;
			DFS(Depth + 1); // 재귀
			Visited[i] = false;
		} 
	} 
}

int main() { 
	std::cin >> N >> M; 
	DFS(0); 
	return 0; 
}
```

## 순열/조합

→ **공통 :**  서로 다른 N개의 수들 중에서 M개의 수를 뽑아서 나열할 수 있는 모든 경우의 수.

→ **순열 :** 순서에 따라 다른 경우의 수로 본다. ( {1, 2}, {2, 1} ~ 2가지의 경우의 수.) [ 공식 : N! / (N - M)! ]
→ **조합 :** 순서가 바뀌어도 같은 경우의 수로 본다. ( {1, 2}, {2, 1} ~ 1가지의 경우의 수.) [ 공식 : N! / (M! * (N - M)!) ]

→ 예시 : { 1, 2, 3, 4 }에서 2개를 뽑아서 만들 수 있는 순열/조합 의 경우의 수.
- **순열** : { 1, 2 }, { 1, 3 }, { 1, 4 }, { 2, 1 }, { 2, 3 }, { 2, 4 }, { 3, 1 }, { 3, 2 }, { 3, 4 }, { 4, 1 }, { 4, 2 }, { 4, 3 } : 총 12가지 경우의 수.
- **조합** : { 1, 2 }, { 1, 3 }, { 1, 4 }, { 2, 3 }, { 2, 4 }, { 3, 4 } : 총 6가지 경우의 수

→ 백트래킹에서 다뤘던 DFS방식으로도 순열을 표현할 수 있다. 조합도 재귀를 통해 표현이 가능한데, 순열의 Visit 방식이 아닌, 이전에 뽑은 원소보다 더 큰 원소를 뽑는 방식을 반복하는 개념이다. 즉, 오름차순으로 정렬이 되고, 중복이 발생할 일도 없어진다.

> [!note]- C++ 순열 : next_permutation
> C++에서는 순열을 만들어주는 함수 `std::next_permutation` 함수가 존재한다. 주어진 순열을 다음 순열로 바꾸고, true를 반환하는데, 해당 컨테이너에 더 이상 다음으로 만들 순열이 없다면 false를 반환한다. do_while 문이 끝나면 다시 이전 Input(sort가 끝난 후)으로 되돌아 온다.
> `std::next_permutation`를 적절하게 사용하려면, 먼저 '오름차순 정렬'의 조건이 붙는다. 만약 정렬 하지 않은 상태로 진행하게 되면, 출력할 때, 모든 경우의 수가 아닌 일부만 출력 시킨다.
> ``` cpp
>void Print_Permutation(std::vector<int> Input) {
>	std::sort(Input.begin(), Input.end());
>	do {
>		for (const auto& Output : Input) std::cout << Output << " ";
>		std::cout << "\n";
>	}while (std::next_permutation(Input.begin(), Input.end()));
>}
>```


**※ 백 트래킹 '조합' 예시**
``` cpp
void DFS_Combination(int N, int M, vector& Result, int Depth, int Start) { 
	if (Depth == M) { 
		Answers.push_back(Result); 
		return;
	} 
	
	for (int i = Start; i <= N; ++i) { 
		Result[Depth] = i;
		DFS_Combination(N, M, Result, Depth + 1, i + 1);
	} 
}
```
### 비트마스크
→ **개념 :** 모든 경우의 수를 비트(bit)로 표현하는 방식. 컴퓨터에서 비트는 0 또는 1로 표현이 가능한데, 비트 여러 개를 통해서 모든 경우의 수를 표현할 수 있다. 

→ 보통 선택(1), 미선택(0) 으로 표현해서 2 가지 경우의 수로 나눌 수 있고, 모든 경우의 수를 대입하여 검사하는 Brute-Force 방식의 일종이다. 다만  Brute-Force의 연산 속도 문제(비효율성)를  '**비트연산**'을 사용하여 극대화 시키는 장점을 가진다.
``` cpp
for (int state = 0; state < (1 << n); ++state) { 
	int sum = 0; std::cout << "선택된 원소: "; 
	for (int i = 0; i < n; ++i) { // state의 i번째 비트가 켜져 있는지 확인 
		if (state & (1 << i)) { 
			std::cout << arr[i] << " "; 
			sum += arr[i];
		} 
	} 
	std::cout << "=> 합: " << sum << "\n"; 
}
```

<table>
  <thead>
    <tr>
      <th>비트 연산자</th>
      <th></th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td><strong>&</strong></td>
      <td>비트 비교 연산자[AND] : 두 비트가 모두 1이면 1, 그 외는 0</td>
    </tr>

    <tr>
      <td><strong>|</strong></td>
      <td>비트 비교 연산자[OR] : 두 비트 중 하나라도 1이면 1, 전부 0이라면 0</td>
    </tr>

    <tr>
      <td><strong>^</strong></td>
      <td>비트 비교 연산자[XOR] : 두 비트가 다르면 1, 같다면 0</td>
    </tr>

    <tr>
      <td><strong>~</strong></td>
      <td>비트 변환 : 모든 비트를 반전 시킨다. ex. 1011 > 0100 </td>
    </tr>

	<tr>
      <td><strong><<</strong></td>
      <td>비트 변환 : 비트를 왼쪽으로 이동. ex. 1 << 2 = 0100 </td>
    </tr>
    
	<tr>
      <td><strong>>></strong></td>
      <td>비트 변환 : 비트를 오른쪽으로 이동. ex. 1010 >> 2 = 0010</td>
    </tr>
    
  </tbody>
</table>
---
## BFS(Breadth-First-Search)

→ **개념 :** 트리/그래프를 탐색하는 방법 중 하나로, 한 노드를 시작으로 모든 노드를 탐색(방문)하는 탐색하는데, 이는 루트 노드를 시작으로, 현재에서 가장 가까운 노드부터 먼저 탐색하는 방식이다. '**너비 우선 탐색**'이라고 부른다.

→ 백트래킹 가능, 최단 길이 경로 보장 가능. 루트 노드부터 목표 노드와 만날 때까지, 탐색을 진행한다. 반면에, 해가 나오지 않으면 무한대로 이어질 가능성이 있다.(프로그램 종료가 안됨) 

→ BFS는 Queue 자료구조를 사용하여 구현할 수 있다.

→ **과정 :** 
1. 루트 노드를 스택에 담는다.
2. 큐의 최전방 노드(front() : 제일 처음에 들어온 노드)를 꺼내서(pop), 데이터를 출력하고, 자식의 노드들을 큐에 넣는다. ( for (int i = 0; i < Size; ++i) )
3. 2번 과정을 계속 반복하고, 남아있는 노드가 없다면 모든 순회를 마친 것으로 탐색을 종료한다.

> [!note]- BFS - Queue
> Queue로 만든 BFS
> 
> ``` cpp
> struct Node {  
 >   int Data;  
 >   std::vector<Node*> NodeList;
>
>    Node(int Value) : Data(Value) {}  
   };
>
>void BFS(Node* Root) {  
>    if (nullptr == Root) return;  
>    std::queue<Node*> DataQueue;  
>    DataQueue.push(Root);  
>    
>    while (!DataQueue.empty()) {  
>        Node* CurrentFront = DataQueue.front();  
>        DataQueue.pop();  
>        
>        std::cout << CurrentFront->Data << " ";  
>        
>        int Size = static_cast<int>(CurrentFront->NodeList.size());  
>        for (int i = 0; i < Size; ++i) {  
>            DataQueue.push(CurrentFront->NodeList[i]);  
>        }  
>   }  
>}
>
>Node* MakeTree()  
>{  
>    Node* Root = new Node(10);  
>    Node* Node1 = new Node(20);  
>    Node* Node2 = new Node(30);  
>    
>    Root->NodeList.push_back(Node1);  
>    Root->NodeList.push_back(Node2);  
>    
>    Node1->NodeList.push_back(new Node(40));  
>    Node1->NodeList.push_back(new Node(50));  
>    Node2->NodeList.push_back(new Node(60));  
>    
>    return Root;  
>}
> ```
## DFS (Depth-First-Search)

→ **개념 :** 트리/그래프를 탐색하는 방법 중 하나로, 한 노드를 시작으로 모든 노드를 탐색(방문)하는 탐색하는데, 이는 루트 노드를 시작으로, **깊은 부분을 먼저** 탐색하는 방식이다. '**깊이 우선 탐색**'이라고 부른다.

→ 비선형 자료구조로, 백트래킹이 적용이 가능한데 제일 깊은 곳(Leaf Node)까지 갔다가 이전 노드로 돌아오면서 경우의 수를 탐색한다. 

→ 구현 방법이 2가지가 있는데, 첫 번째는 Stack, 두 번째는 재귀 함수로 풀이가 가능하다. 

→ **과정 :**
1. 루트 노드를 스택에 담는다.
2. 스택의 최상단 노드(top() : 제일 마지막에 들어온 노드)를 꺼내서(pop), 데이터를 출력하고, 자식의 노드들을 오른쪽에서 왼쪽 순으로 스택에 넣는다. ( for (int i = Size - 1; i >= 0; --i) { ... })(왼쪽부터 탐색하기 위함.)
3. 2번 과정을 계속 반복하고, 남아있는 노드가 없다면 모든 순회를 마친 것으로 탐색을 종료한다.

> [!note]- DFS - Stack
> Stack으로 만든 DFS
> 
> ``` cpp
> struct Node {  
 >   int Data;  
 >   std::vector<Node*> NodeList;
>
>    Node(int Value) : Data(Value) {}  
   };
>
>void DFS_Stack(Node* Root) {  
>    if (nullptr == Root) return;  
>    std::stack<Node*> DataStack;  
>    DataStack.push(Root);
>      
>    while (!DataStack.empty()) {  
>        Node* CurrentTop = DataStack.top();  
>        DataStack.pop();  
>        std::cout << CurrentTop->Data << " ";  
>        int Size = static_cast<int>(CurrentTop->NodeList.size());
>        for (int i = Size - 1; i >= 0; --i) {   // 역순 주의(왼쪽부터 탐색하려면)  
>            DataStack.push(CurrentTop->NodeList[i]);  
>        }  
>    }  
>}
>
>Node* MakeTree()  
>{  
>    Node* Root = new Node(10);  
>    Node* Node1 = new Node(20);  
>    Node* Node2 = new Node(30);  
>    
>    Root->NodeList.push_back(Node1);  
>    Root->NodeList.push_back(Node2);  
>    
>    Node1->NodeList.push_back(new Node(40));  
>    Node1->NodeList.push_back(new Node(50));  
>    Node2->NodeList.push_back(new Node(60));  
>    
>    return Root;  
>}
> ```

> [!note]- DFS - Recursive
> 재귀 함수로 만든 DFS
> 
> ``` cpp
> struct Node {  
 >   int Data;  
 >   std::vector<Node*> NodeList;
>
>    Node(int Value) : Data(Value) {}  
   };
>
>void DFS_Recursive(Node* Root) {  
>    if (nullptr == Root) return;  
>    std::cout << Root->Data << " ";  
>    int Size = static_cast<int>(Root->NodeList.size());  
>    for (int i = 0; i < Size; ++i)  {  
>        DFS_Recursive(Root->NodeList[i]);  
>    }  
>}
> ```

++투 포인터 / 슬라이딩 윈도우 / N-Queen 문제 / 미로 탈출