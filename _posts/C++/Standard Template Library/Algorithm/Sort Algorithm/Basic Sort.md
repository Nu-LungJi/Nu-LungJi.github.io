#  Basic Sort
## Bubble Sort

→ **정렬법 :** 인접한 두 원소의 값을 비교하면서 자리를 교환하는 정렬 방식이다.
→ **과정 :** 
1. 현재 가리키는 원소와 그 다음 원소를 비교해서 교환 또는 고정.
2. 다음 원소가 현재 원소가 되며, 그 다음 원소와 비교. → 배열의 모든 원소와 비교.
3. 가장 큰 숫자가 끝으로 밀려나게 되므로, 제일 끝 원소 뺴고 나머지 원소들끼리 비교.
4. 교환할 원소가 없을 때까지 반복 비교.
→ **효율성 :** 원소 갯수가 적거나, 거의 정렬된 배열의 경우 '비교적 효율적'.
→ **그 외 :** 제자리 정렬(In-Place Sorting), 안정적인 정렬(값이 같은 원소에 대한 순서 유지.)


> [!note]- Bubble Sort
> 버블 정렬 구현
> 
> ``` cpp
void BubbleSort(std::vector<int>& _vec) {  
>   int ElementCount = static_cast<int>(_vec.size());  
>   
>   for (int i = 0; i < ElementCount - 1; ++i) {  
>       bool SwapCheck = false;  
>       for (int j = 0; j < ElementCount - i - 1; ++j) {  
>           if (_vec[j] > _vec[j + 1]) {  
> 	          std::swap(_vec[j], _vec[j + 1]);  
> 	          SwapCheck = true;  
>           }  
>       }  
>       if (!SwapCheck) break;  
>   }  
}
> ```

## Selection Sort

→ **정렬법 :** 배열의 최솟값을 찾아, 현재 배열의 자리를 교환하는 정렬 방식.
→ **과정 :** 
1. 최솟값이 들어갈 자리 지정
2. 해당 자리 이후의 원소들을 순회하면서, 최솟값이 있는 인덱스를 저장
3. 지정한 자리와, 최솟값이 있는 자리와 swap
4. 다음 자리로 넘어가면서 과정 반복.
→ **효율성 :** 교환 횟수가 적음(최악의 경우에도 O(N)-1), 큰 데이터 세트에는 '비효율적'.
→ **그 외 :** 제자리 정렬(In-Place Sorting), 불안정적인 정렬(동일 원소 순서 유지 보장X)

> [!note]- Selection Sort
> 선택 정렬 구현
> 
> ``` cpp
> void SelectionSort(std::vector<int>& _vec) {  
>    size_t VecSize = _vec.size();  
>    for (size_t i = 0; i < VecSize; ++i) {  
>        size_t minIndex = i;  
>        for (size_t j = i + 1; j < VecSize; ++j)  {            
> 	       if (_vec[minIndex] > _vec[j]) minIndex = j;  
>        }        
>        std::swap(_vec[i], _vec[minIndex]);  
>    }
>  }
> ```
## Insertion Sort

→ **정렬법 :** 배열 앞에서 부터 '정렬이 된 부분', 그 뒤에는 '정렬이 안 된 부분'으로 나누고,  '정렬이 안 된 부분'에서 한 원소 씩 가져와 정렬이 된 부분에서 들어갈 곳에 삽입 시킨다.
→ **과정 :** 
1. 2번째 원소 부터 시작하여, 1번째 원소를 '정렬이 된 부분'이라고 생각한다.
2. 두 원소를 비교해서 2번째 원소를 앞에 넣어야 할지, 고정해야 할지 판단 후 삽입.
3. 3번째와 1번, 2번째(정렬이 된 부분) 순회돌며, 삽입 위치 확인 후, 삽입.
4. 2 -> 3 반복하면서, 모든 원소를 '정렬이 된 부분'으로 만들면 종료.
→ **효율적 사례 :** 적은 데이터 세트/거의 정렬된 세트 에서 빠른 정렬 속도, 
→ **비효율적 사례 :** 데이터가 많아질 수록 정렬 속도 기하 급수로 낮아짐.(약 10만 개)
→ **그 외 :** 안정적인 정렬(값이 같은 원소에 대한 순서 유지.)

> [!note]- Insertion Sort
> 선택 정렬 구현
> 
> ``` cpp
void InsertionSort(std::vector<int>& _vec) {  
>   for (size_t i = 1; i < _vec.size(); ++i) {  
>        int Key = _vec[i];  
>        int j = i - 1;  
>        while (j >= 0 && _vec[j] > Key) {
> 		 _vec[j + 1] = _vec[j]; 
>          --j;  
>        }  
>        _vec[j + 1] = Key;  
>    }  
>}
> ```

<table  class="cpp-access-table">
<thead>
<tr>
<th>알고리즘</th>
<th>최선</th>
<th>평균</th>
<th>최악</th>
<th>안정성</th>
<th>교환 횟수</th>
<th>특징</th>
</tr>
</thead>
<tbody>
<tr>
<td><b>버블 정렬</b></td>
<td>O(N)</td>
<td>O(N²)</td>
<td><b>O(N²)</b></td>
<td>안정</td>
<td>O(N²)</td>
<td>이미 정렬된 경우 O(N)</td>
</tr>
<tr>
<td><b>선택 정렬</b></td>
<td>O(N²)</td>
<td>O(N²)</td>
<td><b>O(N²)</b></td>
<td>불안정</td>
<td>O(N)</td>
<td>쓰기 비용 최소화</td>
</tr>
<tr>
<td><b>삽입 정렬</b></td>
<td>O(N)</td>
<td>O(N²)</td>
<td><b>O(N²)</b></td>
<td>안정</td>
<td>O(N²)</td>
<td>온라인, 캐시 효율</td>
</tr>
</tbody>
</table>
