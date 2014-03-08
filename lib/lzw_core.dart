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

library lzw_core;

import "dart:async" show Stream;
import "dart:collection" show HashMap;
import "dart:convert" show ByteConversionSink, ChunkedConversionSink, Codec, Converter;
import "dart:typed_data" show Uint8List;

part "src/buffer.dart";
part "src/codec.dart";
part "src/encoder.dart";
part "src/decoder.dart";
part "src/reader.dart";
part "src/writer.dart";

/**
 * LZW options.
 */
class LzwOptions {
  final int minCodeLen;
  final int maxCodeLen;
  final bool lsb;
  final bool blockMode;
  final bool clear;
  final bool end;
  final bool earlyChange;

  /**
   * Codes in the dictionary will be as minimum [minCodeLen] bits
   * maximum [maxCodeLen] bits.
   *
   * If [lsb] is true, the "Least Significant Bit first" packing order will
   * be used. If [lsb] is false, the "Most Significant Bit first" packing
   * order will be used.
   *
   * If [blockMode] is true, a "Clear Table" marker will be used to indicate
   * that the dictionary should be cleared.
   *
   * If [clear] is true, a "Clear" marker should be the first encoded symbol.
   *
   * If [end] is true, an "End Of Data" marker should be the last encoded symbol.
   *
   * If [earlyChange] is true, code length increases shall occur one code
   * early. If [earlyChange] is false, code length increases shall be
   * postponed as long as possible.
   */
  const LzwOptions({this.minCodeLen : 9, this.maxCodeLen: 12, this.lsb: true,
    this.blockMode: true, this.clear: false, this.end: true, this.earlyChange: false});
}
