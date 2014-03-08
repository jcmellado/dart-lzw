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

abstract class TestDecoder {

  static void run() {

    group("decoder", () {

      test("convert", () {
        var options = new LzwOptions();
        var decoder = new LzwDecoder(options);

        // 0100 0001 | 1000 0100 | 0000 1100 | 0001 0001 | 0011 1000 | 0100 0100 | 0100 1000 | 0100 0000
        // 0 0100 0001 | 00 1000 010 | 001 0000 11 | 1000 0001 0 | 0 0100 0011 | 00 1000 010 | 100 0000 01 | 0
        // 0x41 (A)    | 0x42 (B)    | 0x43 (C)    | 0x102 (AB)  | 0x43 (C)    | 0x42 (B)    | 0x101 (EOD)
        var codes = const <int>[0x41, 0x84, 0x0C, 0x11, 0x38, 0x44, 0x48, 0x40];
        var symbols = decoder.convertSlice(codes, 0, codes.length, true);

        // ABCABCB
        expect(symbols, equals(const <int>[0x41, 0x42, 0x43, 0x41, 0x42, 0x43, 0x42]));
      });

      test("convert with default options", () {
        var options = new LzwOptions();
        var decoder = new LzwDecoder(options);

        var codes = const <int>[84, 158, 8, 41, 242, 68, 138, 147, 39,
                                84, 4, 18, 52, 184, 176, 224, 193, 132,
                                1, 1];
        var symbols = decoder.convertSlice(codes, 0, codes.length, true);

        expect(symbols, equals(_TEST));
      });

      test("convert with clear = true", () {
        var options = new LzwOptions(clear: true);
        var decoder = new LzwDecoder(options);

        var codes = const <int>[0, 169, 60, 17, 82, 228, 137, 20, 39,
                                79, 168, 8, 36, 104, 112, 97, 193, 131,
                                9, 3, 2];
        var symbols = decoder.convertSlice(codes, 0, codes.length, true);

        expect(symbols, equals(_TEST));
      });

      test("convert with end = false", () {
        var options = new LzwOptions(end: false);
        var decoder = new LzwDecoder(options);

        var codes = const <int>[84, 158, 8, 41, 242, 68, 138, 147, 39,
                                84, 2, 14, 44, 168, 144, 160, 65, 132];
        var symbols = decoder.convertSlice(codes, 0, codes.length, true);

        expect(symbols, equals(_TEST));
      });

      test("convert with lsb = false", () {
        var options = new LzwOptions(lsb: false);
        var decoder = new LzwDecoder(options);

        var codes = const <int>[42, 19, 200, 68, 82, 121, 72, 156, 79,
                                42, 64, 160, 144, 104, 92, 22, 15, 9,
                                128, 128];
        var symbols = decoder.convertSlice(codes, 0, codes.length, true);

        expect(symbols, equals(_TEST));
      });

      test("convert with minCodeLen = 4 and maxCodeLen = 4", () {
        var options = new LzwOptions(minCodeLen: 4, maxCodeLen: 4);
        var decoder = new LzwDecoder(options);

        var codes = const <int>[16, 50, 65, 88, 1, 16, 130, 19, 4, 33, 56, 65,
                                21, 144];
        var symbols = decoder.convertSlice(codes, 0, codes.length, true);

        expect(symbols, equals(_TEST_4BITS));
      });

      test("convert with minCodeLen = 4, maxCodeLen = 4 and earlyChange = true", () {
        var options = new LzwOptions(minCodeLen: 4, maxCodeLen: 4, earlyChange: true);
        var decoder = new LzwDecoder(options);

        var codes = const <int>[16, 50, 129, 84, 1, 128, 33, 19, 132,
                                16, 50, 129, 84, 1, 9];
        var symbols = decoder.convertSlice(codes, 0, codes.length, true);

        expect(symbols, equals(_TEST_4BITS));
      });

      test("convert with minCodeLen = 4, maxCodeLen = 4 and blockMode = false", () {
        var options = new LzwOptions(minCodeLen: 4, maxCodeLen: 4, blockMode: false);
        var decoder = new LzwDecoder(options);

        var codes = const <int>[16, 50, 65, 21, 0, 33, 19, 4, 33, 19,
                                84, 1, 8];
        var symbols = decoder.convertSlice(codes, 0, codes.length, true);

        expect(symbols, equals(_TEST_4BITS));
      });

    });
  }
}
