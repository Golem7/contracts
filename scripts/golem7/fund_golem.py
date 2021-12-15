from brownie import GolemVII
from scripts.helpers import fund_golem

def main():
    golem = GolemVII[len(GolemVII)-1]
    fund_golem(golem)