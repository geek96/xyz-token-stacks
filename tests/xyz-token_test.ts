
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';

Clarinet.test({
    name: "Ensure that token can be transferred",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let deployer = accounts.get("deployer")!;
        let wallet_1 = accounts.get("wallet_1")!;
        let block = chain.mineBlock([
            Tx.contractCall("xyz-token", "transfer", [
                types.int(10000000000), 
                types.principal(deployer.address), 
                types.principal(wallet_1.address),
                types.none()
            ], deployer.address),
        ]);
        block.receipts[0].result.expectOk().expectBool(true);
    }
})
