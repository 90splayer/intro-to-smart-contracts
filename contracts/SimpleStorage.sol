// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8; 

contract SimpleStorage {

    uint256 favoriteNumber;

    struct People {
        uint256 favNumber;
        string name;
        }
        

    People[] public people;

    mapping(string => uint256) public nameToFavNumber;

    
    function addPerson(string memory _name, uint256 _favoriteNumber) public{
        people.push(People(_favoriteNumber, _name));
        nameToFavNumber[_name] = _favoriteNumber;
    }

    function store( uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    } 

    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

} 