package main

import (
	"fmt"
	"log"
	"os"

	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	"github.com/gnolang/gno/gno.land/pkg/gnoland/ugnot"
	"github.com/gnolang/gno/gno.land/pkg/sdk/vm"
	rpcclient "github.com/gnolang/gno/tm2/pkg/bft/rpc/client"
	"github.com/gnolang/gno/tm2/pkg/std"
)

func getClient() gnoclient.Client {
	mnemo := os.Getenv("GNO_MNEMONIC")
	bip39Passphrase := ""
	account := uint32(0)
	index := uint32(0)
	chainID := os.Getenv("GNO_CHAIN_ID")

	signer, _ := gnoclient.SignerFromBip39(mnemo, chainID, bip39Passphrase, account, index)

	remote := os.Getenv("GNO_RPC_ADDR")
	rpcClient, _ := rpcclient.NewHTTPClient(remote)

	return gnoclient.Client{
		Signer:    signer,
		RPCClient: rpcClient,
	}
}

func main() {
	client := getClient()

	cfg := gnoclient.BaseTxCfg{
		GasWanted:      100000,
		GasFee:         ugnot.ValueString(10_000),
		AccountNumber:  1,
		SequenceNumber: 1,
	}

	caller, err := client.Signer.Info()

	if err != nil {
		log.Fatal("Failed to get signer info", err)
	}

	msg := []vm.MsgCall{
		{
			Caller:  caller.GetAddress(),
			PkgPath: "gno.land/r/n2p5/home",
			Func:    "Render",
			Args:    []string{""},
			Send:    std.Coins{{Denom: ugnot.Denom, Amount: int64(100)}},
		},
	}

	res, err := client.Call(cfg, msg...)
	if err != nil {
		log.Fatal("Failed to call ", err)
	}
	fmt.Println(res)
}
