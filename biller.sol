pragma solidity ^0.4.0;


contract Biller {

    mapping(address => uint) clientAgreedPayments;
    mapping(address => bool) clientAcknowledgeAgreedPayment;
    address billerAddress;
    string public billerName;
    
    function Biller(string _billerName) {
        billerAddress = msg.sender;
        billerName = _billerName;
    }

    modifier ifBiller(){
        require(msg.sender == billerAddress);  
        _;
    }
    
    modifier ifNotBiller(){
        require(msg.sender != billerAddress);  
        _;
    }   

    function setBillerName(string _billerName) ifBiller {
        billerName = _billerName;
    }
    
    function getBalance() ifBiller constant returns(uint) {
        return this.balance;
    }
    
    function addClient(address client, uint agreedPayment) ifBiller {
        clientAgreedPayments[client] = agreedPayment;
        clientAcknowledgeAgreedPayment[client] = false;
    }
    
    function agreePayment() {
        if (clientAcknowledgeAgreedPayment[msg.sender]) {
            clientAcknowledgeAgreedPayment[msg.sender] = true;
        }
    }
    
    function pay() ifNotBiller payable {
        require(clientAcknowledgeAgreedPayment[msg.sender] == true && clientAgreedPayments[msg.sender] == msg.value);
    }
    
    function getBill(address client) internal constant returns(uint) {
        return clientAgreedPayments[client];
    }

    function getClientBill() constant returns(uint) {
        return getBill(msg.sender);    
    }
    
    function getBillOf(address client) ifBiller constant returns(uint) {
        return getBill(client);
    }

}