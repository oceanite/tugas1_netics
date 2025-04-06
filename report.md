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

- Base Image:
Menggunakan node:18-slim, image ringan untuk aplikasi Node.js.

- Locale dan Timezone:
Menginstal locales dan ca-certificates, lalu mengaktifkan locale id_ID.UTF-8 dan timezone Asia/Jakarta. Tujuannya untuk menyesuaikan waktu dan format lokal.

- Environment Variables:
  - NODE_ICU_DATA=full-icu: Mengaktifkan dukungan internasionalisasi Node.js.
  - LANG=id_ID.UTF-8: Menetapkan bahasa sistem ke Bahasa Indonesia.
  - TZ=Asia/Jakarta: Menyesuaikan zona waktu.

- Setup Aplikasi:
Direktori kerja ditentukan di `/app`. File `package*.json` disalin dan `npm install` dijalankan untuk menginstal dependensi. Kemudian seluruh kode disalin ke container.

- Expose dan CMD:
`Port 5000` diekspos dan perintah default container adalah menjalankan node `server.js`.

- Di awal saya belum menggunakan DockerHub, melainkan langsung melakukan build pada VPS. Caranya adalah dengan menghubungkan VPS saya dengan terminal menggunakan `ssh`. Kemudian hubungkan VPS saya dengan GitHub menggunakan SSH Keys. Setelah semuanya saling terhubung, saya melakukan build dengan:

```bash
docker build -t tugas1-netics .
```

Kemudian menjalankan container dengan:

```bash
docker run -d -p 80:5000 --name health-api tugas1-netics
```

## 4. Push image ke Docker Hub
Setelah membaca ulang petunjuk penugasan, saya jadi penasaran dengan Docker Hub dan ingin mencoba menggunakannya. Caranya:

- Login
`docker build -t daeginting/health-api:latest .`

- Build dan tag image
`docker tag tugas1-netics daeginting/health-api:latest`

- Push ke Docker Hub
`docker push daeginting/health-api:latest`

Kemudian untuk best practice, saya menambahkan username dan password Docker serta private key VPS saya sebagai secret di repository GitHub saya supaya lebih aman. Hasil image yang sudah dipublikasi dapat dilihat [di sini](https://hub.docker.com/repository/docker/daeginting/health-api).

![image](https://github.com/user-attachments/assets/fabc5059-54d7-4f1a-9658-e507ac783185)

## 5. Deploy ke VPS menggunakan Docker
File deploy.yml ini 

