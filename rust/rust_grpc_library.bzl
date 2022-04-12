"""Generated definition of rust_grpc_library."""

load("//rust:rust_grpc_compile.bzl", "rust_grpc_compile")
load("//internal:compile.bzl", "proto_compile_attrs")
load("//rust:rust_proto_lib.bzl", "rust_proto_lib")
load("@rules_rust//rust:defs.bzl", "rust_library")

def rust_grpc_library(name, **kwargs):  # buildifier: disable=function-docstring
    # Compile protos
    name_pb = name + "_pb"
    name_lib = name + "_lib"
    rust_grpc_compile(
        name = name_pb,
        **{
            k: v
            for (k, v) in kwargs.items()
            if k in proto_compile_attrs.keys()
        }  # Forward args
    )

    # Create lib file
    rust_proto_lib(
        name = name_lib,
        compilation = name_pb,
        externs = ["protobuf", "grpc", "grpc_protobuf"],
    )

    # Create rust library
    rust_library(
        name = name,
        srcs = [name_pb, name_lib],
        deps = GRPC_DEPS + kwargs.get("deps", []),
        visibility = kwargs.get("visibility"),
        tags = kwargs.get("tags"),
    )

GRPC_DEPS = [
    Label("//rust/raze:futures"),
    Label("//rust/raze:grpc"),
    Label("//rust/raze:grpc_protobuf"),
    Label("//rust/raze:protobuf"),
]
