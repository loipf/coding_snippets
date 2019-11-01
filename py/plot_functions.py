import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
import numpy as np



# np.array as input
def plot_binhex(x, y, title=None, ylab=None, xlab=None, axis_limit=None, center=True, output_file=None):
    x = x[~np.isnan(x)]  # automatically flattens 2d array
    y = y[~np.isnan(y)]

    if len(x) != len(y):
        print("different length of input, nan maybe: len(x)={}, len(y)={}".format(len(x),len(y)))
        return None

    if axis_limit is None:
        try:
            axis_limit = max(max(map(abs, x)), max(map(abs, y)))  ## make easier
        except:
            axis_limit = 22
    else:
        x = np.minimum(x, axis_limit*0.97)  # values bigger limit on corner
        y = np.minimum(y, axis_limit*0.97)

    fig, ax = plt.subplots()
    h = ax.hist2d(x, y, 100, norm=LogNorm(), cmap='summer')
    fig.colorbar(h[3], ax=ax)

    if center:
        ax.set_ylim(-axis_limit, axis_limit)
        ax.set_xlim(-axis_limit, axis_limit)
    if center is False and axis_limit is not None:
        ax.set_ylim(0, axis_limit)
        ax.set_xlim(0, axis_limit)

    ax.plot([0, 1], [0, 1], transform=ax.transAxes, c="black")  # diagonale
    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)
    ax.set_title(title)

    if output_file is None:
        plt.show()
    else:
        plt.savefig(output_file, bbox_inches='tight')
    plt.clf()






