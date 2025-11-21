const std = @import("std");

fn get_file_name(path: []const u8) []const u8 {
    var it = std.mem.tokenizeScalar(u8, path, '/');
    var segment: []const u8 = undefined;
    var index: u8 = 0;
    while (index < 254) : (index += 1) {
        segment = it.next() orelse break;
    }

    return segment;
}


fn get_base_name(file_name: []const u8) []const u8 {
    var it = std.mem.tokenizeScalar(u8, file_name, '.');
    return it.peek().?;
}


// pub fn main() !void {
//     const path = "test/ss12/qweq.zig";
//     const file_name = get_file_name(path);
//     const base_name = get_base_name(file_name);
//     std.debug.print("{s}\n", .{base_name});
// }


pub fn build(b: *std.Build) void {
    const paths = [_][]const u8{
        "allocators/arena_alloc.zig",
        "allocators/fixed_buffer_alloc.zig",
        "allocators/for_scope_local_var.zig",
        "allocators/general_purpose_alloc.zig",
        "allocators/login_example.zig",
        "allocators/test_array_len.zig",
        "allocators/user_struct.zig",
        "allocators/alloc_free.zig",
        "base64/base64_table.zig",
        "base64/base64_basic.zig",
        "build_system/build.zig",
        "build_system/build_and_run.zig",
        "build_system/build_tests.zig",
        "calling-c/c.zig",
        "calling-c/cstring.zig",
        "calling-c/fopen.zig",
        "calling-c/instantiating-c-objects.zig",
        "calling-c/pow.zig",
        "calling-c/set_user_id.zig",
        "calling-c/stdio-example.zig",
        "calling-c/stdio-math-example.zig",
        "calling-c/translate-c.zig",
        "comptime/comptime_arg_runtime_error.zig",
        "data-structures/generic_array.zig",
        "data-structures/generic_linked_list.zig",
        "data-structures/generic_stack.zig",
        "data-structures/hash_table_it_key.zig",
        "data-structures/hash_tables.zig",
        "data-structures/hash_tables_it.zig",
        "data-structures/linked_list.zig",
        "data-structures/multi-array-list.zig",
        "data-structures/ordered_remove.zig",
        "data-structures/print_chars.zig",
        "data-structures/stack.zig",
        "data-structures/string_hash.zig",
        "data-structures/append-ex.zig",
        "debugging/build.zig",
        "enums/enum1.zig",
        "errors/error_list.zig",
        "file-io/append_to_file.zig",
        "file-io/buff_io.zig",
        "file-io/copy_file.zig",
        "file-io/create_file.zig",
        "file-io/create_file_and_read.zig",
        "file-io/create_file_and_write_toit.zig",
        "file-io/delete-dir.zig",
        "file-io/delete_file.zig",
        "file-io/iterate.zig",
        "file-io/make-dir.zig",
        "file-io/read_stdin.zig",
        "file-io/read_file.zig",
        "file-io/user_input.zig",
        "hello_world/build.zig",
        "http_server/build.zig",
        "image_filter/build.zig",
        "pointer/optional_pointer.zig",
        "pointer/p1.zig",
        "pointer/p2.zig",
        "pointer/p3.zig",
        "pointer/p4.zig",
        "pointer/p5.zig",
        "pointer/p6.zig",
        "pointer/p7.zig",
        "pointer/p8.zig",
        "threads/cancel_thread.zig",
        "threads/data_race.zig",
        "threads/deadlock.zig",
        "threads/detach.zig",
        "threads/example1.zig",
        "threads/example2.zig",
        "threads/example3.zig",
        "threads/joining.zig",
        "threads/mutex.zig",
        "threads/pool.zig",
        "threads/pool_with_task.zig",
        "threads/rw_lock.zig",
        "threads/thread_sleep.zig",
        "unittest/double_free.zig",
        "unittest/leak_memory.zig",
        "unittest/test_error.zig",
        "vectors/build.zig",
        "zig-basics/comp-strings.zig",
        "zig-basics/concat.zig",
        "zig-basics/defer.zig",
        "zig-basics/function_parameters_immu.zig",
        "zig-basics/function_parameters_mmu.zig",
        "zig-basics/hello_world.zig",
        "zig-basics/import-non-pub-struct.zig",
        "zig-basics/loop2.zig",
        "zig-basics/pub-keyword.zig",
        "zig-basics/replace.zig",
        "zig-basics/return-integer.zig",
        "zig-basics/runtime-slices-length.zig",
        "zig-basics/show_hex.zig",
        "zig-basics/string_replace.zig",
        "zig-basics/string_static.zig",
        "zig-basics/switch1.zig",
        "zig-basics/switch2.zig",
        "zig-basics/unused_var.zig",
        "zig-basics/user_struct.zig",
        "zig-basics/utf8-view.zig",
        "zig-basics/vec3_struct.zig",
        "vectors/src/main.zig",
        "vectors/src/main2.zig",
        "image_filter/src/image_filter.zig",
        "image_filter/src/test.zig",
        "http_server/src/config.zig",
        "http_server/src/request.zig",
        "http_server/src/response.zig",
        "http_server/src/main.zig",
        "hello_world/src/main.zig",
        "hello_world/src/root.zig",
        "debugging/src/debug1.zig",
        "build_system/src/hello.zig",
        "build_system/src/main.zig",
        "build_system/src/root.zig"
    };


    for (paths) |path| {
        std.debug.print("Building file: {s}\n", .{path});
        const file_name = get_file_name(path);
        const base_name = get_base_name(file_name);


        const lib = b.addLibrary(.{
            .name = base_name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(path),
                .target = b.graph.host,
            }),
        });

        b.installArtifact(lib);
    }
}
