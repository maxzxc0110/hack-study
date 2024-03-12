# 描述
```
输入一个链表的头节点，按链表从尾到头的顺序返回每个节点的值（用数组返回）。

如输入{1,2,3}的链表如下图:

返回一个数组为[3,2,1]

0 <= 链表长度 <= 10000
```
# 示例
```
输入：
{1,2,3}

返回值：
[3,2,1]


输入：
{67,0,24,58}

返回值：
[58,24,0,67]
```


go
```
package main

import . "nc_tools"

/*
 * type ListNode struct{
 *   Val int
 *   Next *ListNode
 * }
 */

/**
 * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
 *
 * @param head ListNode类
 * @return int整型一维数组
 */
func printListFromTailToHead(head *ListNode) (ans []int) {
	// write code here
	var  temp []int

	for head != nil {
		temp = append(temp, head.Val)
		head = head.Next
	}

	for i:= len(temp)-1;i>=0;i--{
		ans = append(ans,temp[i])
	}

	return 
}

```


c++
```
/**
*  struct ListNode {
*        int val;
*        struct ListNode *next;
*        ListNode(int x) :
*              val(x), next(NULL) {
*        }
*  };
*/
class Solution {
public:
    vector<int> printListFromTailToHead(ListNode* head) {
        vector<int> stack;
        while(head){
            stack.push_back(head->val);
            head = head->next;
        }

        reverse(stack.begin(),stack.end());

        return  stack;
    }
};

```
