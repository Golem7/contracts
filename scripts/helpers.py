from brownie import GolemVII, accounts, config, interface, network

def fund_golem(nft_contract):
    dev = accounts.add(config["wallets"]['from_key'])
    link_token = interface.LinkTokenInterface(config['networks'][network.show_active()]['link_token'])
    link_token.transfer(nft_contract, 1000000000000000000, {"from": dev})