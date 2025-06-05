// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ComputeBilling
/// @notice Tracks compute resource consumption and charges users in OCOS tokens accordingly

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract ComputeBilling {
    IERC20 public ocosToken;
    address public admin;
    uint256 public ratePerSecond = 1 ether / 3600; // 1 OCOS per hour (default)

    struct UsageLog {
        address user;
        uint256 startTime;
        uint256 endTime;
        uint256 cost;
        bool paid;
    }

    uint256 public nextLogId;
    mapping(uint256 => UsageLog) public logs;
    mapping(address => uint256[]) public userLogs;

    event UsageStarted(uint256 indexed logId, address indexed user, uint256 startTime);
    event UsageEnded(uint256 indexed logId, uint256 endTime, uint256 cost);
    event UsagePaid(uint256 indexed logId, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(address _tokenAddress) {
        ocosToken = IERC20(_tokenAddress);
        admin = msg.sender;
    }

    function startUsage(address _user) external onlyAdmin returns (uint256) {
        uint256 logId = nextLogId++;
        logs[logId] = UsageLog({
            user: _user,
            startTime: block.timestamp,
            endTime: 0,
            cost: 0,
            paid: false
        });
        userLogs[_user].push(logId);
        emit UsageStarted(logId, _user, block.timestamp);
        return logId;
    }

    function endUsage(uint256 _logId) external onlyAdmin {
        UsageLog storage log = logs[_logId];
        require(log.endTime == 0, "Usage already ended");

        log.endTime = block.timestamp;
        uint256 duration = log.endTime - log.startTime;
        log.cost = duration * ratePerSecond;

        emit UsageEnded(_logId, log.endTime, log.cost);
    }

    function pay(uint256 _logId) external {
        UsageLog storage log = logs[_logId];
        require(msg.sender == log.user, "Not your usage");
        require(log.endTime > 0, "Usage not ended");
        require(!log.paid, "Already paid");

        log.paid = true;
        require(ocosToken.transferFrom(msg.sender, address(this), log.cost), "Payment failed");

        emit UsagePaid(_logId, log.cost);
    }

    function updateRate(uint256 _newRatePerSecond) external onlyAdmin {
        ratePerSecond = _newRatePerSecond;
    }

    function withdraw(address _to, uint256 _amount) external onlyAdmin {
        ocosToken.transfer(_to, _amount);
    }

    function getUserLogs(address _user) external view returns (uint256[] memory) {
        return userLogs[_user];
    }
}
