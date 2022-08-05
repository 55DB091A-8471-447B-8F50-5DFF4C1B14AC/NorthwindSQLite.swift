.PHONY: clean build run docs
.DEFAULT_GOAL := build


bootstrap:
	brew install sqlite
	brew install graphviz

clean:
	rm -rf ./dist
	mkdir ./dist

build: clean
	touch dist/MarkAsSwift.swift
	sqlite3 dist/northwind.db < src/create.sql > /dev/null
	sqlite3 dist/northwind.db < src/update.sql > /dev/null
	sqlite3 dist/northwind.db < src/report.sql

populate:
	python3 ./src/populate.py
	sqlite3 dist/northwind.db < src/report.sql

report:
	sqlite3 dist/northwind.db < src/report.sql

BASEPATH="/NorthwindSQLite.swift/"
OUTPUT_PATH="$(PWD)/docs"

docs:
	swift package \
	  --allow-writing-to-directory "$(OUTPUT_PATH)" \
	  generate-documentation \
	  --target Northwind \
	  --disable-indexing \
	  --transform-for-static-hosting \
	  --hosting-base-path "$(BASEPATH)" \
	  --output-path "$(OUTPUT_PATH)"
	cp docs-index.html docs/

# http://localhost:8000/documentation/Northwind
preview:
	swift package --disable-sandbox \
		preview-documentation --target Northwind
