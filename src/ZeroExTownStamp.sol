// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Ownable} from "solady/auth/Ownable.sol";
import {ERC721} from "solady/tokens/ERC721.sol";
import {Initializable} from "solady/utils/Initializable.sol";
import {LibString} from "solady/utils/LibString.sol";

contract ZeroExTownStamp is ERC721, Ownable, Initializable {
    error MintNotAllowed();
    error TransferNotAllowed();

    bool public mintAllowed;
    bool public transferAllowed;
    uint public totalSupply;
    string public baseURI;

    mapping(uint => address) public visitors;
    mapping(uint => uint) public timestamps;
    mapping(address => uint) public numbers;

    function name() public pure override returns (string memory) {
        return "0xTOWNSTAMP";
    }

    function symbol() public pure override returns (string memory) {
        return "0xTOWNSTAMP";
    }

    function tokenURI(uint id) public view override returns (string memory) {
        string memory uri = LibString.concat(baseURI, LibString.toString(id));
        string memory visitor = LibString.concat("?visitor=", LibString.toHexString(visitors[id]));
        string memory owner = LibString.concat("&owner=", LibString.toHexString(ownerOf(id)));
        string memory ts = LibString.concat("&ts=", LibString.toString(timestamps[id]));
        return string(abi.encodePacked(uri, visitor, owner, ts));
    }

    function initialize(string calldata _baseURI, address owner) external initializer {
        baseURI = _baseURI;
        _initializeOwner(owner);
    }

    function mint() external {
        if (!mintAllowed || numbers[msg.sender] != 0) {
            revert MintNotAllowed();
        }
        uint tokenId = ++totalSupply;
        visitors[tokenId] = msg.sender;
        timestamps[tokenId] = block.timestamp;
        numbers[msg.sender] = tokenId;
        _mint(msg.sender, tokenId);
    }

    function setMintAllowed(bool allowed) external onlyOwner {
        mintAllowed = allowed;
    }

    function setTransferAllowed(bool allowed) external onlyOwner {
        transferAllowed = allowed;
    }

    function setBaseURI(string calldata _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

    function _beforeTokenTransfer(address from, address, uint) internal virtual override {
        if (from != address(0) && !transferAllowed) {
            revert TransferNotAllowed();
        }
    }
}
