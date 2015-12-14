.PHONY: all clean
.SILENT: all clean

PHP := $(shell which php)
ARGS := -S 0.0.0.0:8282 -t .

run:
	$(PHP) $(ARGS)

help:
	echo "Usage: $0 start|stop|run"

