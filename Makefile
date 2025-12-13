# Global Settings and Phony Targets
.DEFAULT_GOAL := help

.PHONY: help all dockerbuild cl env build run up stop docker-build-push \
        docker-build-local clean

#--------------------------------
# Analysis Pipeline:

#1. Data Import
data/raw/iris.data: scripts/01data_import.py
	python scripts/01data_import.py \
		--url="https://archive.ics.uci.edu/static/public/53/iris.zip" \
		--write_to=data/raw

#2. Validation and Splitting
data/processed/iris_validated.csv \
data/processed/iris_train.csv \
data/processed/iris_test.csv \
data/processed/X_train.csv \
data/processed/y_train.csv \
data/processed/X_test.csv \
data/processed/y_test.csv : scripts/02validation_splitting.py data/raw/iris.data
	python scripts/02validation_splitting.py \
		--raw_data=data/raw/iris.data \
		--data_to=data/processed

#3. EDA Plots
results/figures/pairplot.png \
results/figures/corr.png \
results/figures/histplot.png : scripts/03eda_plots.py data/processed/iris_train.csv
	python scripts/03eda_plots.py \
		--processed_training_data=data/processed/iris_train.csv \
		--plot_to=results/figures

#4. Model Training
results/models/tree_model.pkl: scripts/model.py \
                               data/processed/X_train.csv \
                               data/processed/y_train.csv
	python scripts/model.py \
		--training_data=data/processed \
		--model_to=results/models

#5. Metrics Generation
results/metrics/metrics_summary.csv: scripts/05metrics.py \
                                     results/models/tree_model.pkl \
                                     data/processed/X_test.csv \
                                     data/processed/y_test.csv
	python scripts/05metrics.py \
		--test_data=data/processed \
		--model_from=results/models \
		--metrics_to=results/metrics \
		--plot_to=results/figures

#6. Report Generation
reports/iris_report.html reports/iris_report.pdf: \
    reports/iris_report.qmd \
    reports/references.bib \
    results/metrics/metrics_summary.csv \
    results/figures/pairplot.png \
    results/figures/corr.png \
    results/figures/histplot.png
	quarto render reports/iris_report.qmd --to html
	quarto render reports/iris_report.qmd --to pdf

#7. Clean
clean:
	rm -f data/raw/*
	rm -f data/processed/*
	rm -f results/models/*
	rm -f results/figures/*
	rm -f results/metrics/*
	rm -f reports/iris_report.html reports/iris_report.pdf
	rm -rf reports/iris_report_files

#8. End-to-end analysis pipeline 
all: reports/iris_report.html reports/iris_report.pdf
	@echo "Full analysis pipeline completed (data > split > eda > model > metrics > report)"

#--------------------------------
# Docker and Enviroment Workflow

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2}'

dockerbuild: ## regenerate env + build docker
	make cl
	make env
	make build

cl: ## create conda lock for all platforms
	conda-lock lock \
		--file environment.yml \
		-p linux-64 -p osx-64 -p osx-arm64 -p win-64 -p linux-aarch64

env: ## recreate environment from lock file
	conda env remove -n 522-iris || true
	conda-lock install -n 522-iris conda-lock.yml

build: ## build docker image
	docker build -t esteki/iris-ml-predictor:latest --file Dockerfile .

run: ## docker-compose up
	make up

up: ## start services
	make stop
	docker-compose up

stop: ## stop services
	docker-compose stop

docker-build-push: ## multi-arch build + push
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--tag esteki/iris-ml-predictor:latest \
		--tag esteki/iris-ml-predictor:local-$(shell git rev-parse --short HEAD) \
		--push .

docker-build-local: ## local architecture build
	docker build --tag esteki/iris-ml-predictor:local .
