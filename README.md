# Advent of Code 2025

This is where all my AoC solutions will live for this year. While I don't imagine I'll make it all the way to the end, it's always really fun and this year I'll try to use this as an excuse to play around with Elixir's concurrency a bit more.

## Usage

### Running Solutions

```bash
# Run a specific day
mix aoc.run 2

# Run a specific part
mix aoc.run 2 --part 1

# Run with timing
mix aoc.run 2 --time

# Use example input
mix aoc.run 2 --example

# Run multiple days
mix aoc.run all
mix aoc.run 1..5
mix aoc.run 1,3,5

# Combine flags
mix aoc.run 2 --part 1 --time --example
```

### Creating New Days

```bash
# Scaffold today's puzzle (during December 1-12)
mix aoc.new

# Scaffold a specific day
mix aoc.new 3

# Scaffold and fetch puzzle input from adventofcode.com
mix aoc.new 3 --fetch
```

This creates:
- `lib/d03.ex` with some basic template code
- `test/d03_test.exs` with example test stubs (need to be manually updated by you)
- `priv/inputs/d03/input.txt`
- `priv/inputs/d03/example.input.txt`

**Note:** The `--fetch` flag requires an `AOC_SESSION` environment variable in your `.env` file. You can get your session cookie from the adventofcode.com website while logged in (browser dev tools > Application > Cookies > `session`).

### Checking Answers

```bash
# Verify stored answers for a day
mix aoc.check 2

# Check multiple days
mix aoc.check all
mix aoc.check 1..5
mix aoc.check 1,3,5
```

To store answers, update the `@answers` attribute in your day module:

```elixir
@answers %{part1: 12345, part2: 67890}
```

## Project Structure

```
lib/
  d0<N>.ex                # Day <N> solution
  aoc.ex                  # Main module
  aoc/
    cli.ex                # CLI logic
    day_parser.ex         # Day specification parser
    input.ex              # Input file handling
    template.ex           # Template generation
  mix/tasks/
    aoc.run.ex            # Run command
    aoc.new.ex            # New command
    aoc.check.ex          # Check command
priv/                     # gitignored
  inputs/
    d0<N>/
      input.txt           # Actual puzzle input
      example.input.txt   # Example from problem
```

## TODOs

- [x] `--fetch` flag for `new` command to automatically get the inputs for a given day
- [ ] `bench` command for benchmarking solutions
- [ ] improve command argument parsing
