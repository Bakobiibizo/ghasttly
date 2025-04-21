//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.

const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var input_buffer: [1024]u8 = undefined;

    try stdout.print("Agent Chat Window (type 'exit' to quit)\n", .{});
    while (true) {
        try stdout.print("> ", .{});
        const line = try stdin.readUntilDelimiterOrEof(&input_buffer, '\n');
        if (line == null) break;
        const input = std.mem.trim(u8, line.?, " \r\n");
        if (std.mem.eql(u8, input, "exit")) break;
        if (std.mem.startsWith(u8, input, "write_file ")) {
            // Command format: write_file <filename> <content>
            var parts = std.mem.splitSequence(u8, input, " ");
            _ = parts.next(); // skip 'write_file'
            const filename = parts.next() orelse {
                try stdout.print("Usage: write_file <filename> <content>\n", .{});
                continue;
            };
            const content = parts.rest();
            var file = try std.fs.cwd().createFile(filename, .{ .truncate = true });
            defer file.close();
            try file.writeAll(content);
            try stdout.print("[Agent] Wrote to file: {s}\n", .{filename});
        } else {
            try stdout.print("[Agent] You said: {s}\n", .{input});
        }
    }
    try stdout.print("Goodbye!\n", .{});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "use other module" {
    try std.testing.expectEqual(@as(i32, 150), lib.add(100, 50));
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("ghasttly_lib");
