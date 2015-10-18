PREFIX=/usr/local
VERSION=$(shell git describe)-$(shell date -u +%Y%m%d.%H%M%S)

go build -ldflags "-X main.Version ${VERSION}" -o apiwiki
