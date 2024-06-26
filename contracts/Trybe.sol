// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

// Building a personalized memory built on base
// Create fun, join and never forget.

// An album is a collection of photos and videos that reflect a person's experience with them and other people.
// A trybe album expands it to help you access the whole album capturing not just your own experience but also others.

contract Trybe{
    address public owner;

    uint256 public totalNoOfAlbumsCreated;

    uint private fee;

    struct Album {
        uint256 id;
        string visibility; // "public" or "private"
        uint256 fee; // Fee to join or access images in a private album
        address owner; // Owner of the album
        string name; // Name of the album
        string description; // Description of the Memory
        string profileImage; // Profile image of the memory
        uint256 created; // Timestamp when the memory was created
        address[] participants; // Wallet address of each participant
        mapping (uint256 => Image) image; // Each image in an album
        Image[] images; // Images in an album
        uint256 totalNoOfImages;

    }

    struct Image {
        address owner; // Participant who uploaded the image
        uint256 id;
        string url;
        string description;
    }

    mapping(uint256 => Album) public album;

    Album[] private albums;

    event AlbumCreated(address indexed creator, string nameOfAlbum, uint256 albumId);

    event JoinedAlbum(address indexed participant, uint256 timeJoined);

    event ImageAdded(uint256 albumId, uint256 imageId);
   
    constructor() {
        owner = msg.sender;

        totalAlbumCreated = 0;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");

        _;
    }

    function createAlbum(
        string memory _name,
        string memory description,
        string memory profile,
        address[] memory _participants,
        string memory _image,
        string memory visibility,
        uint256 _fee
    ) public {
        require(msg.sender != address(0), "No zero addresses allowed.");
        require(bytes(_name).length > 0, "Please add a name.");
        require(bytes(description).length > 0, "Describe your album to let the world know how you felt when you created this.");

        totalNoOfAlbumsCreated++;

        address[] memory participants = new address[](_participants.length + 1);

        for (uint256 i = 0; i < _participants.length; i++) {
            participants[i] = _participants[i];
        }

        participants[_participants.length] = msg.sender;

        Image memory image;
        Image[] memory images;

        Album memory _album = Album({
            id: totalNoOfAlbumsCreated,
            visibility: visibility,
            fee: visibility == "private" ? _fee * 1 ether : 0,
            owner: msg.sender,
            name: _name,
            description: description,
            profileImage: _image,
            created: block.timestamp,
            participants: participants,
            image: image,
            images: images,
            totalNoOfImages: 0
        })

        album[totalAlbumCreated] = _album;

        albums.push(_album);

        emit AlbumCreated(msg.sender, _name, totalNoOfAlbumsCreated);
    }

    function joinAlbum(uint256 albumId) public payable {
        require(albumId > 0 && albumId <= totalAlbumCreated, "This album does not exist");

        Album storage _album = album[albumId];

        require(_album.visibility == "public" || msg.value >= _album.fee, "This is a private album.");
        
        _album.participants.push(msg.sender);

        if(_album.visibility == "private") {
            uint256 _fee = (fee * msg.value) / 100;
            uint256 balance = msg.value - _fee;

            (bool, os) = payable(_album.owner).call{value: balance}();
            require(os, "Fee payment to album owner failed.");

            (bool, os1) = payable(owner).call{value: _fee}();
            require(os1, "Fee payment to trybe owner failed.");
        }

        emit JoinedAlbum(msg.sender, block.timestamp);
    }

    function addImageToAlbum(
        uint256 albumId,
        string memory _url,
        string memory _description
    ) public {
        require(albumId > 0 && albumId <= totalAlbumCreated, "This album does not exist");

        Album storage _album = album[albumId];

        _album.totalNoOfImages += 1;

        bool isParticipant = false;
        
        for (uint256 i = 0; i < _album.participants.length; i++) {
            if (_album.participants[i] == msg.sender) {
                isParticipant = true;

                break;
            }
        }

        require(isParticipant, "Only those who have joined the album can add an image.");

        Image memory image = Image({
            owner: msg.sender,
            id: _album.totalNoOfImages,
            url: _url,
            description: _description
        })

        _album.image[_album.totalNoOfImages] = image;

        _album.images.push(image);

        emit ImageAdded(albumId, _album.totalNoOfImages);
    }

    function getAlbum( uint256 albumId) public view returns (Album memory) {
        require(albumId > 0 && albumId <= totalAlbumCreated, "This album does not exist");

        Album memory _album = album[albumId];

        return _album;
    }

    function getImagesInPublicAlbum(uint256 albumId) public view returns (Image[] memory) {
        require(albumId > 0 && albumId <= totalAlbumCreated, "This album does not exist");

        Album memory _album = album[albumId];

        require(_album.visibility == "public", "This is a private album.");

        return _album.images;
    }

    function getImageInPublicAlbum(uint256 albumId, uint256 imageId) public view returns (Image memory) {
        require(albumId > 0 && albumId <= totalAlbumCreated, "This album does not exist");
        require(imageId > 0 && imageId <= totalAlbumCreated, "This image does not exist");

        Album memory _album = album[albumId];

        require(_album.visibility == "public", "This is a private album.");

        Image memory image = _album.image[imageId];

        return image;
    }

    function getImagesInPrivateAlbum(uint256 albumId) public payable view returns (Image[] memory) {
        require(albumId > 0 && albumId <= totalAlbumCreated, "This album does not exist");

        Album memory _album = album[albumId];

        require(_album.visibility == "private" && msg.value >= _album.fee, "This is a public album.");

        uint256 _fee = (fee * msg.value) / 100;
        uint256 balance = msg.value - _fee;

        (bool, os) = payable(_album.owner).call{value: balance}();
        require(os, "Fee payment to album owner failed.");

        (bool, os1) = payable(owner).call{value: _fee}();
        require(os1, "Fee payment to trybe owner failed.");

        return _album.images;
    }

    function getImageInPrivateAlbum(uint256 albumId, uint256 imageId) public payable view returns (Image memory) {
        require(albumId > 0 && albumId <= totalAlbumCreated, "This album does not exist");
        require(imageId > 0 && imageId <= totalAlbumCreated, "This image does not exist");

        Album memory _album = album[albumId];

        require(_album.visibility == "private" && msg.value >= _album.fee, "This is a public album.");

        uint256 _fee = (fee * msg.value) / 100;
        uint256 balance = msg.value - _fee;

        (bool, os) = payable(_album.owner).call{value: balance}();
        require(os, "Fee payment to album owner failed.");

        (bool, os1) = payable(owner).call{value: _fee}();
        require(os1, "Fee payment to trybe owner failed.");

        Image memory image = _album.image[imageId];

        return image;
    }

    function getListofParticipants(uint256 albumId) public view returns (address[] memory){
        require(albumId > 0 && albumId <= totalAlbumCreated, "This album does not exist");

        Album memory _album = album[albumId];

        return  _album.participants;
    }
}
