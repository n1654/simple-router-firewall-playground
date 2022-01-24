# Simple router/firewall playground for devops school

## Description
This playground composed of four linux machines. Two of them in the middle supposed to be routers, the rest end-user machines.
Here you play with:
 - static routing
 - iptables

## Diagram

                        123.45.1.0/24                   123.45.2.0/24                   123.45.3.0/24
    ┌──────────────────┬──┐         ┌──┬───────────────┬──┐       ┌──┬───────────────┬──┐         ┌──┬──────────────────┐
    │ SITE_LEFT        ├──┴─┐     ┌─┴──┤ROUTER_L_MIDDLE├──┴─┐   ┌─┴──┤ROUTER_R_MIDDLE├──┴─┐     ┌─┴──┤       SITE_RIGHT │
    │            .101  │eth1├─────┤eth1│.100       .101│eth2├───┤eth1│.102       .100│eth2├─────┤eth1│.101              │
    │                  ├──┬─┘     └─┬──┤               ├──┬─┘   └─┬──┤               ├──┬─┘     └─┬──┤                  │
    └──────────────────┴──┘         └──┴───────────────┴──┘       └──┴───────────────┴──┘         └──┴──────────────────┘

## Management network
| host | container ip-address:port | host ip-address:port | 
|---|---|---|
| SITE_LEFT | `172.20.0.127:22` | `<host-ip>:60622` |
| ROUTER_LEFT_MIDDLE | `172.20.0.129:22` | `<host-ip>:60822` |
| ROUTER_RIGHT_MIDDLE | `172.24.0.130:22` | `<host-ip>:60922` |
| SITE_RIGHT | `172.20.0.128:22` | `<host-ip>:60722` |

## Helpful commands

Adds `<latency>` ms, `<jitter>` ms, `loss` perc. 
```sh
$ tc qdisc add dev eth1 root netem delay 100ms 20ms loss 50%
$ tc qdisc add dev eth0 root tbf rate 1024kbit latency 100ms burst 1540
```

Iptables examples
```sh
$ iptables -nvL FORWARD --line-numbers
$ iptables -A FORWARD -p icmp --icmp-type echo-request -j REJECT
$ iptables -D FORWARD 1
$ iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE
$ iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE -m state --state ESTABLISHED,RELATED,NEW
$ iptables -R INPUT 1 -p icmp --icmp-type echo-request -j ACCEPT --match limit --limit 1/second
$ iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
```
