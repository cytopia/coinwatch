ifneq (,)
.error This Makefile requires GNU Make.
endif

# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
.PHONY: help lint pycodestyle pydocstyle black dist sdist bdist build checkbuild deploy autoformat clean


VERSION = 2.7
BINPATH = bin/
BINNAME = coinwatch

# -------------------------------------------------------------------------------------------------
# Default Target
# -------------------------------------------------------------------------------------------------
help:
	@echo "lint             Lint source code"
	@echo "test             Test source code"
	@echo "build            Build Python package"
	@echo "dist             Create source and binary distribution"
	@echo "sdist            Create source distribution"
	@echo "bdist            Create binary distribution"
	@echo "clean            Build"


# -------------------------------------------------------------------------------------------------
# Lint Targets
# -------------------------------------------------------------------------------------------------

lint: pycodestyle pydocstyle black

pycodestyle:
	docker run --rm -v $(PWD):/data cytopia/pycodestyle --show-source --show-pep8 $(BINPATH)$(BINNAME)

pydocstyle:
	docker run --rm -v $(PWD):/data cytopia/pydocstyle $(BINPATH)$(BINNAME)

black:
	docker run --rm -v ${PWD}:/data cytopia/black -l 100 --check --diff $(BINPATH)$(BINNAME)


# -------------------------------------------------------------------------------------------------
# Test Targets
# -------------------------------------------------------------------------------------------------

test: test-default test-human test-verbose test-ascii test-sort test-example test-row


test-default:
	@echo "--------------------------------------------------------------------------------"
	@echo " Test default"
	@echo "--------------------------------------------------------------------------------"
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		python:$(VERSION)-alpine \
		sh -c "pip install -r requirements.txt \
			&& while ! ./bin/coinwatch -c example/config.yml; do sleep 1; done"

test-human:
	@echo "--------------------------------------------------------------------------------"
	@echo " Test human"
	@echo "--------------------------------------------------------------------------------"
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		python:$(VERSION)-alpine \
		sh -c "pip install -r requirements.txt \
			&& while ! ./bin/coinwatch -h; do sleep 1; done"

test-verbose:
	@echo "--------------------------------------------------------------------------------"
	@echo " Test verbose"
	@echo "--------------------------------------------------------------------------------"
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		python:$(VERSION)-alpine \
		sh -c "pip install -r requirements.txt \
			&& while ! ./bin/coinwatch -v; do sleep 1; done"

test-ascii:
	@echo "--------------------------------------------------------------------------------"
	@echo " Test ascii"
	@echo "--------------------------------------------------------------------------------"
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		python:$(VERSION)-alpine \
		sh -c "pip install -r requirements.txt \
			&& while ! ./bin/coinwatch -t ascii; do sleep 1; done"

test-sort:
	@echo "--------------------------------------------------------------------------------"
	@echo " Test sort"
	@echo "--------------------------------------------------------------------------------"
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		python:$(VERSION)-alpine \
		sh -c "pip install -r requirements.txt \
			&& while ! ./bin/coinwatch -s profit -o desc -g profit; do sleep 1; done"

test-example:
	@echo "--------------------------------------------------------------------------------"
	@echo " Test example"
	@echo "--------------------------------------------------------------------------------"
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		python:$(VERSION)-alpine \
		sh -c "pip install -r requirements.txt \
			&& while ! ./bin/coinwatch -c example/config.yml; do sleep 1; done"

test-row:
	@echo "--------------------------------------------------------------------------------"
	@echo " Test row"
	@echo "--------------------------------------------------------------------------------"
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		python:$(VERSION)-alpine \
		sh -c "pip install -r requirements.txt \
			&& while ! ./bin/coinwatch -r 'name diffprice amount invest wealth profit'; do sleep 1; done"


# -------------------------------------------------------------------------------------------------
# Build Targets
# -------------------------------------------------------------------------------------------------

dist: sdist bdist

sdist:
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		-u $$(id -u):$$(id -g) \
		python:$(VERSION)-alpine \
		python setup.py sdist

bdist:
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		-u $$(id -u):$$(id -g) \
		python:$(VERSION)-alpine \
		python setup.py bdist_wheel --universal

build:
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		-u $$(id -u):$$(id -g) \
		python:$(VERSION)-alpine \
		python setup.py build

checkbuild:
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		python:$(VERSION)-alpine \
		sh -c "pip install twine \
		&& twine check dist/*"


# -------------------------------------------------------------------------------------------------
# Publish Targets
# -------------------------------------------------------------------------------------------------

deploy:
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		python:$(VERSION)-alpine \
		sh -c "pip install twine \
		&& twine upload dist/*"


# -------------------------------------------------------------------------------------------------
# Misc Targets
# -------------------------------------------------------------------------------------------------

autoformat:
	docker run \
		--rm \
		$$(tty -s && echo "-it" || echo) \
		-v $(PWD):/data \
		-w /data \
		cytopia/black -l 100 $(BINPATH)$(BINNAME)
clean:
	-rm -rf $(BINNAME).egg-info/
	-rm -rf dist/
	-rm -rf build/
