// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();

contract NFTzin is ERC721, Ownable {
    using Strings for uint256;

    string public baseURI;
    uint256 public currentTokenId;
    uint256 public constant TOTAL_SUPPLY = 100;
    uint256 public constant MINT_PRICE = 0.00008 ether;

    mapping(address => uint256[]) myNFTs;

    constructor(string memory _name, string memory _symbol, string memory _baseURI)
        ERC721(_name, _symbol)
        Ownable(msg.sender)
    {
        baseURI = _baseURI;
    }

    function mintTo(address recipient) public payable returns (uint256) {
        // TODO: quanto mais pagar melhor o NFT
        if (msg.value < MINT_PRICE) {
            revert MintPriceNotPaid();
        }
        uint256 newTokenId = currentTokenId + 1;
        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }
        currentTokenId = newTokenId;
        _safeMint(recipient, newTokenId);
        myNFTs[msg.sender].push(newTokenId);
        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert NonExistentTokenURI();
        } else {
            return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".png")) : "";
        }
    }

    function withdrawPayments(address payable payee) external onlyOwner {
        if (address(this).balance == 0) {
            revert WithdrawTransfer();
        }

        payable(payee).transfer(address(this).balance);
    }

    function _checkOwner() internal view override {
        require(msg.sender == owner(), "Ownable: caller is not the owner");
    }

    function getMyNFTs() external returns (uint256[] memory) {
        return myNFTs[msg.sender];
    }
}
