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
| Docker Image (health-api)   | [Docker Image] (https://hub.docker.com/repository/docker/daeginting/health-api)|

---
