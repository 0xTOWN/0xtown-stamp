// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Ownable} from "solady/auth/Ownable.sol";
import {ERC721} from "solady/tokens/ERC721.sol";
import {Initializable} from "solady/utils/Initializable.sol";
import {LibString} from "solady/utils/LibString.sol";

/// @title 0xTOWNSTAMP Soulbound NFT Token
contract ZeroExTownStamp is ERC721, Ownable, Initializable {
    error MintNotAllowed(); // Error thrown when minting is not allowed.
    error TransferNotAllowed(); // Error thrown when transfer attempts are made but not allowed.

    bool public mintAllowed; // Controls the minting functionality.
    bool public transferAllowed; // Controls the transferability of the NFT tokens.
    uint public totalSupply; // Tracks the total number of tokens minted.
    string public baseURI; // Base URI for computing {tokenURI}.

    mapping(uint => address) public visitors; // Maps token IDs to visitor addresses.
    mapping(uint => uint) public timestamps; // Maps token IDs to their minting timestamps.
    mapping(address => uint) public numbers; // Maps visitor addresses to their token numbers.

    /// @notice Returns the name of the token.
    function name() public pure override returns (string memory) {
        return "0xTOWNSTAMP";
    }

    /// @notice Returns the symbol of the token.
    function symbol() public pure override returns (string memory) {
        return "0xTOWNSTAMP";
    }

    /// @notice Generates a token URI for a given token ID.
    /// @param id The token ID.
    /// @return string representing the token URI.
    function tokenURI(uint id) public view override returns (string memory) {
        string memory visitor = LibString.concat("?visitor=", LibString.toHexString(visitors[id]));
        string memory owner = LibString.concat("&owner=", LibString.toHexString(ownerOf(id)));
        string memory ts = LibString.concat("&ts=", LibString.toString(timestamps[id]));
        return string(abi.encodePacked(baseURI, LibString.toString(id), visitor, owner, ts));
    }

    /// @notice Initializes the contract with a base URI and owner.
    /// @dev Sets the base URI and initializes ownership to the provided owner address.
    /// @param _baseURI The base URI to be set for computing {tokenURI}.
    /// @param owner The address to be set as the owner of the contract.
    function initialize(string calldata _baseURI, address owner) external initializer {
        baseURI = _baseURI;
        _initializeOwner(owner);
    }

    /// @notice Mints a new token to the sender address.
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

    /// @notice Sets the minting permission.
    /// @dev Can only be called by the contract owner.
    /// @param allowed Boolean representing the permission status.
    function setMintAllowed(bool allowed) external onlyOwner {
        mintAllowed = allowed;
    }

    /// @notice Sets the transfer permission.
    /// @dev Can only be called by the contract owner.
    /// @param allowed Boolean representing the permission status.
    function setTransferAllowed(bool allowed) external onlyOwner {
        transferAllowed = allowed;
    }

    /// @notice Sets the base URI for computing {tokenURI}.
    /// @dev Can only be called by the contract owner.
    /// @param _baseURI The base URI to be set.
    function setBaseURI(string calldata _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

    /// @dev Overrides the ERC721 _beforeTokenTransfer to enforce the transferAllowed policy.
    function _beforeTokenTransfer(address from, address, uint) internal virtual override {
        if (from != address(0) && !transferAllowed) {
            revert TransferNotAllowed();
        }
    }
}
