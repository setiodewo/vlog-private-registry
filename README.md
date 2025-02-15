# VLOG PRIVATE DOCKER REGISTRY

Referensi:
  - What is Registry? https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-registry/
  - Image Docker Registry https://hub.docker.com/_/registry
  - Tutorial Setup Private Docker Registry https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-20-04

Buat folder reg untuk menyimpan file2 yg dibutuhkan


## 1. Setup nginx (container-based)

  Kita memerlukan nginx untuk proxy_pass, buat authentikasi & SSL

  1. Buat Dockerfile untuk nginx (lihat file Dockerfile)
  2. Buat subfolder ./auth untuk menyimpan file autentikasi


## 2. Install Registry

  1. Buat docker-compose.yml (lihat docker-compose.yml)
  2. Buat subfolder ./data.


## 3. Jalankan

  ```
  docker compose up --build
  ```

  Test registry

  ```
  curl http://localhost/v2/_catalog
  ```


## 4. Buat user & password

  Masuk container nginx

  ```
  docker exec -it nginx bash
  ```

  Buat file otentikasi.
  Parameter -B artinya membuat password dengan algoritma bcrypt.

  ```
  cd /auth
  htpasswd -Bc registry.password dewo
  ```

  Untuk menambah user lain, hilangkan parameter c. Contoh:
  
  ```
  htpasswd -B registry.password namausernya
  ```


## 5. Naikkan ukuran upload nginx

  Masuk ke container

  ```
  docker exec -it nginx bash
  nano /etc/nginx/nginx.conf
  ```

  Tambahkan baris client_max_body_size di blok http:

  ```
  http {
        client_max_body_size 16384m;
        ...
  }
  ```

  Restart nginx dari host:

  ```
  docker restart nginx
  ```


## 6. Login ke registry

  Login dengan cli:

  ```
  docker login localhost
  ```

  Coba pull image & push ke registry private

  ```
  docker pull nginx:latest

  docker tag nginx:latest localhost/nginx:latest

  docker push localhost/nginx:latest
  ```


## 7. Tambahkan IP dari registry ke insecure-registries

  Jika kita menggunakannya di LAN, maka tidak perlu setup HTTPS. Jadi cukup tambahkan alamat IP registry kita ke server2 yang nantinya pull/push image via registry kita.

  Buat file /etc/docker/daemon.json dengan isi sbb:

  ```
  {
    "insecure-registries" : [ "192.168.0.133:5000" ]
  }
  ```

  Jika menggunakan Docker Desktop, maka harus ditambahkan di Setting > Docker Engine:

  ```
  "insecure-registries" : [ "192.168.0.133:5000" ]
  ```

  <ins>**NOTES:**</ins>

    - Ubah IP sesuai dengan alamat server kalian ya.

    - Jika sudah menggunakan nginx proxy_pass, maka tidak perlu port 5000.


## 8. Jika ingin menggunakan HTTPS

  1. Pastikan memiliki IP public & domain name yg sudah pointing ke IP tsb.
  2. Bisa menggunakan letsencrypt untuk mendapatkan key SSL.
  3. Redirect port 80 ke 443.
  4. Masukkan public & private key di konfigurasi nginx (/etc/nginx/conf.d/default.conf).



## Xenara Cafe and Coworking Space

Ruko Citra Grand, Blok London C-08, Semarang, Jawa Tengah, Indonesia
