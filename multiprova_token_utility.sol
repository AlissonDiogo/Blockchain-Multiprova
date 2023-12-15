// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Nome: <Alisson Diogo Soares de Souza>
// Conta do contrato: https://sepolia.etherscan.io/address/0x9f4aeb5deb62BAA925dF5B71792b6c3ecF49125c

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MultiprovaTokenUtility {
    address private owner;
    address private contract_token_address =
        0x87826Bc65Bd978112179012cd7263915d59d4CE8;
    mapping(address => bool) docentes_permitidos;

    struct Aluno_distribute_object {
        address aluno_address;
        uint256 qtd_tokens;
    }

    constructor() {
        owner = msg.sender;
    }

    modifier only_docente_permitido() {
        require(
            docentes_permitidos[msg.sender] == true,
            "Voce nao tem permissao para distribuir tokens"
        );
        _;
    }

    modifier only_owner() {
        require(
            msg.sender == owner,
            "Voce nao tem permissao para executar esta operacao"
        );
        _;
    }

    event tokens_distribuidos(bool success);

    function distribuir_tokens(Aluno_distribute_object[] calldata lista_alunos)
        external
        only_docente_permitido
    {
        require(lista_alunos.length > 0, "Lista de alunos vazia.");

        for (uint256 i = 0; i < lista_alunos.length; i++) {
            require(
                lista_alunos[i].aluno_address != address(0),
                "Aluno DEVE ter um address."
            );
            ERC20(contract_token_address).transferFrom(
                owner,
                lista_alunos[i].aluno_address,
                lista_alunos[i].qtd_tokens
            );
        }
        emit tokens_distribuidos(true);
    }

    function permitir_docente(address docente_address) external only_owner {
        docentes_permitidos[docente_address] = true;
    }
}
