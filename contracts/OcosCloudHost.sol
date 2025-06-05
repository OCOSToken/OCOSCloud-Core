// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OcosCloudHost
/// @notice Core contract for managing compute and storage service provisioning on OCOS Cloud

contract OcosCloudHost {
    address public owner;
    address public tokenAddress;

    enum ServiceType { Compute, Storage, Hosting }

    struct Service {
        ServiceType serviceType;
        address user;
        uint256 quota;        // GB for storage or hours for compute
        uint256 startTime;
        uint256 endTime;
        bool active;
    }

    uint256 public nextServiceId;
    mapping(uint256 => Service) public services;
    mapping(address => uint256[]) public userServices;

    event ServiceProvisioned(uint256 indexed serviceId, address indexed user, ServiceType serviceType, uint256 quota, uint256 startTime, uint256 endTime);
    event ServiceTerminated(uint256 indexed serviceId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }

    function provisionService(ServiceType _type, uint256 _quota, uint256 _duration) external returns (uint256) {
        require(_quota > 0 && _duration > 0, "Invalid parameters");

        uint256 serviceId = nextServiceId++;

        services[serviceId] = Service({
            serviceType: _type,
            user: msg.sender,
            quota: _quota,
            startTime: block.timestamp,
            endTime: block.timestamp + _duration,
            active: true
        });

        userServices[msg.sender].push(serviceId);

        emit ServiceProvisioned(serviceId, msg.sender, _type, _quota, block.timestamp, block.timestamp + _duration);

        return serviceId;
    }

    function terminateService(uint256 _serviceId) external {
        Service storage service = services[_serviceId];
        require(service.user == msg.sender || msg.sender == owner, "Unauthorized");
        require(service.active, "Service already inactive");

        service.active = false;
        emit ServiceTerminated(_serviceId);
    }

    function getActiveServices(address _user) external view returns (uint256[] memory) {
        uint256[] memory all = userServices[_user];
        uint256 count;

        for (uint i = 0; i < all.length; i++) {
            if (services[all[i]].active) count++;
        }

        uint256[] memory active = new uint256[](count);
        uint256 index;

        for (uint i = 0; i < all.length; i++) {
            if (services[all[i]].active) {
                active[index++] = all[i];
            }
        }

        return active;
    }

    function updateTokenAddress(address _newToken) external onlyOwner {
        tokenAddress = _newToken;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        owner = _newOwner;
    }
}
