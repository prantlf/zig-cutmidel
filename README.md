# cutmidel in Zig

An experiment to rewrite [cutmidel] from C to Zig.

The code is shorter and simpler to write, but the size grew substantially.

| Language |  Size [B] |  Speed [ms] |
|----------|----------:|------------:|
| C        |    49,928 |      0.0055 |
| V        |   490,832 |      0.0075 |
| Zig      |   877,054 |      0.0060 |
| Go       | 1,983,776 |      0.0070 |

## Build

    zig build
    ./zig-out/bin/cutmidel longtest 1 2

[cutmidel]: https://github.com/prantlf/cutmidel
