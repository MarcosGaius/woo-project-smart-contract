// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWoo;
    uint256 totalWooBack;
    uint256 private seed;

    event newWave(uint indexed id, address indexed waveSender, uint256 timestamp, string message, uint256 woobacks);

    struct Wave {
        uint id;
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] wavesArr;
    mapping(address => uint256) public lastWoo;
    mapping(uint256 => uint256) public woosBack;

    constructor() payable{
        console.log("Sou um contrato inteligente!");
        seed = (block.timestamp + block.difficulty) % 100; //numero randomico, porem pode ser manipulado por invasores
    }
    
    function woo(string memory _message) public {
        require(lastWoo[msg.sender] + 10 minutes < block.timestamp, "Espere 15 minutos!");
        lastWoo[msg.sender] = block.timestamp;
        
        totalWoo += 1;
        console.log("%s fez o Woo!", msg.sender);
        wavesArr.push(Wave(totalWoo, msg.sender, _message, block.timestamp));

        emit newWave(totalWoo, msg.sender, block.timestamp, _message, totalWooBack);

        seed = (block.timestamp + block.difficulty + seed) % 100;
        console.log("# randomico gerado: %d", seed);

        if(seed <= 50){
            console.log("%s ganhou!", msg.sender);
            uint prizeAmount = 0.0001 ether;

            require(prizeAmount <= address(this).balance, "O contrato nao possui 0.0001 ether.");
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Falhou em sacar ether do contrato.");
        }
    }
    
    function wooBack(uint256 _id) public {
        require(wavesArr[_id-1].waver != msg.sender, "Voce nao pode mandar o Woo Back para voce mesmo!");
        totalWooBack += 1;
        woosBack[_id] = totalWooBack;
        console.log("%s fez o Woo Back, Baby!", msg.sender);
    }

    function getAllWoo() public view returns(Wave[] memory){
        return wavesArr;
    }

    function getAllWooBack(uint256 _id) public view returns(uint256){
        return woosBack[_id];
    }

    function getTotalWoo() public view returns(uint256){
        console.log("%d Woo ja foram dados!", totalWoo);
        return totalWoo;
    }
}