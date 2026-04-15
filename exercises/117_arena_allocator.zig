//
// Zig has several kinds of allocators for several kinds of things.
// On of those allocators is ArenaAllocator which we previusly learned
// in exercise 099_memory_allocation.zig
// You may wondering why does the ArenaAllocator came again?
// --> ArenaAllocator came again because it want you to know about it more,
// becuase ArenaAllocator has many things to tell you.
//
// ArenaAllocator: Sometimes you need to allocate many small pieces of memory that
// all lives for the exact same short time period.
// --> For example:
//     When parsing a file, handeling a web request, or computing a temporary
//     data structure.
//
// ArenaAllocator: That's why I'm absolutely perfect for this. You allocate
// as much as you want, as often as you want, and then you free everything at once
// via de-initializing me using a single `deinit()` call.
//
// Under the hood, ArenaAllocator wraps another allocator...
// ArenaAllocator: Let me explain! often i use page_allocator as child allocator,
// Why? becuase i request large chunks of memory from the child allocator and hands out smaller pieces to you.
//
// Also, No individual free() calls are needed! which ArenaAllocator forgot to tell you.
// This pattern is extremely comman and used everywhere in real system-level Zig programs.
//
// Let's see what's left from ArenaAllocator via this exercise:
//
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    // First of all we should initialize ArenaAllocator and its "child allocator"
    // to request its large memory block from.
    var arena = std.???.ArenaAllocator.???; // Oh no! i forgot how to right it?
    // Please complete it for me!

    // We want arena to free all its memory when we are done so
    // our os can reuse it.
    defer ???;

    // Remember or see previous 116_gpa_debug.zig and check what is next step?
    const allocator = ???; // Again! you should fix this.

    // Now we can allocate multiple pieces of memory.
    // The `dupe` function duplicates a slice, allocating exactly enough
    // memory to hold the copy. This requires an allocator.
    const name1 = ??? allocator.???(u8, "Zig");
    const name2 = ??? allocator.???(u8, "is");
    const name3 = ??? allocator.???(u8, "awesome for systems programming!");
    // Please fix this code!

    // Now we should print out our assembled sentence.
    print("{?} {?} {?}\n", .{
        name1, name2, name3
    });

    // Note: we did NOT call free() on name1, name2, name3
    // We don't have to! The arena cleans everything up when it is deinited
    // earlier.
    //
    // In fact, calling free() on an ArenaAllocator does nothing unless
    // it happens to be the very last allocation made! It's super fast!
}
