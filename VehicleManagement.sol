// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract VehicleManagement {
    struct Vehicle {
        address owner;
        string make;
        string model;
        uint256 year;
    }
    
    struct Service {
        string serviceName;
        uint256 serviceDate;
        string changedPart;
        bool isAccident;
    }
    
    mapping(address => Vehicle) public vehicles;
    mapping(address => mapping(string => uint256)) public partsExpiry;
    mapping(address => Service[]) public vehicleServices;
    
    event PartExpired(address vehicle, string partName);
    event ServicePerformed(address vehicle, string serviceName, string changedPart, bool isAccident);
    
    modifier onlyOwner(address _vehicleAddress) {
        require(vehicles[_vehicleAddress].owner == msg.sender, "You are not the owner");
        _;
    }
    
    function addVehicle(address _vehicleAddress, string memory _make, string memory _model, uint256 _year) external {
        require(vehicles[_vehicleAddress].owner == address(0), "Vehicle already exists");
        vehicles[_vehicleAddress] = Vehicle(msg.sender, _make, _model, _year);
    }
    
    function addPartExpiry(address _vehicleAddress, string memory _partName, uint256 _expiryDate) external onlyOwner(_vehicleAddress) {
        partsExpiry[_vehicleAddress][_partName] = _expiryDate;
        emit PartExpired(_vehicleAddress, _partName);
    }
    
    function performService(address _vehicleAddress, string memory _serviceName, string memory _changedPart, bool _isAccident) external onlyOwner(_vehicleAddress) {
        Service memory newService = Service(_serviceName, block.timestamp, _changedPart, _isAccident);
        vehicleServices[_vehicleAddress].push(newService);
        emit ServicePerformed(_vehicleAddress, _serviceName, _changedPart, _isAccident);
    }
    
    function getPartExpiry(address _vehicleAddress, string memory _partName) external view returns (uint256) {
        return partsExpiry[_vehicleAddress][_partName];
    }
    
    function getVehicleServicesCount(address _vehicleAddress) external view returns (uint256) {
        return vehicleServices[_vehicleAddress].length;
    }
}