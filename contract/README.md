
# Smart contract


starkli declare --account account.json --keystore keystore.json --network=sepolia target/dev/contract_LotteryStarknet.contract_class.json

```bash
Sierra compiler version not specified. Attempting to automatically decide version to use...
Network detected: sepolia. Using the default compiler version for this network: 2.9.1. Use the --compiler-version flag to choose a different version.
Declaring Cairo 1 class: 0x05e26e7afdedacdd3d57e43753e1ac892a2dac4f32b421695281ddb4b4c99e23
Compiling Sierra class to CASM with compiler version 2.9.1...
CASM class hash: 0x07a9909066dc85942ca500c182ede52ac4e9a3f3f1cf38265b8e9e631c6eb9e8
Contract declaration transaction: 0x02145cc8f9871774335604a2d9c55f221421918aff6338589b80909e454906ae
Class hash declared:
0x05e26e7afdedacdd3d57e43753e1ac892a2dac4f32b421695281ddb4b4c99e23
```


starkli deploy --account account.json --keystore keystore.json \
    0x05e26e7afdedacdd3d57e43753e1ac892a2dac4f32b421695281ddb4b4c99e23 \
    0x82c1420bef90ef7f26ab41054f0f638fc9e68dc5a7bc62ee304109d3db1d89 \
    --network=sepolia

```bash
Deploying class 0x05e26e7afdedacdd3d57e43753e1ac892a2dac4f32b421695281ddb4b4c99e23 with salt 0x032bbb4c0a8aefdf9ab8ee4c19432bb0b7ab9760ab08a96777d89672fa2e5ed8...
The contract will be deployed at address 0x058ec50072f4cb7587809f2c18cc216ca2c706f22d165128a0c1ca0e22175049
Contract deployment transaction: 0x04d714f1a1a9bd13164e6bd797ac3c1b7be2a96e5deca53c7516728426a0d173
Contract deployed:
0x058ec50072f4cb7587809f2c18cc216ca2c706f22d165128a0c1ca0e22175049
```




starkli invoke --account account.json --keystore keystore.json --network=sepolia \
    0x058ec50072f4cb7587809f2c18cc216ca2c706f22d165128a0c1ca0e22175049 \
    create_new_contest 1738368000

1738368000 - Saturday 1 February 2025 00:00:00