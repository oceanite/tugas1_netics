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
   - Pembuatan dan konfigurasi `server.js`
   - Pembuatan `Dockerfile` dan build image
   - Push image ke Docker Hub
   - Deploy ke VPS menggunakan Docker
   - Setup GitHub Actions untuk CI/CD
   - Testing and debugging

## 🔗 Link Penting

| Komponen                     | Tautan                                                                 |
|-----------------------------|------------------------------------------------------------------------|
| Repository GitHub           | [tugas1_netics](https://github.com/deaginting/tugas1_netics)           |
| File `server.js`            | [server.js](https://github.com/deaginting/tugas1_netics/blob/main/server.js) |
| File `Dockerfile`           | [Dockerfile](https://github.com/deaginting/tugas1_netics/blob/main/Dockerfile) |
| Workflow CI/CD (`deploy.yml`) | [.github/workflows/deploy.yml](https://github.com/deaginting/tugas1_netics/blob/main/.github/workflows/deploy.yml) |
| Endpoint Health Check       | [http://104.214.186.134/health](http://104.214.186.134/health)         |
| Docker Image (health-api)   | [Docker Image](https://hub.docker.com/repository/docker/daeginting/health-api) |

---

## 1. Pembuatan dan Konfigurasi API
  File `server.js` merupakan inti dari API yang dibangun menggunakan framework **Express.js**. API ini berfungsi untuk memberikan informasi status server melalui endpoint `/health`.
Untuk menjalankan server, dilakukan instalasi modul berikut:

```bash
npm install express cors

Endpoint /health memberikan respons JSON berisi status server dan waktu hidupnya (uptime) dalam satuan detik. Server dapat diuji secara lokal dengan menjalankan:

```bash
node server.js

Contoh respons:
![image](https://github.com/user-attachments/assets/e979d4b4-ce0e-4f88-a3c9-73f904cf7471)

