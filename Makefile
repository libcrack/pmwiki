.PHONY: run help
.SILENT: run help

LPORT := 8081
LHOST := 0.0.0.0
PHP := $(shell which php)
DOCROOT := .

run:
	$(PHP) -S $(LHOST):$(LPORT) -t $(DOCROOT)

help:
	echo "Usage: $0 help|run"

