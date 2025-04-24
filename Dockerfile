# syntax=docker/dockerfile:1

ARG CADDY_VERSION=latest

# 构建阶段
FROM golang:1.21-alpine AS builder

RUN apk add --no-cache git

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build "$CADDY_VERSION" \
    --with github.com/caddy-dns/dnspod

# 运行时阶段
FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /go/caddy /usr/bin/caddy

# 验证插件安装
RUN caddy list-modules | grep "dns.providers.dnspod"
