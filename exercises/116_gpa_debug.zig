//
// Do you know what the real system programming,
// Actual memory management projects/programms use which tool?
// Its DebugAllocator previusly its known as GeneralPurposeAllocator in Zig,
// The rename was happened in 0.16.0-dev version. As you know
//
// We can use page_allocator but we are using DebugAllocator because it adds safety checks,
// leak detection, double-free protection and even stack traces when something goes wrong.
//
// Its specially designed for safety and devlopment rather than for performance.
// Also its true that DebugAllocator is slower than page_allocator or
// c_allocator, while you are developing it is your real best friend.
// DebugAllocator will literally scream at you if you forgot to free the occupied memory.
//
// Do you remember the Memory Allocation exercise we did in 099_memory_allocation.zig
//
// We used the Arena allocator for simple
// programs which allocate once and then exit:
//
//     const std = @import("std");
//
//     // memory allocation can fail, so the return type is !void
//     pub fn main() !void {
//
//         var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//         defer arena.deinit();
//
//         const allocator = arena.allocator();
//
//         const ptr = try allocator.create(i32);
//         std.debug.print("ptr={*}\n", .{ptr});
//
//         const slice_ptr = try allocator.alloc(f64, 5);
//         std.debug.print("slice_ptr={*}\n", .{slice_ptr});
//     }
// But this time we will use DebugAllocator which is similir when we used
// ArenaAllocator, but insted of ArenaAllocator we will use DebugAllocator here is an example:
//
//     const std = @import("std");
//
//     // memory allocation can fail, so the return type is !void
//     pub fn main() !void {
//
//         var debug_allocator = std.heap.DebugAllocator(.{ .safety = true }).init;
//                       --> did you see we used `.init` instead of `.{}`—————^^^^
//                       --> becuase `.{}` which is default for DebugAllocator is deprecated.
//         defer _ = debug_allocator.deinit();
//
//         const allocator = debug_allocator.allocator();
//
//         ... mostly as arenaallocator style.
//     }
// 
// Every DebugAllocator has three phases:
// 1. Initialization (init)
// 2. Use
// 3. Deinitialization (deinit)
// You must pair init and deinit, if you don't they cause the memory leak.
// Also we use defer to make this entire process automatic. It runs deinit when the scope exists.
// Even if function fails so it returns error earlier. This is zig's patterns for guaranteed cleanup.
//
// Let's create our first DebugAllocator and manage a slice of memory.
//
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    // We can init DebugAllocator by passing a configuration struct.
    var gpa = ???; // What's missing here, if you wonder so explore!

    // As we all know when a program finishes (or if it returns early due to an error),
    // we want to make sure the allocator cleans up and checks for leaks.
    // So what we need to do below?
    defer ???;

    // TO actually allocate memory, we need to get the generic `std.mem.Allocator`
    // interface from our DebugAllocator. This is what we pass to functions.
    const allocator = gpa.allocator();

    // Now let's allocate 64 bytes of memory!
    const slice = ??? allocator.???(u8, ???); // Here 3 things missing do it wisely.

    // We can write to our newly allocated memory.
    @memset(slice, 0xaa); // here `0xaa` is used and if you forgot about it see some exercises backword.

    // Now we will print the first byte.
    print("Allocated 64 bytes safely with GPA. First byte is 0x{x}\n", .{slice[???]});

    // We must remember to free the memory we allocated!
    // If you forget this, DebugAllocator will report a memory leak when
    // deinit() is called at the end of the program!
    ???; // think about it, what to use?

    // A common mistake is to try to use the memory after freeing it, which is called a "use-after-free" bug.
    // Did you know? deinit() does justnot clean up the memory, it also returns either `.ok` or `.leak`. 
    // you can also use `_ = ` to ignore the return value if you don't care about it or do if-else to handle it.
}

// Upcoming Exercises will be exiting and also if found this exercise easy,
// So you might be comfortable with the memory and allocators.
// If you found this hard so don't worry just redo entire ziglings from scrath,
// Remember: Try and try until success!

// If you are lazzy to find previous exercises when we used binaries so here is an addition info.
// Additional Info: Why 0xaa? It is 10101010 in binary, a very recognizable pattern.
// debuggers and tools have used this for decades as a "poisoned" fill.
// If you ever see 0xaa in memory you were not supposed to touch it,
// you know immediately something went wrong. It is not magic, just smart.