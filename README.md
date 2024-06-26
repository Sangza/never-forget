# Never Forget

Never Forget is a blockchain-based platform for storing and sharing memories. This platform allows users to securely store photos, videos, files, music, and other digital memories. Users has the ability to share these memories with others and can also monetize their content by charging for access. For instance, event planners can use this platform instead of Google Photos to store event images, offering them for purchase to attendees. Similarly, photographers can monetize their digital images by sending them through this platform.

## Features

- **Create Albums**: Users can create albums with a name, description, and profile image.
- **Join Albums**: Users can join existing albums to contribute and view shared memories.
- **Add Images**: Participants can add images to the albums they have joined.
- **Create Collections**: Album admins can create collections within albums to organize images.
- **Move Images**: Images can be moved from one album to another.
- **View Participants**: View the list of participants in an album.
- **View Images and Collections**: Retrieve and view images and collections within an album.

## Smart Contracts

The dApp consists of the following smart contracts:

- **Trybe**: The main contract that handles album creation, joining, image addition, collection creation, and moving images between albums.
- **AlbumImage**: Handles image-related data and functionalities.
- **AlbumCollections**: Manages collections of images within albums.

## Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/yourusername/never-forget.git
    ```

2. **Navigate to the project directory**:
    ```sh
    cd never-forget
    ```

3. **Install dependencies**:
    ```sh
    npm install
    ```

4. **Compile the contracts**:
    ```sh
    npx hardhat compile
    ```

5. **Deploy the contracts**:
    ```sh
    npx hardhat run scripts/deploy.js --network yournetwork
    ```

## Usage

1. **Create an Album**:
    ```solidity
    function createAlbum(
        string memory _name,
        string memory description,
        string memory profile,
        address[] memory _participant,
        AlbumImage.Image[] memory imageee,
        AlbumCollections.Collections[] memory collectionee
    ) public returns (Memory memory);
    ```

2. **Join an Album**:
    ```solidity
    function joinAlbum(uint256 albumId) public;
    ```

3. **Add Images to an Album**:
    ```solidity
    function addImagestoAlbum(
        uint256 albumId,
        string memory _Imageurl,
        string memory _description
    ) public;
    ```

4. **Create a Collection in an Album**:
    ```solidity
    function createCollection(uint256 albumId, string memory _name, uint256[] memory images) public;
    ```

5. **Move an Image from One Album to Another**:
    ```solidity
    function moveImagefromanAlbumtoAnotherAlbum(uint256 albumId1, uint256 albumId2, uint256 imageId) public;
    ```

6. **Get Album Details**:
    ```solidity
    function getAlbum(uint256 albumId) public view returns (Memory memory);
    ```

7. **Get Images in an Album**:
    ```solidity
    function getImageInAlbum(uint256 albumId) public view returns (AlbumImage.Image[] memory);
    ```

8. **Get Collections in an Album**:
    ```solidity
    function getCollectionsInAlbum(uint256 albumId) public view returns (AlbumCollections.Collections[] memory);
    ```

9. **Get Images from a Collection**:
    ```solidity
    function getImageFromCollection(
        address adminnn,
        uint256 albumId,
        uint256 collectionId
    ) public view returns (AlbumImage.Image[] memory images);
    ```

10. **Get List of Participants in an Album**:
    ```solidity
    function getTheListofParticipant(uint256 albumId) external view returns (address[] memory participant);
    ```

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or inquiries, please contact [your email].

---

Feel free to customize this README file to fit your specific needs and project structure.
