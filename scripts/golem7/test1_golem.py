from brownie import GolemVII, accounts, config, network
import time
from scripts.golem7.create_golem import mint
from scripts.golem7.deploy_golem import deploy_golem

def test1():
    golem = deploy_golem()
    tokenid = mint()

def main():
    test1()