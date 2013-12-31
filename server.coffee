net = require 'net'

chatServer = net.createServer()
clients = []

chatServer.on 'connection', (client) ->
  client.name = "#{client.remoteAddress}:#{client.remotePort}"
  client.write "Hey #{client.name}!\n"
  console.log "#{client.name} joined"

  clients.push client

  client.on 'data', (data) ->
    broadcast data, client

  client.on 'end', () ->
    console.log "#{client.name} quit"
    clients.splice clients.indexOf(client), 1

  client.on 'error', (e) ->
    console.log e

broadcast = (message, sender) ->
  cleanup = []
  for client in clients
    do (client) ->
      if client isnt sender
        if client.writable
          client.write "#{sender.name} says #{message}"
        else
          cleanup.push client
          client.destroy()

  clients.splice clients.indexOf(trash), 1 for trash in cleanup

chatServer.listen 9000
