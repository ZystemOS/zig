const std = @import("std");
const testing = std.testing;
const mem = std.mem;
const expect = testing.expect;
const expectEqual = testing.expectEqual;

test "arrays" {
    var array: [5]u32 = undefined;

    var i: u32 = 0;
    while (i < 5) {
        array[i] = i + 1;
        i = array[i];
    }

    i = 0;
    var accumulator = @as(u32, 0);
    while (i < 5) {
        accumulator += array[i];

        i += 1;
    }

    try expect(accumulator == 15);
    try expect(getArrayLen(&array) == 5);
}
fn getArrayLen(a: []const u32) usize {
    return a.len;
}

test "array init with mult" {
    const a = 'a';
    var i: [8]u8 = [2]u8{ a, 'b' } ** 4;
    try expect(std.mem.eql(u8, &i, "abababab"));

    var j: [4]u8 = [1]u8{'a'} ** 4;
    try expect(std.mem.eql(u8, &j, "aaaa"));
}

test "array literal with explicit type" {
    const hex_mult: [4]u16 = .{ 4096, 256, 16, 1 };

    try expect(hex_mult.len == 4);
    try expect(hex_mult[1] == 256);
}

test "array literal with inferred length" {
    const hex_mult = [_]u16{ 4096, 256, 16, 1 };

    try expect(hex_mult.len == 4);
    try expect(hex_mult[1] == 256);
}

test "array dot len const expr" {
    try expect(comptime x: {
        break :x some_array.len == 4;
    });
}

const ArrayDotLenConstExpr = struct {
    y: [some_array.len]u8,
};
const some_array = [_]u8{ 0, 1, 2, 3 };

test "array literal with specified size" {
    var array = [2]u8{ 1, 2 };
    try expect(array[0] == 1);
    try expect(array[1] == 2);
}

test "array len field" {
    var arr = [4]u8{ 0, 0, 0, 0 };
    var ptr = &arr;
    try expect(arr.len == 4);
    comptime try expect(arr.len == 4);
    try expect(ptr.len == 4);
    comptime try expect(ptr.len == 4);
}
