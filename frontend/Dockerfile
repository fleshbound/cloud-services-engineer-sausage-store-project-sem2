# Build
FROM node:16-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --no-audit --no-fund && \
    npm cache clean --force
COPY . .
RUN npm run build -- --prod

# Release
FROM nginx:1.30.0-alpine-slim
RUN addgroup -S nginxuser && \
    adduser -S -s /sbin/nologin nginxuser -G nginxuser
COPY --from=builder /app/dist/frontend /usr/share/nginx/html
RUN chown -R nginxuser:nginxuser /var/cache/nginx && \
    chown -R nginxuser:nginxuser /var/log/nginx && \
    chown -R nginxuser:nginxuser /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginxuser:nginxuser /var/run/nginx.pid
USER nginxuser
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
