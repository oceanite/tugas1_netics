FROM node:18-slim

# Install full-icu dan set locale + timezone
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    locales \
    ca-certificates \
    && echo "id_ID.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen id_ID.UTF-8 && \
    update-locale LANG=id_ID.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV NODE_ICU_DATA=full-icu
ENV LANG=id_ID.UTF-8
ENV TZ=Asia/Jakarta

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 5000
CMD ["node", "server.js"]
