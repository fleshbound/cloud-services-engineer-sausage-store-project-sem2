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
COPY --from=builder /app/dist/frontend /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
