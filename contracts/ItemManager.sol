 pragma solidity >=0.6.0;

import "./Ownable.sol";
import "./Item.sol";
 contract ItemManager is Ownable{

    enum supplyChainState {
        created, paid, delivered
    }

    struct S_item{

        Item item;
        string identifier;
        uint itemPrice;
        ItemManager.supplyChainState state;
    }
    
    event supplyChainStep(uint _id, uint _step, address _itemAddress);
    mapping (uint => S_item) public items;
    uint itemIndex;

    function createItem(string memory _id, uint _itemPrice) public onlyOwner{
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex].item = item;
        items[itemIndex].identifier = _id;
        items[itemIndex].itemPrice = _itemPrice;
        items[itemIndex].state = supplyChainState.created;
        emit supplyChainStep(itemIndex, uint(items[itemIndex].state),address(item));
        itemIndex++;
    }

    function triggerPayment(uint _id) public payable{
        require(items[_id].itemPrice == msg.value, "Only full payments accepted");
        require(items[_id].state == supplyChainState.created, "It was already payed");

        items[_id].state = supplyChainState.paid;
        emit supplyChainStep(itemIndex, uint(items[itemIndex].state), address(items[itemIndex].item));
    }
    
    function triggerDelivery(uint _id) public onlyOwner{
        require(items[_id].state == supplyChainState.paid, "Item is further in the chain");
        items[_id].state = supplyChainState.delivered;
        emit supplyChainStep(itemIndex, uint(items[itemIndex].state),address(items[itemIndex].item));
    }

}