 
 // SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT_USE_PAYMENTS is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string public baseURI;
  string public baseExtension = ".json";
  uint256 public cost = 0.05 ether;
  uint256 public maxSupply = 10000;
  uint256 public maxMintAmount = 20;
  bool public paused = false;
  mapping(address => bool) public whitelisted;
  address payable public payments;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI,
    address _payments
  ) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
    payments = payable(_payments);
    mint(msg.sender, 20);
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }
 
 function presaleMint(bytes32[] memory proof, uint256 numberOfTokens) external override payable {
        require(isPresaleActive, "You cannot mint, sale is inactive.");
        require(!isPublicSaleActive, "You cannot mint, using presale sale mint. ");
        require(merkleRoot != 0, "Currently there are no whitelisted addresses. ");
        require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You are a not in the presale list.");
        require(numberOfGangMembers <= maxPresaleMint, 'Cannot purchase this many tokens on PRE-SALE. ');
        require(_presaleCountClaimedTokens[msg.sender].add(numberOfTokens) <= maxPresaleMint, "Purchase exceeds max allowed presale mints. ");
        require(totalSupply().add(numberOfTokens) <= MAX_PRE_SALE, "The purchase will exceed the member slots for PRE-SALE. ");
        require(MINT_PRESALE_PRICE.mul(numberOfTokens) <= msg.value, "Ether value sent is not enough");

        for(uint i = 0; i < numberOfTokens; i++) {
            uint mintIndex = totalSupply().add(1);
            _presaleCountClaimedTokens[msg.sender] += 1;
            _safeMint(msg.sender, mintIndex);
        }

    }