# GolemVII contracts

This repo is base for GolemVII, on-chain NFT game prototype basing on ERC-1155.

Current base structure contain:

1. Base contract [GolemVII.sol](./contracts/GolemVII.sol)
2. [Chainlink VRF](https://docs.chain.link/docs/get-a-random-number) for random, dynamic artibutes creation. 
3. Brownie scripts for deployment, fund, and create(mint).
4. Basic brownie-config.yaml .

## Quickstart

Basic Brownie installation is required. [Install guide](https://eth-brownie.readthedocs.io/en/stable/install.html).

Right now repo is intended to work on mumbay (Polygon testnet). 

### Setup Environment Variables

You'll need to set testnet wallet details and moralis speedy node endpoint address for mumbai in enviroment. 

You can use `PRIVATE_KEY` and get key from metamask. [Details](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).

`MORALIS_NODE` is speedy node url [Details](https://docs.moralis.io/speedy-nodes/connecting-to-rpc-nodes/connect-to-eth-node).

You can provide such variables via creation of `.env` file.

```bash
export PRIVATE_KEY='frog dog smog...'
export MORALIS_NODE='https://speedy-nodes-nyc.moralis.io/XXXXX'
```

### Adding mumbai network

To add network run `./scripts/polygon_setting.bash`. In case execution premissions are missing: `chmod +x ./scripts/polygon_setting.bash`.

### Deployment, funding and other actions

1. To deploy contract run: `brownie run scripts/golem7/deploy_golem.py --network mumbai_moralis` 
2. To fund contract after deployment with link (for chainlink oracle) run: `brownie run scripts/golem7/fund_golem.py --network mumbai_moralis` 
3. Next you can mint ``ship`` with randomly generated atributes: `brownie run scripts/golem7/create_ship.py --network mumbai_moralis` 