// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ParametricInsurance {
    address public insurer;
    
    struct Policy {
        uint256 premium;
        uint256 payoutAmount;
        uint256 targetCondition; // E.g., Weather metric or delay hours
        bool isActive;
        bool claimed;
    }

    mapping(address => Policy) public policies;
    mapping(address => bool) public verifiedOracles;

    event PolicyPurchased(address indexed insured, uint256 premium, uint256 payout);
    event PolicyTriggered(address indexed insured, uint256 payout);

    modifier onlyInsurer() { require(msg.sender == insurer, "Not insurer"); _; }
    modifier onlyOracle() { require(verifiedOracles[msg.sender], "Not verified oracle"); _; }

    constructor() {
        insurer = msg.sender;
    }

    function addOracle(address _oracle) external onlyInsurer {
        verifiedOracles[_oracle] = true;
    }

    function purchasePolicy(uint256 _targetCondition, uint256 _payoutAmount) external payable {
        require(msg.value > 0, "Premium required");
        require(!policies[msg.sender].isActive, "Policy already exists");

        policies[msg.sender] = Policy({
            premium: msg.value,
            payoutAmount: _payoutAmount,
            targetCondition: _targetCondition,
            isActive: true,
            claimed: false
        });

        emit PolicyPurchased(msg.sender, msg.value, _payoutAmount);
    }

    function triggerPayout(address _insured, uint256 _actualCondition) external onlyOracle {
        Policy storage policy = policies[_insured];
        require(policy.isActive && !policy.claimed, "Invalid policy state");
        require(_actualCondition >= policy.targetCondition, "Condition threshold not met");

        policy.claimed = true;
        policy.isActive = false;
        
        payable(_insured).transfer(policy.payoutAmount);
        emit PolicyTriggered(_insured, policy.payoutAmount);
    }

    receive() external payable {}
}
