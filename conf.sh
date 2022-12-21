#!/bin/bash
#
if [ "$EUID" -ne 0 ]
        then echo "Porfavor, me execute como root."
        exit 1
fi

chmod 755 Ghost_networking/ghost.sh
cp Ghost_networking/ghost.sh /usr/bin/ghost
rm -rf Ghost_networking
echo "Basta digitar 'ghost' para chamar o comando"
