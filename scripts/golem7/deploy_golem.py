from brownie import GolemVII, accounts, network, config
from scripts.helpers import fund_golem


def deploy_golem():
    dev = accounts.load('test_moralis', password='123Test')
    print(network.show_active())
    publishSource=False
    golem7=GolemVII.deploy(
        config['networks'][network.show_active()]['vrf_coordinator'],
        config['networks'][network.show_active()]['link_token'],
        config['networks'][network.show_active()]['keyhash'],
        {"from": dev},
        publish_source = publishSource
    )
    fund_golem(golem7)
    return golem7

def main():
    deploy_golem()