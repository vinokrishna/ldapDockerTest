from dnslib.server import DNSServer, BaseResolver
from dnslib import RR, QTYPE, A
import itertools
import os

ips = [
    "172.28.0.11",
    "172.28.0.12",
    "172.28.0.13"
]

counter = 0

def get_active_ips():
    active = []
    for ip in ips:
        marker = f"/tmp/down-{ip}"
        if not os.path.exists(marker):
            active.append(ip)
    return active


class Resolver(BaseResolver):
    def resolve(self, request, handler):
        global counter

        reply = request.reply()
        active_ips = get_active_ips()

        if not active_ips:
            print("No healthy LDAP servers!")
            return reply

        ip = active_ips[counter % len(active_ips)]
        counter += 1

        reply.add_answer(RR("ldap.rr", QTYPE.A, rdata=A(ip), ttl=1))

        print(f"DNS query → returning {ip}")

        return reply


resolver = Resolver()
server = DNSServer(resolver, port=53, address="0.0.0.0")

print("Starting RR DNS server with health simulation")
server.start()

