//
// In this exercise we are going deeper into the system.
// 
// If you did previous 2 exrcies well so you will notice something
// common in this exercise.
//
// Sometimes you want to talk directly to the OS and ask for 
// raw memory pages (usually 4096 bytes at a time).
//
// Now let's call zig's and our old friend page_allocator.
// 
// page_allocator: I'm very fast because i bypass any user-space 
// memory management and go strait to the OS.
// --> I can do it via mmap on Linux/MacOS or VirtualAlloc on Windows.
//
// However, there is a catch: you are 100% responsible for freeing
// the memory yourself. There is no safety net, no leak detection,
// and no hand-holding. This is real system programming territory.
// 
// page_allocator: Often, I am used as the backing "child allocator" for 
// other, more sophisticated allocators like ArenaAllocator or DebugAllocator
// but sometimes you just need raw pages for yourself.
//
// Exactly what page_allocator said, We previously used page_allocator
// in ArenaAllocator and DebugAllocator.
//
// If you have these questions in your mind, so here are awnsers of them.
//
// What is a memory page?
// --> Most OS does not give memory byte by byte, instead it gives memory in chunks called pages.
// --> One page is usually 4096 bytes means 4KB which i mentioned above.
// --> This is not a Zig thing, this is how
// --> every modern OS and CPU manages memory at the hardware level.
// --> When you ask page_Allocator for memory, so you are asking directly to OS for one or more of these pages.
// --> Also, Nothing in between, no wrapper, just raw pages.
//
// Why would i ever want this?
// --> Most of the time you would not, ArenaAllocator or DebugAllocator are better.
// --> But sometimes you are writing something very low level like a custom allocator,
// --> a memory pool, or a runtime, and you want to build your own system on top.
// --> page_allocator is the foundation everything else sits on.
// 
// We will learn more about all allocators in future...
// 
// Let's allocate exactly one page of memory!
//
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    // The page_allocator is a global instance, so we don't need to init it.
    // It impls(Implements) the standard `std.mem.Allocator` interface.
    // Can you make an allocator const variable using page_allocator.
    ???;

    // Ask the allocator for exactly 4096 bytes of memory 
    // which is a standard page size.
    // This is done by allocating a slice of 4096 `u8` elements.
    const page = ??? ???(u8, ???); // Please fix this!

    // As always, we must ensure to free what we allocate.
    // Orelse the OS will reclaim it when program exits,
    // but in a long-running program, this would be catastrophic memory leak!
    // it is your only safety net. DebugAllocator would warn you about a leak. 
    // page_allocator will not say a word. It will just silently let the OS clean up
    // when the program exits.
    defer ???;

    // Write a pattern at the start of the page so we can see it worked.
    // We are just modifying the memory to prove we really own it.
    @memset(page[0..16], 0xbb);  

    // Let's print a success message to prove we did it!
    print("Successfully allocated and will free one full memory page.\n", .{});
}

// Note: While war page allocation is powerful, remember that it's usually
// better to use either ArenaAllocator or DebugAllocator for most general usecases.
// as they provide better safety guarantees!
// If wonder about Allocator, so you will learn more about it very soon!
// As Allocators are the zig building blocks for making reusable and efficient program.