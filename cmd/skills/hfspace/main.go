package main

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/router-for-me/CLIProxyAPI/v6/internal/skills/hfspace"
)

func readTokenFromFile(path string) string {
	f, err := os.Open(strings.TrimSpace(path))
	if err != nil {
		return ""
	}
	defer func() { _ = f.Close() }()
	sc := bufio.NewScanner(f)
	var last string
	for sc.Scan() {
		line := strings.TrimSpace(sc.Text())
		if line != "" {
			last = line
		}
	}
	t := strings.TrimSpace(last)
	if strings.HasPrefix(t, "hf_") {
		return t
	}
	return ""
}

func main() {
	space := flag.String("space", "", "")
	kind := flag.String("kind", "build", "")
	diagnose := flag.Bool("diagnose", true, "")
	timeout := flag.Duration("timeout", 60*time.Second, "")
	tokenArg := flag.String("token", "", "")
	tokenFile := flag.String("token-file", "", "")
	flag.Parse()
	token := strings.TrimSpace(*tokenArg)
	if token == "" && strings.TrimSpace(*tokenFile) != "" {
		token = readTokenFromFile(*tokenFile)
	}
	if token == "" {
		token = strings.TrimSpace(os.Getenv("HF_TOKEN"))
	}
	if token == "" {
		wd, _ := os.Getwd()
		p := wd + string(os.PathSeparator) + ".trae" + string(os.PathSeparator) + "skills" + string(os.PathSeparator) + "hf-log-recovery" + string(os.PathSeparator) + "token.local"
		token = readTokenFromFile(p)
	}
	if token == "" {
		fmt.Println("missing env HF_TOKEN")
		return
	}
	if strings.TrimSpace(*space) == "" {
		fmt.Println("missing --space owner/space")
		return
	}
	ctx, cancel := context.WithTimeout(context.Background(), *timeout)
	defer cancel()
	lines := make([]string, 0, 1024)
	events, errs := hfspace.Stream(ctx, token, *space, *kind)
	done := make(chan struct{})
	go func() {
		w := bufio.NewWriter(os.Stdout)
		for e := range events {
			txt := strings.TrimSpace(e.Line)
			if txt == "" {
				continue
			}
			lines = append(lines, txt)
			_, _ = w.WriteString(txt + "\n")
			_ = w.Flush()
		}
		close(done)
	}()
	select {
	case err := <-errs:
		if err != nil {
			fmt.Println("error:", err.Error())
		}
	case <-done:
	case <-ctx.Done():
	}
	if *diagnose {
		ds := hfspace.Diagnose(lines)
		if len(ds) == 0 {
			fmt.Println("no diagnostics")
			return
		}
		for i := range ds {
			fmt.Println("diagnosis:", ds[i].Title)
			fmt.Println("reason:", ds[i].Reason)
			for _, a := range ds[i].Actions {
				fmt.Println("action:", a)
			}
		}
	}
}
