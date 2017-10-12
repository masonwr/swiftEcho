import Foundation
import Socket


let port = 1234
print("Hello, world!")

func main() {
    do {
        let socket = try Socket.create()
        try socket.listen(on: port)
        listen(to: socket)
    } catch let error {
        print("error: \(error)")
    }
}

func listen(to socket: Socket) {
    print("listening on port: \(port)")

    while true {

        do {
            let newSocket = try socket.acceptClientConnection()
            print("Socket Signature: \(newSocket.signature?.description)")

            try newSocket.write(from: "Hello there!!!")

            while true {
                let res = try newSocket.readString()
                print("res: \(res)")

                if let str = res {
                   try newSocket.write(from: "-> " + str)
                }
            }
        } catch let error {
            print("error: \(error)")
        }

    }
}


main()
