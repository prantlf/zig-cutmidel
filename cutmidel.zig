const std = @import("std");

const version = "1.0.0";
const hint = "use -h to get help";

const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();

fn usage(out: anytype) !void {
    try out.print(
        \\cutmidel {s}
        \\  Shortens a text by trimming it by an ellipsis in the middle.
        \\
        \\Usage: cutmidel [options] <text> <leading> <trailing> [ellipsis]
        \\
        \\  Specify the text and the maximum count of leading and trailing
        \\  characters. The overall maximum length will be their sum plus
        \\  the length of an ellipsis (3 dots by default). Zero for either
        \\  leading or trailing count means no leading or trailing parts.
        \\
        \\Options:
        \\  -V|--version  prints the version of the executable and exits
        \\  -h|--help     prints th usage information and exits
        \\
        \\Examples:
        \\  $ cutmidel "~/Sources/private/cutmidel" 5 10
        \\  ~/Sou...e/cutmidel
        \\  $ cutmidel ~/Sources/private/cutmidel 0 12 ..
        \\  ..ate/cutmidel
        \\
    , .{version});
}

pub fn main() !void {
    const process = std.process;
    const exit = process.exit;
    const mem = std.mem;
    const os = std.os;
    var args = process.args();
    const argc = os.argv.len;
    // print usage information if no arguments were provided
    if (argc == 1) {
        try usage(stderr);
        exit(1);
    }
    _ = args.skip();
    // check if printing the version number or usage information was requested
    if (argc == 2) {
        const arg = args.next().?;
        if (mem.eql(u8, arg, "-V") or std.mem.eql(u8, arg, "--version")) {
            _ = try stdout.write(version);
            exit(0);
        }
        if (mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
            try usage(stdout);
            exit(0);
        }
        // unexpected one argument or fail if unexpected arguments were not provided
        try stderr.print("invalid argument: {s} ({s})\n", .{ arg, hint });
        exit(1);
    }
    // check if exactly three arguments are available
    if (argc == 3) {
        try stderr.print("too few arguments ({s})\n", .{hint});
        exit(1);
    }
    if (argc > 5) {
        try stderr.print("too many arguments ({s})\n", .{hint});
        exit(1);
    }

    // get the text to trim with its length; it will be trimmed in-place
    var txt = args.next().?;
    const txtlen = txt.len;

    // make sure that leading and trailing character count are numeric
    const fmt = std.fmt;
    var lead: usize = 0;
    var arg = args.next().?;
    if (fmt.parseInt(usize, arg, 10)) |number| {
        lead = number;
    } else |_| {
        try stderr.print("invalid leading character count: \"{s}\" ({s})\n", .{ arg, hint });
        exit(1);
    }
    var trail: usize = 0;
    arg = args.next().?;
    if (fmt.parseInt(usize, arg, 10)) |number| {
        trail = number;
    } else |_| {
        try stderr.print("invalid trailing character count: \"{s}\" ({s})\n", .{ arg, hint });
        exit(1);
    }
    // ellipsis cannot be put to the middle unless the middle is specified
    if (lead == 0 and trail == 0) {
        try stderr.print("both leading and trailing counts cannot be zero ({s})\n", .{hint});
        exit(1);
    }
    // check if a custom ellipsis was specified
    var ellipsis: []const u8 = "...";
    if (argc == 5) {
        ellipsis = args.next().?;
    }
    const elliplen = ellipsis.len;

    // if the input text is shorter than the ledting and trailing character
    // count plus the ellipsis length, leave it intact
    const heap = std.heap;
    var allocator = heap.ArenaAllocator.init(heap.page_allocator);
    defer allocator.deinit();
    if (txtlen > lead + trail + elliplen) {
        if (lead == 0) {
            try stdout.print("{s}{s}", .{ ellipsis, txt[txtlen - trail .. txtlen] });
        } else if (trail == 0) {
            try stdout.print("{s}{s}", .{ txt[0..lead], ellipsis });
        } else {
            try stdout.print("{s}{s}{s}", .{ txt[0..lead], ellipsis, txt[txtlen - trail .. txtlen] });
        }
    } else {
        _ = try stdout.write(txt);
    }
}
