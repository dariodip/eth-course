const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');  // we use web3 in uppercase because it is a constructor
const provider = ganache.provider();
const web3 = new Web3(provider);  // instance of web3 using ganache provider
const { interface, bytecode } = require('../compile');

const INITIAL_STRING = 'Hi there!';
const NEW_STRING = 'Bye there!';

let accounts;
let inbox;

beforeEach(async () => {
    // Get a list of all accounts
    accounts = await web3.eth.getAccounts();
    // Use one of those accounts to deploy the contract
    inbox = await new web3.eth.Contract(JSON.parse(interface))   
        .deploy({ data: bytecode, arguments: [INITIAL_STRING] })
        .send({ from: accounts[0], gas: '1000000' });
    
});

describe('Inbox', () => {
    it('deploys a contract', () => {
        assert.ok(inbox.options.address); // we are checking that the address is a value that exists 
    });

    it('has a correct default message', async () => {
        const message = await inbox.methods.message().call();
        assert.equal(INITIAL_STRING, message);
    });

    it('can change the message', async () => {
        await inbox.methods.setMessage(NEW_STRING).send({
            from: accounts[0]
        });
        const message = await inbox.methods.message().call();
        assert.equal(message, NEW_STRING);
        

    });
});
