#!/bin/bash

# build-iso.sh - Script para criar uma ISO bootável do Ubuntu 24.04
# Este script é um exemplo básico - personalize conforme suas necessidades

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHROOT_DIR="$SCRIPT_DIR"
OUTPUT_DIR="$SCRIPT_DIR/output"
ISO_NAME="custom-ubuntu-24.04"
LABEL="CUSTOM-UBUNTU"

echo "=========================================="
echo "  Criador de ISO - Ubuntu 24.04 Custom"
echo "=========================================="
echo ""

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then 
    echo "ERRO: Execute este script como root (sudo)"
    exit 1
fi

# Criar diretório de saída
mkdir -p "$OUTPUT_DIR"

echo "[1/5] Preparando o sistema de arquivos..."
SQUASHFS_DIR="$OUTPUT_DIR/squashfs"
mkdir -p "$SQUASHFS_DIR"

# Copiar arquivos para o diretório de trabalho (excluindo arquivos desnecessários)
echo "[2/5] Copiando arquivos..."
rsync -a --exclude='.git' --exclude='output' --exclude='build-iso.sh' --exclude='README.md' "$CHROOT_DIR/" "$SQUASHFS_DIR/"

# Criar sistema de arquivos squashfs
echo "[3/5] Criando squashfs..."
mksquashfs "$SQUASHFS_DIR" "$OUTPUT_DIR/${ISO_NAME}.squashfs" -comp xz -e boot

# Criar estrutura da ISO
echo "[4/5] Criando estrutura da ISO..."
ISO_ROOT="$OUTPUT_DIR/iso-root"
mkdir -p "$ISO_ROOT/live"
mkdir -p "$ISO_ROOT/boot/grub"

# Copiar o squashfs para a ISO
cp "$OUTPUT_DIR/${ISO_NAME}.squashfs" "$ISO_ROOT/live/"

# Você precisa de um kernel para tornar a ISO bootável
# Copie seu vmlinuz e initrd para a pasta boot
# cp /boot/vmlinuz-$(uname -r) "$ISO_ROOT/boot/vmlinuz"
# cp /boot/initrd.img-$(uname -r) "$ISO_ROOT/boot/initrd"

# Criar configuração do GRUB
cat > "$ISO_ROOT/boot/grub/grub.cfg" << 'EOF'
set default=0
set timeout=10

menuentry "Custom Ubuntu 24.04" {
    linux /boot/vmlinuz boot=live config components quiet splash
    initrd /boot/initrd
}
EOF

# Criar a ISO
echo "[5/5] Criando imagem ISO..."
xorriso -as mkisofs -iso-level 3 -full-iso9660-filenames \
    -volid "$LABEL" -appid "Custom Ubuntu 24.04" \
    -publisher "Custom Build" \
    -omit-version-number -disable-deep-flatten \
    -boot-load-size 4 -boot-info-table --grub2-boot-info \
    -eltorito-alt-boot -e boot/efi.img --no-emul-boot \
    -append_partition 2 0xEF "$ISO_ROOT/boot/efi.img" \
    -output "$OUTPUT_DIR/${ISO_NAME}.iso" \
    "$ISO_ROOT/"

echo ""
echo "=========================================="
echo "  ISO criada com sucesso!"
echo "=========================================="
echo "Local: $OUTPUT_DIR/${ISO_NAME}.iso"
echo ""
echo "NOTA: Para tornar a ISO bootável, você precisa:"
echo "1. Copiar um kernel Linux (vmlinuz) para iso-root/boot/"
echo "2. Copiar um initrd para iso-root/boot/"
echo "3. Atualizar o arquivo grub.cfg com os nomes corretos"
