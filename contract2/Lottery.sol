// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract lottery{
 address public owner;
 address payable[] public players;
 address public Winner;
 uint public PlayerNum;
uint public Balance;
bool IsOver;
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
function Allplayers() external view returns(address payable[] memory){
    return players;
}
function winner() external  onlyOwner returns(address winnerAddr) {
uint winnerNum= randomness() % players.length;
winnerAddr=players[winnerNum];
Winner= winnerAddr;
payable(winnerAddr).transfer(address(this). balance);
emit _winner(winnerAddr, address(this).balance);

// Default settings: Starting betting all over again.
players= new address payable[](0);
PlayerNum= 0;

IsOver=true;

}
function lotteryOver() external onlyOwner {
    require(IsOver, "Lottery isn't over and the winer hasn't been rewarded yet");
selfdestruct(payable(owner));

}


function getBalance() external  returns(uint){
  Balance= address(this).balance;
  return address(this).balance;
}

}