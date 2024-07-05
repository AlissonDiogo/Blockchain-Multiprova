// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Nome: <Alisson Diogo Soares de Souza>
// Conta do contrato: https://sepolia.etherscan.io/address/0x87826Bc65Bd978112179012cd7263915d59d4CE8

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MultiprovaToken is ERC20 {
    string private token_name = "MultiprovaToken";
    string private token_symbol = "MuTK";
    address private owner; 

    constructor(uint256 initialSupply) ERC20(token_name, token_symbol) {
        _mint(msg.sender, initialSupply);
        owner = msg.sender;
    }
 
}
