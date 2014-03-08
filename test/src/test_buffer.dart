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

abstract class TestBuffer {

  static void run() {

    group("buffer", () {

      test("write and takeBytes", () {
        var buffer = new ByteBuffer();

        expect(buffer.takeBytes(), isEmpty);

        buffer.write(1);
        expect(buffer.takeBytes(), equals(const <int>[1]));

        buffer.write(2);
        expect(buffer.takeBytes(), equals(const <int>[2]));

        buffer..write(10)..write(11)..write(12);
        expect(buffer.takeBytes(), equals(const <int>[10, 11, 12]));
      });

      test("ensure capacity", () {
        var list = new List<int>.generate(ByteBuffer.INITIAL_SIZE, (i) => i);

        var buffer = new ByteBuffer();

        expect(buffer.takeBytes(), isEmpty);

        buffer.write(1);
        expect(buffer.takeBytes(), equals(const <int>[1]));

        list.forEach(buffer.write);
        expect(buffer.takeBytes(), hasLength(ByteBuffer.INITIAL_SIZE));

        list.forEach(buffer.write);
        buffer.write(2);
        expect(buffer.takeBytes(), hasLength(ByteBuffer.INITIAL_SIZE + 1));

        list.forEach(buffer.write);
        list.forEach(buffer.write);
        expect(buffer.takeBytes(), hasLength(ByteBuffer.INITIAL_SIZE * 2));

        list.forEach(buffer.write);
        list.forEach(buffer.write);
        buffer.write(3);
        expect(buffer.takeBytes(), hasLength((ByteBuffer.INITIAL_SIZE * 2) + 1));

        expect(buffer.takeBytes(), isEmpty);
      });

    });
  }
}