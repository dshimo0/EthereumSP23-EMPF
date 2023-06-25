const Web3 = require('web3');
const contract = require("@truffle/contract");
const EmprestaFacil_artifact = require('./build/contracts/EmprestaFacil.json');

async function main() {
  let provider = new Web3.providers.HttpProvider("http://localhost:7545");
  let EmprestaFacil = contract(EmprestaFacil_artifact);
  EmprestaFacil.setProvider(provider);

  let instance = await EmprestaFacil.at('0x460a1fdf346F71b96796aF7e66512E199c6B2E2b');
  let name = await instance.name();
  let symbol = await instance.symbol();
  let totalSupply = await instance.totalSupply();

  console.log(`Name: ${name}`);
  console.log(`Symbol: ${symbol}`);
  console.log(`Total Supply: ${totalSupply.toString()}`);
}

main();
