---
title: C++ STL [List & Forward_List]
excerpt:
date: 2026-09-22 17:10:00 +0900
last_modified_at: 2026-09-22
categories:
  - STL
tags:
  - "#STL"
  - "#List"
  - "#Forward_List"
toc: true
toc_sticky: true
published: true
---

### List
→ **정의 :** '이중 연결 리스트' 자료구조를 기반으로 한 Node 시퀀스 컨테이너로, 원소를 노드 단위로 저장한다. 하나의 노드가 다음 노드, 이전 노드를 가리키는 포인터 변수를 가지고 있다.

→ **특성 :** 크기 제한 없이 데이터를 저장할 수 있고, 데이터가 연속적이지 않아, 위치만 알고 있으면, 추가/삽입/삭제가 **O(1)** 시간 복잡도로 빠르게 수행이 가능하다.

![Double Linked List](../../../../assets/images/posts/C++/Double-Linked-List.png)

→ **동작 :** 노드 전체를 관리하는 리스트 클래스와, 노드 자체가 정의되어 있다. 노드 전체를 관리하는 컨테이너는 [첫 노드의 포인터], [마지막 노드의 포인터]와 원소의 총 갯수를 나타내는`size_t`자료형의 size변수가 정의되어 있다. 노드 자체는 [데이터], [다음 노드 포인터], [이전 노드 포인터] 이렇게 3개의 멤버 변수를 가지고 있다. 이 노드와 list 클래스를 사용해서 각 함수를 동작시킨다.
``` cpp
template <typename T> 
struct Node { 
	T data; // 실제 데이터
	Node* prev; // 이전 노드 포인터
	Node* next; // 다음 노드 포인터 
};

template <typename T> 
class list { 
private: 
	Node<T>* head; // 첫 노드의 포인터 
	Node<T>* tail; // 마지막 노드의 포인터 
	size_t size_;  // 전체 요소 개수 
	
public:
	// Method
};
```

→ **강점 :** 
- **삽입(추가)/삭제가 빠르다** - 중간 삽입/삭제여도 위치만 알고 있다면, 양 옆 노드의 포인터만 변경해주고, 삽입되는 노드의 포인터도 양 옆을 지정해주면 된다. 항상 같은 로직으로 수행되로, O(1) 시간 복잡도로 수행된다.
- **재할당이 없음** - 리스트는 필요한 메모리 노드 1개만 받아오고, 반환하면 되므로 재할당을 할 필요가 없다. 그렇기에 이에 대한 오버헤드에 고민할 필요가 없다.

→ **단점 :**
- **낮은 캐시 히트율** - 보통 캐싱을 위해 데이터를 가져올 때, 연속적인 메모리의 Cache Line을 가져오게 되는데, 데이터가 불연속적으로 저장됨으로 인해 '캐시 히트'의 혜택을 보기 힘들다.
- **노드의 메모리 오버헤드** - 데이터 하나를 저장하는데, 데이터 뿐만 아니라 두 개의 포인터까지 같이 저장하게 된다. 노드 하나당 16Byte + DataSize 이므로, 대량의 메모리 저장에는 비효율적이게 된다.
- **느린 접근** - 변수에 저장해두지 않는 이상, list의 처음부터 끝까지 순회를 하면서 데이터를 찾아야 한다. 데이터가 늘어날 수록 순회가 더 길어지므로, O(N) 시간 복잡도를 가진다. 

### Forward_List

→ **개요 :** C++11에서 새롭게 `forward_list`가 추가되었다. '단방향 리스트'를 기반으로 한 리스트로, list 클래스에는 [첫 노드의 포인터]만 남겼고, 노드에는 [데이터], [다음 노드의 포인터] 로 메모리를 절약했다. 그로인해, 캐시 히트율을 높이기도 했고, 노드를 할당하는 속도도 높여 개선점이 분명하지만, 단점이 완전히 해결된 것은 아니다.

---
### Method

**※ 원소 접근자**
- **ref front() / back()** - 첫 / 마지막 원소 접근

**※ 반복자**
- **iterator begin() / cbegin()** - list의 시작 iterator 반환 (begin - iterator / cbegin - const_iterator)
- **iterator end() / cend()** - list의 끝 iterator 반환 (end - iterator / cend - const_iterator)
- **iterator rbegin / rend / rcbegin / rcend** - r이 붙으면 역전된(reverse) iterator 반환. (시작 = list의 끝 원소, 끝 = list의 시작 원소)

**※ 용량 확인**
- **bool empty()** - list의 원소가 비어있는지 확인 (원소가 0개 라면 true)
- **size_type size()** - list의 현재 원소 갯수
- **size_type max_size()** - 현재 자료형으로 list가 이론적으로 가질 수 있는 원소의 수.

※ **수정자**
- clear() - 모든 원소 제거
- iterator insert(iterator pos, const T& value) - value 데이터를 pos iterator 뒤에 삽입. (노드 1개 삽입)
- iterator insert(iterator pos, InputIt first, InputIt last) - [first-last]범위의 iterator를 post iterator뒤에 삽입 (보통 연속적인 노드들을 삽입)
- emplace(iterator pos, T Args) / emplace_back(T Args) / emplace_front(T Args) - pos / 앞 / 뒤노드를 생성 후에 삽입.
- push_back(const T& value), push_front(const T& value) - 원소를 복사하여 앞/뒤에 삽입.
- pop_front() / pop_back() - 노드 삭제, 원소 delete는 개별적.
- iterator erase(iterator pos) - 해당 위치(iterator)의 노드 삭제. (노드 1개 삭제)
- iterator erase(iterator start, iterator end) - start노드 부터, end까지 범위 내에 있는 노드들 삭제. (연속적인 노드들을 삭제)
- resize(size_type count, const value_type& value) - 리스트의 value로 초기화된 노드들을 count만큼 생성
- swap(list& other) - 다른 list와 포인터 교환

※ **수정자**
- Merge(list& other) - 두 개의 리스트를 합침. 매개변수로 들어오는 리스트를 뒤에 붙이는데, 이동시켜 붙이는 동작 방식으로 원본은 빈 list가 된다. Merge전에 sort()함수로 정렬을 해줘야 한다.
- splice(iterator pos, list& other) - 원래 리스트 중간에 다른 리스트의 노드들을 전부 삽입. 이동시켜 붙이는 동작 방식으로 원본은 빈 list가 된다.
- remove(const T& value) - 해당 값과 일치하는 노드는 전부 해제(delete).
- unique() - 연속으로 중복된 값을 가진 노드를 제거. 정렬 후 사용을 권장.
- sort() - 노드들의 포인터 연결만 변경시키는 "병합 정렬"을 수행.
- reverse() - 리스트들의 노드들 전체 순서를 역전시킨다.
