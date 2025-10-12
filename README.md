# piping-shellscript

Exploring how to create small composable shell scripts that follows the Unix Philosophy.

## The Unix Philosophy

* Write programs that do one thing and do it well. 
* Write programs to work together. 
* Write programs to handle text streams, because that is a universal interface.

[Wikipedia](https://en.wikipedia.org/wiki/Unix_philosophy)

This translates to the following core principles for shell scripting:

1. **Do one thing well**: each program should do one thing and do it well. One script, one transformation/operation. Small is beautiful.
2. **Everything is a file**: treat devices, processes, and data uniformly as files or streams, enabling consistent interfaces.
3. **Make each program a filter**: programs should read from `stdin` and write to `stdout`, enables piping and composition. Use `stderr` for errors and diagnostics, keeps data stream clean.
4. **Produce parseable output**: plain text, line-oriented when possible, tool-friendly.
5. **Use software leverage**: build on existing tools rather than reinventing functionality.
6. **Silent on success**: programs should be quiet when they succeed and only produce output when necessary.
7. **Exit with meaningful status codes**: 0 for success, non-zero for errors
