// SPDX-License-Identifier: MIT
//version de solidity
pragma solidity ^0.8.7;

import "./JamToken.sol";
import "./StellarToken.sol";

contract TokenFram {

    // declaraciones
    string public name = "Stellar Token Fram";
    address public Owner;
    JamToken public jamToken;
    StellarToken public stellarToken;

    // estructuras de datos
    address [] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    //constructor
    constructor(StellarToken _stellarToken, JamToken _jamToken){
        stellarToken = _stellarToken;
        jamToken = _jamToken;
        Owner = msg.sender;

    }

    // Stak de tokens
    function stakenTokens(uint _amount) public {
        // se requiere una cantidad superior a 0
        require(_amount < 0, "La cantidad no puede ser menor a 0");
        // transferir tokens JAM al smart contract principal
        jamToken.transferFrom(msg.sender, address(this), _amount);
        //actualizar el saldo del staking 
        stakingBalance[msg.sender] += _amount;
        //guardar token 
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);        
        }
        // actualizar el estado del staking
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    //quitar el staking de los tokens
    function unstakeToken() public {
        //saldo del staking de un usuario
        uint balance = stakingBalance[msg.sender];
        // requiere uan cantidad superior a 0
        require(balance > 0, "El balance del staking es 0");
        // transferencia de los tokens al usuario
        jamToken.transfer(msg.sender, balance);
        //recetea el balance del staking del usuario
        stakingBalance[msg.sender] = 0;
        //update of status the staking 
        isStaking[msg.sender] = false;

    }

    // emision de tonkens
    function issueTokens() public {
        // unicamente ejecutado por el owner
        require(msg.sender == Owner, "No eres el owner");
        // emitir tokens a todos los stakers
        for(uint i=0; i < stakers.length; i++){
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance > 0){
                stellarToken.transfer(recipient, balance);
            }
        }
    } 

}
// ><