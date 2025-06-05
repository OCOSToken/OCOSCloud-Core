// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CloudVault
/// @notice Decentralized file vault with access control, storage staking, and metadata anchoring on OCOS Cloud

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract CloudVault {
    IERC20 public ocosToken;
    address public admin;

    struct File {
        string cid;               // IPFS or Arweave CID
        address owner;
        uint256 size;             // in megabytes (MB)
        uint256 timestamp;
        bool encrypted;
    }

    mapping(uint256 => File) public files;
    mapping(address => uint256[]) public userFiles;
    uint256 public nextFileId;

    uint256 public storageRatePerMB = 1 ether; // Example: 1 OCOS token per MB

    event FileStored(uint256 indexed fileId, address indexed user, string cid, uint256 size, bool encrypted);
    event FileDeleted(uint256 indexed fileId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(address _tokenAddress) {
        admin = msg.sender;
        ocosToken = IERC20(_tokenAddress);
    }

    function storeFile(string calldata _cid, uint256 _sizeMB, bool _encrypted) external returns (uint256) {
        require(_sizeMB > 0, "File size required");

        uint256 cost = _sizeMB * storageRatePerMB;
        require(ocosToken.transferFrom(msg.sender, address(this), cost), "Token transfer failed");

        uint256 fileId = nextFileId++;
        files[fileId] = File({
            cid: _cid,
            owner: msg.sender,
            size: _sizeMB,
            timestamp: block.timestamp,
            encrypted: _encrypted
        });

        userFiles[msg.sender].push(fileId);

        emit FileStored(fileId, msg.sender, _cid, _sizeMB, _encrypted);
        return fileId;
    }

    function deleteFile(uint256 _fileId) external {
        File storage file = files[_fileId];
        require(file.owner == msg.sender || msg.sender == admin, "Unauthorized");
        delete files[_fileId];

        emit FileDeleted(_fileId);
    }

    function getUserFiles(address _user) external view returns (uint256[] memory) {
        return userFiles[_user];
    }

    function updateStorageRate(uint256 _newRate) external onlyAdmin {
        storageRatePerMB = _newRate;
    }

    function updateTokenAddress(address _newToken) external onlyAdmin {
        ocosToken = IERC20(_newToken);
    }

    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}
