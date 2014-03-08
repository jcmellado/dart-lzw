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

import "dart:io" show File;
import "package:lzw/lzw.dart";

/**
 * Compresses one file using LZW.
 *
 * A new file with the same name of the original one but .Z extension
 * will be created. If the .Z file already exists it will be overwritten.
 */
void main(List<String> args) {
  if (args.length != 1) {
    print("Usage: compress file");
    return;
  }

  // Opens the input raw file.
  var input = new File(args[0]).openRead();

  // Opens the output .Z file.
  var output = new File(args[0] + ".Z").openWrite();

  // Set the maximum code length to 16 bits and disable the "End Of Data" mark.
  var codec = const LzwCodec(const LzwOptions(maxCodeLen: 16, end: false));

  // Header: MAGIC1, MAGIC2 and block mode on (0x80) OR max code length (0x10).
  output.add([0x1f, 0x9d, 0x90]);

  // Encodes raw bytes to LZW compressed bytes.
  input.transform(codec.encoder).pipe(output);
}
