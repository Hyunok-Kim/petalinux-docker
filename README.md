# petalinux-docker

Copy petalinux-v2022.2-final-installer.run file to this folder. Then run:

`docker build --build-arg PETA_VERSION=2022.2 --build-arg PETA_RUN_FILE=petalinux-v2022.2-final-installer.run -t hokim72/petalinux:2022.2 .`

After installation, launch petalinux with:

`cd project; petalinux-docker`
