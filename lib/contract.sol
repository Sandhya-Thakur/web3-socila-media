// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SocialMediaStatus {
    uint256 constant MAX_WORD = 110;

    struct Status {
        string content;
        string imageUrl;
        uint256 timeStamp;
    }

    struct UserProfile {
        string username;
        string bio;
        string profilePictureUrl;
    }

    Status[] public allStatus;
    uint256 updateId;
    mapping(address => Status) public userStatus;
    mapping(address => UserProfile) public userProfiles;  // Mapping to store user profiles

    event UpdatedStatus(address indexed user, uint256 indexed updateId, string content, string imageUrl, uint256 timeStamp);
    event DeletedStatus(address indexed user, uint256 indexed updateId, string content, string imageUrl, uint256 timeStamp);
    event UpdatedProfile(address indexed user, string username, string bio, string profilePictureUrl);  // New event to log profile updates

    function updateStatus(string memory _content, string memory _imageUrl) public {
        // Check if the user has a profile by checking if the username field is not empty
        require(bytes(userProfiles[msg.sender].username).length > 0, "User does not have a profile");
        require(bytes(_content).length < MAX_WORD , "Maximum word length reached");
        Status memory newStatus = Status(_content, _imageUrl, block.timestamp);
        allStatus.push(newStatus);
        userStatus[msg.sender] = newStatus;
        updateId++;
        emit UpdatedStatus(msg.sender, updateId, _content, _imageUrl, block.timestamp);
    }

    function deleteStatus(uint256 _id) public returns(Status memory){
        require(_id < allStatus.length, "This id does not exist");
        Status memory deletedStatus = allStatus[_id];
        for (uint256 i = _id; i < allStatus.length - 1; i++) {
            allStatus[i] = allStatus[i + 1];
        }
        allStatus.pop();
        emit DeletedStatus(msg.sender, _id, deletedStatus.content, deletedStatus.imageUrl, deletedStatus.timeStamp);
        return deletedStatus;
    }

    function updateProfile(string memory _username, string memory _bio, string memory _profilePictureUrl) public {
        UserProfile memory newProfile = UserProfile(_username, _bio, _profilePictureUrl);
        userProfiles[msg.sender] = newProfile;  // Update the profile in the mapping
        emit UpdatedProfile(msg.sender, _username, _bio, _profilePictureUrl);  // Emit an event to log the profile update
    }

    function getProfile(address _user) public view returns(UserProfile memory) {
        return userProfiles[_user];  // Retrieve the profile from the mapping
    }

    function getAllStatus() public view returns(Status[] memory){
        return allStatus;
    }
}
