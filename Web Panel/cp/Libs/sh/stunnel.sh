#!/bin/bash
echo "cert = /etc/stunnel/stunnel.pem
 [openssh]
 accept = $1
 connect = 0.0.0.0:$2
" > /etc/stunnel/stunnel.conf
