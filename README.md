# crypto_final_2021



## prerequisite

- metamask
- [remix IDE](https://remix.ethereum.org/)

## How to Use

First of all, paste the code to [remix IDE](https://remix.ethereum.org/) and run the 

### Flow

Add a compnay ➡️  Issue/Re-issue/Transfer ➡️ Comfirm an Action

### Add a Company

Please enter the following information. 

```
1. company name (string)
2. funding date (string)
3. number of shares (uint)
4. funders' adress (array of address)
5. number of comfirmation for each action (uint)
```

After you add a company, the first number of shares genesis will be minted automatically.

The NFT is under the system (not one of the funder's address)

![截圖 2022-01-17 下午10.23.19](https://s2.loli.net/2022/01/17/hezNtoZT4DvburU.png)



### Issue

To issue/mint a token, just enter the company name. the "issue" event will start when the number of confirmations is enough.

Note: Only funders can issue a token. 

![截圖 2022-01-17 下午10.29.54](https://s2.loli.net/2022/01/17/VGkLdcIlSMJ1v2C.png)

### Re-Issue

Same as Issue. The difference is that the "reissue" event will burn a token and issue two token.

Note: if the token is not enough, re-issue will fail.

![截圖 2022-01-17 下午10.36.31](https://s2.loli.net/2022/01/17/pPcXYFENzm2t67W.png)

### Transfer

To transfer a token to a given address. Enter the following informations:

```
1. Compayn name(string)
2. Target address (address)
```

Note: Only funders can launch a transfer event.

Note: transfer will start when the number of confirmations is enough.

![截圖 2022-01-17 下午10.36.47](https://s2.loli.net/2022/01/17/juAoO4UCmn5Z1gM.png)

### Confirm an Action

After an action is launched, funders can confirm the action by "confirmAction".

The informations needed are:

```
1. Company name (string)
2. action index (uint)
```

Once the number of confirmations is enough. the action will be launched automatically.

Note: Only funders can confirm an action.

![截圖 2022-01-17 下午10.39.31](https://s2.loli.net/2022/01/17/jXzHOYcKt4VyvZa.png)



## Links

OpenSea: https://testnets.opensea.io/assets/0xbcef17ee68d05e923a372d489b0185595c430980/0 

Github: https://github.com/KaiChen1008/crypto_final_2021

## Reference

https://www.itread01.com/content/1526458804.html

https://ethereum.stackexchange.com/questions/30912/how-to-compare-strings-in-solidity/103807

https://ithelp.ithome.com.tw/articles/10204297

https://solidity-by-example.org/app/multi-sig-wallet/

https://docs.openzeppelin.com/openzeppelin/
