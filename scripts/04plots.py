import pandas as pd
import seaborn as sns 
import matplotlib.pyplot as plt
import os

directory = "figures"

def create_dir_if_not_exists(directory):
        os.makedirs(directory, exist_ok=True)

create_dir_if_not_exists(directory)

iris_train = pd.read_csv("data/iris_train.csv")

pairplt = sns.pairplot(iris_train, hue='class')
pairplt.fig.suptitle("Pairwise plot of all features", y=1.02, fontsize=16)
pairplt.fig.tight_layout()
pairplt.fig.savefig("figures/pairplot.png",bbox_inches='tight')

plt.figure(figsize=(8, 6))
plt_corr = sns.heatmap(
    iris_train.drop(columns=['class'], axis=1).corr(),
    annot=True
)
plt.tight_layout()
plt.savefig("figures/corr.png")
plt.close()

plt.figure(figsize=(8, 6))
histplot = sns.histplot(
    data=iris_train, 
    x='petal width', 
    hue='class', 
    bins=50, 
    alpha=0.5,
    multiple='layer'

)
histplot.set_title('Distribution of Petal Width by Flower Species')
plt.tight_layout()
plt.savefig("figures/histplot.png")
plt.close()