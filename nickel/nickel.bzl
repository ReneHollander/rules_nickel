NickelLibraryPkg = provider(
    doc = "Collects files from nickel_library for use in downstream nickel_export.",
    fields = {
        "transitive_nickel_files": "Nickel files for this target and its dependencies.",
    },
)

def _nickel_library_impl(ctx):
    """Implementation of the nickel_library rule."""
    return [
        DefaultInfo(files = depset(ctx.files.srcs)),
        NickelLibraryPkg(
            transitive_nickel_files = depset(
                ctx.files.srcs,
                transitive = [dep[NickelLibraryPkg].transitive_nickel_files for dep in ctx.attr.deps],
                # Provide .ncl sources from dependencies first
                order = "postorder",
            ),
        ),
    ]

nickel_library = rule(
    implementation = _nickel_library_impl,
    attrs = {
        "deps": attr.label_list(
            doc = "List of targets that are required by the `srcs` Nickel files.",
            providers = [NickelLibraryPkg],
            allow_files = False,
        ),
        "srcs": attr.label_list(
            allow_files = [".ncl"],
        ),
    },
)

def _nickel_export_impl(ctx):
    output_file = ctx.actions.declare_file(ctx.label.name + "." + ctx.attr.output_format)

    inputs = depset(ctx.files.src, transitive = [dep[NickelLibraryPkg].transitive_nickel_files for dep in ctx.attr.deps])

    args = ctx.actions.args()
    args.add("export")
    args.add("-f", ctx.files.src[0])
    args.add("--format", ctx.attr.output_format)
    args.add("-o", output_file)

    ctx.actions.run(
        mnemonic = "NickelCompile",
        executable = ctx.executable._nickel_binary,
        arguments = [args],
        inputs = inputs,
        outputs = [output_file],
    )

    return [DefaultInfo(files = depset([output_file]))]

nickel_export = rule(
    implementation = _nickel_export_impl,
    attrs = {
        "src": attr.label(allow_single_file = [".ncl"]),
        "deps": attr.label_list(
            doc = "List of targets that are required by the `src` Nickel file.",
            providers = [NickelLibraryPkg],
            allow_files = False,
        ),
        "output_format": attr.string(
            doc = "Output format",
            default = "json",
            values = [
                "json",
                "yaml",
            ],
        ),
        "_nickel_binary": attr.label(
            default = Label("@nickel_crate_index//:nickel-lang__nickel"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
