GUILE_LOAD_PATH=./src
TESTS=$(wildcard t/test-decelle-*.scm)

.PHONY: test

test:
	@for f in $(TESTS); do \
		echo "===> Running $$f"; \
		GUILE_LOAD_PATH=$(GUILE_LOAD_PATH) guile $$f || exit 1; \
	done
	@echo "All tests passed."
