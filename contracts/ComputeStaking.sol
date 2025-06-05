// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ComputeStaking
/// @notice Allows users and node operators to stake OCOS tokens for compute resource quotas

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract ComputeStaking {
    IERC20 public ocosToken;
    address public admin;

    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 duration;
        bool claimed;
    }

    mapping(address => Stake[]) public userStakes;

    event Staked(address indexed user, uint256 amount, uint256 duration);
    event Unstaked(address indexed user, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(address _tokenAddress) {
        admin = msg.sender;
        ocosToken = IERC20(_tokenAddress);
    }

    function stake(uint256 _amount, uint256 _duration) external {
        require(_amount > 0, "Amount must be > 0");
        require(_duration >= 1 days, "Minimum staking period is 1 day");

        ocosToken.transferFrom(msg.sender, address(this), _amount);

        userStakes[msg.sender].push(Stake({
            amount: _amount,
            startTime: block.timestamp,
            duration: _duration,
            claimed: false
        }));

        emit Staked(msg.sender, _amount, _duration);
    }

    function unstake(uint256 _index) external {
        require(_index < userStakes[msg.sender].length, "Invalid index");
        Stake storage stakeInfo = userStakes[msg.sender][_index];

        require(!stakeInfo.claimed, "Already claimed");
        require(block.timestamp >= stakeInfo.startTime + stakeInfo.duration, "Staking period not ended");

        stakeInfo.claimed = true;
        ocosToken.transfer(msg.sender, stakeInfo.amount);

        emit Unstaked(msg.sender, stakeInfo.amount);
    }

    function getStakes(address _user) external view returns (Stake[] memory) {
        return userStakes[_user];
    }

    function updateTokenAddress(address _newToken) external onlyAdmin {
        ocosToken = IERC20(_newToken);
    }

    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}
