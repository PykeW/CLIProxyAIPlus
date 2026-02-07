package hfspace

import (
	"bufio"
	"context"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"
)

type Event struct {
	At   time.Time
	Line string
}

func endpoint(space, kind string) (string, error) {
	space = strings.TrimSpace(space)
	kind = strings.TrimSpace(kind)
	if space == "" {
		return "", errors.New("space is empty")
	}
	switch kind {
	case "build":
		return "https://huggingface.co/api/spaces/" + space + "/logs/build", nil
	case "run":
		return "https://huggingface.co/api/spaces/" + space + "/logs/run", nil
	default:
		return "", fmt.Errorf("unknown kind %s", kind)
	}
}

func Stream(ctx context.Context, token, space, kind string) (<-chan Event, <-chan error) {
	out := make(chan Event, 64)
	errc := make(chan error, 1)
	go func() {
		defer close(out)
		defer close(errc)
		url, err := endpoint(space, kind)
		if err != nil {
			errc <- err
			return
		}
		req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
		if err != nil {
			errc <- err
			return
		}
		if strings.TrimSpace(token) != "" {
			req.Header.Set("Authorization", "Bearer "+strings.TrimSpace(token))
		}
		client := &http.Client{}
		resp, err := client.Do(req)
		if err != nil {
			errc <- err
			return
		}
		defer func() { _ = resp.Body.Close() }()
		if resp.StatusCode != 200 {
			errc <- fmt.Errorf("status %d", resp.StatusCode)
			return
		}
		r := bufio.NewReader(resp.Body)
		for {
			select {
			case <-ctx.Done():
				return
			default:
			}
			line, err := r.ReadString('\n')
			if len(line) > 0 {
				l := strings.TrimRight(line, "\r\n")
				if strings.HasPrefix(l, "data:") {
					l = strings.TrimSpace(l[5:])
				}
				out <- Event{At: time.Now(), Line: l}
			}
			if err != nil {
				if errors.Is(err, context.Canceled) {
					return
				}
				if err.Error() == "EOF" {
					return
				}
				errc <- err
				return
			}
		}
	}()
	return out, errc
}

type Diagnosis struct {
	Title   string
	Reason  string
	Actions []string
}

func Diagnose(lines []string) []Diagnosis {
	ds := make([]Diagnosis, 0, 8)
	text := strings.Join(lines, "\n")
	if strings.Contains(text, "does not contain package github.com/PykeW/CLIProxyAIPlus") {
		ds = append(ds, Diagnosis{
			Title:  "模块路径不匹配",
			Reason: "远端 v1.x 被解析为 /v6 导入",
			Actions: []string{
				"在 go.mod 添加: replace github.com/PykeW/CLIProxyAIPlus => .",
				"执行 go mod tidy && go mod vendor 并重新构建",
			},
		})
	}
	if strings.Contains(text, "The term 'go' is not recognized") || strings.Contains(text, "missing git") {
		ds = append(ds, Diagnosis{
			Title:  "构建环境缺少工具",
			Reason: "镜像中缺少 go 或 git",
			Actions: []string{
				"在 builder 期安装 git: RUN apk add --no-cache git",
				"使用官方 golang:alpine 基础镜像",
			},
		})
	}
	if strings.Contains(text, "unknown flag: -addr") {
		ds = append(ds, Diagnosis{
			Title:  "启动参数无效",
			Reason: "程序不支持 -addr",
			Actions: []string{
				"改为使用: --host 0.0.0.0 --port 7860",
				"更新 Dockerfile CMD 绑定 7860 端口",
			},
		})
	}
	if strings.Contains(text, "Cloud deploy mode") && strings.Contains(text, "standing by for configuration") {
		ds = append(ds, Diagnosis{
			Title:  "云部署缺少有效配置",
			Reason: "加载到空或无效的 config.yaml",
			Actions: []string{
				"确保复制 config.example.yaml 到运行目录 config.yaml",
				"或提供 --host/--port 覆盖并启动服务",
			},
		})
	}
	return ds
}
