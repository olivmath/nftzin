import os
import json
import hashlib
import random


micro_phrases = {
    "background_color": {
        "background-blue": ["Under an endless blue sky,", "With the calm of the deep blue,"],
        "background-purple": ["Under the light of a purple twilight,", "Wrapped in purple mystery,"],
        "background-yellow": ["Under the vibrant yellow sun,", "Lit by a yellow glow,"],
        "background-green": ["Among whispering green leaves,", "With the freshness of green nature,"],
        "background-red": ["Under the heat of a red sun,", "In a world dyed red,"],
    },
    "speed": {
        "0": ["stopped in time,", "in a tranquil pause,"],
        "30": ["crosses the streets with agility,", "on a serene ride,"],
        "50": ["with the speed of a fast river,", "at a steady pace,"],
        "100": ["flying like the wind,", "breaking speed barriers,"],
    },
    "car_model": {
        "hatch": ["a compact and stylish hatch", "a nimble city hatch"],
        "suv": ["a robust SUV for adventures", "a spacious and comfortable SUV"],
        "pickup": ["a pickup ready for hard work", "a versatile pickup for all terrains"],
    },
    "wheel_color": {
        "wheel-yellow": ["with wheels that capture the sun.", "and highlighted yellow wheels."],
        "wheel-red": ["with wheels of passion.", "and vibrant red wheels."],
        "wheel-blue": ["with wheels like the ocean.", "and calming blue wheels."],
        "wheel-green": ["with wheels that reflect nature.", "and lively green wheels."],
    }
}


# Exemplo de listas de características - ajuste conforme necessário
background_colors = ["background-blue", "background-purple", "background-yellow", "background-green", "background-red"]
speeds = ["0", "30", "50", "100"]
car_models = [
    "hatch-blue",
    "hatch-purple",
    "hatch-yellow",
    "hatch-green",
    "hatch-red",
    "suv-blue",
    "suv-purple",
    "suv-yellow",
    "suv-green",
    "suv-red",
    "pickup-blue",
    "pickup-purple",
    "pickup-yellow",
    "pickup-green",
    "pickup-red",
]
wheel_colors = ["wheel-yellow", "wheel-red", "wheel-blue", "wheel-green"]


# Generate a unique description and description_id for an NFT
def generate_description_and_id(bg_color, speed, car_model, wheel_color):
    """
    Generate a unique description and a SHA256 hash as description_id.
    """
    phrases = [
        random.choice(micro_phrases["background_color"][bg_color]),
        random.choice(micro_phrases["speed"][speed]),
        random.choice(micro_phrases["car_model"][car_model.split("-")[0]]),
        random.choice(micro_phrases["wheel_color"][wheel_color])
    ]
    description = ' '.join(phrases)
    description_id = hashlib.sha256(description.encode()).hexdigest()
    return description, description_id

# Generate a unique NFT suggestion
def generate_unique_nft_suggestion(ids_seen):
    """
    Generates a unique NFT suggestion that does not exist in ids_seen.
    """
    while True:
        bg_color = random.choice(background_colors)
        speed = random.choice(speeds)
        car_model = random.choice(car_models)
        wheel_color = random.choice(wheel_colors)
        suggestion = f"{bg_color};{speed};{car_model};{wheel_color}.png"
        suggestion_id = hashlib.sha256(suggestion.encode()).hexdigest()
        if suggestion_id not in ids_seen:
            return suggestion

# Write rarity statistics to a Markdown file
def write_stats_to_markdown(attribute_frequencies, counter):
    """
    Write rarity statistics for each attribute to a Markdown file.
    """
    with open("RarityStats.md", "w") as md_file:
        md_file.write("# NFT Rarity Statistics\n\n")
        for attribute, frequencies in attribute_frequencies.items():
            md_file.write(f"## {attribute}\n")
            md_file.write("| Value | Rarity (%) |\n")
            md_file.write("|-------|------------|\n")
            for value, count in frequencies.items():
                rarity = (count / (counter-1)) * 100
                md_file.write(f"| {value} | {rarity:.2f}% |\n")
            md_file.write("\n")

# Main process
def main():
    """
    Main process for generating NFT metadata and writing rarity statistics.
    """
    images_path = './cars/images/'
    metadata_path = './cars/metadata/'

    # Ensure metadata directory exists
    os.makedirs(metadata_path, exist_ok=True)

    counter = 1
    ids_seen = set()
    attribute_frequencies = {"background_color": {}, "speed": {}, "car_model": {}, "wheel_color": {}}

    for filename in os.listdir(images_path):
        if not filename.endswith(".png"):
            continue

        bg_color, speed, car_model, wheel_color = filename.split(".png")[0].split(";")

        nft_id = hashlib.sha256(filename.encode()).hexdigest()

        if nft_id in ids_seen:
            suggestion = generate_unique_nft_suggestion(ids_seen)
            print(f"Duplicated: {filename}\nSuggestion: {suggestion}")
            continue
        ids_seen.add(nft_id)

        description, description_id = generate_description_and_id(bg_color, speed, car_model, wheel_color)

        metadata = {
            "nft_id": nft_id,
            "description_id": description_id,
            "name": f"NFT #{counter}",
            "description": description,
            "image": "ipfs://<CID>/{counter}.png",
            "attributes": [
                {"trait_type": "background_color", "value": bg_color},
                {"trait_type": "speed", "value": speed},
                {"trait_type": "car_model", "value": car_model},
                {"trait_type": "wheel_color", "value": wheel_color},
            ],
        }

        for attribute, value in [
            ("background_color", bg_color),
            ("speed", speed),
            ("car_model", car_model),
            ("wheel_color", wheel_color),
        ]:  
            attribute_frequencies[attribute].setdefault(value, 0)
            attribute_frequencies[attribute][value] += 1

        with open(f"{metadata_path}/{counter}.json", 'w') as f:
            json.dump(metadata, f, indent=4)

        src = os.path.join(images_path, filename)
        dst = os.path.join(metadata_path, f"{counter}.png")
        os.rename(src, dst)

        counter += 1

    write_stats_to_markdown(attribute_frequencies, counter)
    print(f"\nMetadata for {counter-1} unique NFTs generated.")

if __name__ == "__main__":
    main()
