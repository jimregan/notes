import json
import csv



def update_json_snippets_from_csv(json_path, csv_path, output_path):
    # Load JSON
    with open(json_path, 'r') as f:
        json_data = json.load(f)

    # Load CSV and store snippets by (start, end)
    csv_snippets = {}
    with open(csv_path, 'r') as f:
        reader = csv.reader(f, delimiter='\t')
        for row in reader:
            if len(row) != 3:
                continue
            try:
                start = round(float(row[0]), 3)
                end = round(float(row[1]), 3)
                snippet = row[2]
                csv_snippets[(start, end)] = snippet
            except ValueError:
                continue

    # Replace JSON snippets based on matching start/end
    for entry in json_data.values():
        start = round(entry['general']['start'], 3)
        end = round(entry['general']['end'], 3)
        if (start, end) in csv_snippets:
            entry['snippet'] = csv_snippets[(start, end)]

    # Save updated JSON
    with open(output_path, 'w') as f:
        json.dump(json_data, f, indent=2)

    print(f"Updated JSON saved to: {output_path}")


json_file = ".//hsi_5_0718_209_003.json"
csv_file = "/home/deichler/data/sgs_recordings/hsi/sentence_tsvs_cut_new/hsi_5_0718_209_003_main.csv"
output_file = "./hsi_5_0718_209_003_main_updated.json"

update_json_snippets_from_csv(json_file, csv_file, output_file)
