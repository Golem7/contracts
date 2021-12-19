from brownie import GolemVII, accounts, config, network
import time

def mint():
    dev = accounts.add(config["wallets"]['from_key'])
    print()
    golem7 = GolemVII[len(GolemVII)-1]
    transaction = golem7.newMintGolem({"from": dev})
    transaction.wait(1)
    time.sleep(35)
    requestId = transaction.events["requestedGolem"]['requestId']
    tokenId = golem7.requestIdToTokenId(requestId)
    golem = golem7.getTokenDetails(tokenId)
    print(golem)
    return(tokenId)

def main():
    mint()
