# ^_^ encoding: utf-8 ^_^
# @date: 2013-7-22
# @author: icejoywoo (icejoywoo@gmail.com)
# @version: 0.0.1-alpha

import xml.dom.minidom as Dom

class Class2XmlHelper(object):
    '''
    Convert a object to xml text helper. This is a very simple converter.
    '''
    
    # skipped built-in attr
    __skipped_members = ("__doc__", "__module__")
    
    def __init__(self, obj, rootname = None, doc = None, root = None, isChild = False):
        self.obj = obj
        self.doc = doc
        self.root = root
        self.rootname = rootname
        self.isChild = isChild
        self.handlers = {
            "classobj": self.__handleClass, # old class-style
            "type": self.__handleClass, # new class-style
            "instance": self.__handleClass, 
            
            "str": self.__handleString,
            "int": self.__handleString,
            "long": self.__handleString,
            "float": self.__handleString,
            
            "list": self.__handleList,
            "tuple": self.__handleList,
            
            # skipped the instance method
            "instancemethod": self.__handleNone,
        }
    
    def xmlText(self, encoding = "utf-8"):
        if self.doc is None:
            self.doc = Dom.Document()
        self.__createRoot()
            
        for member in dir(self.obj):
            if member not in Class2XmlHelper.__skipped_members:
                _type = type(getattr(self.obj, member)).__name__
                self.handlers[_type](member)
        return self.doc.toprettyxml(indent = "  ", newl = "\n", encoding = encoding)
    
    def __createRoot(self):
        if self.rootname is not None:
            rootname = self.rootname
        elif type(self.obj).__name__ == "instance":
            rootname = self.obj.__class__.__name__
        elif type(self.obj).__name__ in ("classobj", "type"):
            rootname = self.obj.__name__
        else:
            raise Exception("Must be a class or instance, or giving a root name.")
        node = self.doc.createElement(rootname)
        if self.isChild:
            self.root.appendChild(node)
        else:
            self.doc.appendChild(node)
        self.root = node
    
    def __handleString(self, member):
        node = self.doc.createElement(member)
        value = self.doc.createTextNode(str(getattr(self.obj, member)))
        node.appendChild(value)
        self.root.appendChild(node)
    
    def __handleClass(self, member):
        helper = Class2XmlHelper(getattr(self.obj, member), member, self.doc, self.root, True)
        helper.xmlText()

    def __handleList(self, members):
        node = self.doc.createElement(members)
        for member in getattr(self.obj, members):
            value = self.doc.createTextNode(getattr(self.obj, member))
            node.appendChild(value)
        self.root.appendChild(node)
    
    def __handleNone(self, member):
        pass

if __name__ == "__main__": 
    class A:
        a = "another a"
    
    class Test:
        # strings
        a = "just a a"
        b = "just a b"
        aa = A() # nested object
        test = ["aaaaaa", "bbbbbbb"]
        # chinese character test
        chinese = "中文测试"
        # numbers
        i = 1
        j = 1000000000000000000000000000000000000000000000
        f = 1.0
        f2 = 1000.12345
        def __init__(self):
            self.bbb = 44444
    
    # can convert class or instance
    print Class2XmlHelper(Test()).xmlText()
    print Class2XmlHelper(Test).xmlText()