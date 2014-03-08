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
 * Growable list of bytes.
 */
class ByteBuffer {
  static const int INITIAL_SIZE = 4096;

  Uint8List _bytes;

  int _length;

  void write(int byte) {
    _ensureCapacity();

    _bytes[_length ++] = byte;
  }

  List<int> takeBytes() {
    _ensureCapacity();

    var view = new Uint8List.view(_bytes.buffer, 0, _length);
    _bytes = null;
    _length = 0;
    return view;
  }

  void _ensureCapacity() {
    if (_bytes == null) {
      _bytes = new Uint8List(INITIAL_SIZE);
      _length = 0;
    }
    if (_length == _bytes.length) {
      var len = _bytes.length + (_bytes.length >> 1);
      _bytes = new Uint8List(len)..setAll(0, _bytes);
    }
  }
}
