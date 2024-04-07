import { parseEther } from "viem";
import contractsMetadata from "../public/contractsMetadata";
import { useWriteContract } from "wagmi";

const ClaimNFT = () => {
  const { data: hash, writeContract } = useWriteContract();

  const mintNFT = async () => {
    writeContract({
      address: contractsMetadata.vrum.address,
      abi: contractsMetadata.vrum.abi,
      functionName: "mintToMe",
      args: [],
      value: parseEther('0.08'),
    });
  }

  return (
    <button onClick={() => mintNFT()}>
      {hash ? "Claiming..." : "Claim Your Free NFT"}
    </button>
  );
};

export default ClaimNFT;
