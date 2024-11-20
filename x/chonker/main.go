package main

import (
	"fmt"
	"os"

	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	rpcclient "github.com/gnolang/gno/tm2/pkg/bft/rpc/client"
	"github.com/gnolang/gno/tm2/pkg/crypto/keys"
)

func getClient() gnoclient.Client {
	kb, _ := keys.NewKeyBaseFromDir(os.Getenv("GNO_KEYBASE_DIR"))
	signer := gnoclient.SignerFromKeybase{
		Keybase:  kb,
		Account:  os.Getenv("GNO_ACCOUNT"),
		Password: os.Getenv("GNO_PASSWORD"),
	}
	rpcClient, _ := rpcclient.NewHTTPClient(os.Getenv("GNO_RPC_ADDR"))
	client := gnoclient.Client{
		Signer:    signer,
		RPCClient: rpcClient,
	}
	return client
}

func main() {
	client := getClient()

	fmt.Println(client)

}
