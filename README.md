<div align="center">
  
# Docker Image Deployment Using Azure and CI/CD Implementation
</div>

1. **Deskripsi Singkat Proyek**
   - API sederhana menggunakan Express.js
   - Menampilkan data status server melalui endpoint `/health`

2. **Langkah-langkah Pengerjaan**
   - Pembuatan dan konfigurasi API
   - Membuat VPS gratis dengan Azure 
   - Pembuatan `Dockerfile` dan build image
   - Push image ke Docker Hub
   - Deploy dan Setup GitHub Actions untuk CI/CD
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


## 3. Pembuatan `Dockerfile` dan Build Image
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
Agar image dapat diakses secara publik, image dapat dipush ke Docker Hub. Caranya:

- Login
`docker build -t daeginting/health-api:latest .`

- Build dan tag image
`docker tag tugas1-netics daeginting/health-api:latest`

- Push ke Docker Hub
`docker push daeginting/health-api:latest`

Kemudian untuk best practice, saya menambahkan username dan password Docker serta private key VPS saya sebagai secret di repository GitHub saya supaya lebih aman. Hasil image yang sudah dipublikasi dapat dilihat [di sini](https://hub.docker.com/repository/docker/daeginting/health-api).

![image](https://github.com/user-attachments/assets/fabc5059-54d7-4f1a-9658-e507ac783185)

## 5. Deploy dan Setup GitHub Actions untuk CI/CD
Setelah image berhasil dibangun, proses deploy dilakukan ke VPS menggunakan Docker. Tahapan-tahapan yang dilakukan di VPS antara lain:
- Masuk ke direktori project di VPS.
- Build docker image:
`docker build -t tugas1-netics .`
- Menjalankan container:
`docker run -d -p 80:5000 --name health-api tugas1-netics`

Setelah proses ini selesai, API dapat diakses melalui alamat publik VPS, dengan format
`http://<IP_ADDRESS>/health`
Dalam pengerjaan ini:
`http://104.214.186.134/health`

Agar deployment dilakukan secara otomatis setiap kali ada perubahan pada branch main, digunakan GitHub Actions sebagai sistem Continuous Integration & Deployment (CI/CD). Caranya:
- Buat file bernama .github/workflows/deploy.yml di dalam repositori GitHub.
- Berikut isi `deploy.yml` saya:
```bash
name: Deploy to VPS

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repo
      uses: actions/checkout@v3

    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
        
    - name: Build and Push to Docker Hub
      run: |
        docker build -t daeginting/health-api:latest .
        docker push daeginting/health-api:latest

    # Setup SSH
    - name: Setup SSH
      uses: webfactory/ssh-agent@v0.7.0
      with:
        ssh-private-key: ${{ secrets.SSH_PRVT_KEY }}

    - name: Deploy to VPS
      run: |
        ssh -o StrictHostKeyChecking=no ${{ secrets.VPS_USER }}@${{ secrets.VPS_HOST }} << 'EOF'
          which docker || (curl -fsSL https://get.docker.com | sh)

          docker pull daeginting/health-api:latest

          docker stop health-api || true
          docker rm health-api || true

          docker run -d -p 80:5000 --name health-api daeginting/health-api:latest

          docker ps -a
          docker logs health-api || true
        EOF
```
### Workflow
Pada workflow ini, proses yang didefinisikan adalah (`name: Deploy to VPS`):
- Build Docker image,
- Push ke Docker Hub,
- Deploy ke VPS menggunakan SSH.

### Events 
Workflow ini akan dijalankan secara otomatis setiap kali ada push ke branch `main`. Dalam hal ini `push`.

### Jobs
Terdapat 1 job bernama `deploy`. Job ini akan:
- Checkout repository
- Login ke Docker Hub
- Build & Push image
- Setup SSH
- SSH ke VPS dan menjalankan perintah deployment

### Actions
Actions adalah blok yang melakukan tugas tertentu. Bisa berupa action bawaan (dari GitHub) atau custom. Contoh actions di workflow ini:


- Untuk mengambil isi repo ke runner
  `uses: actions/checkout@v3`

- Untuk login ke Docker Hub
  `uses: docker/login-action@v2`

- Untuk mengaktifkan SSH agar bisa remote ke VPS
  `uses: webfactory/ssh-agent@v0.7.0`

### Runners
Runners adalah mesin tempat job dijalankan. Di workflow ini, digunakan runner GitHub default (hosted runner) dengan OS ubuntu-latest.
Runner `runs-on: ubuntu-latest` akan:
- Menjalankan perintah-perintah docker build, docker push
- Menjalankan SSH untuk mengakses VPS

## 6. Testing dan Debugging
Untuk memeriksa apakah CI/CD sudah terpasang dengan baik, coba lakukan perubahan ke salah satu file, misalnya file README.md seperti yang sudah saya lakukan dengan cara melakukan echo melalui VPS yang sudah saya buat kemudian `push` ke `main`. Kemudian di GitHub akan terlihat proses/alur CI/CD nya. 

![image](https://github.com/user-attachments/assets/53a403e2-c6b7-419f-8846-72097474fbb1)

Jika failed, cek detail prosesnya untuk melihat penyebabnya.
![image](https://github.com/user-attachments/assets/04f3dbd4-bb4a-468a-8e83-9a5f61ec618c)


## KESIMPULAN
- Containerization dilakukan untuk menampung semua artifact yang dibutuhkan untuk menjalankan aplikasi.
- Dengan Docker Hub, image yang sudah dibuat dapat digunakan oleh siapa saja dan pada VPS mana pun.
- CI/CD dilakukan agar setiap kali dilakukan perubahan pada code, aplikasi dapat secara otomatis terupdate.

## KENDALA
- Awalnya saya bingung maksud uptime, bagaimana cara mendapatkannya, dan bagaimana cara menampilkannya.
- Kesulitan mencari VPS gratis. Ternyata Azure bisa pakai akun ITS.


## Sekian dan Terima Kasih!
