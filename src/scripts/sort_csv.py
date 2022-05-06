import csv
import json

from argparse import ArgumentParser


def sort_terms(node, parent_children, hierarchy):
    """Recursively create a list of nodes grouped by category."""
    for c in parent_children.get(node, []):
        hierarchy.append(c)
        sort_terms(c, parent_children, hierarchy)
    return hierarchy


p = ArgumentParser()
p.add_argument("input")
p.add_argument("output")
args = p.parse_args()

terms = {}
parent_children = {}
with open(args.input, "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        label = row["LABEL"].strip()
        parent = row["SubClass Of"].strip()
        terms[label] = {"ID": row["ID"], "Definition": row["definition"], "Category": parent}
        if not parent:
            parent = ""
        if parent in parent_children:
            children = parent_children[parent]
        else:
            children = []
        children.append(label)
        parent_children[parent] = children

hierarchy = sort_terms("", parent_children, [])

rows = []
for term in hierarchy:
    row = terms[term]
    row["Label"] = term
    rows.append(row)

with open(args.output, "w") as f:
    writer = csv.DictWriter(
        f, fieldnames=["Category", "ID", "Label", "Definition"], lineterminator="\n"
    )
    writer.writeheader()
    writer.writerows(rows)
