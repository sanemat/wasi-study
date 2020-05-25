.PHONY: test
test:
	wasmtime wast examples/*.wast
