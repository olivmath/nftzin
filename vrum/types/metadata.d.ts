export interface Attributes {
    trait_type: string;
    value: string;
}

export interface NFTMetadata {
  nft_id: string;
  description_id: string;
  name: string;
  description: string;
  image: string;
  attributes:  Attributes[];
}
