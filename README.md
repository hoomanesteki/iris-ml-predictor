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

To setup, please clone this repository from Github onto your computer.

The dependencies and packages needed to run this project successfully can be installed by running 
the following code blocks sequentially in your terminal.

```bash
conda env create -f environment.yml
conda activate 522-iris
```

Once done, please navigate to `iris_summary.ipynb` and run all cells.


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