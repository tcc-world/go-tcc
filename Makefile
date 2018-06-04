# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: tcc android ios tcc-cross swarm evm all test clean
.PHONY: tcc-linux tcc-linux-386 tcc-linux-amd64 tcc-linux-mips64 tcc-linux-mips64le
.PHONY: tcc-linux-arm tcc-linux-arm-5 tcc-linux-arm-6 tcc-linux-arm-7 tcc-linux-arm64
.PHONY: tcc-darwin tcc-darwin-386 tcc-darwin-amd64
.PHONY: tcc-windows tcc-windows-386 tcc-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

tcc:
	build/env.sh go run build/ci.go install ./cmd/tcc
	@echo "Done building."
	@echo "Run \"$(GOBIN)/tcc\" to launch tcc."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/tcc.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/TCC.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

tcc-cross: tcc-linux tcc-darwin tcc-windows tcc-android tcc-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/tcc-*

tcc-linux: tcc-linux-386 tcc-linux-amd64 tcc-linux-arm tcc-linux-mips64 tcc-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-*

tcc-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/tcc
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep 386

tcc-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/tcc
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep amd64

tcc-linux-arm: tcc-linux-arm-5 tcc-linux-arm-6 tcc-linux-arm-7 tcc-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep arm

tcc-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/tcc
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep arm-5

tcc-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/tcc
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep arm-6

tcc-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/tcc
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep arm-7

tcc-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/tcc
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep arm64

tcc-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/tcc
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep mips

tcc-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/tcc
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep mipsle

tcc-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/tcc
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep mips64

tcc-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/tcc
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/tcc-linux-* | grep mips64le

tcc-darwin: tcc-darwin-386 tcc-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/tcc-darwin-*

tcc-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/tcc
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-darwin-* | grep 386

tcc-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/tcc
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-darwin-* | grep amd64

tcc-windows: tcc-windows-386 tcc-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/tcc-windows-*

tcc-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/tcc
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-windows-* | grep 386

tcc-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/tcc
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/tcc-windows-* | grep amd64
