// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Todo{

  struct Details{
    string name;
    uint time;
    bool completed;
  }
   Details[] public details;
   bytes4 public key;
   bool public created;
   mapping(bytes4=>Details)public pin;// getting your details using your pin


  function create(string calldata _name,uint _time) external{
    require(_time>=block.timestamp, "Time Expired!!!");
    details.push(Details({name:_name, completed:false, time:_time}));
  }

  function update(string calldata _name, uint _y, uint _time ) external {
    Details storage x= details[_y];
    x.name= _name;
    x.time=_time;
  
  }

function getkey(string calldata Name, uint _x) public{
    IfCreated(_x); 
     Details storage C= details[_x];
  
   bytes4 keys =  bytes4(keccak256(abi.encodePacked(Name)));
   key=keys;

   pin[keys]= C;    
    
}

  function IfCreated(uint _x) public returns(bool){
    Details storage C= details[_x];
    C.completed=true;
   created=true;
   return created;
  }

}
 