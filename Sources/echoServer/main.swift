import Foundation
import Socket

var prompt = "--> "

func main(port: Int) {
  do {
    let socket = try Socket.create()
    try socket.listen(on: port)
    listen(to: socket)
  } catch let error {
    print("error: \(error)")
  }
}

func listen(to socket: Socket) {
  
  print("to connect: telnet localhost \(port)")
  
  while true {
    guard let newSocket = try? socket.acceptClientConnection() else {
      print("Could not accept new connection")
      return
    }
    
    print("Accepted connection from: \(newSocket.remoteHostname):\(newSocket.remotePort)")
    //print("Socket Signature: \(String(describing: newSocket.signature?.description))")

    
    do {
      try newSocket.write(from: "-- init connection --\n\r" + prompt)
    } catch let error {
      print("error: \(error)")
    }
    
    
    while true {
      guard let res = try? newSocket.readString(), let str = res else {
        print("(!) count not get responce")
        continue
      }
      
      let trimmed = str.trimmingCharacters(in: .whitespacesAndNewlines)
      
      if trimmed.lowercased() == "exit" {
        let _ = try? newSocket.write(from: "Goodbuy...\n")
        newSocket.close()
        socket.close()
        break
      }
      
      print("res -> \(trimmed)")
      
      do {
        try newSocket.write(from: trimmed + "\n" + prompt)
      } catch let error {
        print("error: \(error)")
      }
    }
  }
}


let port = 1234
main(port: port)

