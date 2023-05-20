# cutmidel in Zig

An experiment to rewrite [cutmidel] from C to Zig.

The code is practically the same, simpler to write, but the size grew substantially.

| Language |  Size [B] |  Speed [ms] |
|----------|----------:|------------:|
| C        |    49,928 |      0.0055 |
| C++      |    53,104 |      0.0055 |
| Rust     |   300,368 |      0.0060 |
| V        |   490,832 |      0.0075 |
| Zig      |   876,084 |      0.0060 |
| Go       | 1,983,776 |      0.0070 |

See the others in [C++], [Rust], [V] and [Go].

## Build

    zig build
    ./zig-out/bin/cutmidel longtest 1 2

[cutmidel]: https://github.com/prantlf/cutmidel
[C++]: https://github.com/prantlf/cpp-cutmidel
[Rust]: https://github.com/prantlf/rust-cutmidel
[V]: https://github.com/prantlf/v-cutmidel
[Go]: https://github.com/prantlf/go-cutmidel
