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

abstract class TestWriter {

  static void run() {

    group("writer", () {

      test("lsb with codeLen = 3", () {
        var writer = new LsbWriter()..codeLen = 3;

        expect(writer.takeBytes(), isEmpty);

        // 010 | 011 | 001 | 100
        writer..write(2)..write(3)..write(1)..write(4)..flush();

        // 01 011 010 | .... 100 0
        expect(writer.takeBytes(), equals(const <int>[0x5A, 0x08]));
      });

      test("lsb with codeLen = 9", () {
        var writer = new LsbWriter()..codeLen = 9;

        expect(writer.takeBytes(), isEmpty);

        writer.write(0x100);
        expect(writer.takeBytes(), equals(const <int>[0x00]));
        writer.flush();
        expect(writer.takeBytes(), equals(const <int>[0x01]));

        writer.write(0x100);
        writer.flush();
        expect(writer.takeBytes(), equals(const <int>[0x00, 0x01]));

        // 1 0000 0000 | 0 0100 0001 | 0 0100 0010 | 0 0100 0011 | 1 0000 0001
        writer..write(0x100)..write(0x41)..write(0x42)..write(0x43)..write(0x101);
        writer.flush();

        // 0000 0000 | 100 0001 1 | 00 0010 0 0 | 0 0011 0 01 | 0001 0 010 | ... 1 0000
        expect(writer.takeBytes(), equals(const <int>[0x00, 0x83, 0x08, 0x19, 0x12, 0x10]));
      });

      test("lsb with codeLen = 9 then 10", () {
        var writer = new LsbWriter();

        // 1 0000 0000 | 0 0100 0001 | 00 0100 0011 | 01 0000 0001
        writer..codeLen = 9..write(0x100)..write(0x41);
        writer..codeLen = 10..write(0x43)..write(0x101);
        writer.flush();

        // 0000 0000 | 100 0001 1 | 00 0011 0 0 | 0001 00 01 | .. 01 0000
        expect(writer.takeBytes(), equals(const <int>[0x00, 0x83, 0x0C, 0x11, 0x10]));
      });

      test("msb with codeLen = 3", () {
        var writer = new MsbWriter()..codeLen = 3;

        expect(writer.takeBytes(), isEmpty);

        // 010 | 011 | 001 | 100
        writer..write(2)..write(3)..write(1)..write(4)..flush();

        // 010 011 00 | 1 100 ....
        expect(writer.takeBytes(), equals(const <int>[0x4C, 0xC0]));
      });

      test("msb with codeLen = 9", () {
        var writer = new MsbWriter()..codeLen = 9;

        expect(writer.takeBytes(), isEmpty);

        writer.write(0x100);
        expect(writer.takeBytes(), equals(const <int>[0x80]));
        writer.flush();
        expect(writer.takeBytes(), equals(const <int>[0x00]));

        writer.write(0x100);
        writer.flush();
        expect(writer.takeBytes(), equals(const <int>[0x80, 0x00]));

        // 1 0000 0000 | 0 0100 0001 | 0 0100 0010 | 0 0100 0011 | 1 0000 0001
        writer..write(0x100)..write(0x41)..write(0x42)..write(0x43)..write(0x101);
        writer.flush();

        // 1 0000 000 | 0 0 0100 00 | 01 0 0100 0 | 010 0 0100  | 0011 1 000 | 0 0001 ...
        expect(writer.takeBytes(), equals(const <int>[0x80, 0x10, 0x48, 0x44, 0x38, 0x08]));
      });

      test("msb with codeLen = 9 then 10", () {
        var writer = new MsbWriter();

        // 1 0000 0000 | 0 0100 0001 | 00 0100 0011 | 01 0000 0001
        writer..codeLen = 9..write(0x100)..write(0x41);
        writer..codeLen = 10..write(0x43)..write(0x101);
        writer.flush();

        // 1 0000 000 | 0 0 0100 00 | 01 00 0100 | 0011 01 00 | 00 0001 ..
        expect(writer.takeBytes(), equals(const <int>[0x80, 0x10, 0x44, 0x34, 0x04]));
      });

   });
  }
}