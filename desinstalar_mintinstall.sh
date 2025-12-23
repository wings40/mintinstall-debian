#!/bin/bash

# 1. Comprobar privilegios
if [ "$EUID" -ne 0 ]; then 
  echo "Error: Por favor, ejecuta el script con sudo."
  exit 1
fi

echo "=========================================================="
echo "   DESINSTALADOR MINTINSTALL + LIMPIEZA (DEBIAN 13)       "
echo "=========================================================="

# 2. Definir la lista de paquetes instalados para borrar
# Incluimos los de Mint y las dependencias de apoyo instaladas
LISTA_PAQUETES="mintinstall mint-common aptkit python3-defer mint-translations appstream appstream-util packagekit packagekit-tools app-install-data"

# 3. Comprobación inteligente de Flatpak
# Solo lo añadimos a la lista de borrado si no tienes aplicaciones instaladas por el usuario
if command -v flatpak >/dev/null 2>&1; then
    # Contamos apps instaladas (excluyendo el encabezado)
    APP_COUNT=$(flatpak list --app 2>/dev/null | wc -l)
    
    if [ "$APP_COUNT" -eq 0 ]; then
        echo "[I] No se detectaron apps Flatpak. Se eliminará el motor Flatpak..."
        LISTA_PAQUETES="$LISTA_PAQUETES flatpak"
    else
        echo "[I] Se conservará el motor Flatpak porque tienes $APP_COUNT apps instaladas."
    fi
fi

# 4. Ejecutar la purga de paquetes
echo "[1/4] Purgando paquetes y archivos de configuración..."
apt purge $LISTA_PAQUETES -y

# 5. Limpieza de dependencias huérfanas
echo "[2/4] Eliminando dependencias innecesarias..."
apt autoremove --purge -y

# 6. Borrar archivos manuales, puentes e iconos vinculados
echo "[3/4] Eliminando archivos manuales y restos de sistema..."

# Borrar el puente de fuentes de software
if [ -f "/usr/local/bin/mintsources" ]; then
    rm -f /usr/local/bin/mintsources
    echo "  - Puente 'mintsources' eliminado."
fi

# Borrar el enlace simbólico del logo de Debian (el que quitó la cámara)
ICON_FIX="/usr/share/icons/hicolor/symbolic/apps/linuxmint-logo-badge-symbolic.svg"
if [ -L "$ICON_FIX" ]; then
    rm -f "$ICON_FIX"
    echo "  - Enlace de icono 'linuxmint-logo-badge' eliminado."
fi

# Borrar carpetas residuales que Debian no borra por no estar vacías (__pycache__, etc.)
[ -d "/usr/lib/linuxmint" ] && rm -rf /usr/lib/linuxmint
[ -d "/usr/share/linuxmint" ] && rm -rf /usr/share/linuxmint
echo "  - Carpetas de Linux Mint eliminadas."

# 7. Actualizar cachés finales
echo "[4/4] Actualizando cachés de sistema..."
gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null
update-desktop-database 2>/dev/null

echo "=========================================================="
echo "   DESINSTALACIÓN COMPLETADA. SISTEMA LIMPIO.             "
echo "=========================================================="
