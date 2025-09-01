#!/usr/bin/env bash
#
# Copyright (c) 2025, OpenSavvy and contributors.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

cachefile="/etc/pacman.d/cachelist"
cachedir="/home/root/cache"

if [[ ! -f "$cachefile" ]];
then
	echo "Could not find the file $cachefile, please create it! For example, add a volume."
	exit 2
fi

if [[ ! -d "$cachedir" ]];
then
	echo "Could not find the directory $cachedir, please create it! For example, add a volume."
	exit 3
fi

echo "Starting Caddy…"
caddy file-server --root "$cachedir" --browse --listen :8000 &

while true; do
	date
	echo "Updating the cache…"
	pkgs=$(<"$cachefile" sed 's/#.*//' | tr '\n' ' ')
	echo "Packages: $pkgs"
	pacman -Syw --noconfirm \
		--cachedir "$cachedir" \
		$pkgs
	echo "Updated finished. Cleaning up old versions of packages…"
	paccache -r \
		--cachedir "$cachedir" \
		--keep 5 \
		--min-atime '30 days ago'
	echo "Sleeping until next update…"
	echo

	sleep 72000 # 20h
done
