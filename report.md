<div align="center">
  
# Laporan Tugas 1 : Deploy Docker Image ke VPS dan Penerapan CI/CD
| Nama              | NRP         |
|-------------------|-------------|
| Dea Kristin Ginting | 5025231040 |
</div>

## 📂 Struktur Pengerjaan

1. **Deskripsi Singkat Proyek**
   - API sederhana menggunakan Express.js
   - Menampilkan data status server melalui endpoint `/health`

2. **Langkah-langkah Pengerjaan**
   - Pembuatan dan konfigurasi API
   - Membuat VPS gratis dengan Azure 
   - Pembuatan `Dockerfile` dan build image
   - Push image ke Docker Hub
   - Deploy ke VPS menggunakan Docker
   - Setup GitHub Actions untuk CI/CD
   - Testing and debugging

## 🔗 Link Penting

| Komponen                     | Tautan                                                                 |
|-----------------------------|------------------------------------------------------------------------|
| Repository GitHub           | [tugas1_netics](https://github.com/oceanite/tugas1_netics)           |
| File `server.js`            | [server.js](https://github.com/oceanite/tugas1_netics/blob/main/server.js) |
| File `Dockerfile`           | [Dockerfile](https://github.com/oceanite/tugas1_netics/blob/main/dockerfile) |
| Workflow CI/CD (`deploy.yml`) | [.github/workflows/deploy.yml](https://github.com/oceanite/tugas1_netics/blob/main/.github/workflows/deploy.yml) |
| Endpoint Health Check       | [http://104.214.186.134/health](http://104.214.186.134/health)         |
| Docker Image (health-api)   | [Docker Image](https://hub.docker.com/repository/docker/daeginting/health-api) |

---

## 1. Pembuatan dan Konfigurasi API
  File `server.js` merupakan inti dari API yang dibangun menggunakan framework **Express.js**. API ini berfungsi untuk memberikan informasi status server melalui endpoint `/health`.
Untuk menjalankan server, dilakukan instalasi modul berikut:

```bash
npm install express cors
```

  Endpoint /health memberikan respons JSON berisi status server dan waktu hidupnya (uptime) dalam satuan detik. Server dapat diuji secara lokal dengan menjalankan:

```bash
node server.js
```

  Contoh respons:
![image](https://github.com/user-attachments/assets/e979d4b4-ce0e-4f88-a3c9-73f904cf7471)

## 2. Membuat VPS gratis dengan Azure 
Setelah berguru dari pentutor India di [video tutorial ini](https://youtu.be/4xGPfVfJ4iM?si=UcIOqxK4-3mNaSCc), akhirnya saya berhasil membuat sebuah server secara gratis. Kemudian jalankan server dengan klik `start`.

![image](https://github.com/user-attachments/assets/0180a2c2-df7e-427b-aa24-50b84b08b1e1)


## 3. Pembuatan `Dockerfile` dan build image
[Dockerfile](https://github.com/oceanite/tugas1_netics/blob/main/dockerfile) dibuat dalam bentuk multistage.

```bash
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
```

- Tahap pertama (build) menginstall dependencies di dalam image `Node.js` berbasis Alpine Linux.
- Tahap kedua menyalin hasil build ke image production yang bersih, hanya berisi hasil jadi dan tanpa folder node_modules development.
- EXPOSE 5000 menunjukkan bahwa aplikasi akan berjalan di port 5000.
- Perintah `bash CMD ["node", "server.js"]` digunakan untuk menjalankan aplikasi saat container dijalankan.
- Sebelum menggunakan DockerHub, saya langsung build image pada VPS, namun hal ini kurang best. 
