// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract lottery{
 address public owner;
 address payable[] public players;
 address public Winner;
 uint public PlayerNum;
uint public Balance;
event _winner(address you, uint amount);
    constructor(){
        owner=msg.sender;
    }
modifier onlyOwner(){
    require(owner==msg.sender, "Not owner");
    _;
}
function play() public payable{
    require(msg.value==1 ether, "Amount is not equal 1 ether");
     players.push(payable(msg.sender));
     PlayerNum=players.length;
}
function randomness() public view returns(uint){
    return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
}
function winner() external  onlyOwner returns(address winnerAddr) {
uint winnerNum= randomness() % players.length;
winnerAddr=players[winnerNum];
Winner= winnerAddr;
payable(winnerAddr).transfer(address(this). balance);
emit _winner(winnerAddr, address(this).balance);
}

function getBalance() external  returns(uint){
  Balance= address(this).balance;
  return address(this).balance;
}

}