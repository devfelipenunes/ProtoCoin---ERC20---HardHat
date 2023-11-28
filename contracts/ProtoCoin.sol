// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ProtoCoin is ERC20 {
    address private _owner;
    uint256 private _mintAmount = 0;
    uint64 private _mintDelay = 60 * 60 * 24; //1 day in seconds

    mapping(address => uint256) private nextMint;

    constructor() ERC20("PauliNCoin", "PNC") {
        _owner = msg.sender;
        _mint(msg.sender, 10000000 * 10 ** 18);
    }

    function mint(address to) public restricted {
        require(_mintAmount > 0, "Minting is not enabled");
        require(block.timestamp > nextMint[to], "Not time yet");

        _mint(to, _mintAmount);
        nextMint[to] = block.timestamp + _mintDelay;
    }

    function setMintAmount(uint256 newAmount) public restricted {
        _mintAmount = newAmount;
    }

    function setMintDelay(uint256 newDelay) public restricted {
        _mintAmount = newDelay;
    }

    modifier restricted() {
        require(_owner == msg.sender, "You do not have permission");
        _;
    }
}
