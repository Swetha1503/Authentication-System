// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Authentication {
    struct User {
        bytes32 passwordHash;
        address did;
    }

    mapping(address => User) private users; 

    event UserRegistered(address indexed did);
    event UserLoggedIn(address indexed did);

    constructor() {}

    function registerUser(address _did, bytes32 _passwordHash) public {
        require(_did != address(0), "Invalid DID address");
        require(_passwordHash != bytes32(0), "Invalid password hash");
        require(users[msg.sender].did == address(0), "User already registered");

        users[msg.sender] = User(_passwordHash, _did);
        emit UserRegistered(_did);
    }

    function login(bytes32 _passwordHash) public returns (string memory) {
        User storage user = users[msg.sender];
        require(user.did != address(0), "User not registered");
        require(user.passwordHash == _passwordHash, "Invalid password");

        emit UserLoggedIn(user.did);
        return "Login successful!";
    }

    function getUserDID() public view returns (address) {
        return users[msg.sender].did;
    }

    function hashPassword(string memory _password) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_password));
    }
}

