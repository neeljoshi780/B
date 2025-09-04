----------------------------------- 3rd -----------------------------------
Basic Solidity:
• Versioning
• Compiling
• Contract Declaration
• Types & Declaring Variables
o uint256, int256, bool, string, address,
bytes32
• Default Initializations
• Comments
• Functions
• Deploying a Contract
• Calling a public state-changing Function
• Visibility
• Scope
• View & Pure Functions
• Structs
• Intro to Storage
• Arrays - Dynamic & Fixed sized
• Compiler Errors and Warnings
• Memory
• Mappings
• SPDX License
• Recap 

// SPDX-License-Identifier: MIT
// 1.Versioning
pragma solidity  0.6.0;


// 3. Contract Declaration
contract SimpleStorage{

    // 4. Types & Declaring Variables
    // bool favoriteBool = false;
    // string favoriteString = "String";
    // int256 favoriteInt = -5;
    // address favoriteAddress = 0xca8F6cee18b5bc6030451f5Bda4292BaF021B606;
    // bytes32 favoriteBytes = "cat";

    // 5. Default Initializations 0!
    uint256 favoriteNumber;

    struct People{
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    // view
    function retrive() public view returns(uint256) {
        return favoriteNumber;
    }

    // add person
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}



----------------------------------- 4th -----------------------------------
Storage Factory
Inheritance, Factory Pattern, and Interacting
with External Contracts
• Factory Pattern
• Imports
• Deploy a Contract From a Contract
• Interact With a Deployed Contract
• Recap

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 1. Imports
import "./SimpleStorage.sol";

// 2. Inheritance
contract StorageFactory is SimpleStorage{

    // Array to keep track of all deployed SimpleStorage contracts.
    SimpleStorage[] public simpleStorageArray;

    // Function to deploy (create) a new SimpleStorage contract.
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    // Function to store a value in one of the deployed SimpleStorage contracts.
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{
        // Address
        // ABI 
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    // Function to retrieve the stored value from a deployed SimpleStorage contract.
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrive();
    }
}

// Note
// 1. You don’t deploy SimpleStorage contracts manually one by one in Remix.
// 2. You have a single factory contract (StorageFactory) that can create and manage many instances of another contract (SimpleStorage).
// 3. This makes your system scalable — 1 factory → 100s of storage contracts, all tracked in one place.



----------------------------------- 5th -----------------------------------
Fund Me
Payable, msg.sender, msg.value, Units of
Measure
• Payable
• Wei/Gwei/Eth Converter
• msg.sender&msg.value

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6 <0.9.0;

contract FundMe {

    // Mapping to track how much ETH each address has funded
    mapping(address => uint256) public addressToAmountFunded;

    // // Payable function allows contract to receive ETH
    function fund() public payable {
        // msg.sender: Address of the sender who called the fund function
        // msg.value: Amount of Wei (ETH) sent with the function call
        addressToAmountFunded[msg.sender] += msg.value;
    }
}

// ********************Extra Add one this code*********************
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundMe {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Function to fund the contract
    function fund() public payable {
        require(msg.value > 0, "Send some ETH");
    }

    // Function to check balance of contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Function to withdraw funds (only owner)
    function withdraw() public {
        require(msg.sender == owner, "Not the owner");
        payable(owner).transfer(address(this).balance);
    }
}
