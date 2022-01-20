# Simple router/firewall playground for devops school

## Description
This playground composed of four linux machines. Two of them in the middle supposed to be routers, the rest end-user machines.
Here you play with:
 - static routing
 - iptables

## Diagram
    ┌─────────────────┐   ┌──────────────────────────┐   ┌──────────────────────────┐   ┌─────────────────┐
    │SITE_LEFT        │   │ROUTER_LEFT_MIDDLE        │   │ROUTER_RIGHT_MIDDLE       │   │SITE_RIGHT       │
    │                 │   │                          │   │                          │   │                 │
    │                 │   │                          │   │                          │   │                 │
    │ 123.45.1.101/24 ├───┤ 123.45.1.100/24          │   │          123.45.3.100/24 ├───┤ 123.45.3.101/24 │
    │                 │   │                          │   │                          │   │                 │
    │                 │   │          123.45.2.101/24 ├───┤ 123.45.2.102/24          │   │                 │
    │                 │   │                          │   │                          │   │                 │
    └─────────────────┘   └──────────────────────────┘   └──────────────────────────┘   └─────────────────┘
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
```

Iptables examples
```sh
$ iptables -nvL FORWARD --line-numbers
$ iptables -A FORWARD -p icmp --icmp-type echo-request -j REJECT
$ iptables -D FORWARD 1
$ iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE
$ iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE -m state --state ESTABLISHED,RELATED,NEW
```
