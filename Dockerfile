FROM alpine:latest

RUN mkdir -p /conf

RUN apk update  && apk add \
  strongswan \ 
  supervisor \
  xl2tpd

# Strongswan Configuration
ADD conf/* /etc/

# XL2TPD Configuration
ADD xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
ADD options.xl2tpd /etc/ppp/options.xl2tpd

# Supervisor config
ADD supervisord.conf supervisord.conf
ADD kill_supervisor.py /usr/bin/kill_supervisor.py

ADD run.sh /run.sh
ADD scripts/* /usr/local/bin/

# The password is later on replaced with a random string
ENV VPN_USER user
ENV VPN_PASSWORD password
ENV VPN_PSK password

VOLUME ["/etc/ipsec.d"]

EXPOSE 4500/udp 500/udp 1701/udp

CMD ["/run.sh"]
