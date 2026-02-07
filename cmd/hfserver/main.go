package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
)

var (
	Version   = "dev-plus"
	Commit    = "none"
	BuildDate = "unknown"
)

func main() {
	host := flag.String("host", "0.0.0.0", "bind host")
	port := flag.String("port", "7860", "bind port")
	flag.Parse()
	mux := http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "CLIProxyAPIPlus HF build ok\nversion=%s commit=%s date=%s\n", Version, Commit, BuildDate)
	})
	addr := *host + ":" + *port
	log.Printf("HF stub server listening on %s", addr)
	if err := http.ListenAndServe(addr, mux); err != nil {
		log.Fatal(err)
	}
}
