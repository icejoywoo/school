# ^_^ encoding: utf-8 ^_^
# @brief: Just a simple implementation of tries 
#     (supporting characters [a-z] [A-Z] [0-9], 
#     refer(cn): http://godorz.info/2009/11/using-tries/,
#     refer(en): http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=usingTries)
# @class: Tries (字典树)
# @date: 2013-7-30
# @author: wujiabin

class TrieNode:
    
    def __init__(self):
        self.words = 0
        self.prefixes = 0
        self.nodes = {}
        import string
        for i in string.lowercase:
            self.nodes[i] = None
        for i in string.uppercase:
            self.nodes[i] = None
        for i in string.digits:
            self.nodes[i] = None

class Trie:
    
    def __init__(self):
        self.root = TrieNode()
    
    def add_word(self, word):
        self.__add_word(self.root, word)
    
    def __add_word(self, node, word):
        if not word:
            node.words += 1
        else:
            node.prefixes += 1
            k = word[0]
            if node.nodes[k] == None:
                node.nodes[k] = TrieNode()
            self.__add_word(node.nodes[k], word[1:])

    def find_word(self, word):
        return self.count_words(word) > 0
    
    def count_words(self, word):
        return self.__count_words(self.root, word)
        
    def __count_words(self, node, word):
        if not word:
            return node.words
        elif node.nodes[word[0]] == None:
            return 0
        else:
            return self.__count_words(node.nodes[word[0]], word[1:])
            
    def count_prefixes(self, word):
        return self.__count_prefixes(self.root, word)
        
    def __count_prefixes(self, node, word):
        if not word[1:]:
            return node.prefixes
        elif node.nodes[word[0]] == None:
            return 0
        else:
            return self.__count_prefixes(node.nodes[word[0]], word[1:])

# simple test
if __name__ == "__main__":
    trie = Trie()
    trie.add_word("")
    trie.add_word("")
    trie.add_word("test")
    trie.add_word("test")
    trie.add_word("test")
    trie.add_word("testabc")
    trie.add_word("123")
    
    assert trie.count_words("test") == 3
    assert trie.count_words("") == 2
    assert trie.count_words("testabc") == 1
    assert trie.count_words("123") == 1
    
    assert trie.count_prefixes("test") == 4
    assert trie.count_prefixes("testa") == 1
    
    assert trie.find_word("testa") == False
    assert trie.find_word("test") == True