pragma solidity >=0.6.0;

import "./ItemManager.sol";

contract Item{
    uint public priceInWei;
    uint public id;
    uint public pricePaid;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _id) public{
        priceInWei = _priceInWei;
        id = _id;
        parentContract = _parentContract;
    }

    receive() external payable{
        
        require(pricePaid == 0,"The item is paid already");
        require(priceInWei == msg.value, " Only full payments allowed");
        pricePaid += msg.value;
        (bool succes,) = address(parentContract).call.value (msg.value) (abi.encodeWithSignature("triggerPayment(uint256)",id));
        require(succes, "The payment failed");


    }

    fallback() external{}
}
