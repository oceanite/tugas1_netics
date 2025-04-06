# Tahap 1: Build
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Tahap 2: Production Image
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app /app
EXPOSE 5000
CMD ["node", "server.js"]
