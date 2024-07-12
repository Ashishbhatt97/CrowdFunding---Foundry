// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract CrowdFunding {
    mapping(address => uint256) public contributedMoney;

    address public manager;
    uint256 public minimumContribution;
    uint256 public deadline;
    uint256 public target;
    uint256 public raisedAmount;
    uint256 public noOfContributors;

    struct Request {
        string description;
        address payable recipient;
        uint256 value;
        bool completed;
        uint256 noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public requests;
    uint256 public numOfRequest;

    constructor(uint256 _target, uint256 _deadline) {
        target = _target;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        manager = msg.sender;
    }

    // Transfer Eth function
    function transferEth() public payable {
        require(block.timestamp < deadline, "Deadline passed");
        require(
            msg.value >= minimumContribution,
            "Minimum Contribution is not met"
        );

        if (contributedMoney[msg.sender] == 0) {
            noOfContributors++;
        }

        contributedMoney[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    // Get the contract balance function
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function takeRefund() public {
        require(
            block.timestamp > deadline && raisedAmount < target,
            "You are not eligible for refund"
        );
        require(contributedMoney[msg.sender] > 0);
        address payable user = payable(msg.sender);
        user.transfer(contributedMoney[msg.sender]);
        contributedMoney[msg.sender] = 0;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only Manager can call this function");
        _;
    }

    function createRequest(
        string memory _description,
        address payable _recipient,
        uint256 _value
    ) public onlyManager {
        Request storage newRequest = requests[numOfRequest++];
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    function voteRequest(uint256 _requestNumber) public {
        require(
            contributedMoney[msg.sender] > 0,
            "You have to contributor first, then only you can vote"
        );
        Request storage requestInstance = requests[_requestNumber];
        require(
            requestInstance.voters[msg.sender] == false,
            "You have already voted!"
        );
        requestInstance.voters[msg.sender] == true;
        requestInstance.noOfVoters++;
    }

    function makePayment(uint256 _requestNumber) public onlyManager {
        require(raisedAmount > target, "Sorry, Payment cannot be initialized");
        Request storage requestInstance = requests[_requestNumber];
        require(
            requestInstance.completed == false,
            "Withdrawal request already completed"
        );

        require(
            requestInstance.noOfVoters > noOfContributors / 2,
            "This Withdrawal request is denied because of less majority"
        );

        requestInstance.recipient.transfer(requestInstance.value);
        requestInstance.completed = true;
    }
}
