const c = @cImport({
    @cInclude("hello_lib.h");
});

pub fn main() void {
    c.hello_cpp();
}
