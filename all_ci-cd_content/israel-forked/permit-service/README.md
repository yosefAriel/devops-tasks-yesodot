# permit-service

## Compile proto

In order to compile the proto file make sure you have `protobuf` and `protoc-gen-go`

### Installing protobuf on Linux

`./install_protoc.sh`

### Installing protoc-gen-go

`go get -u github.com/golang/protobuf/protoc-gen-go`

[example guide to gRPC and protobuf](https://grpc.io/docs/quickstart/go.html)

**Compiling Protobuf To Golang:**
`protoc -I proto/ proto/permit.proto --go_out=plugins=grpc:./proto`