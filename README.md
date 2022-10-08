# rules_nickel
Bazel build rules for [nickel-lang.org](https://nickel-lang.org)

## Usage

In your `WORKSPACE` file:
```
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_rust",
    sha256 = "0cc7e6b39e492710b819e00d48f2210ae626b717a3ab96e048c43ab57e61d204",
    urls = [
        "https://github.com/bazelbuild/rules_rust/releases/download/0.10.0/rules_rust-v0.10.0.tar.gz",
    ],
)

load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies", "rust_register_toolchains")

rules_rust_dependencies()

rust_register_toolchains()

load("@rules_rust//crate_universe:repositories.bzl", "crate_universe_dependencies")

crate_universe_dependencies(bootstrap = True)

http_archive(
    name = "rules_nickel",
    sha256 = "435ba2fe9e6c257cdeb2de709efe8f0577c7a7cf914e6b216ddce2be0451d449",
    urls = [
        "https://github.com/ReneHollander/rules_nickel/releases/download/v0.0.1/rules_nickel-v0.0.1.tar.gz",
    ],
)

load("@rules_nickel//nickel:deps.bzl", "nickel_dependencies")

nickel_dependencies()

load("@nickel_crate_index//:defs.bzl", nickel_crate_repositories = "crate_repositories")

nickel_crate_repositories()

```

See `examples/` on how to use the rules.
