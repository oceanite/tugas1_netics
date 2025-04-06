FROM node:18-slim

# Install full-icu dan dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    full-upgrade \
    locales \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable untuk full-icu
ENV NODE_ICU_DATA=/usr/lib/node_modules/full-icu
ENV LANG=id_ID.UTF-8
ENV TZ=Asia/Jakarta

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 5000
CMD ["node", "server.js"]
