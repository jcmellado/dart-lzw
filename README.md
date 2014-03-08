LZW data compression.

### Usage ###

Encode:

```
var encoded = LZW.encode([ /* raw bytes */ ]);
```

Decode:

```
var raw = LZW.decode([ /* encoded bytes */ ]);
```

Take a look at the `example` folder to know how to use the library to compress
and decompress files.

### Options ###

The class `LzwOption` can be used if more control over the process is needed.

```
var options = new LzwOptions(lsb: false, clear: true);

var codec = new LzwCodec(options);

codec.encode([ /* raw bytes */ ]);

codec.decode([ /* encoded bytes */ ]);
```

Read the documentation of the `LzwOption` class to know all the available options.
