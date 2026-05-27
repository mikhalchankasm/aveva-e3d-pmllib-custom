# COPYCE

[Русская версия](README.md) | English version

`COPYCE` is a PML helper for copying the current database element and then renaming copied named elements.

The idea is simple: the native `NEW ... COPY ...` command makes a technical copy, but the names inside the copied tree are often not convenient for real project work. This helper creates a copy in a more human-controlled way: it creates the copy, finds a free prefix, renames the root and nested named elements, and creates a `MARKDB` mark so the operation can be reverted with `UNDODB`.

## Location

```text
pmllib\mylib\design\copyfunc
```

Main object:

```text
copyce.pmlobj
```

## Simple Copy

If you need a normal copy of the current `CE` under the same owner, use the short wrapper:

```pml
!newCopy = !!copyCeWithCopyofNames(!!ce, !!ce.owner)
```

It creates a copy and renames elements like this:

```text
/copyof-OriginalName
/copyof-(2)-OriginalName
```

If an already-created copy is copied again, the old `copyof-` or `copyof-(n)-` part is stripped from the base name. Repeated copies therefore do not become `copyof-copyof-...`; the index changes instead:

```text
/copyof-OriginalName
/copyof-(2)-OriginalName
/copyof-(10)-OriginalName
```

You can also call the object directly:

```pml
!copy = object COPYCE(!!ce, !!ce.owner)
!newCopy = !copy.run()
```

After the run, inspect the result:

```pml
q var !copy.copyRoot
q var !copy.lastPrefix
q var !copy.lastRenamed
```

## Copy With A Custom Prefix

If you need a custom prefix instead of `copyof`, for example `clone`, use:

```pml
!newCopy = !!copyCeWithPrefixRoot(!!ce, !!ce.owner, 'clone')
```

Example names:

```text
/clone-PipeName
/clone-BranchName
/clone-(2)-PipeName
```

If you also need custom undo mark text:

```pml
!newCopy = !!copyCeWithPrefixRootMark(!!ce, !!ce.owner, 'clone', 'Clone current CE')
```

## Name Length Limit

The full element name, including `/`, is limited to 50 characters. `COPYCE` builds names with the current prefix and copy index in mind. If the generated name is too long, the base part of the name is truncated while the prefix and index are preserved.

For example, for the tenth copy, space is reserved for `copyof-(10)-` first, and only then the available part of the source name is used:

```text
/copyof-(10)-VeryLongOriginalElementName...
```

If the prefix is too long by itself and leaves no room for even one base-name character, that prefix candidate is treated as unavailable and the copy is not run with it.

## Complex Or Custom Copy

If you need more advanced naming logic, create the `COPYCE` object directly and choose a mode:

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'typecopy', 'Copy TYPEPREFIX', 'TYPEPREFIX')
!newCopy = !copy.run()
```

Or use the wrapper:

```pml
!newCopy = !!copyCeWithMode(!!ce, !!ce.owner, 'typecopy', 'TYPEPREFIX', 'Copy TYPEPREFIX')
```

Available modes:

```text
DEFAULT     /copyof-PipeName
TYPEPREFIX  /typecopy-PIPE-PipeName
PIPEBRANCH  /pbcopy-P-PipeName or /pbcopy-B-BranchName
LOWER       /lowercopy-pipename
```

Mode purpose:

- `DEFAULT` - the general-purpose mode. It only adds the selected prefix, for example `copyof-` or `clone-`. Use it for a normal copy without extra classification in the name.
- `TYPEPREFIX` - adds the element type after the prefix: `PIPE`, `BRAN`, `EQUI`, and so on. This is useful when the copied structure contains different element types and the name should make that visible.
- `PIPEBRANCH` - a shorter piping-focused mode: `PIPE` gets `P-`, `BRAN` gets `B-`, and all other types fall back to `TYPEPREFIX`. It keeps names shorter while still marking pipe and branch elements clearly.
- `LOWER` - converts the generated name to lowercase. Use it when the project naming convention prefers lowercase names or when copied names should not keep mixed case.

## Mode Examples

### DEFAULT

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'copyof', 'Copy DEFAULT', 'DEFAULT')
!newCopy = !copy.run()
```

### TYPEPREFIX

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'typecopy', 'Copy TYPEPREFIX', 'TYPEPREFIX')
!newCopy = !copy.run()
```

### PIPEBRANCH

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'pbcopy', 'Copy PIPEBRANCH', 'PIPEBRANCH')
!newCopy = !copy.run()
```

### LOWER

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'lowercopy', 'Copy LOWER', 'LOWER')
!newCopy = !copy.run()
```

## Test

Run this only on a safe test element:

```pml
!created = !!copyCeTestCurrent()
```

The test creates four copies of the current `CE` under `CE.owner`:

```text
DEFAULT
TYPEPREFIX
PIPEBRANCH
LOWER
```

Undo:

```pml
UNDODB
UNDODB 4
```

## PostEvents

Optional undo/redo callbacks:

```pml
!ok = !!copyCeInstallPostEvents()
```

Disable callback output:

```pml
!ok = !!copyCePostEventsEnabled(FALSE)
```

Enable it again:

```pml
!ok = !!copyCePostEventsEnabled(TRUE)
```

## Files

```text
copyce.pmlobj                     main COPYCE object
copycepostevents.pmlobj           optional !!postEvents object
copyCeTestCurrent.pmlfnc          test runner
copyCeWithMode.pmlfnc             naming mode wrapper
copyCeWithCopyofNames.pmlfnc      simple copyof copy
copyCeWithPrefixRoot.pmlfnc       custom prefix copy
copyCeWithPrefixRootMark.pmlfnc   custom prefix copy with MARKDB text
```
