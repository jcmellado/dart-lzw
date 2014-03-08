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
 * Base class for LZW converters.
 */
abstract class LzwConverter extends Converter<List<int>, List<int>> {

  List<int> convertSlice(List<int> chunk, int start, int end, bool isLast);

  List<int> flush();

  ChunkedConversionSink startChunkedConversion(ChunkedConversionSink sink) {
    if (sink is! ByteConversionSink) {
      sink = new ByteConversionSink.from(sink);
    }
    return new LzwSink(this, sink);
  }

  /**
   *  Override the base-classes bind, to provide a better type.
   */
  Stream<List<int>> bind(Stream<List<int>> stream) => super.bind(stream);
}

/**
 * LZW converter sink.
 */
class LzwSink extends ByteConversionSink {
  final LzwConverter _converter;

  final ChunkedConversionSink<List<int>> _sink;

  LzwSink(this._converter, this._sink);

  void add(List<int> chunk) {
    _sink.add(_converter.convert(chunk));
  }

  void addSlice(List<int> chunk, int start, int end, bool isLast) {
    _sink.add(_converter.convertSlice(chunk, start, end, isLast));
    if (isLast) {
      close();
    }
  }

  void close() {
    _sink.add(_converter.flush());
    _sink.close();
  }
}
