// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Investimento {
    IERC20 public token;
    mapping(address => uint256) public investments;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function investir(uint256 amount) external {
        require(token.balanceOf(msg.sender) >= amount, "Saldo insuficiente para o investimento");
        token.transferFrom(msg.sender, address(this), amount);
        investments[msg.sender] += amount;
    }
}
