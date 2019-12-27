build:  ## Build the repository
	python3 setup.py build 

tests: ## Clean and Make unit tests
	python3 -m pytest -v greeks/tests --cov=greeks

test: lint ## run the tests for travis CI
	@ python3 -m pytest -v greeks/tests --cov=greeks

lint: ## run linter
	flake8 greeks 

fix:  ## run autopep8/tslint fix
	autopep8 --in-place -r -a -a greeks/

annotate: ## MyPy type annotation check
	mypy -s greeks  

annotate_l: ## MyPy type annotation check - count only
	mypy -s greeks | wc -l 

clean: ## clean the repository
	find . -name "__pycache__" | xargs  rm -rf 
	find . -name "*.pyc" | xargs rm -rf 
	find . -name ".ipynb_checkpoints" | xargs  rm -rf 
	rm -rf .coverage cover htmlcov logs build dist *.egg-info
	rm -rf ./*.gv*
	make -C ./docs clean

install:  ## install to site-packages
	pip3 install .

docs:  ## make documentation
	make -C ./docs html
	open ./docs/_build/html/index.html

dist:  ## dist to pypi
	rm -rf dist build
	python3 setup.py sdist
	python3 setup.py bdist_wheel
	twine check dist/* && twine upload dist/*

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean build run test tests help annotate annotate_l docs dist
