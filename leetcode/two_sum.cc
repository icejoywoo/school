/**
 * https://leetcode.com/problems/two-sum/
 */

#include <algorithm>
#include <iostream>
#include <map>
#include <vector>

using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        map<int, int> d;
        for (size_t i = 0; i < nums.size(); ++i) {
            d[nums[i]] = i+1;
        }

        vector<int> ret;
        for (size_t i = 0; i < nums.size(); ++i) {
            int diff = target - nums[i];
            map<int, int>::iterator iter = d.find(diff);

            if (iter != d.end() && d[diff] != i + 1) {
                ret.push_back(i+1);
                ret.push_back(d[diff]);
                return ret;
            }
        }
        return ret;
    }
};

struct myclass {  // function object type:
  void operator() (int i) {cout << ' ' << i;}
} myobject;

int main() {
    Solution s;
    vector<int> nums;
    nums.push_back(3);
    nums.push_back(2);
    nums.push_back(4);
    vector<int> ret = s.twoSum(nums, 6);
    for_each(ret.begin(), ret.end(), myobject);
}
