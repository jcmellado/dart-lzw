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

library lzw;

import "dart:convert" show Codec, Converter;
import "package:lzw/lzw_core.dart" show LzwEncoder, LzwDecoder, LzwOptions;

export "package:lzw/lzw_core.dart" show LzwOptions;

/**
 * An instance of the default implementation of the [LzwCodec].
 *
 * This instance provides a convenient access to the most common LZW use cases.
 */
const LzwCodec LZW = const LzwCodec();

/**
 * The [LzwCodec] encodes raw bytes to LZW compressed bytes and decodes LZW
 * compressed bytes to raw bytes.
 */
class LzwCodec extends Codec<List<int>, List<int>> {
  final LzwOptions options;

  /**
   * Construct a new [LzwCodec] with default options.
   *
   * An instance of [LzwOptions] could be created to use a custom set
   * of options.
   */
  const LzwCodec([this.options = const LzwOptions()]);

  /**
   * Encodes raw bytes to LZW compressed bytes.
   */
  List<int> encode(List<int> input)
    => new LzwEncoder(options).convertSlice(input, 0, input.length, true);

  /**
   * Decodes LZW compressed bytes to raw bytes.
   */
  List<int> decode(List<int> encoded)
    => new LzwDecoder(options).convertSlice(encoded, 0, encoded.length, true);

  /**
   * Get a [Converter] for encoding to LZW compressed data.
   *
   * It is stateful and must not be reused.
   */
  Converter<List<int>, List<int>> get encoder => new LzwEncoder(options);

  /**
   * Get a [Converter] for decoding LZW compressed data.
   *
   * It is stateful and must not be reused.
   */
  Converter<List<int>, List<int>> get decoder => new LzwDecoder(options);
}
