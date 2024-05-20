const { SuiClient, Ed25519Keypair, RawSigner } = require('@mysten/sui');
const { Connection } = require('@mysten/sui/src/connection');
const { BCS, getSuiMoveConfig } = require('@mysten/bcs');

const main = async () => {
  // Setup connection and client
  const connection = new Connection({
    fullnode: 'https://fullnode.devnet.sui.io',
  });
  const client = new SuiClient(connection);

  // Generate a new keypair
  const keypair = Ed25519Keypair.generate();
  const signer = new RawSigner(keypair, client);

  // Create HelloWorld object
  const createHelloWorldTxn = {
    packageObjectId: '0x790355a1ab04e1adcf9a06a44f609622ac882b780cedd3f14ea64445c7b4e76c', // Replace with your deployed package ID
    module: 'hello_world',
    function: 'create_hello_world',
    arguments: [],
    gasBudget: 1000,
  };

  const response = await signer.signAndExecuteTransaction(createHelloWorldTxn);
  console.log('Create HelloWorld Transaction Response:', response);

  // Fetch the HelloWorld object
  const objectId = response.effects.events[0].moveEvent.moveObject.objectId; // Adjust according to actual response
  const helloWorldObject = await client.getObject(objectId);
  console.log('HelloWorld Object:', helloWorldObject);
};

main().catch(err => {
  console.error('Error:', err);
});
