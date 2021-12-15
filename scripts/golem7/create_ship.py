from brownie import GolemVII, accounts, config, network
from scripts.helpers import get_details
import time

def main():
    dev = accounts.add(config["wallets"]['from_key'])
    print()
    golem7 = GolemVII[len(GolemVII)-1]
    transaction = golem7.newMintShip("NONE", {"from": dev})
    transaction.wait(1)
    time.sleep(35)
    requestId = transaction.events["requestedShip"]['requestId']
    tokenId = golem7.requestIdToTokenId(requestId)
    ship = get_details(golem7.getTokenDetails(tokenId))
    print(ship)
