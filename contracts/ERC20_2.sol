// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken2 is ERC20 {
    constructor() ERC20("MyToken2", "MTK2") {
        _mint(msg.sender, 10 ** (decimals()));
    }
}