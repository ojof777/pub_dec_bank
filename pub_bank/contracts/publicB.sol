//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";


contract J_Bank is Ownable {
    
    mapping(address => uint) balance;
    
    event depositDone(uint amount, address indexed depositedTo);
    event addTx(address from, address to, uint amount);
    
    function deposit() public payable returns (uint)  {
        balance[msg.sender] = msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }
    
    function withdraw(address payable withdrawer, uint amount) public onlyOwner returns (uint){
        require(balance[msg.sender] >= amount);
        require(withdrawer == msg.sender);
        withdrawer.transfer(amount);
        return balance[msg.sender];
    }
    
    function getBalance() public view onlyOwner returns (uint){
        return balance[msg.sender];
    }
    
    function transfer(address recipient, uint amount) public onlyOwner {
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Don't transfer money to yourself");
        
        uint previousSenderBalance = balance[msg.sender];
        
        _transfer(msg.sender, recipient, amount);
        
        emit addTx(msg.sender, recipient, amount);
        
        assert(balance[msg.sender] == previousSenderBalance - amount);
    }
    
    function _transfer(address from, address to, uint amount) internal view {
        require(balance[from] > amount);
        uint256 minfee = (amount/100);
        balance[from] - (amount + minfee);
        balance[to] + amount;
    }
    
    
}