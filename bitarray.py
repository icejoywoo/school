from array import array
'''
Description:
This library provide array of bit-stream.
Naming Rules:
    Inner function/class start with _
Author:
    Lanser
License:
    GPL v1
'''
class BitArray(object):
    '''
    Bit array in which big-endian bytes stored.
    *** Promise ***
        This array start from index 1 instead of 0 for convenience.
    '''
    def __init__(self, initializer=None):
        if initializer:
            self.bytearray = array('B', initializer)
        else:
            self.bytearray = array('B')
        self.remainder = 0
    @staticmethod
    def _getbit(byte, index):
        return ((byte >> (7-index)) & 0x1)
    @staticmethod
    def _setbit(byte, index, bit):
        if bit == 0:
            byte &= ~(1 << index)
        else:
            byte |= 1 << index
        return byte
    @staticmethod
    def _key(len, key):
        if not isinstance(key, int):
            raise TypeError
        if key == 0:
            raise IndexError
        if key > 0 and len < key:
            raise IndexError
        else:
            key -= 1
            return key
        if key < 0 and len < -key:
            raise IndexError
        else:
            key = len + key
            return key
    @staticmethod
    def MakeByte(bits):
        ''' reform sliced bits as byte, i.e PID '''
        result = 0
        offset = 0
        for i in reversed(bits):
            result |= (i << offset)
            offset += 1
        return result
    def __str__(self):
        print ('%02X ' * len(self.bytearray)) % tuple(self.bytearray)
    def __len__(self):
        if self.remainder == 0:
            return len(self.bytearray)*8 + self.remainder
        else:
            return (len(self.bytearray)-1)*8 + self.remainder
    def __getitem__(self, key):
        key = self._key(self.__len__(), key)
        remainder = key % 8
        index = key / 8
        return self._getbit(self.bytearray[index], remainder)
    def __setitem__(self, key, value):
        assert value == 0 or value == 1, 'bit value should be 0 or 1'
        key = self._key(self.__len__(), key)
        remainder = key % 8
        index = key / 8
        self.bytearray[index] = \
                self._setbit(self.bytearray[index], 7-remainder, value)
    def __delitem__(self, key):
        assert False, 'NOT support del method yet'
        
    def __getslice__(self, start, stop):
        ''' it should be optimize as byte + bits '''
        result = []
        index = range(start, stop)
        for i in index:
            result.append(self[i])
        return result
    def __setslice__(self, start, stop, value):
        ''' it should be optimize as byte + bits '''
        if len(value) == 1:
            index = range(start, stop)
            for i in index:
                self[i] = value
        else:
            assert len(value) == stop-start, 'value must map to index'
            if isinstance(value, str):
                value = map(lambda x:int(x), value)
            for i in range(0, stop-start):
                self[start+i] = value[i]
    class _Iterator(object):
        def __init__(self, sequence, index=0):
            self.seq = sequence
            self.index = index
        def __iter__(self):
            return self
        def next(self):
            if self.index > len(self.seq):
                raise StopIteration
            else:
                result = self.seq[self.index]
                self.index += 1
                return result
    def __iter__(self):
        return self._Iterator(self, 1)