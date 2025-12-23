#!/bin/bash

# 1. Comprobar privilegios
if [ "$EUID" -ne 0 ]; then 
  echo "Error: Por favor, ejecuta el script con sudo."
  exit 1
fi

echo "========================================"
echo "   INSTALADOR MINTINSTALL (DEBIAN 13)   "
echo "========================================"

# 2. Preparar directorio temporal para evitar errores de sandbox (_apt)
echo "[1/6] Preparando entorno temporal de instalación..."
TEMP_DIR=$(mktemp -d)
# Copiamos los .deb de la carpeta actual a la temporal
cp ./*.deb "$TEMP_DIR/"
# Damos permisos para que el usuario del sistema '_apt' pueda leerlos
chmod 755 "$TEMP_DIR"
chmod 644 "$TEMP_DIR"/*.deb

# 3. Actualizar e instalar dependencias base
echo "[2/6] Instalando dependencias desde repositorios oficiales..."
apt update
apt install flatpak appstream appstream-util packagekit packagekit-tools desktop-base -y

# 4. Instalar los paquetes locales desde la carpeta temporal
echo "[3/6] Instalando paquetes de Mint (con downgrade permitido)..."
apt install "$TEMP_DIR"/*.deb --allow-downgrades -y
apt install -f -y

# 5. Limpiar carpeta temporal
rm -rf "$TEMP_DIR"

# 6. Crear el puente para Fuentes de Software (mintsources)
echo "[4/6] Configurando 'Fuentes de Software'"
cat << 'EOF' > /usr/local/bin/mintsources
#!/bin/bash
EDITORS=("xed" "gedit" "mousepad" "pluma" "kwrite" "leafpad")
SELECTED_EDITOR=""
for EDITOR in "${EDITORS[@]}"; do
    if command -v $EDITOR &> /dev/null; then SELECTED_EDITOR=$EDITOR; break; fi
done

FILES="/etc/apt/sources.list"
[ -f /etc/apt/sources.list.d/debian.sources ] && FILES="$FILES /etc/apt/sources.list.d/debian.sources"

OLD_MD5=$(md5sum $FILES 2>/dev/null)

if [ -n "$SELECTED_EDITOR" ]; then
    pkexec $SELECTED_EDITOR $FILES
else
    x-terminal-emulator -e "sudo nano $FILES"
fi

NEW_MD5=$(md5sum $FILES 2>/dev/null)

if [ "$OLD_MD5" != "$NEW_MD5" ]; then
    echo "Cambios detectados. Actualizando repositorios..."
    pkexec sh -c "apt-get update && appstreamcli refresh --force"
fi
EOF

chmod +x /usr/local/bin/mintsources

# 7. REPARACIÓN DE ICONOS (Fix del logo de Debian)
echo "[5/6] Aplicando Reparación de iconos (Logo de Debian)..."

# Arreglo Accesibilidad (Silenciar el aviso de "Permiso denegado")
sudo sed -i '/import sys/i import os\nos.environ["NO_AT_BRIDGE"] = "1"' /usr/lib/linuxmint/mintinstall/mintinstall.py

# Arreglo del Icono "Cámara" -> Logo Debian
ICON_DIR="/usr/share/icons/hicolor/symbolic/apps"
DEBIAN_LOGO="/usr/share/icons/desktop-base/scalable/emblems/emblem-debian.svg"

mkdir -p "$ICON_DIR"

if [ -f "$DEBIAN_LOGO" ]; then
    ln -sf "$DEBIAN_LOGO" "$ICON_DIR/linuxmint-logo-badge-symbolic.svg"
    echo "Logo de Debian vinculado correctamente."
else
    ln -sf /usr/share/icons/Adwaita/symbolic/categories/applications-system-symbolic.svg "$ICON_DIR/linuxmint-logo-badge-symbolic.svg"
fi

#Rescatar iconos de categorías de Mint
cp /usr/share/linuxmint/mintinstall/*.svg "$ICON_DIR/" 2>/dev/null

# Actualizar el caché de iconos del sistema
gtk-update-icon-cache -f /usr/share/icons/hicolor


# 8. Actualizar base de datos de aplicaciones
echo "[6/5] Actualizando caché de software (AppStream)..."
appstreamcli refresh --force

echo "============================"
echo "   INSTALACIÓN FINALIZADA   "
echo "============================"
