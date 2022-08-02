// SPDX-License-Identifier: MIT
//version de solidity
pragma solidity ^0.8.7;

contract JamToken {

//declaraciones
string public name = "JAM Token";
string public symbol = "JAM";
uint public totalSupply = 100000000000000000000000000000;//1 millon de tokens
uint public decimals = 18;

//evento para la transferencia de tokens de un usuario
event Transfer (
    address indexed _from,
    address indexed _to,
    uint _value
);

// evento para la aprobacion de un operador
event Approval (
    address indexed _owner,
    address indexed _spender,
    uint value
);

//estructura de datos 
mapping(address => uint) public balanceOf;
mapping(address => mapping(address  => uint)) public allwance;

//constructor 
constructor(){
    balanceOf[msg.sender] = totalSupply;
}

// transferencia de tokens de los usuarios
function transfer(address  _to, uint _value) public returns(bool){
    require(balanceOf[msg.sender] <= _value);
    balanceOf[msg.sender] -=_value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
}

// Aprobaciond de unacantidad para ser gastada por un operador 
function approve(address _speder, uint _value) public returns (bool) {
    allwance[msg.sender][_speder] = _value;
    emit Approval(msg.sender, _speder, _value);
    return true;
}

// Transferencia de tokens especificando el emisor
// Owner (20 tokens - operador (5) = 15 tokens
function transferFrom(address _from, address _to, uint _value) public returns (bool) {
    require(_value <= balanceOf[_from]);
    require(_value <= allwance[_from][msg.sender]);
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allwance[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
    return true;
}
}
// ><