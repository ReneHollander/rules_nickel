load("@rules_rust//crate_universe:defs.bzl", "crate", "crates_repository", "render_config")

def nickel_dependencies():
    crates_repository(
        name = "nickel_crate_index",
        cargo_lockfile = "@rules_nickel//:Cargo.Bazel.lock",
        lockfile = "@rules_nickel//:cargo-bazel-lock.json",
        packages = {
            "nickel-lang": crate.spec(
                version = "0.2.1",
            ),
        },
        render_config = render_config(
            default_package_name = "",
        ),
    )
