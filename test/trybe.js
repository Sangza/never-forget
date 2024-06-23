const except = require('chai');
const hre = require('hardhat');

describe('Trybe', function () {
    it('this is to join an album', async function(){
      const trybe = await hre.ethers.deployContract("Trybe");

      except(await trybe.createAlbum('Onchain Summer','Building Onchain',))
    })
})