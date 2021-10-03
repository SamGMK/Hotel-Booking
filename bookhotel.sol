// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract HotelRoom {
    
    //It allows someone to make a payment for a room if the room is vacant
    // After payment is made to the contract the funds are sent to the owner. 
    //dispense a key code after payment is made. 
    
    //The enum to fix the vacancy of a room
    enum RoomState{
        Free,
        Occupied
    }

    RoomState vacancy;
    //event to notify when a room has been Occupied
    event Booked (address _occupant, uint _value);
    
    address payable public owner;
    
    constructor() {
       owner = payable(msg.sender);
       vacancy = RoomState.Free;
    }
   
   //modifier to check if the room is vacant
   
   modifier onlyWhileVacant {
        require(vacancy == RoomState.Free, "Currently Occupied");
        _;
   } 
   
  //modifier for the withdraw function
  //Only owner of the contract can withdraw
  
  modifier onlyOwner(){
      require(msg.sender == owner, "Not owner");
      _;
  }
  
  //modifier allows you to pass in a value
  //checks if the amount sent is equal to the room rent 
  modifier costs(uint _amount) {
      require(msg.value >= _amount, "Rent aint that cheap boy");
      _;
      
  }
   
   //function to withdraw money to the owner address
  
  function withdraw() public payable onlyOwner returns(bool) {
        
        owner.transfer(msg.value);
        
        return true;

    }
   
   //function to check if room is Occupied
   //If not, returns room key
   
    function getRoom() public payable onlyWhileVacant costs(1 ether) returns(string memory) {
        
       require(msg.sender.balance >= msg.value);
        
       withdraw();
        
       vacancy = RoomState.Occupied;
        
        emit Booked(msg.sender, msg.value);
      
       return "Room Key";
       
       
        
    }
    
    
    
    
    
    
    
    
    
    
}