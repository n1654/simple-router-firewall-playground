FROM alpine:latest

RUN apk add openssh bash busybox-extras iperf3 tcpdump iproute2 --no-cache

RUN echo -e "Port 22\n\
AddressFamily any\n\
ListenAddress 0.0.0.0\n\
PermitRootLogin yes\n\
PasswordAuthentication yes" >> /etc/ssh/sshd_config

RUN echo root:root123 | chpasswd

RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key

CMD ["sh","-c","ip route add 123.45.3.0/24 via 123.45.1.100 ; /usr/sbin/sshd -D"]
