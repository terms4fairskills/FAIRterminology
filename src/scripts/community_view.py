import csv

from argparse import ArgumentParser


top_levels = [
    {"ID": "T4FS:0000012", "Label": "Data stewardship activity"},
    {"ID": "T4FS:0000446", "Label": "Data stewardship guideline"},
    {"ID": "T4FS:0000548", "Label": "Data stewardship soft skill"},
    {"ID": "T4FS:0000372", "Label": "Data stewardship technical concept"},
    {"ID": "T4FS:0000519", "Label": "Learning medium"},
    {"ID": "T4FS:0000513", "Label": "Role"},
]


def main():
    p = ArgumentParser()
    p.add_argument("query_result")
    p.add_argument("community_view_template")
    args = p.parse_args()

    template = []
    with open(args.query_result, "r") as f:
        reader = csv.reader(f)
        next(f)
        for row in reader:
            template.append({"ID": row[0], "Label": row[1], "Parent": row[2]})

    with open(args.community_view_template, "w") as f:
        writer = csv.DictWriter(f, fieldnames=["ID", "Label", "Parent"])
        writer.writeheader()
        writer.writerow({"ID": "ID", "Label": "LABEL", "Parent": "SC %"})
        writer.writerows(top_levels)
        writer.writerows(template)


if __name__ == "__main__":
    main()
