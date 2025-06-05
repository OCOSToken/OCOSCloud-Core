// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NodeRewardVault
/// @notice Reward distribution vault for compute and storage node operators in OCOS Cloud

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract NodeRewardVault {
    IERC20 public ocosToken;
    address public admin;

    struct Reward {
        uint256 totalEarned;
        uint256 lastClaimed;
    }

    mapping(address => Reward) public operatorRewards;
    uint256 public totalVaultBalance;

    event RewardAllocated(address indexed operator, uint256 amount);
    event RewardClaimed(address indexed operator, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(address _tokenAddress) {
        ocosToken = IERC20(_tokenAddress);
        admin = msg.sender;
    }

    /// @notice Deposit tokens into reward vault for later distribution
    function deposit(uint256 _amount) external onlyAdmin {
        require(_amount > 0, "Invalid amount");
        require(ocosToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        totalVaultBalance += _amount;
    }

    /// @notice Allocate reward to a specific node operator
    function allocateReward(address _operator, uint256 _amount) external onlyAdmin {
        require(_amount > 0, "Amount must be > 0");
        require(_operator != address(0), "Invalid operator");
        require(_amount <= totalVaultBalance, "Insufficient vault balance");

        operatorRewards[_operator].totalEarned += _amount;
        totalVaultBalance -= _amount;

        emit RewardAllocated(_operator, _amount);
    }

    /// @notice Claim all available rewards by the operator
    function claimRewards() external {
        uint256 reward = operatorRewards[msg.sender].totalEarned;
        require(reward > 0, "No rewards available");

        operatorRewards[msg.sender].totalEarned = 0;
        operatorRewards[msg.sender].lastClaimed = block.timestamp;

        require(ocosToken.transfer(msg.sender, reward), "Transfer failed");
        emit RewardClaimed(msg.sender, reward);
    }

    /// @notice Get current unclaimed reward amount for operator
    function getPendingRewards(address _operator) external view returns (uint256) {
        return operatorRewards[_operator].totalEarned;
    }

    /// @notice Admin can withdraw leftover vault funds
    function withdrawVaultBalance(address _to, uint256 _amount) external onlyAdmin {
        require(_amount <= totalVaultBalance, "Exceeds vault balance");
        totalVaultBalance -= _amount;
        require(ocosToken.transfer(_to, _amount), "Transfer failed");
    }

    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}
