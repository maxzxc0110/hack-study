# 描述

```
在一个长度为n的数组里的所有数字都在0到n-1的范围内。 数组中某些数字是重复的，但不知道有几个数字是重复的。也不知道每个数字重复几次。请找出数组中任意一个重复的数字。 例如，如果输入长度为7的数组[2,3,1,0,2,5,3]，那么对应的输出是2或者3。存在不合法的输入的话输出-1

数据范围：
0≤n≤10000 
进阶：时间复杂度O(n)

O(n) ，空间复杂度O(n)
```

# 示例1

```
输入：
[2,3,1,0,2,5,3]

返回值：
2

说明：
2或3都是对的  
```


# go

暴力,时间复杂度O(n^2)
```
package main

/**
 * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
 *
 * 
 * @param numbers int整型一维数组 
 * @return int整型
*/
func duplicate( numbers []int ) int {
    // write code here

    for i := 0;i< len(numbers);i++ {
        for j := i+1; j<len(numbers);j++{
            if numbers[i] == numbers[j]{
                return numbers[i]
            }
        }
    }

    return -1
}
```

利用map,只需要一次循环，时间复杂度O(n)

```
package main

/**
 * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
 *
 * 
 * @param numbers int整型一维数组 
 * @return int整型
*/

func duplicate(numbers []int) int {
	// write code here
	var m = make(map[int]bool)

	for _, v := range numbers {
		if m[v] {
			return v
		}

		m[v] = true
	}

	return -1
}
```


# c++


暴力。

这里注意取数组长度时不能用```  int l = sizeof(numbers) / sizeof(numbers[0]);```,当测试用例是空数组时会数组越界

```
class Solution {
public:
    /**
     * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
     *
     * 
     * @param numbers int整型vector 
     * @return int整型
     */
    int duplicate(vector<int>& numbers) {
        // write code here

        int l = end(numbers) - begin(numbers);

        if(l == 0 || l == 1){
            return -1;
        }

        for(int i=0;i<l;i++){
            for(int j=i+1;j<l;j++){
                if(numbers[i] == numbers[j]){
                    return numbers[i];
                }
            }
        }

        return -1;
    }
};
```


利用哈希表
```
#include <unordered_map>
class Solution {
public:
    /**
     * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
     *
     * 
     * @param numbers int整型vector 
     * @return int整型
     */
    int duplicate(vector<int>& numbers) {
        // write code here

        //定义一个哈希表
        unordered_map<int, int> mp;


        for(int i=0;i<numbers.size();i++){
                //如果没有出现过就加入哈希表
                if(mp.find(numbers[i]) == mp.end()){
                    mp[numbers[i]]++;
					//否则就是重复数字
                }else{
                    return numbers[i];
                }
        }

        return -1;
        
    }
};
```