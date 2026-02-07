#!/bin/sh

# 检查 config.yaml 是否存在
if [ -f "$HOME/app/config.yaml" ]; then
    echo "Injecting environment variables into config.yaml..."
    # 使用 envsubst 替换 config.yaml 中的环境变量占位符
    # 仅替换已定义的变量，避免破坏其他格式
    envsubst < "$HOME/app/config.yaml" > "$HOME/app/config.yaml.tmp" && mv "$HOME/app/config.yaml.tmp" "$HOME/app/config.yaml"
fi

# 启动主程序
exec "$@"