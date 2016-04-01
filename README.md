Demos y fuentes de la asignatura de Análisis de redes sociales con R
====================================================================

Instalación
-----------

A continuación se especifica el proceso de instalación de los diferentes sistemas necesarios para ejecutar las demos.

### Instalar el repositorio clonándolo de Github:
Ejecutar el siguiente script:
```bash
sudo yum -y install git
cd
git clone https://github.com/vitongos/ufv-social-network-analysis-with-r sna-r-src
chmod +x sna-r-src/deploy/*.sh
```

### Instalar R y RStudio 0.97
Ejecutar el siguiente script:
```bash
cd ~/sna-r-src/
deploy/r.sh
```

### Instalar paquetes
Ejecutar el siguiente script (puede tardar un poco):
```bash
cd ~/sna-r-src/src
sudo R --no-save < setup.R
```
