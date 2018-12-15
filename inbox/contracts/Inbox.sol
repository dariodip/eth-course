pragma solidity ^0.4.17;

/**
* A simple contract simulating an inbox
*/
contract Inbox {
    /**
    * the message of the inbox
     */
    string public message;
    
    /**
    * the constructor. it takes an inital message
     */
    function Inbox(string initialMessage) public {
        message = initialMessage;
    }
    
    /**
    * a method to set a new message
     */
    function setMessage(string newMessage) public {
        message = newMessage;
    }
    
    /**
    * a method to retrieve the message
     */
    function getMessage() public view returns (string) {
        return message;
    }
    
}