pragma solidity >=0.6.0;

contract Ownable{
    address payable owner;

    constructor() public{
        owner = payable (msg.sender);
    }

    modifier onlyOwner(){
        require(isOwner(),"You are not the owner");
        _;
    }

    function isOwner() public view returns(bool){
        return (msg.sender == owner);
    }
}