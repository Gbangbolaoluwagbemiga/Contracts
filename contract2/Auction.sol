// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IERC721{
    function transferFrom(address _from, address _to, uint nftId)external;
      function safeTransferFrom(
        address from,
        address to,
        uint id
    ) external ;
}

contract Auction{
struct Bidders{
    address bidder;
    uint amount;
    uint Id;
}
event start(string start);
event refund(address collect, string money);
event Ended(string wins, address winner);
    Bidders[] public bidders;
    uint public ID;
    mapping(uint=>mapping(address=>uint)) public Bid;
    mapping(address=> bool) public ifBidded;
    mapping(address=> uint) public YourId;
    bool public started;
    bool public ended;
    uint public startingPrice;
    uint startingTime= block.timestamp;
    uint endingBy= block.timestamp + 1 days;
    uint public Time_left;
    address public highestBidder;
    uint public highestBid;
    IERC721 nft;

     address public seller;

modifier onlyOwner(){
require(msg.sender==seller, "Not the seller");
_;
}

    uint public nftId;
    constructor(address _nft,uint _startingPrice, uint _nftId){  
            startingPrice=_startingPrice;
            nft=IERC721(_nft);
            nftId= _nftId;

     seller=msg.sender;
        }
function Start() external onlyOwner{
    require(started==false, "Auctioning has started");
    require(ended==false, "Auction ended");

    nft.transferFrom(seller, address(this), nftId);
     started=true;
     Time_left= endingBy-block.timestamp;
emit start("Auction has started");
}
    function bid() payable external{
   require(started, "Auctioning hasn't started!!");
   require(!ended, "Auctioning has ended!!");
   require(highestBid<msg.value, "Price is too Low");
   uint _id= ID;
   ID++;
   YourId[msg.sender]=_id;
   bidders.push(Bidders({
    bidder: msg.sender,
    amount:msg.value,
    Id:_id
}));
    ifBidded[msg.sender]= true;

        highestBidder= msg.sender;
        highestBid=msg.value;
        Bid[_id][highestBidder]+=highestBid;

   } 

function Refund() external{
    require(highestBidder!=msg.sender, "Not eligible to redraw yet");
    uint _amount=Bid[ID][msg.sender];
    Bid[ID][msg.sender]=0;
    payable(msg.sender).transfer(_amount);
    emit refund(msg.sender,"Collect Your money");
}

function end() external{
 require(started, "Auctioning hasn't started!!");
   require(!ended, "Auctioning has ended!!");
   require(Time_left==0, "Auctioning still going");
   if(highestBidder!=address(0)){
   nft.safeTransferFrom(address(this), highestBidder, nftId);
   }
   else{
        nft.safeTransferFrom(address(this), seller, nftId);

   }
   ended=true;
    emit Ended("The winner of the auctioning is", highestBidder);
}



