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

library lzw_core_test;

import "package:unittest/unittest.dart";

import "package:lzw/lzw_core.dart";

part "src/test_buffer.dart";
part "src/test_decoder.dart";
part "src/test_encoder.dart";
part "src/test_reader.dart";
part "src/test_writer.dart";

// Famous string used for testing.
final List<int> _TEST = "TOBEORNOTTOBEORTOBEORNOT".codeUnits;

final List<int> _TEST_4BITS = _TEST
    .map((i) => [84, 79, 66, 69, 82, 78].indexOf(i))  //T, O, B, E, R, N
    .toList();

// Test all.
void main() {
  TestBuffer.run();
  TestDecoder.run();
  TestEncoder.run();
  TestReader.run();
  TestWriter.run();
}
