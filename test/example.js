const {except} = require('chai');
const hre = require('hardhat');
const time = require('@nomicfoundation/hardhat-toolbox/network-helpers');

describe("Example", ()=>{
    it('should run the example',async function name() {
        await hre.ethers.deployContract('Example')
    })
})