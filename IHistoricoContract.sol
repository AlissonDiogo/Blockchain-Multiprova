// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IHistoricoContract {
    function set_historico(address account, string memory data) external;
}
