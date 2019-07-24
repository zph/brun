BIN := src/brun.cr
output := dist/brun

build: $(output)

$(output): $(wildcard **/*.cr)
	crystal build $(BIN) -o $(output)

install: build
	cp $(output) ~/bin_local && chmod +x ~/bin_local/brun
