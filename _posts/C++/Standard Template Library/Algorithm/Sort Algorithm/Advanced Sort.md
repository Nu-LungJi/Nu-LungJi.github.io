# Advanced Sort - 비교(Compare) 기반 정렬

## Merge Sort

→ **정렬법 :** 원소 갯수가 1개 이하가 되도록 반복적으로 분할하고, 다시 반복적으로 합치는 동시에, 원소 값들을 비교하여 정렬하는 방식.

**※ Top-Down 방식 - 재귀 형태**
→ **과정 :** 
1. vector의 가운데 기준으로 2개 구간으로 1차 분할, 분할 된 구간에서 다시 가운데 기준으로 분할, 구간에 있는 원소가 1개 이하가 될 때까지 과정을 반복한다. 
2. 분할 된 원소를 합치면서 값을 비교하고, 임시 배열에 저장해 두었다가, 정렬된 하나의 구간으로 병합한다. 이 과정을 반복하여 모든 원소를 합친다.

**※ Bottom-Up 방식 - 반복 형태**
→ **과정 :** 
1. vector를 처음에 1칸에 대해서 값을 비교하고 정렬을 하면서 순회한다. 정렬은 빈 벡터를 2칸 (1칸 + 1칸) 만들어서 작은 것부터 빈 벡터에 채워, 다시 원래 벡터의 2칸에 순서대로 넣어준다. (정렬됨.)
2. 이것을 반복하는데, 칸 수를 x2씩 늘려 작은 단위에서 큰 단위로 늘려 정렬하는 방식으로 진행한다. ex. 2칸 비교 - 빈 벡터 4칸을 이용하여 병합 수행 -> 4칸 -> 8칸 ... 순으로 병합한다.

→ **효율성 :** 데이터 갯수가 많은, '대용량 외부 정렬'같은 경우에도 빠른 정렬로 해결할 수 있고, 원소들의 기존 순서를 유지함. 다만, 공간 복잡도에서 효율이 떨어진다. 연결 리스트 정렬에 특히 유리하다.
→ **그 외 :** 분할 정복 방식(Divide & Conquer) 채택, 안정적인 정렬 보장, 일정 성능 보장
→ **C++ :** C++에서는 `std::stable_sort`를 제공하는데, 병합 정렬을 기반으로 만들어진 정렬 함수이다.

! 위 두 방식은 구현에만 차이가 있지, 성능은 차이가 거의 없다.

> [!note]- Merge Sort (Top-Down)
> **병합 정렬 구현** 
> ``` cpp
>void Merge(std::vector<int>& _vec, int _Left, int _Center, int _Right) { 
>    int LeftIndex = _Left;  
>    int RightIndex = _Center;  
>    int ArrayIndex = _Left;  
>    
>    std::vector<int> SortedArray(_Right);  
>    
>    while (LeftIndex < _Center && RightIndex < _Right)  {
>        SortedArray[ArrayIndex++] = _vec[LeftIndex] <= _vec[RightIndex] ? _vec[LeftIndex++] : _vec[RightIndex++];  
>    }
>    
>    int LastIndex = LeftIndex >= _Center ? RightIndex : LeftIndex;  
>    
>    while (ArrayIndex < _Right) { SortedArray[ArrayIndex++] = _vec[LastIndex++]; }
>    
>    for (int i = _Left; i < _Right; ++i) { _vec[i] = SortedArray[i]; }  
>}
>  
>void Divide(std::vector<int>& _vec, int _Left, int _Right)  {  
>    if (_Right - _Left <= 1) return ;  
>    int Center = (_Left + _Right) / 2;  
>     
>    Divide(_vec, _Left, Center);  
>    Divide(_vec, Center, _Right);  
>    Merge(_vec, _Left, Center, _Right);  
>}  
>
>void MergeSort(std::vector<int>& _vec) {  
>    Divide(_vec, 0, static_cast<int>(_vec.size()));  
>}
>```

> [!note]- Merge Sort (Bottom-Up)
> **병합 정렬 구현** 
> ``` cpp
> void Merge(std::vector\<int>& _vec, int _Left, int _Center, int _Right) { 
>    int LeftIndex = _Left;  
>    int RightIndex = _Center;  
>    int ArrayIndex = _Left;  
>    
>    std::vector<int> SortedArray(_Right);  
>
>    while (LeftIndex < _Center && RightIndex < _Right)  {
>        SortedArray[ArrayIndex++] = _vec[LeftIndex] <= _vec[RightIndex] ? _vec[LeftIndex++] : _vec[RightIndex++];  
>    }
>    
>    int LastIndex = LeftIndex >= _Center ? RightIndex : LeftIndex;  
>    
>    while (ArrayIndex < _Right) { SortedArray[ArrayIndex++] = _vec[LastIndex++]; }
>    
>    for (int i = _Left; i < _Right; ++i) { _vec[i] = SortedArray[i]; }  
>}
>
>void BottomUpSort(std::vector<int>& _vec) {  
>    int Size = static_cast<int>(_vec.size());  
>    for (int Width = 1; Width < Size; Width *= 2)  {  
>       for (int Left = 0; Left < Size; Left += Width * 2) {  
> 	       int Center = std::min(Left + Width, Size);  
>            int Right = std::min(Left + 2 * Width, Size);  
>            
>            Merge(_vec, Left, Center, Right);  
>        }  
>    }  
>}
>``` 
## Quick Sort

→ **정렬법 :** 하나의 데이터 리스트를 비균등한 크기로 분할하고, 
→ **과정 :** 
1. 데이터 리스트에서 하나의 원소를 Pivot으로 선택한다. 
2. Pivot을 기준으로 좌측에는 피벗보다 작은 원소들, 우측에는 Pivot보다 큰 원소들로 이동시켜 정렬시킨다.
3. 분할된 두 리스트도 재귀호출로 최소 단위까지 정렬시켜, 전체 정렬을 완료시킨다.

→ **효율성 :** 배열같은 연속 메모리를 정렬하면, **캐시 효율**이 좋아 왠만한 정렬보다 빠르게 나오는 경우가 있다. 메모리가 한정적인 상황이라면, 제자리 정렬을 생각하며 사용이 가능하다. 평균 O(N log N)의 평균적으로도 빠른 성능을 보인다. 하지만, Pivot 선택에 따라, 최악의 경우 **O(N²)**까지 성능이 저하될 수 있다.
→ **그 외 :** 불안정한 정렬, 제자리 정렬(In-Place Sorting), 캐시 친화적인 정렬 방법. 정렬 알고리즘 중에서 빠른 속도/고성능

> [!note]- Quick Sort
> **퀵 정렬 구현** 
>``` cpp
>void QuickSort(std::vector<int>& _vec, int _Left, int _Right) {
>    if (_Right - _Left <= 1) return ;
>    int Pivot = _vec[_Left + (_Right - _Left - 1) / 2];
>    int i = _Left - 1;
>    int j = _Right;
>  
>    while (true) {  
>        do { ++i; } while (_vec[i] < Pivot);
>        do { --j; } while (_vec[j] > Pivot);
>        
>        if (i >= j) break;
>        
>        std::swap(_vec[i], _vec[j]);
>    }  
>    QuickSort(_vec, _Left, j + 1);
>    QuickSort(_vec, j + 1, _Right);
>}
>```
## Heap Sort

## Shell Sort


<table class="cpp-access-table">
<thead>
<tr>
<th>알고리즘</th>
<th>최선</th>
<th>평균</th>
<th>최악</th>
<th>안정성</th>
<th>추가 공간</th>
<th>특징</th>
</tr>
</thead>

<tbody>

<tr>
<td><b>병합 정렬</b></td>
<td>O(N log N)</td>
<td>O(N log N)</td>
<td><b>O(N log N)</b></td>
<td>안정</td>
<td>O(N)</td>
<td>분할 정복, 일정한 성능</td>
</tr>

<tr>
<td><b>퀵 정렬</b></td>
<td>O(N log N)</td>
<td>O(N log N)</td>
<td><b>O(N²)</b></td>
<td>불안정</td>
<td>O(log N) 평균</td>
<td>분할 정복, 캐시 효율이 좋음</td>
</tr>

<tr>
<td><b>힙 정렬</b></td>
<td>O(N log N)</td>
<td>O(N log N)</td>
<td><b>O(N log N)</b></td>
<td>불안정</td>
<td>O(1)</td>
<td>최악에도 O(N log N), 제자리 정렬</td>
</tr>

<tr>
<td><b>셸 정렬</b></td>
<td>Gap 수열 의존</td>
<td>Gap 수열 의존</td>
<td><b>O(N²)*</b></td>
<td>불안정</td>
<td>O(1)</td>
<td>삽입 정렬 개선형, Gap 수열에 성능 의존</td>
</tr>

</tbody>
</table>

# Advanced Sort - 비-비교(Non-Compare) 기반 정렬

## Radix Sort

## Counting Sort

## Bucket Sort

<table class="cpp-access-table">
<thead>
<tr>
<th>알고리즘</th>
<th>최선</th>
<th>평균</th>
<th>최악</th>
<th>안정성</th>
<th>추가 공간</th>
<th>특징</th>
</tr>
</thead>

<tbody>

<tr>
<td><b>기수 정렬</b></td>
<td>O(D(N + K))</td>
<td>O(D(N + K))</td>
<td><b>O(D(N + K))</b></td>
<td>안정*</td>
<td>O(N + K)</td>
<td>자릿수 단위 정렬, 비교 연산 없음</td>
</tr>

<tr>
<td><b>계수 정렬</b></td>
<td>O(N + K)</td>
<td>O(N + K)</td>
<td><b>O(N + K)</b></td>
<td>안정*</td>
<td>O(N + K)</td>
<td>값의 범위가 작을수록 효율적</td>
</tr>

<tr>
<td><b>버킷 정렬</b></td>
<td>O(N + K)</td>
<td>O(N + K)</td>
<td><b>O(N²)</b></td>
<td>구현 의존</td>
<td>O(N + K)</td>
<td>데이터가 균등 분포일 때 효율적</td>
</tr>

</tbody>
</table>

**※ 분할 정복 방식 (Divide & Conquer)**
→ 문제를 2개(이상)로 나누어 각자 처리하는 방식. 문제를 각각 부분 문제로 분할하여, 해결하고, 필요한 경우 각각의 결과를 결합하여 하나의 결과를 만드는 '**문제 해결 방식**'. 이후에 결과를 한데 모아 최종적으로 문제를 해결해나가는 방식이다. 대부분 **재귀(Recursive) 함수 호출**을 통해 해결하는 방식이며, 반복문 형식도 존재한다.