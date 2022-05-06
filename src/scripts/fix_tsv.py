import csv
import itertools

from argparse import ArgumentParser


p = ArgumentParser()
p.add_argument("paths", nargs="+")
args = p.parse_args()

for path in args.paths:
	with open(path, "r") as f:
		reader = csv.reader(f, delimiter="\t")
		first_row = next(reader)
		max_len = len(first_row)
		new_lines = [first_row]
		for row in reader:
			include = itertools.islice(row, max_len)
			new_lines.append(include)

	with open(path, "w") as f:
		writer = csv.writer(f, delimiter="\t", lineterminator="\n")
		writer.writerows(new_lines)
