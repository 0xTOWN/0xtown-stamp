// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {OwnableRoles} from "solady/auth/OwnableRoles.sol";
import {ERC721} from "solady/tokens/ERC721.sol";
import {Initializable} from "solady/utils/Initializable.sol";

contract ZeroExTownVisit is ERC721, OwnableRoles, Pausable, Initializable {
    uint public count;
    mapping(uint => uint) public timestamps;

    function name() public pure override returns (string memory) {
        return "0xTOWN Visitor";
    }

    function symbol() public pure override returns (string memory) {
        return "0xTOWNSTAMP";
    }

    function tokenURI(uint id) public pure override returns (string memory) {
        return "0xTOWNSTAMP";
    }

    function initialize(address owner) external initializer {
        count = 0;
        _initializeOwner(owner);
    }

    function mint() external {
        ++count;
        timestamps[count] = block.timestamp;
        _mint(msg.sender, count);
    }

    function _beforeTokenTransfer(address, address, uint) internal virtual override {
        // TODO
    }
}
