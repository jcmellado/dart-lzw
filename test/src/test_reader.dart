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

part of lzw_core_test;

abstract class TestReader {

  static void run() {

    group("reader", () {

      test("lsb with codeLen = 3", () {
        var reader = new LsbReader()..codeLen = 3;

        expect(reader.hasData, isFalse);

        // 0101 1010 | 0000 1000
        var list = const <int>[0x5A, 0x08];
        reader.setInput(list.iterator, list.length);

        // 010 | 01 1 | 0 01 | 100 | 0000
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(2));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(3));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(1));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(4));
      });

      test("lsb with codeLen = 9", () {
        var reader = new LsbReader()..codeLen = 9;

        expect(reader.hasData, isFalse);

        // 0000 0000 | 1000 0011 | 0000 1000 | 0001 1001 | 0001 0010 | 0001 0000
        var list = const <int>[0x00, 0x83, 0x08, 0x19, 0x12, 0x10];
        reader.setInput(list.iterator, list.length);

        // 1 0000 0000 | 00 1000 001 | 001 0000 10 | 0010 0001 1 | 1 0000 0001  | 000
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x100));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x41));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x42));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x43));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x101));
        expect(reader.hasData, isFalse);

        reader.flush();
        expect(reader.hasData, isFalse);
      });

      test("lsb with codeLen = 9 then 10", () {
        var reader = new LsbReader();

        // 0000 0000 | 1000 0011 | 0000 1100 | 0001 0001 | 0001 0000
        var list = const <int>[0x00, 0x83, 0x0C, 0x11, 0x10];
        reader.setInput(list.iterator, list.length);

        // 1 0000 0000 | 00 1000 001 | 0001 0000 11 | 1 0000 0001 | 000
        reader.codeLen = 9;

        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x100));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x41));
        expect(reader.hasData, isTrue);

        reader.codeLen = 10;

        expect(reader.read(), equals(0x43));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x101));
        expect(reader.hasData, isFalse);

        reader.flush();
        expect(reader.hasData, isFalse);
      });

      test("msb with codeLen = 3", () {
        var reader = new MsbReader()..codeLen = 3;

        expect(reader.hasData, isFalse);

        // 0100 1100 | 1100 0000
        var list = const <int>[0x4C, 0xC0];
        reader.setInput(list.iterator, list.length);

        // 010 | 0 11 | 00 1 | 100 | 0000
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(2));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(3));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(1));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(4));
      });

      test("msb with codeLen = 9", () {
        var reader = new MsbReader()..codeLen = 9;

        expect(reader.hasData, isFalse);

        // 1000 0000 | 0001 0000 | 0100 1000 | 0100 0100 | 0011 1000 | 0000 1000
        var list = const <int>[0x80, 0x10, 0x48, 0x44, 0x38, 0x08];
        reader.setInput(list.iterator, list.length);

        // 1000 0000 0 | 001 0000 01 | 00 1000 010 | 0 0100 0011 | 1000 0 0001 | 000
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x100));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x41));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x42));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x43));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x101));
        expect(reader.hasData, isFalse);

        reader.flush();
        expect(reader.hasData, isFalse);
      });

      test("msb with codeLen = 9 then 10", () {
        var reader = new MsbReader();

        // 1000 0000 | 0001 0000 | 0100 0100 | 0011 0100 | 0000 0100
        var list = const <int>[0x80, 0x10, 0x44, 0x34, 0x04];
        reader.setInput(list.iterator, list.length);

        // 1000 0000 0 | 001 0000 01 | 00 0100 0011 | 0100 0000 01 | 00
        reader.codeLen = 9;

        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x100));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x41));
        expect(reader.hasData, isTrue);

        reader.codeLen = 10;

        expect(reader.read(), equals(0x43));
        expect(reader.hasData, isTrue);
        expect(reader.read(), equals(0x101));
        expect(reader.hasData, isFalse);

        reader.flush();
        expect(reader.hasData, isFalse);
      });

    });
  }
}
