/*
  Copyright (c) 2014 Juan Mellado

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
*/

part of lzw_core;

/**
 * LZW reader.
 */
abstract class LzwReader {
  int codeLen;

  Iterator<int> _iterator;

  int _bitLength = 0;

  int _tail = 0;

  int _tailLen = 0;

  void setInput(Iterator<int> iterator, int length) {
    _iterator = iterator;
    _bitLength = length * 8;
  }

  bool get hasData => (_bitLength + _tailLen) >= codeLen;

  int read() {
    _bitLength -= 8;
    _iterator.moveNext();
    return _iterator.current;
  }

  void flush();
}

/**
 * Reader that use the "Least Significant Bit first" packing order.
 *
 * Example: 87654321 xxxxCBA9
 */
class LsbReader extends LzwReader {

  int read() {
    for (; _tailLen < codeLen; _tailLen += 8) {
      _tail |= super.read() << _tailLen;
    }

    _tailLen -= codeLen;
    var code = _tail & ((1 << codeLen) - 1);
    _tail >>= codeLen;

    return code;
  }

  void flush() {
    for (; _bitLength > 0; _tailLen += 8) {
      _tail |= super.read() << _tailLen;
    }
  }
}

/**
 * Reader that use the "Most Significant Bit first" packing order.
 *
 * Example: CBA98765 4321xxxx
 */
class MsbReader extends LzwReader {

  int read() {
    for (; _tailLen < codeLen; _tailLen += 8) {
      _tail = (_tail << 8) | super.read();
    }

    _tailLen -= codeLen;
    var code = _tail >> _tailLen;
    _tail &= (1 << _tailLen) - 1;

    return code;
  }

  void flush() {
    for (; _bitLength > 0; _tailLen += 8) {
      _tail = (_tail << 8) | super.read();
    }
  }
}
