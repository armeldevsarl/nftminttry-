// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract myNFT is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint256 maxSupply =10;
    bool public publicMintOpen= false;
    bool public allowListMintOpen = false;
    mapping(address=>bool) public allowList;




    constructor(address initialOwner)
        ERC721("nftBuilder", "nftB")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmWCguX1bBtZydXGQDdUmVfrfWEmaebpjWoBtVBdFnRU8Q/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    
    function unpause() public onlyOwner {
        _unpause();
    }
    //add publicMint and allowListMint options 
    function editMintWindows (
        bool _publicMintOpen,
        bool _allowListMintOpen) external onlyOwner {
        publicMintOpen= _publicMintOpen;
        allowListMintOpen= _allowListMintOpen;
    }
    // add a require to allow only the allowlist people to mint 
    //add allowListMint function 
    function allowListMint () public payable {
        require (allowList[msg.sender],"you are not in the allow List");
        require(allowListMintOpen,"Allow List is Closed ");
        require(msg.value==0.001 ether, "not enough funds");
        internalMint;

    }
    //add the public mint payable and value of the nft
    // add a limiting number of mint

    function publicMint() public payable  {
        require(publicMintOpen,"Public mint closed");
        require(msg.value == 0.01 ether, "not enough fund");
        internalMint;
    }
//add a specific mint function
    function internalMint () internal  {
         require(totalSupply()<maxSupply,"no more supply");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }
// add a withdraw function 
    function withdraw (address _addr) external onlyOwner {
        //get the balance of the contract fist
        uint256 balance= address(this).balance;
        payable(_addr).transfer(balance);

    }

    //ADD addresses to the Allow List 
    function setAllowList(address[] calldata addresses) external onlyOwner { 
        for (uint256 i=0; i<addresses.length; i++){
            allowList[addresses[i]]= true;

    }
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}