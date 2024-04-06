import os
import json

folder_path = './cars/metadata/'
CID = "QmcRNcm7n4W2zUF81r3JPXXL2N4FrvL86ukkdEfMbCA3bL"

for filename in os.listdir(folder_path):
    src = os.path.join(folder_path, filename)
    if os.path.isfile(src):
        with open(src, 'rb') as metadata_file:
            metadata = json.loads(metadata_file.read())
            counter = int(src.rstrip(".json").split("/")[-1])
            metadata["image"] = f"ipfs://{CID}/{counter}.png"
            print("Reading metadata", metadata["image"])

            with open(src, 'w') as new_metadata_file:
                new_metadata_file.write(json.dumps(metadata))

