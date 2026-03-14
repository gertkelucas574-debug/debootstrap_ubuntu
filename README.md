# Ubuntu 24.04 Base System (Debootstrap)

Este repositório contém o sistema base do Ubuntu 24.04 (Noble) pré-compilado, obtido através da ferramenta oficial **debootstrap** do Ubuntu.

## O que é Debootstrap?

Debootstrap é uma ferramenta oficial do Debian/Ubuntu que permite instalar um sistema Debian/Ubuntu básico em um subdiretório do sistema host. É amplamente utilizado para:

- Criar sistemas base para Live CDs
- Compilar distribuições Linux customizadas
- Configurar ambientes de chroot
- Criar containers minimalistas

## Por que usar este repositório?

### Vantagens

1. **Praticidade**: Não é necessário executar o debootstrap manualmente
2. **Economia de tempo**: Já vem com todos os pacotes pré-baixados e instalados
3. **Offline**: Você pode clonar este repositório e criar uma ISO sem conexão com a internet
4. **Compatibilidade**: Arquivos prontos para uso com ferramentas como Live Build, Cubic, ou scripts personalizados

## Como usar

### Clonar o repositório

```bash
git clone https://github.com/gertkelucas574-debug/debootstrap_ubuntu.git
cd debootstrap_ubuntu
```

### Criar uma ISO simples

Você pode usar o script `build-iso.sh` incluído ou criar o seu próprio:

```bash
#!/bin/bash

# build-iso.sh - Script simples para criar uma ISO do Ubuntu

set -e

ISO_NAME="my-custom-ubuntu"
OUTPUT_DIR="./output"

echo "=== Criando ISO customizada do Ubuntu 24.04 ==="

# Criar diretório de saída
mkdir -p $OUTPUT_DIR

# Criar a ISO usando o genisoimage ou xorriso
# (Este é um exemplo simples - você pode expandir conforme necessário)
echo "ISO criada com sucesso em: $OUTPUT_DIR/$ISO_NAME.iso"
```

### Usar como chroot

```bash
# Montar o sistema de arquivos
sudo mount --bind /proc live-cd/proc
sudo mount --bind /sys live-cd/sys
sudo mount --bind /dev live-cd/dev

# Entrar no chroot
sudo chroot live-cd /bin/bash
```

## Requisitos para criar ISO

Para transformar este sistema base em uma ISO bootável, você precisará de:

- `xorriso` ou `genisoimage` - Para criar a imagem ISO
- `squashfs-tools` - Para compactar o sistema de arquivos
- `grub2` ou `grub-pc` - Para criar o bootloader
- Um kernel Linux (vmlinuz) compilado para o ambiente Live

##Personalização

Para personalizar o sistema:

1. Entre no chroot: `sudo chroot . /bin/bash`
2. Instale pacotes adicionais: `apt-get install <pacotes>`
3. Configure conforme necessário
4. Saia do chroot: `exit`
5. Crie a ISO com suas modificações

## Créditos

- **Debootstrap**: Ferramenta oficial do Ubuntu/Debian
- **Ubuntu**: Marca registrada da Canonical Ltd.

## Licença

Este repositório contém software sob diversas licenças de código aberto. Os pacotes individuais mantêm suas respectivas licenças originais.
