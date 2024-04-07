import { useEffect, useState } from "react";
import { pinataUri } from "../services/convertURI.service";
import { NFTMetadata } from "../types/metadata";

interface NFTCardProps {
  metadataUrl: string;
}

const NFTCard: React.FC<NFTCardProps> = ({ metadataUrl }) => {
  const [metadata, setMetadata] = useState<NFTMetadata | null>(null);

  useEffect(() => {
    const getMetadata = async (uri: string) => {
      const response = await fetch(uri);
      const data: NFTMetadata = await response.json();
      // Atualize o estado dos metadados já com a URL da imagem convertida
      setMetadata({ ...data, image: pinataUri(data.image) });
    };
    getMetadata(pinataUri(metadataUrl));
  }, [metadataUrl]);

  if (!metadata) return <div>Loading...</div>;

  return (
    <div style={{ margin: "10px", padding: "10px", border: "1px solid black" }}>
      {/* Use diretamente metadata.image, já que agora é uma URL HTTP acessível */}
      <img src={metadata.image} alt={metadata.name} style={{ width: "100px" }} />
      <h3>{metadata.name}</h3>
      <p>{metadata.description}</p>
    </div>
  );
};

export default NFTCard;
