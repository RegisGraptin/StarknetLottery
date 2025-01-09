# Makefile for Scarb project

# Default target
all: build

# Build the project using Scarb
build:
	@echo "Building the project..."
	scarb build

# Clean the build artifacts
clean:
	@echo "Cleaning build artifacts..."
	scarb clean

# Run tests
test:
	@echo "Running tests..."
	scarb test

# Default target when just running 'make'
.DEFAULT_GOAL := all

# Phony targets (targets that don't represent files)
.PHONY: all build clean test
