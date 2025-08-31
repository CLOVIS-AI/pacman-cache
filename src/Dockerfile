FROM archlinux:base

RUN pacman -Syuu --noconfirm caddy pacman-contrib

COPY --chmod=700 update-cache.sh /usr/bin/update-cache

ENTRYPOINT [ "/usr/bin/update-cache" ]
