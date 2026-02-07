FROM golang:1.24-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# 构建
ARG VERSION=dev
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w -X 'main.Version=${VERSION}-plus'" -o ./CLIProxyAPIPlus ./cmd/server/

FROM alpine:3.22.0

# 安装基础工具和 gettext (用于 envsubst)
RUN apk add --no-cache tzdata ca-certificates gettext

# 创建非 root 用户 (Hugging Face 推荐)
RUN adduser -D -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

WORKDIR $HOME/app

# 复制二进制文件
COPY --from=builder --chown=user /app/CLIProxyAPIPlus $HOME/app/CLIProxyAPIPlus
COPY --from=builder --chown=user /app/config.example.yaml $HOME/app/config.yaml
COPY --chown=user entrypoint.sh $HOME/app/entrypoint.sh

# 创建必要的目录并设置权限
RUN mkdir -p $HOME/app/logs $HOME/app/auths && \
    chmod 777 $HOME/app/logs $HOME/app/auths && \
    chmod +x $HOME/app/entrypoint.sh

# 暴露 Hugging Face 默认端口
EXPOSE 7860

# 启动命令：使用 entrypoint.sh 处理配置，然后启动应用
ENTRYPOINT ["./entrypoint.sh"]
CMD ["./CLIProxyAPIPlus", "-addr", "0.0.0.0:7860"]
