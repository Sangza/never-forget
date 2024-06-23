// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

// Building a personalized memory built on base
// Create fun, join and never forget.

// An album is a collection of photos and videos that reflect a person's experience with them and other people.
// A trybe album expands it to help you access the whole album capturing not just your own experience but also others.
//

contract Trybe{
    address public owner;
    uint256 public totalAlbumCreated;

    mapping(uint256 => Memory) public trackAlbumMade;
    mapping(address => mapping(uint256 => Image[])) public albumImage;
    mapping(uint256 => mapping(uint256 => Collections)) public albumCollections;
   


    constructor() {
        owner = msg.sender;
        totalAlbumCreated = 0;
    }

    struct Memory {
        uint256 id;
        address admin; // Owner of the album
        string name; // Name of the album
        string description; // Description of the Memory
        string profileImage; // Profile image of the memory
        uint256 created; // Timestamp when the memory was created
        address[] participant; // Wallet address of each participant
        uint256 totalCollection; // Number of collections created in a memory
        uint256[] albumids;
    }

    struct Image {
        uint256 id;
        string images;
        string description;
        address owner;
    }

    struct Collections {
        uint256 id;
        string name;
        uint256 created;
        uint256[] imageid;
    }

    event AlbumCreated(address indexed creator, string nameofAlbum, uint256 albumNumber);
    event JoinedAlbum(address indexed participant, uint256 timeJoined);
    event ImageCreated(uint256 albumId, uint256 imageId);
    event CollectionCreated(uint256 albumId, uint256 collectionId, string collectionName);

    function createAlbum(
        string memory _name,
        string memory description,
        string memory profile,
        address[] memory _participant,
        uint256[] memory imageee
    ) public returns (bytes32) {
        require(msg.sender != address(0), "Only the initial call of this contract can be an admin");
        require(bytes(_name).length > 0, "Please add a name");
        require(bytes(description).length > 0, "Describe your album to let the world know how you felt when you created this");

        totalAlbumCreated++;

        address[] memory participant = new address[](_participant.length + 1);
        for (uint256 i = 0; i < _participant.length; i++) {
            participant[i] = _participant[i];
        }
        participant[_participant.length] = msg.sender;

        Memory memory newAlbum = Memory(totalAlbumCreated, msg.sender, _name, description, profile, block.timestamp, participant, 0, imageee);
        trackAlbumMade[totalAlbumCreated] = newAlbum;
        trackAlbumMade[totalAlbumCreated].participant = participant;

        emit AlbumCreated(msg.sender, _name, totalAlbumCreated);
        return 'tybe${msg.sender}/${newAlbum.id}';
    }

    function joinAlbum(uint256 albumId) public {
        Memory storage album1 = trackAlbumMade[albumId];
        require(albumId != 0, "Album does not exist");

        album1.participant.push(msg.sender);
        emit JoinedAlbum(msg.sender, block.timestamp);
    }

    function addImagestoAlbum(
        uint256 albumId,
        string memory _Imageurl,
        string memory _description

    ) public {
        Memory storage album2 = trackAlbumMade[albumId];
        require(albumId != 0, "This album does not exist");

        bool isParticipant = false;
        address[] memory participant = album2.participant;

        for (uint256 i = 0; i < participant.length; i++) {
            if (participant[i] == msg.sender) {
                isParticipant = true;
                break;
            }
        }
        require(isParticipant, "Only those who have joined the album can add a memory");

        uint256 imageId = albumImage[album2.admin][albumId].length + 1;
        Image memory newImage = Image(imageId, _Imageurl, _description, msg.sender);
        albumImage[album2.admin][albumId].push(newImage);

        emit ImageCreated(albumId, imageId);
    }

    function createCollection(
        uint256 albumId,
        string memory _name,
        uint256[] memory images
    ) public {
        Memory storage album3 = trackAlbumMade[albumId];
        require(albumId != 0, "This album does not exist");
        require(msg.sender == album3.admin, "Only the admin can create a collection");

        album3.totalCollection++;
        uint256 collectionId = album3.totalCollection;
        Collections memory collect = Collections(collectionId, _name, block.timestamp, images);
        albumCollections[albumId][collectionId] = collect;

        emit CollectionCreated(albumId, collectionId, _name);
    }

    function addImageToCollection(
        uint256 albumId,
        uint256 collectionId,
        uint256 imageId
    ) public {
        Memory storage album4 = trackAlbumMade[albumId];
        require(albumId != 0, "This album does not exist");
        require(msg.sender == album4.admin, "Only the admin can add images to the collection");

        Collections storage collection1 = albumCollections[albumId][collectionId];
        require(collection1.id != 0, "This collection does not exist");

        collection1.imageid.push(imageId);
    }

    function getAlbum( uint256 albumId) public view returns (Memory memory) {
        Memory memory album5 = trackAlbumMade[albumId];
        require(albumId != 0, "This album does not exist");

        return album5;
    }

    function getImageInAlbum(uint256 albumId) public view returns (Image[] memory) {
        Memory memory album8 = trackAlbumMade[albumId];
        return albumImage[album8.admin][albumId];
    }

    function getCollectionsInAlbum(uint256 albumId) public view returns (Collections[] memory collectionL) {
        Memory storage album6 = trackAlbumMade[albumId];
        require(albumId != 0, "This album does not exist");

        collectionL = new Collections[](album6.totalCollection);
        for (uint256 i = 1; i <= album6.totalCollection; i++) {
            collectionL[i - 1] = albumCollections[albumId][i];
        }
    }

    function getImageFromCollection(
        address adminnn,
        uint256 albumId,
        uint256 collectionId
    ) public view returns (Image[] memory images) {
        Collections storage collection3 = albumCollections[albumId][collectionId];
        require(albumId != 0, "This album does not exist");

        images = new Image[](collection3.imageid.length);
        for (uint256 i = 0; i < collection3.imageid.length; i++) {
            images[i] = albumImage[adminnn][albumId][collection3.imageid[i] - 1];
        }
    }

    function getTheListofParticipant( uint256 albumId)external view returns (address[] memory participant){
        Memory storage album7 = trackAlbumMade[albumId];
        return  album7.participant;
    }


}
