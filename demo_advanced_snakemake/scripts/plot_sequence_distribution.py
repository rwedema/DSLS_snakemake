import matplotlib
matplotlib.use('Agg')

import matplotlib.pyplot as plt

sequence = ''
count_dict = {}

with open(snakemake.input[0]) as file_in:
    next(file_in)
    for line in file_in:
        sequence += line.strip()

for letter in set(sequence):
    count_dict[letter] = sequence.count(letter) / len(sequence)

plt.bar(*zip(*count_dict.items()))
plt.savefig(snakemake.output.svg)
