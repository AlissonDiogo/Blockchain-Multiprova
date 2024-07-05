// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Nome: <Alisson Diogo Soares de Souza>
// Conta do contrato: https://sepolia.etherscan.io/address/0x1af8102C1891a81544b16c53Bdf8E275cc83a4C7

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MultiprovaTokenUtility {
    address private owner;
    address private contract_token_address =
        0x426740b5AEaA9191F3E33F090b378fA824864E6b;
    address private contract_coin_address =
        0x231Ecef923294bf9470ABF99C8cD0C2864942A57;
    mapping(address => bool) docentes_permitidos;
    mapping(address => string[]) historico;

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
    event swapEfetuado(string tipo);

    function get_historico_by_address(address user_address)
        external
        view
        returns (string[] memory)
    {
        return historico[user_address];
    }

    function set_historico(address account, string memory data) public {
        string memory stringData = _getDateInfo(block.timestamp);
        string memory formattedData = string(
            abi.encodePacked(data, ";", stringData)
        );
        historico[account].push(formattedData); 
    }

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

    function swap_MuTK_to_MuCoin(uint256 quantity_MuTK, uint256 quantity_MuCoin)
        external
    {
        require(
            ERC20(contract_token_address).balanceOf(msg.sender) >=
                quantity_MuTK,
            "Usuario nao contem MultiprovaTokens suficientes"
        );

        ERC20(contract_coin_address).transferFrom(
            owner,
            msg.sender,
            quantity_MuCoin
        );

        ERC20(contract_token_address).transferFrom(
            msg.sender,
            owner,
            quantity_MuTK
        );
        emit swapEfetuado("mutk_mucoin");
        string memory textToHistorico = string(
            abi.encodePacked(
                "swap;",
                Strings.toString(quantity_MuTK),
                " MuTK;",
                Strings.toString(quantity_MuCoin),
                " MuCoin"
            )
        );
        set_historico(msg.sender, textToHistorico);
    }

    function swap_MuCoin_to_MuTK(uint256 quantity_MuCoin, uint256 quantity_MuTK)
        external
    {
        require(
            ERC20(contract_coin_address).balanceOf(msg.sender) >=
                quantity_MuCoin,
            "Usuario nao contem MultiprovaCoins suficientes"
        );

        ERC20(contract_token_address).transferFrom(
            owner,
            msg.sender,
            quantity_MuTK
        );

        ERC20(contract_coin_address).transferFrom(
            msg.sender,
            owner,
            quantity_MuCoin
        );
        emit swapEfetuado("mucoin_mutk");
        string memory textToHistorico = string(
            abi.encodePacked(
                "swap;",
                Strings.toString(quantity_MuCoin),
                " MuCoin;",
                Strings.toString(quantity_MuTK),
                " MuTK"
            )
        );
        set_historico(msg.sender, textToHistorico);
    }

    function _getDateInfo(uint256 timestamp)
        internal
        pure
        returns (string memory)
    {
        uint256 month = BokkyPooBahsDateTimeLibrary.getMonth(timestamp);
        uint256 year = BokkyPooBahsDateTimeLibrary.getYear(timestamp);
        uint256 day = BokkyPooBahsDateTimeLibrary.getDay(timestamp);
        string memory monthString = Strings.toString(month);
        string memory yearString = Strings.toString(year);
        string memory dayString = Strings.toString(day);

        string memory formattedData = string(
            abi.encodePacked("", dayString, "/", monthString, "/", yearString)
        );
        return formattedData;
    }
}
