.PHONY: all clean scratch cl build stop up run

all:
	make reports/reports/iris_report.html

clean:
	rm -f results/figures/*.png
	rm -f results/metrics/*.csv
	rm -f results/models/*.pkl
	rm -f data/raw/*.data
	rm -f data/processed/*.csv
	rm -f reports/reports/*.pdf
	rm -f reports/results/figures/*.png
	rm -f reports/reports/*.html
	rm -rf reports/iris_report_files
	@echo "All files deleted."

scratch:
	make clean
	python scripts/01data_import.py \
		--url="https://archive.ics.uci.edu/static/public/53/iris.zip" \
		--write_to=data/raw
	python scripts/02validation_splitting.py \
		--raw_data=data/raw/iris.data \
		--data_to=data/processed
	python scripts/03eda_plots.py \
		--processed_training_data=data/processed \
		--plot_to=results/figures
	python scripts/model.py \
		--training_data=data/processed \
		--model_to=results/models
	python scripts/05metrics.py \
		--test_data=data/processed \
		--model_from=results/models \
		--metrics_to=results/metrics \
		--plot_to=results/figures
	quarto render reports/iris_report.qmd
	@echo "Output available at reports/"

reports/reports/iris_report.html: reports/iris_report.qmd \
			results/metrics/metrics_summary.csv \
			results/figures/pairplot.png \
			results/figures/corr.png \
			results/figures/histplot.png \
			results/figures/confusion_matrix.png
	quarto render reports/iris_report.qmd
	@echo "Output available at reports/"

results/metrics/metrics_summary.csv results/figures/confusion_matrix.png: scripts/05metrics.py \
																	models/tree_model.pkl \
																	data/processed/X_test.csv \
																	data/processed/y_test.csv
	python scripts/05metrics.py \
		--test_data=data/processed \
		--model_from=results/models \
		--metrics_to=results/metrics \
		--plot_to=results/figures
	
models/tree_model.pkl: scripts/model.py \
					data/processed/X_train.csv \
					data/processed/y_train.csv
	python scripts/model.py \
		--training_data=data/processed \
		--model_to=results/models

results/figures/pairplot.png results/figures/corr.png results/figures/histplot.png: scripts/03eda_plots.py \
																		data/processed/iris_train.csv
	python scripts/03eda_plots.py \
		--processed_training_data=data/processed \
		--plot_to=results/figures

data/processed/X_train.csv data/processed/y_train.csv data/processed/X_test.csv data/processed/y_test.csv: scripts/02validation_splitting.py \
																									data/raw/iris.data
	python scripts/02validation_splitting.py \
		--raw_data=data/raw/iris.data \
		--data_to=data/processed

data/raw/iris.data: scripts/01data_import.py
	python scripts/01data_import.py \
		--url="https://archive.ics.uci.edu/static/public/53/iris.zip" \
		--write_to=data/raw

cl:
	conda-lock lock \
		--file environment.yml \
		-p linux-64 -p osx-64 -p osx-arm64 -p win-64 -p linux-aarch64

build:
	docker build -t esteki/iris-ml-predictor:latest --file Dockerfile .

stop:
	docker-compose stop

up:
	make stop
	docker-compose up

run:
	make up