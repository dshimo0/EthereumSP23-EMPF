// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CPF {
    mapping(address => bytes32) public cpfHashes;
    mapping(address => bool) public blockedAccounts;

    function registrarCPF(bytes32 cpfHash) external {
        require(cpfHashes[msg.sender] == 0, 'CPF ja registrado para este endereco');
        cpfHashes[msg.sender] = cpfHash;
    }

    function validarCPF(address user, bytes32 cpfHash) external view returns (bool) {
        return cpfHashes[user] == cpfHash;
    }

    function blockAccount(address account) external {
        blockedAccounts[account] = true;
    }

    function unblockAccount(address account) external {
        blockedAccounts[account] = false;
    }
}
