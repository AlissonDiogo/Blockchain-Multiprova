// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IHistoricoContract.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MultiprovaCoin is ERC20 {
    string private token_name = "MultiprovaCoin";
    string private token_symbol = "MuCoin";
    address private owner;
    IHistoricoContract public historicoContract;

    mapping(address => uint256) multipla_escolha_bomb;
    mapping(address => uint256) associacao_de_colunas_bomb;
    mapping(address => uint256) v_ou_f_bomb;
    mapping(address => mapping(string => bool)) log_multipla_escolha_bomb_use;

    constructor(uint256 initialSupply) ERC20(token_name, token_symbol) {
        _mint(msg.sender, initialSupply);
        owner = msg.sender;
    }

    event bomba_usada(string tipo_bomba);
    event bomba_comprada(string tipo_bomba, uint256 quantidade_total);

    modifier only_owner() {
        require(
            msg.sender == owner,
            "Voce nao tem permissao para executar esta operacao"
        );
        _;
    }

    function set_token_utility_address(address contractAddress)
        external
        only_owner
    {
        historicoContract = IHistoricoContract(contractAddress);
    }

    function comprar_multipla_escolha_bomb(uint256 quantity) external {
        uint256 total = quantity * 5;

        require(total > 0, "A quantidade deve ser maior que 0.");

        require(
            balanceOf(msg.sender) >= total,
            "Usuario nao contem tokens suficientes"
        );

        transfer(owner, total);
        multipla_escolha_bomb[msg.sender] += quantity;
        emit bomba_comprada(
            "Multipla escolha",
            multipla_escolha_bomb[msg.sender]
        );
        string memory textToHistorico = string(
            abi.encodePacked(
                "buy;",
                Strings.toString(quantity),
                " Bomba Mult. Escolha;",
                Strings.toString(total),
                " MuCoin"
            )
        );
        historicoContract.set_historico(msg.sender, textToHistorico);
    }

    function comprar_vouf_bomb(uint256 quantity) external {
        uint256 total = quantity * 5;

        require(total > 0, "A quantidade deve ser maior que 0.");

        require(
            balanceOf(msg.sender) >= total,
            "Usuario nao contem tokens suficientes"
        );

        transfer(owner, total);
        v_ou_f_bomb[msg.sender] += quantity;
        emit bomba_comprada("V ou F", v_ou_f_bomb[msg.sender]);
        string memory textToHistorico = string(
            abi.encodePacked(
                "buy;",
                Strings.toString(quantity),
                " Bomba V ou F;",
                Strings.toString(total),
                " MuCoin"
            )
        );
        historicoContract.set_historico(msg.sender, textToHistorico);
    }

    function comprar_associacao_de_colunas_bomb(uint256 quantity) external {
        uint256 total = quantity * 5;

        require(total > 0, "A quantidade deve ser maior que 0.");

        require(
            balanceOf(msg.sender) >= total,
            "Usuario nao contem tokens suficientes"
        );

        transfer(owner, total);
        associacao_de_colunas_bomb[msg.sender] += quantity;
        emit bomba_comprada(
            "Associacao de colunas",
            associacao_de_colunas_bomb[msg.sender]
        );
        string memory textToHistorico = string(
            abi.encodePacked(
                "buy;",
                Strings.toString(quantity),
                " Bomba Ass. de Colunas;",
                Strings.toString(total),
                " MuCoin"
            )
        );
        historicoContract.set_historico(msg.sender, textToHistorico);
    }

    function get_multipla_escolha_bombs(address account)
        external
        view
        returns (uint256)
    {
        return multipla_escolha_bomb[account];
    }

    function get_associacao_de_colunas_bombs(address account)
        external
        view
        returns (uint256)
    {
        return associacao_de_colunas_bomb[account];
    }

    function get_v_ou_f_bombs(address account) external view returns (uint256) {
        return v_ou_f_bomb[account];
    }

    function usar_multipla_escolha_bombs(
        address account,
        string memory id_questao
    ) external {
        require(
            multipla_escolha_bomb[account] >= 1,
            "Usuario nao tem bombs suficiente"
        );

        require(
            log_multipla_escolha_bomb_use[msg.sender][id_questao] == false,
            "Usuario ja usou bomba nesta questao."
        );

        multipla_escolha_bomb[account] -= 1;
        log_multipla_escolha_bomb_use[msg.sender][id_questao] = true;
        emit bomba_usada("Multipla escolha");
    }

    function usar_associacao_de_colunas_bombs(address account, uint256 qtd)
        external
    {
        require(
            associacao_de_colunas_bomb[account] >= qtd,
            "Usuario nao tem bombs suficiente"
        );

        associacao_de_colunas_bomb[account] -= qtd;
        emit bomba_usada("Associacao de colunas");
    }

    function usar_v_ou_f_bombs(address account, uint256 qtd) external {
        require(
            v_ou_f_bomb[account] >= qtd,
            "Usuario nao tem bombs suficiente"
        );

        v_ou_f_bomb[account] -= qtd;
        emit bomba_usada("V ou F");
    }

    function verificar_se_questao_usou_bomb(
        address account,
        string memory tipo_bomb,
        string memory id_questao
    ) external view returns (bool log_uso_bomb) {
        string memory multipla_escolha_text = "multipla_escolha";
        if (
            keccak256(abi.encodePacked(tipo_bomb)) ==
            keccak256(abi.encodePacked(multipla_escolha_text))
        ) {
            //verificar multipla_escolha
            return log_multipla_escolha_bomb_use[account][id_questao];
        }
    }

}
