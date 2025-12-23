# MintInstall para Debian 13 (Trixie)

Este repositorio contiene los scripts necesarios para que el **Gestor de Software de Linux Mint (mintinstall)** funcione en **Debian 13**. 

### ¿Para qué sirve este proyecto?
El Gestor de Software de Mint es muy intuitivo, pero depende de componentes y configuraciones que son exclusivos de Linux Mint. Si intentas instalarlo por tu cuenta en Debian, te encontrarás con que la aplicación no abre, faltan iconos (se ve una cámara de fotos en su lugar) o los botones de configuración no funcionan.

**Este proyecto resuelve automáticamente todos esos problemas de dependencias y configuración.**

---

## 🌟 Lo que hacen estos scripts por ti:
*   **Instalación Sencilla**: Configura el sistema para que Debian acepte y entienda las herramientas de Linux Mint, resolviendo dependencias que son exclusivas de esa distribución.
*   **Corrección Visual**: Repara los iconos faltantes para que la interfaz se vea nativa, integrando el logo de Debian donde corresponda.
*   **Acceso a Repositorios**: Habilita el botón de "Fuentes de Software" para que puedas gestionar tus repositorios fácilmente desde la propia tienda.
*   **Sincronización Automática**: Si haces cambios en tus fuentes de software, el sistema detecta lo guardado y se actualiza para mostrarte los nuevos programas disponibles.

---

## 📦 Archivos necesarios
Para que la instalación sea exitosa, asegúrate de tener los siguientes archivos `.deb` (puedes encontrarlos en la carpeta `debs/` de este repositorio):
1.  `app-install-data`
2.  `mintinstall`
3.  `mint-common`
4.  `aptkit`
5.  `python3-defer`
6.  `mint-translations`

> **UBICACIÓN DE LOS ARCHIVOS:** Los archivos `.deb` se encuentran dentro de la carpeta llamada `debs`. Para que el instalador funcione, **debes mover o copiar todos los archivos .deb a la carpeta principal** (donde están los scripts `.sh`).

---

## 🚀 Instrucciones de Instalación

### 1. Obtener los archivos
Puedes obtener este proyecto de dos maneras:
*   **Descarga directa (ZIP):** Haz clic en el botón verde **"Code"** (arriba a la derecha) y selecciona **"Download ZIP"**. Luego, descomprime el archivo en tu computadora.
*   **Usando Git:** Clona el repositorio con el siguiente comando:
    ```bash
    git clone https://github.com/wings40/mintinstall-debian.git
    cd mintinstall-debian
    ```

### 2. Preparar los paquetes
Mueve los archivos `.deb` de la subcarpeta a la carpeta raíz donde se encuentran los scripts:
```bash
mv debs/*.deb .
```

### 3. Ejecutar el instalador
Da permisos de ejecución a los archivos y lanza la instalación:
```bash
chmod +x instalar_mintinstall.sh quitar_mintinstall.sh
sudo ./instalar_mintinstall.sh
```

---

## 🗑️ Cómo desinstalar
Si decides dejar de usar la tienda de Mint, el script de desinstalación dejará tu sistema impecable, eliminando el programa, los iconos manuales, el puente de configuración y las carpetas residuales:

```bash
sudo ./desinstalar_mintinstall.sh
```
*Nota: El script revisará si tienes aplicaciones Flatpak instaladas; si no tienes ninguna, eliminará también el motor Flatpak para ahorrar espacio.*

---
**Nota:** Este proyecto adapta el excelente trabajo del equipo de [Linux Mint](https://github.com/linuxmint/mintinstall) para que los usuarios de Debian 13 disfruten de una gestión de software más sencilla y visual.
