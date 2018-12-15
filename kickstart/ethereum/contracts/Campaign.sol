pragma solidity ^0.4.17;

contract CampaignFactory {
    
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimumAmount) public {
        address newCampaign = new Campaign(minimumAmount, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    
    function getAllCampaigns() public view returns (address[])  {
        return deployedCampaigns;
    }
}

contract Campaign {
    
    struct Request {
        string description;
        uint value;
        address recipient;
        mapping(address => bool) approvals;
        uint approvalCount;
        bool completed;
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function Campaign(uint minimum, address _manager) public {
        manager = _manager;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        approvers[msg.sender] = true;
        approversCount ++;
    }
    
    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request({description: description,
                                    value:value,
                                    recipient: recipient,
                                    approvalCount: 0,
                                    completed: false});
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        Request storage request = requests[index];
        
        require(approvers[msg.sender]); // it can vote
        require(!request.approvals[msg.sender]);  // it hasn't already voted

        request.approvals[msg.sender] = true;        
        request.approvalCount++;
        
    }
    
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        require(!request.completed);
        require(request.approvalCount > (approversCount / 2));

        request.recipient.transfer(request.value);
        request.completed = true;
        
    }
}