const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const {interface, bytecode} = require('./compile');
require('dotenv').load();

const provider = new HDWalletProvider(
	process.env.SECRET,
	'https://rinkeby.infura.io/v3/3fb8f431db684cdd94895e1142cba10b'
);
const web3 = new Web3(provider);

const deploy = async () => {
	const accounts = await web3.eth.getAccounts();
	console.log('Attempting to deploy from account', accounts[0]);
	
	const result = await new web3.eth.Contract(JSON.parse(interface))
		.deploy({ data: '0x' + bytecode })
		.send({gas: '1000000', from: accounts[0] });

	console.log('Contract deployed to ', result.options.address);
    console.log(interface);	
};
deploy();
