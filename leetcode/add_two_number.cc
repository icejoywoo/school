/**
 * https://leetcode.com/problems/add-two-numbers/
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */

#include <cstdlib>
#include <iostream>

using namespace std;

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int x) : val(x), next(NULL) {}
};

class Solution {
public:
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        ListNode* result = NULL;
        ListNode* p = NULL;

        // 进位
        int flag = 0;
        while (l1 != NULL && l2 != NULL) {
            int a1 = l1->val;
            int a2 = l2->val;
            if (p == NULL) {
                result = new ListNode((a1+a2+flag)%10);
                p = result;
            } else {
                p->next = new ListNode((a1+a2+flag)%10);
                p = p->next;
            }
            flag = (a1+a2+flag)/10;
            l1 = l1->next;
            l2 = l2->next;
        }

        while (l1 != NULL) {
            int a = l1->val;
            p->next = new ListNode((a+flag)%10);
            p = p->next;
            l1 = l1->next;
            flag = (a+flag)/10;
        }

        while (l2 != NULL) {
            int a = l2->val;
            p->next = new ListNode((a+flag)%10);
            p = p->next;
            l2 = l2->next;
            flag = (a+flag)/10;
        }

        if (flag) {
            p->next = new ListNode(flag);
        }

        return result;
    }
};


int main() {
    Solution s;

    ListNode* l1 = new ListNode(2);
    l1->next = new ListNode(4);
    l1->next->next = new ListNode(3);

    ListNode* l2 = new ListNode(5);
    l2->next = new ListNode(6);
    l2->next->next = new ListNode(4);

    ListNode* ret = s.addTwoNumbers(l1, l2);
    while (ret != NULL) {
        cout << ret->val << endl;
        ret = ret->next;
    }
}
