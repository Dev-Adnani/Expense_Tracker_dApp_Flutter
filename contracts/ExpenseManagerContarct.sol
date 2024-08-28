// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract ExpenseManagerContract {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Transaction {
        address user;
        uint256 amount;
        string reason;
        uint256 timestamp;
    }
    mapping(address => uint256) public balances;

    Transaction[] public transactions;

    event Deposit(address indexed _from, uint256 _amount, string _reason, uint256 _timestamp);
    event Withdraw(address indexed _to, uint256 _amount, string _reason, uint256 _timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function deposit(uint _amount, string memory _reason) public payable
    {
        require(_amount > 0, "Amount should be greater than 0");
        balances[msg.sender] += _amount;
        transactions.push(Transaction(msg.sender, _amount, _reason, block.timestamp));
        emit Deposit(msg.sender, _amount, _reason, block.timestamp);
    }

    function withdraw(uint _amount, string memory _reason) public 
    {
        require(_amount > 0, "Amount should be greater than 0");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        transactions.push(Transaction(msg.sender, _amount, _reason, block.timestamp));
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount, _reason, block.timestamp);
    }
    
    function getBalance(address _account) public view returns(uint)
    {
        return balances[_account];
    }

    
    function getTransactionsCount() public view returns(uint)
    {
        return transactions.length;
    }

    function getTransaction(uint index) public view returns(address, uint, string memory, uint)
    {
        require(index < transactions.length, "Invalid index");
        Transaction memory transaction = transactions[index];
        return (transaction.user,transaction.amount,transaction.reason,transaction.timestamp);
    }

    function getAllTransactions() public view returns(address[] memory,uint[] memory,string[] memory,uint[] memory)
    {
        address[] memory users = new address[](transactions.length);
        uint[] memory amounts = new uint[](transactions.length);
        string[] memory reasons = new string[](transactions.length);
        uint[] memory timestamps = new uint[](transactions.length);
        for(uint i=0; i<transactions.length; i++)
        {
            Transaction memory transaction = transactions[i];
            users[i] = transaction.user;
            amounts[i] = transaction.amount;
            reasons[i] = transaction.reason;
            timestamps[i] = transaction.timestamp;
        }
        return (users,amounts,reasons,timestamps);
    }

    function changeOwner(address _newOwner) public onlyOwner
    {
        owner = _newOwner;
    } 

}