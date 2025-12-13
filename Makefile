.PHONY: all clean scratch cl build stop up run

all:
	make reports/iris_report.html

clean:
	rm -f reports/results/figures/*.png
	rm -f reports/results/metrics/*.csv
	rm -f reports/results/models/*.pkl
	rm -f data/raw/*.data
	rm -f data/processed/*.csv
	rm -f reports/*.pdf
	rm -f reports/*.html
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
		--plot_to=reports/results/figures
	python scripts/model.py \
		--training_data=data/processed \
		--model_to=reports/results/models
	python scripts/05metrics.py \
		--test_data=data/processed \
		--model_from=reports/results/models \
		--metrics_to=reports/results/metrics \
		--plot_to=reports/results/figures
	quarto render reports/iris_report.qmd
	@echo "Output available at reports/"

reports/iris_report.html: reports/iris_report.qmd \
			reports/results/metrics/metrics_summary.csv \
			reports/results/figures/pairplot.png \
			reports/results/figures/corr.png \
			reports/results/figures/histplot.png \
			reports/results/figures/confusion_matrix.png
	quarto render reports/iris_report.qmd
	@echo "Output available at reports/"

reports/results/metrics/metrics_summary.csv reports/results/figures/confusion_matrix.png: scripts/05metrics.py \
																	reports/results/models/tree_model.pkl \
																	data/processed/X_test.csv \
																	data/processed/y_test.csv
	python scripts/05metrics.py \
		--test_data=data/processed \
		--model_from=reports/results/models \
		--metrics_to=reports/results/metrics \
		--plot_to=reports/results/figures
	
reports/results/models/tree_model.pkl: scripts/model.py \
					data/processed/X_train.csv \
					data/processed/y_train.csv
	python scripts/model.py \
		--training_data=data/processed \
		--model_to=reports/results/models

reports/results/figures/pairplot.png reports/results/figures/corr.png reports/results/figures/histplot.png: scripts/03eda_plots.py \
																		data/processed/iris_train.csv
	python scripts/03eda_plots.py \
		--processed_training_data=data/processed \
		--plot_to=reports/results/figures

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