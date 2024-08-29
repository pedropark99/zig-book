const c = @cImport({
    @cInclude("person.h");
});

fn add_age(x: c.Person) c.Person {
    return x.age + 2;
}

pub fn main() !void {
    const z = add_age(c.default_person);
    _ = z;
}
