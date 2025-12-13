import pandas as pd
import seaborn as sns 
import matplotlib.pyplot as plt
import os
import click

def create_dir_if_not_exists(directory):
        os.makedirs(directory, exist_ok=True)

@click.command()
@click.option('--processed_training_data', type=str, help="Path to folder of processed training data")
@click.option('--plot_to', type=str, help="Path to directory where the plot will be written to")

def main(processed_training_data, plot_to):
    '''
    creates a pairwise comparison plot, heatmap and histogram for the features of the iris.csv training data set.
    
    :param processed_training_data: full path to the repo where training data is saved
    :param plot_to: directory for where to save the images
    '''

    #check if plots directory exists, if not create it
    create_dir_if_not_exists(plot_to)

    #load the data
    iris_train = pd.read_csv(os.path.join(processed_training_data, "iris_train.csv"))

    #create pair plot
    pairplt = sns.pairplot(iris_train, hue='class')
    pairplt.figure.suptitle("Pairwise plot of all features", y=1.02, fontsize=16)
    pairplt.figure.savefig(os.path.join(plot_to, "pairplot.png"),bbox_inches='tight')

    #create heatmap
    plt.figure(figsize=(8, 6))
    plt_corr = sns.heatmap(
        iris_train.drop(columns=['class'], axis=1).corr(),
        annot=True
    )
    plt.tight_layout()
    plt.savefig(os.path.join(plot_to, "corr.png"),bbox_inches='tight')
    plt.close()

    #create histogram
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
    plt.savefig(os.path.join(plot_to, "histplot.png"),bbox_inches='tight')
    plt.close()

if __name__ == '__main__':
      main()