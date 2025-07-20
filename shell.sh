#!/bin/bash

clear
echo "======================================="
echo "     🔒 Setup Tunnel Cloudflare 🔒     "
echo "        by BetaBotz | Ptero Ready      "
echo "======================================="

# === INPUT DARI USER (tanpa read -p agar tampil di Pterodactyl) ===
echo ""
echo "📥 Masukkan nama folder tempat script berada (misal: api): "
read FOLDER

echo ""
echo "📥 Masukkan nama tunnel/subdomain yang ingin digunakan (misal: gates): "
read SUBDOMAIN

echo ""
echo "📥 Masukkan port lokal tempat server berjalan (misal: 3000): "
read PORT

# === PROSES SETUP SCRIPT PANEL ===
echo ""
echo "📂 Masuk ke folder '$FOLDER'..."
cd "$FOLDER" || { echo "❌ Folder '$FOLDER' tidak ditemukan!"; exit 1; }

echo "📦 Menginstall dependencies..."

echo "🚀 Menjalankan script dengan PM2..."

# === KEMBALI KE HOME ===
cd ~

# === SETUP CLOUDFLARED ===
echo ""
echo "🌐 Mendownload cloudflared..."
wget -q -O cr https://github.com/cloudflare/cloudflared/releases/download/2023.10.0/cloudflared-linux-amd64

echo "🔒 Memberi izin eksekusi ke cloudflared..."
chmod +x cr

echo "🔐 Login ke akun Cloudflare (akan membuka browser)..."
./cr tunnel login

echo "🌈 Membuat tunnel bernama '$SUBDOMAIN'..."
./cr tunnel create "$SUBDOMAIN"

echo "🌍 Menambahkan DNS CNAME ke '$SUBDOMAIN'..."
./cr tunnel route dns "$SUBDOMAIN" "$SUBDOMAIN"

echo "🛣️ Menjalankan tunnel ke http://localhost:$PORT ..."
./cr tunnel run --url http://localhost:$PORT "$SUBDOMAIN"
