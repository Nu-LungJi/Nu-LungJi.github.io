# Tree

**※ 선형 자료구조**
→ 배열/스택/큐 같이 데이터가 연속적으로 나열되어 저장되어 있고, 자료를 저장하고 접근하는데 특화되어진 자료구조로 구분한 것이다.
→ STL : Array, Vector, List, Stack, Queue

**※ 비선형 자료구조**
→ 그래프/트리 같이 데이터들이 관계를 맺고 연결되어 있는 구조를 형성한다. 계층적인 연결 구조를 표현하는데에 적합한데, 대표적으로 트리의 경우에서 <부모>→<자식>의 관계 개념을 주로 '**노드**'로 표현한다. 
→ STL : Set, Map, MultiMap, MultiSet

→ 데이터의 집합들을 '**노드**'와 '**간선**'을 통해, 부모-자식 관계로 구성한 '**비선형 자료구조**'이다. 트리는 그래프의 일종으로, 그래프는 노드끼리 관계를 가지는데, 트리에서는 A에서 B로 향하는 '**방향성(DAG - Directed Async Graphs)**'이 존재하는 관계여야 한다. 그리고 트리는 사이클(Cycle)-순환이 없는 그래프로, 시작하는 노드(루트 노드)가 있으면 반드시 끝나는 노드(리프 노드)가 있어야 한다.

→ **트리의 구성 :** 
![](Pasted%20image%2020260930200955.png)

- **루트 노드 :** 부모가 없는 유일한 노드로, 트리의 '**시작**'이 되는 노드이다.
- **부모/자식 노드 :** 정점(노드) A에서 B까지 연결이 될 때, A를 '부모 노드', B를 '자식 노드'라고 한다. 부모에서 자식으로 향하는 방향성의 관계를 가진다.
- **차수 :** 부모가 하위에 두고 있는 자식 노드의 수.
- **리프 노드 :** 제일 마지막의 노드, 자식을 가지지 않고 트리의 '**끝**'이 되는 노드이다.
- **높이/레벨 :** 레벨은 루트를 시작으로 해당 노드까지의 깊이를 말한다. E노드까지의 레벨은 루트에서 두 번 이동해야 하므로 레벨이 2이다. 높이는 루트에서 제일 깊은 리프 노드까지(최대 거리), 트리 전체의 레벨을 말한다. 사진 같은 경우는 루트에서 리프까지 3번을 거쳐 내려가므로, 높이가 3.
- **경로(간선) :** 노드끼리 연결해주는 선

### Binary Tree(이진 트리)
![](Pasted%20image%2020260930205103.png)
→ 각 노드가 최대 2개의 자식 노드를 가지는 트리를 "**이진 트리**"라고 부른다. 자식 노드가 없거나 1개or2개까지 가능하지만, 3개 이상을 가지는 노드가 존재할 때, 해당 트리는 더 이상 이진 트리가 아니게 된다.
- **정 이진 트리 :** 트리의 모든 노드들은 하위 노드가 0개 or 2개이다.
- **포화 이진 트리 :** 모든 리프 노드의 레벨이 같고, 리프 노드가 아닌 노드들은 전부 2개의 하위 노드를 갖는다. 
- **완전 이진 트리 :** 모든 리프 노드의 레벨에서 최소/최대의 차이가 최대 1 이면서, 하위 노드를 오른쪽(←)부터 채우는 방식의 트리. 즉, 왼쪽 노드가 있다면 반드시 오른쪽 노드가 있어야, 완전 이진 트리라고 할 수 있다.
- **균형 이진 트리 :** 노드들이 한 쪽으로 치우치지 않고, 리프 노드들의 최소 레벨과 최대 레벨을 최소화 시켜주도록 노드들이 회전하는 트리
### Binary Search Tree(이진 탐색 트리)

→ 보통 트리는 데이터가 순서나 정렬 없이 무작위로 삽입되어 연결된 경우가 많은데, '**이진 탐색 트리**'는 "**오른쪽 하위 노드가 부모보다 작고, 왼쪽 하위 노드가 부모보다 큰 관계**"를 이룬다. 루트 노드부터, 서브 트리까지 이 조건을 만족해야, '이진 탐색 트리' 라고 할 수 있다.

→ 데이터를 검색하고자 할 때, BST가 활용이 되는데, 쉽게 Up/Down 게임처럼 찾으려는 Value가 Target노드보다 큰 경우, Target노드의 오른쪽의 서브 트리들은 전부 제외된다. 정확한 값을 찾게되면, 검색을 멈추고, 만약 값을 찾지 못하면, 결과값이 없게 된다. (C++에서는 NULL) 

→ **시간 복잡도 :** 삽입/삭제/탐색의 경우, 트리가 이상적으로 구성되어진 최선의 경우는 O(logN), 데이터 집합의 최댓값이 루트 노드일 경우(한 쪽으로 치우친 상태), O(N) 시간 복잡도를 가진다.

→ **중복 키 처리 :** 이는 개발자의 판단에 맡기는데, 중복을 허용할 경우, 트리에 독립적인 노드를 만들어서 추가할 것인지, 노드 내부에 Counter를 만들어서 Counter만 증가 시켜 갯수만 확인할 것인지는 개발자의 판단에 맡긴다. 만약 전자로 간다면, 중복 노드를 왼쪽에 둘 것인지, 오른쪽에 둘것인지 선택해야 한다.
### Tree Traversal

※ 간선을 따르면서 순회하는 것이 아니므로, 순회할 때 간선은 다 지우고 노드의 현재 위치에만 집중해서 순회하는 것이 생각하기 편함.

![438](Pasted%20image%2020260930223932.png)
### 중위 순회
{ L -> ROOT -> R } 1 → A → 2 → B → 3 → C → 4 → D → 5 → E → 6 → F → 7 → G → 8
> [!note]- In - Order Traversal
> 중위 순회 구현
> ``` cpp
>template<typename T>  
>void InOrder_Traversal(Node<T>* _Node) {  
>    if (_Node == nullptr) return;
>    InOrder_Traversal<T>(_Node->LeftNode);  
>    std::cout << _Node->Data << " → ";  
>    InOrder_Traversal<T>(_Node->RightNode);  
>}
> ```
### 전위 순회
{ ROOT -> L -> R } C → B → A → 1 → 2 → 3 → E → D → 4 → 5 → F → 6 → G → 7 → 8
> [!note]- Pre - Order Traversal
> 전위 순회 구현
> ``` cpp
>template<typename T>  
>void PreOrder_Traversal(Node<T>* _Node) {  
>    if (_Node == nullptr) return;
>    std::cout << _Node->Data << " → ";  
>    PreOrder_Traversal<T>(_Node->LeftNode);  
>    PreOrder_Traversal<T>(_Node->RightNode);
>}
> ```
### 후위 순회
{ L -> R -> ROOT } 1 → 2 → A → 3 → B → 4 → 5 → D → 6 → 7 → 8 → G → F → E → C
> [!note]- Post - Order Traversal
> 후위 순회 구현
> ``` cpp
>template<typename T>  
>void PostOrder_Traversal(Node<T>* _Node) {  
>    if (_Node == nullptr) return;
>    PostOrder_Traversal<T>(_Node->LeftNode);  
>    PostOrder_Traversal<T>(_Node->RightNode);  
>    std::cout << _Node->Data << " → ";
>}
> ```
### 레벨 순서 순회
{ 레벨 순으로 왼쪽부터 방문 } C → B → E → A → 3 → D → F → 1 → 2 → ...
> [!note]- Level - Order Traversal
> 레벨 순회 구현
> ``` cpp
>template<typename T>  
>void LevelOrder_Traversal(Node<T>* _Node) {  
>    if (_Node == nullptr) return ;  
>    
>    std::queue<Node<T>*> NodeQueue;  
>    NodeQueue.push(_Node);  
>    
>    while (!NodeQueue.empty()) {  
>        auto Node = NodeQueue.front();  
>        std::cout << Node->Data << " > ";  
>        NodeQueue.pop();  
>        if (Node->LeftNode) NodeQueue.push(Node->LeftNode);  
>        if (Node->RightNode) NodeQueue.push(Node->RightNode);  
>    }  
>}
> ```

### Tree 구현

