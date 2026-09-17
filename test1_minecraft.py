from mcstatus import JavaServer

server = JavaServer.lookup("${Server_IP_Adresse}:8888")
status = server.status()

print(f"The server is online and reachable!")

print(f"The server nun has: {status.players.online} player(s) online")
print(f"The maximal number of players is: {status.players.max}")
print(f"The actual version of Minecraft is: {status.version.name}")

latency=server.ping()
print(f"The Server replied in {latency} ms")
