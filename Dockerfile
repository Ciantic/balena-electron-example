# Base images
FROM balenalib/raspberrypi3-node:buster-build as builder
FROM balenalib/raspberrypi3-node:buster as runtime

# Following builds but does not run, it just gives a black screen or garbled output:
# FROM balenalib/raspberrypi4-64-node:buster-build as builder
# FROM balenalib/raspberrypi4-64-node:buster as runtime


# -----------------------------------------------------------------------------
# X-server
FROM runtime as xserver

# Electron runtime dependencies:
RUN install_packages libnss3 libxtst6 libasound2 libglib2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libxss1

# X-server
RUN install_packages xserver-xorg-core xinit 

# X command https://www.x.org/releases/X11R7.7/doc/man/man1/Xserver.1.xhtml
RUN printf '\
#!/bin/bash \n\
exec /usr/bin/X -s 0 dpms -nocursor -nolisten tcp "$@"\
' > /etc/X11/xinit/xserverrc

# # Test, with green xterm in the corner
# RUN install_packages xterm
# CMD ["startx", "-fa", "Monospace", "-bg", "green", "-fg", "black"]


# -----------------------------------------------------------------------------
# Electron
FROM builder as electron

WORKDIR /app/built-electron
RUN npm init -y
RUN npm install electron@^6.1.0 --save --unsafe-perm --production --silent


# -----------------------------------------------------------------------------
# Your electron application
FROM xserver
COPY --from=electron /app/built-electron /app/built-electron
WORKDIR /app/kiosk
COPY package.json .
COPY main.js .

# Enable USB hardware, e.g. keyboard or mouse on balena images
ENV UDEV=1

CMD ["startx", "/app/built-electron/node_modules/electron/dist/electron", "/app/kiosk", "--enable-logging", "--no-sandbox"]