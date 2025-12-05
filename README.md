# iris-ml-predictor

- author Suryash Chakravarty, Hooman Esteki, Bright Arafat Bello

## About

In this project we attempt to build a ML classifier to indentify certain flower species based 
on the lengths and widths of petals and sepals. Our model can identify 3 main species of flowers- 
`Setosa`, `Virginica` and `Versicolor`, with a score of 86%.

The dataset used in this project is the `Iris.csv` dataset from the UCI ML Repo, which can be 
found here --> https://archive.ics.uci.edu/dataset/53/iris

Citation --> 
Fisher, R. (1936). Iris [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C56C76.


## Setup

There are 2 recommended ways to work with this repository:

### Option 1 (recommended): Run using Docker Compose 🐳
Use Docker Compose to easily reproduce and run the environment. To start:

#### Start:
```bash
make build
make up
```

#### Stop:
```bash
make stop
```

### Option 2:  Local setup using conda-lock


#### Install dependencies:

```bash
conda install -c conda-forge conda-lock -y
```

#### Create environment:

```bash
conda-lock install --name 522-iris conda-lock.yml
conda activate 522-iris
```

Once done, please navigate to `notebooks/iris_summary.ipynb` and run all cells.


## License

MIT License

Copyright (c) 2025 hoomanesteki

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.




## Scripts for Running

```bash
python scripts/01data_import.py --url="https://archive.ics.uci.edu/static/public/53/iris.zip"  --write_to=data/raw 

python scripts/02validation_splitting.py --raw_data=data/raw/iris.data --data_to=data --seed=522

python scripts/03eda_plots.py --processed_training_data=data/iris_train.csv --plot_to=figures


```