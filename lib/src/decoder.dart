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
 * [Converter] for decoding LZW compressed data.
 */
class LzwDecoder extends LzwConverter {
  final LzwOptions _options;

  /// Dictionary code:key, where key = (previous code << 8) | current symbol.
  final Map<int, int> _dictionary = new HashMap<int, int>();

  /// Symbols are stored here.
  final ByteBuffer _buffer = new ByteBuffer();

  /// Codes are read from here.
  LzwReader _reader;

  /// Next code to be added to the dictionary.
  int _nextCode;

  /// Maximum code allowed for the current code length.
  int _maxCode;

  /// "Clear Table" code.
  int _clear;

  /// "End of Data" code.
  int _eod;

  /// Previous key.
  int _prevKey;

  LzwDecoder(this._options) {
    _reader = _options.lsb ? new LsbReader() : new MsbReader();

    _clearTable();

    // Calculate the "Clear Table" code.
    if (_options.blockMode) _clear = 1 << (_options.minCodeLen - 1);

    // Calculate the "End Of Data" code.
    if (_options.end) _eod = 1 << (_options.minCodeLen - 1);
    if (_options.end && _options.blockMode) _eod ++;
  }

  List<int> convert(List<int> chunk) => _convert(chunk.iterator, chunk.length);

  List<int> convertSlice(List<int> chunk, int start, int end, bool isLast)
    => _convert(chunk.getRange(start, end).iterator, end - start, isLast);

  /*
   * Decode.
   */
  List<int> _convert(Iterator<int> codes, int length, [bool isLast = false]) {
    var stack = new List<int>();

    _reader.setInput(codes, length);

    while(_reader.hasData) {
      var code = _reader.read();

      // Clear Table?
      if (code == _clear) {
        _clearTable();
        _prevKey = null;
        continue;
      }

      // End Of Data?
      if (code == _eod) break;

      // Corrupt input?
      if (code > _nextCode) throw new StateError("Unexpected code ($code)");

      // Get the key (aka sequence of symbols) for the current code...
      var key = _dictionary[code];

      // ... or use the key calculated in the previous iteration.
      if (key == null) {
        _dictionary[code] = key = _prevKey; // previous + previous[0]
      }

      // Get the current symbol and write it to the output buffer.
      var symbol = key & 0xff;
      if ((key >> 8) == 0) {
        _buffer.write(symbol);
      } else {

        // Sequences of symbols are written using a stack.
        do {
          stack.add(symbol);
          key = _dictionary[(key >> 8) - 1];
          symbol = key & 0xff;
        } while((key >> 8) != 0);

        stack
          ..add(symbol)
          ..reversed.forEach(_buffer.write)
          ..clear();
      }

      // Add the new entry to the dictionary: (previous code << 8) | current symbol.
      if (_prevKey != null) {
        _dictionary[_nextCode ++] = ((_prevKey >> 8) << 8) | symbol;
      }

      // Calculate the key for the next iteration: (current code << 8) | current symbol.
      _prevKey = ((code + 1) << 8) | symbol;

      // Check limits.
      if (_nextCode == _maxCode) {
        if (_reader.codeLen < _options.maxCodeLen) {

          // Increase the code lenght.
          _reader.codeLen ++;

          // Calculate the maximum code allowed for the new code length.
          _maxCode = 1 << _reader.codeLen;
          if (_options.earlyChange) _maxCode --;
        }
      }
    }

    _reader.flush();

    return _buffer.takeBytes();
  }

  List<int> flush() => const [];

  /**
   * Clear the dictionary.
   */
  void _clearTable() {
    _dictionary.clear();

    // Initialize the first entries in the dictionary.
    for (var i = (1 << (_options.minCodeLen - 1)) - 1; i >= 0; -- i) {
      _dictionary[i] = i;
    }

    // Set the initial code length.
    _reader.codeLen = _options.minCodeLen;

    // Calculate the next code to be added to the dictionary.
    _nextCode = 1 << (_options.minCodeLen - 1);
    if (_options.blockMode) _nextCode ++;
    if (_options.end) _nextCode ++;

    // Calculate the maximum code allowed for the current code length.
    _maxCode = 1 << _options.minCodeLen;
    if (_options.earlyChange) _maxCode --;
  }
}
