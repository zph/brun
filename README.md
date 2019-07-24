# brun

b-run ie binary run

An attempt to make a generic form of Makefile, that builds and runs
or if no source files have changed since last build, it just runs the binary.

Builds are cached into $TMPDIR and are compared using timestamps to the source
files. Currently setup for use with Crystal projects and experimental
Golang project support.

## Why

I found myself building near identical Makefiles for various projects and wanting
that build or build and run logic to be more generic and re-usable. I appreciated
the idea of crun and gorun, but wanted to try for something cross-language.

It's an experiment :).

## Installation

```
make build && make install
```

## Usage

```
# Build or build and run kit.cr and pass `-h` as argument
brun ~/src/kit/bin/kit.cr -h
```

## Development

Standard crystal project protocol.

## Contributing

1. Fork it (<https://github.com/zph/brun/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Zander Hill](https://github.com/zph) - creator and maintainer
