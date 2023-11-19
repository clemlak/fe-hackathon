![ban](https://taikai.azureedge.net/3hXwJK0rFDB-IYZCOUDwnF3n0ZlLl_RikuZBDjwtFJM/rs:fit:1920:0:0/aHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL3RhaWthaS1zdG9yYWdlL2ltYWdlcy9kMTgzZTc0MC04NmIxLTExZWUtODQ3Mi0yZGI4YTQ2NjcyYjhfMmIxOTg3NDgtN2VmZC00ZGI1LTgyMjAtMjU3Yjc5YTYzMTdkLmpwZWc)

# Fecret Santa

A Secret Santa with a twist! Send a collectible to the last Santa and you'll be the next to receive a gift 🎅

## Overview

Fecret Santa is fun project made for the [Fe hackathon](https://taikai.network/felang/hackathons/ist2023), and obviously the smart-contract is written in [Fe](https://fe-lang.org)!

This version of Secret Santa is a bit different from the original one, here the concept is based on a chain (see what I did there?) of Santas, where anyone can join by sending a gift to the last Santa in the chain, and then they'll be the next to receive a gift!

Santas can gift each other ERC721 and ERC1155 tokens, however the collectibles must be whitelisted beforehand (to keep the Grinch away from ruining the fun!).

## Instructions

This repository is a Fe project that comes with Foundry installed. This allowed me to create more complex tests (Fe tests are kind of limited at this time) and deploy ERC721 and ERC1155 mock contracts.

If you want to test or build the project, be sure to:
1. Install [Fe](https://fe-lang.org)
2. Install [Foundry](https://getfoundry.sh)

Then you can, you'll be able to:

Run the Fe tests:

```shell
$ fe test
```

Or build the Fe project:
```shell
$ fe build
```

You can also run the Forge tests:
```shell
$ forge test
```

Have fun!
