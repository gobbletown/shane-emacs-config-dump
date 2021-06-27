;;; traad-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "traad" "traad.el" (0 0 0 0))
;;; Generated autoloads from traad.el

(autoload 'traad-undo "traad" "\
Undo the IDXth change from the history. IDX is the position of an entry in the undo list (see: traad-history). This change and all that depend on it will be undone. Python-like negative indexing works here, so you can undo the most recent change by passing `-1' (the default value).

\(fn IDX)" t nil)

(autoload 'traad-redo "traad" "\
Redo the IDXth change from the history. IDX is the position of an entry in the redo list (see: traad-history). This change and all that depend on it will be redone. Python-like negative indexing works here, so you can redo the most recent undo by passing `-1' (the default value).

\(fn IDX)" t nil)

(autoload 'traad-display-history "traad" "\
Display undo and redo history." t nil)

(autoload 'traad-undo-info "traad" "\
Get info on the I'th undo history.

\(fn I)" t nil)

(autoload 'traad-redo-info "traad" "\
Get info on the I'th redo history.

\(fn I)" t nil)

(autoload 'traad-auto-import "traad" "\
Automatically add the necessary import for the current symbol.

Displays a list of potential imports - the user must select the
correct one." t nil)

(autoload 'traad-rename "traad" "\
Rename the object at the current location.

Attempts to rename all occurrences of the object in the project.

Optional arguments `DOCSTRINGS' and `IN-HIERARCHY' set renaming
options:

  - `DOCSTRINGS' (default `t') specifies whether occurrences in
    comments/docstrings should be renamed. For example, let's say
    we're renaming a variable, `var_to_rename` and `DOCSTRINGS'
    is set to `nil':

    | var_to_rename = 'this is a string'                 # [1]
    |
    | some_variable = var_to_rename                      # [2]
    |
    | # This is an occurrence of `var-to-rename`         # [3]
    |
    | def some_function(input_var):
    |     '''Docstring that has `var_to_rename` in it.'''# [4]
    |     return input_var ** 2
    |
    | some_function(var_to_rename)                       # [5]

    Renaming `var_to_rename` to `new_var_name`, this would
    become:

    | new_var_name = 'this is a string'                  # [1]
    |
    | some_variable = new_var_name                       # [2]
    |
    | # This is an occurrence of `var-to-rename`         # [3]
    |
    | def some_function(input_var):
    |     '''Docstring that has `var_to_rename` in it.'''# [4]
    |     return input_var ** 2
    |
    | some_function(new_var_name)                        # [5]

    Note that [1], [2] & [5] were renamed, but [3] &
    [4] (occurrences in a comment and a docstring) were not
    renamed. If `DOCSTRINGS' were `t', [3] & [4] would have been
    renamed.

  - `IN-HIERARCHY' (default `t') specifies whether occurrences
    higher and lower in the hierarchy should be renamed. (In
    practise this means the same method in a subclass or
    superclass) For example, let's say you're renaming some
    method, `method_to_rename`, and `IN-HIERARCHY' is set to
    `nil':

    | class BaseClass(object):
    |     def method_to_rename():                        # [1]
    |         print('This is the super class.')
    |
    | class DerivedClass(BaseClass):
    |     def method_to_rename():                        # [2]
    |         print('This is the derived class.')

    Renaming `BaseClass.method_to_rename` to
    `BaseClass.new_name`, results in:

    | class BaseClass(object):
    |     def new_name():                                # [1]
    |         print('This is the super class.')
    |
    | class DerivedClass(BaseClass):
    |     def method_to_rename():                        # [2]
    |         print('This is the derived class.')

    The original method, [1], is renamed. Note that the override
    method in the subclass, [2], does not get renamed. If
    `IN-HIERARCHY' were set to `t', [2] would also be renamed.

Note that unsure occurrences will not be renamed. Rope may find
occurrences that it is unsure about, which are marked as
`unsure`. These will generally be wrong, so you don't want to
include them all. However, this means you may miss some
occurrences of the object. See the Rope documentation for more
details on the `unsure` parameter.

\(fn NEW-NAME &key (DOCSTRINGS t) (IN-HIERARCHY t))" t nil)

(autoload 'traad-rename-advanced "traad" "\
Rename the thing at point, with advanced options.

\(fn NEW-NAME DOCSTRINGS IN-HIERARCHY)" t nil)

(autoload 'traad-rename-module "traad" "\
Rename the currently opened module.

Note that this renames the module associated with the current
buffer, NOT the module under point.

\(fn NEW-NAME)" t nil)

(autoload 'traad-move "traad" "\
Move the current object (DWIM).

Calls the correct form of `move` based on the type of thing at
the point." t nil)

(autoload 'traad-move-global "traad" "\
Move the object at the current location to file `DEST'.

Prompts for a `DEST' when called interactively.

\(fn DEST)" t nil)

(autoload 'traad-move-module "traad" "\
Move the current module to file `DEST'.

Prompts for a `DEST' when called interactively.

Note that this moves the currently *open* module, not the module
under point.

\(fn DEST)" t nil)

(autoload 'traad-normalize-arguments "traad" "\
Normalize the arguments for the method at point.

This refactors all calls to this function to ensure the variables
are called in the correct order. It also removes explicit
references to keyword arguments whenever possible, replacing them
with positional references. For example, given the following:

    | def this_is_a_test(a, b, c=5):
    |     return [a, b, c]
    |
    | this_is_a_test(a=10, b=10, c=20)
    | this_is_a_test(20, 20, c=10)
    | this_is_a_test('a', 'b', 'c')
    | this_is_a_test(b='b', c='c', a='a')
    | this_is_a_test(a='a', b='b')

Calling `traad-normalize-arguments' on `this_is_a_test`, it would
become:

    | def this_is_a_test(a, b, c=5):
    |     return [a, b, c]
    |
    | this_is_a_test(10, 10, 20)
    | this_is_a_test(20, 20, 10)
    | this_is_a_test('a', 'b', 'c')
    | this_is_a_test('a', 'b', 'c')
    | this_is_a_test('a', 'b')

Note that the arguments in [1] were reordered. A more complex
case would be:

    | def longer_function(a, b, c=10, d=20):
    |     return [a, b, c, d]
    |
    | longer_function(a='a', b='b', d='d')

Calling `traad-normalize-arguments' on `longer_function`, it
would become:

    | def longer_function(a, b, c=10, d=20):
    |     return [a, b, c, d]
    |
    | longer_function('a', 'b', d='d')

It cannot remove the keyword reference to `d`, so \"d='d'\" is
retained.
" t nil)

(autoload 'traad-remove-argument "traad" "\
Remove the `INDEX'th argument from the signature at point.

Also attempts to remove it from any calls to this function.

For example, let's say we have the following:

    | def some_function(arg1, arg2, arg3=10, arg4='some string'):
    |     '''Do something to some arbitrary parameters.'''
    |     first_half = [arg1, arg2]
    |     second_half = [arg3, arg4]
    |     return first_half, second_half
    |
    | some_function(1, 2, arg3=3, arg4='four')

Calling `traad-remove-argument' on `some_function` with an
`INDEX' of 2, this would become:

    | def some_function(arg1, arg2, arg4='some string'):
    |     '''Do something to some arbitrary parameters.'''
    |     first_half = [arg1, arg2]
    |     second_half = [arg3, arg4]                     # [1]
    |     return first_half, second_half
    |
    | some_function(1, 2, 'four')                        # [2]

It has removed the third argument, `arg3`.

Note:

  - The index counts from zero, so an index of 0 means the first
    argument and an index of 2 means the _third_ argument.

  - It does not remove internal references to the argument (e.g.
    [1]) in the function logic.

  - References to the function also have their function call
    normalised. See [2], where the explicit keyword reference was
    removed in favour of a positional reference. See
    `traad-normalize-arguments' for more information.

\(fn INDEX)" t nil)

(autoload 'traad-add-argument "traad" "\
Add a new argument at `INDEX' in the signature at point.

Takes the following arguments:

  `INDEX'   - The index to add the argument at. Note that this
              is zero-indexed, so an index of 1 will insert it
              as the _second_ argument.
  `NAME'    - The name of the argument.
  `DEFAULT' - The default value of the argument.
  `VALUE'   - The value to insert for this argument in any
              existing calls to this function.

For example, let's say we have the following:

    | def some_function(arg1, arg2, arg3=10, arg4='some string'):
    |     return [arg1, arg2, arg3, arg4]
    |
    | some_function(1, 2, arg3=3, arg4='four')

Let's call `traad-add-argument' on some_function. We'll supply
the following arguments:

`INDEX'   = 3
`NAME'    = \"new_arg\"
`DEFAULT' = 30
`VALUE'   = 50

This will become:

    | def some_function(arg1, arg2, arg3=10, new_arg=30, arg4='some string'):
    |     return [arg1, arg2, arg3, arg4]
    |
    | some_function(1, 2, 3, 50, 'four')                 # [1]

Note that references to the function also have their function
call normalised. See [1], where the explicit keyword reference
was removed in favour of a positional reference. See
`traad-normalize-arguments' for more information.

Arguments are always added as keyword arguments. Rope does not
discriminate based on position, so you can add keyword arguments
out-of-order. For example, back to the original function:

    | def some_function(arg1, arg2, arg3=10, arg4='some string'):
    |     return [arg1, arg2, arg3, arg4]
    |
    | some_function(1, 2, arg3=3, arg4='four')

Adding the same argument as before at `INDEX' = 1, this will
become:

    | def some_function(arg1, new_arg=30, arg2, arg3=10, arg4='some string'):# [1]
    |     return [arg1, arg2, arg3, arg4]
    |
    | some_function(1, 50, 2, 3, 'four')

Watch line [1]. Note that the sequence argument `arg2` now
appears after `new_arg`, a keyword argument, so the function
signature is no longer valid.

\(fn INDEX NAME DEFAULT VALUE)" t nil)

(autoload 'traad-inline "traad" "\
Inline this object (replace the object with the thing it represents.)

Inlining can be performed on many objects.

Functions:

  Inlining a function replaces calls to a function with the
  explicit code the function executes. For example:

    | def do_something():
    |     print sys.version
    |     return C()

  Inlining `do_something`, becomes:

    | print sys.version
    | return C()

  Methods, etc. can also be inlined. For example:

    | class C(object):
    |     var = 1
    |
    |     def f(self, p):                                # [1]
    |         result = self.var + pn                     # [1]
    |         return result                              # [1]
    |
    | c = C()
    | x = c.f(1)                                         # [2]

  Inlining `C.f`, becomes:

    | class C(object):
    |     var = 1
    |
    | c = C()
    | result = c.var + pn                                # [2]
    | x = result                                         # [2]

Parameters:

  Inlning a parameter passes the default value of a keyword
  parameter whenever the parameter is not explicitly referenced.
  For example:

    | def f(p1=1, p2=2):
    |     pass
    |
    | f(3, 2)
    | f()                                                # [1]
    | f(3)                                               # [2]
    | f(p1=5, p2=7)                                      # [3]

  Inlining `p2`, becomes:

    | def f(p1=1, p2=2):
    |     pass
    |
    | f(3, 2)
    | f(p2=2)                                            # [1]
    | f(3, 2)                                            # [2]
    | f(5, 7)                                            # [3]

\[1] and [2] have had explicit calls to the keyword argument
added. Note that:

  - It prefers positional over keyword calls.

  - It also normalizes the arguments, so [3] is affected. See
    `traad-normalize-arguments' for more information.
" t nil)

(autoload 'traad-introduce-parameter "traad" "\
Introduce a parameter in a function.

This extracts a hard-coded value in a function, and introduces it
as a parameter. An example may be clearer. Let's say we have:

    | def multiply(value):
    |     result = value * 2
    |     return result
    |
    | my_var = multiply(10)

Let's call `traad-introduce-parameter' when the cursor is on '2'
and with `PARAMETER' = \"multiplier\". It will become:

    | def multiply(value, multiplier=2):
    |     result = value * 2
    |     return result
    |
    | my_var = multiply(10)

\(fn PARAMETER)" t nil)

(autoload 'traad-encapsulate-field "traad" "\
Introduce getters and setters and use them instad of references.

For example:

    | class MyClass(object):
    |     def __init__(self):
    |         self.my_var = 1
    |
    | my_class = MyClass()
    | print(my_class.my_var)                             # [1]
    | my_class.my_var = 5                                # [2]

Note that [1] is a get operation. [2] is a set operation.
Encapsulating the field `MyClass.my_var` this becomes:

    | class MyClass(object):
    |     def __init__(self):
    |         self.my_var = 1
    |
    |     def get_my_var(self):
    |         return self.my_var
    |
    |     def set_my_var(self, value):
    |         self.my_var = value
    |
    | my_class = MyClass()
    | print(my_class.get_my_var())                       # [1]
    | my_class.set_my_var(5)                             # [2]

Note that [1] and [2] have had the getters and setters inserted
automatically.
" t nil)

(autoload 'traad-local-to-field "traad" "\
Turns a local variable into a field variable.

In other words, toggles the 'self' keyword or similar. Some
examples may be clearer.

Let's say we have:

    | class MyClass(object):
    |     def __init__(self):
    |         some_var = 1
    |         another_var = some_var * 2

  Calling `local-to-field' on `some_var`, it becomes:

    | class MyClass(object):
    |     def __init__(self):
    |         self.some_var = 1
    |         another_var = self.some_var * 2

Note that the refactoring is only performed on the variable in
scope, not on other occurrences of the name. For example, if we
have:

    | class MyClass(object):
    |     def __init__(self):
    |         some_var = 1
    |         another_var = some_var * 2
    |
    |     def do_something(self):
    |         some_var = 200

  Calling `local-to-field' on `some_var`, it becomes:

    | class MyClass(object):
    |     def __init__(self):
    |         self.some_var = 1
    |         another_var = self.some_var * 2
    |
    |     def do_something(self):
    |         some_var = 200
" t nil)

(autoload 'traad-use-function "traad" "\
Tries to find the places in which a function can be used and
changes the code to call it instead.

For example, let's say we have the following code:

    | def square(p):
    |     return p ** 2
    |
    | my_var = 3 ** 2                                    # [1]
    |
    | another_var = 4 ** 2                               # [2]

  Performing 'use function' on `square`, becomes:

    | def square(p):
    |     return p ** 2
    |
    | my_var = square(3)                                 # [1]
    |
    | another_var = square(4)                            # [2]

It also works across files. Let's say we have two files,
'mod1.py' and 'mod2.py'. They look as follows:

    mod1.py:
    | def square(p):
    |     return p ** 2
    |
    | my_var = 3 ** 2                                    # [1]

    mod2.py:
    | another_var = 4 ** 2                               # [2]

  Performing 'use function' on `square`, the two files become:

    mod1.py:
    | def square(p):
    |     return p ** 2
    |
    | my_var = square(3)                                 # [1]

    mod2.py:
    | import mod1                                        # [2]
    | another_var = mod1.square(4)                       # [2]
" t nil)

(autoload 'traad-extract-method "traad" "\
Extract the currently selected region to a new method.

Here are some examples from the Rope documentation.
${region_start} and ${region_end} show the selected region for
extraction:

    | def a_func():
    |     a = 1
    |     b = 2 * a
    |     c = ${region_start}a * 2 + b * 3${region_end}  # [1]

After performing extract method (supplying the name `new_func`)
we'll have:

    | def a_func():
    |     a = 1
    |     b = 2 * a
    |     c = new_func(a, b)                             # [1]
    |
    | def new_func(a, b):                                # [2]
    |     return a * 2 + b * 3                           # [2]

For multi-line extractions if we have:

    | def a_func():
    |     a = 1
    |     ${region_start}b = 2 * a                       # [1]
    |     c = a * 2 + b * 3${region_end}                 # [1]
    |     print b, c

After performing extract method we'll have:

    | def a_func():
    |     a = 1
    |     b, c = new_func(a)                             # [1]
    |     print b, c
    |
    | def new_func(a):                                   # [2]
    |     b = 2 * a                                      # [2]
    |     c = a * 2 + b * 3                              # [2]
    |     return b, c                                    # [2]

\(fn NAME BEGIN END)" t nil)

(autoload 'traad-extract-variable "traad" "\
Extract the currently selected region to a new variable.

For example, take this code:

    | my_var = 1 * 2 * 3 * 4

${region_start} and ${region_end} show the selected region for
extraction:

    | my_var = ${region_start}1 * 2 * 3${region_end} * 4

Extracting to a new variable, `another_var`, gives:

    | another_var = 1 * 2 * 3
    | my_var = another_var * 4

Traad will _not_ try to replace similar expressions with the new
variable. For example, if we have:

    | my_var = 1 * 2 * 3 * 4
    | similar_var = 1 * 2 * 3                            # [1]

And we extract the following:

    | my_var = ${region_start}1 * 2 * 3${region_end} * 4
    | similar_var = 1 * 2 * 3                            # [1]

Extracting to `another_var` gives:

    | another_var = 1 * 2 * 3
    | my_var = another_var * 4
    | similar_var = 1 * 2 * 3                            # [1]

The expression at [1] will not be replaced with a reference to the
new variable.

\(fn NAME BEGIN END)" t nil)

(autoload 'traad-organize-imports "traad" "\
Organize the import statements in `filename' according to pep8.

This is the preferred structure:

    [__future__ imports]

    [standard imports]

    [third-party imports]

    [project imports]


    [the rest of module]

\(fn FILENAME)" t nil)

(autoload 'traad-expand-star-imports "traad" "\
Expand * import statements in `filename'.

This replaces 'import *' with explicit references to the objects
used in the module.

For example, let's say we have two files, 'mod1.py' and
'mod2.py'. They look as follows:

    mod1.py:
    | def some_function():
    |     return True
    |
    | my_var = 1

    mod2.py:
    | from some_mod import *                             # [1]
    |
    | my_var = some_function()

  Expanding star imports in 'mod2.py' gives:

    mod1.py:
    | def some_function():
    |     return True
    |
    | my_var = 1

    mod2.py:
    | from some_mod import some_function                 # [1]
    |
    | my_var = some_function()

Note that it treats the new assignment of my_var as though it is
creating a variable local to 'mod2.py'.

\(fn FILENAME)" t nil)

(autoload 'traad-froms-to-imports "traad" "\
Convert 'from' imports to normal imports in `filename'.

For example:

    | from mod1 import some_function
    |
    | my_var = some_function()

becomes:

    | import mod1
    |
    | my_var = mod1.some_function()

\(fn FILENAME)" t nil)

(autoload 'traad-relatives-to-absolutes "traad" "\
Convert relative imports to absolute in `filename'.

\(fn FILENAME)" t nil)

(autoload 'traad-handle-long-imports "traad" "\
Transform long imports into 'from' imports in `filename'.

Handle long imports command tries to make long imports look
better. It attempts to transform imports like this:

    import pkg1.pkg2.pkg3.pkg4.mod1

into:

    from pkg1.pkg2.pkg3.pkg4 import mod1

Long imports can be identified either by having lots of dots or
being very long. The default configuration considers imported
modules with more than 2 dots or with more than 27 characters to
be long.

\(fn FILENAME)" t nil)

(autoload 'traad-imports-super-smackdown "traad" "\
Apply all the import reformatting commands Traad provides.

Applies the following commands (in order):
\(
  `traad-expand-star-imports'
  `traad-relatives-to-absolutes'
  `traad-froms-to-imports'
  `traad-handle-long-imports'
  `traad-organize-imports'
)
See each of these commands for full documentation.

\(fn FILENAME)" t nil)

(autoload 'traad-goto-definition "traad" "\
Jump to the position this object was defined.

\(fn POS)" t nil)

(autoload 'traad-goto-definition-synchronous "traad" "\
Go to this object's definition. Blocks until the task is completed.

\(fn POS)" t nil)

(autoload 'traad-list-occurrences "traad" "\
Return a list of occurrences for the object at `POS'.

Useful for alternate displays, e.g. `helm'.

\(fn POS)" nil nil)

(autoload 'traad-list-implementations "traad" "\
Return a list of implementatins for the object at `POS'.

Useful for alternate displays, e.g. `helm'.

\(fn POS)" nil nil)

(autoload 'traad-findit-definition-synchronous "traad" "\
Return a list of possible definitions for the object at `POS'.

Useful for alternate displays, e.g. `helm'.

\(fn POS)" nil nil)

(autoload 'traad-find-occurrences "traad" "\
Finds and displays all occurrences of the current symbol.

\(fn POS)" t nil)

(autoload 'traad-find-implementations "traad" "\
Finds and displays all implementations of the current symbol.

\(fn POS)" t nil)

(autoload 'traad-find-definition "traad" "\
Finds and displays the definition of the current symbol.

Note that this is not the same as `traad-goto-definition'.

  - This function locates the definition with the `findit' module
    from Rope. It does not jump to the definition.

  - `traad-goto-definition' finds the definition with the
    `code_assist' module from Rope. It jumps to the location of
    the definition.

\(fn POS)" t nil)

(autoload 'traad-thing-at "traad" "\
Get the type of the Python thing at `POS'.

When called interactively, displays the type.

\(fn POS)" t nil)

(autoload 'traad-code-assist "traad" "\
Get possible completions at `POS' in current buffer.

This returns an alist like ((completions . [[name documentation scope type]]) (result . \"success\"))

\(fn POS)" t nil)

(autoload 'traad-display-calltip "traad" "\
Display calltip for an object.

\(fn POS)" t nil)

(autoload 'traad-popup-calltip "traad" "\
Display calltip for an object in a popup.

\(fn POS)" t nil)

(autoload 'traad-display-doc "traad" "\
Display docstring for an object.

\(fn POS)" t nil)

(autoload 'traad-popup-doc "traad" "\
Display docstring for an object in a popup.

\(fn POS)" t nil)

(autoload 'traad-kill-all "traad" "\
Kill all traad servers and associated buffers." t nil)

(autoload 'traad-install-server "traad" "\
Install traad.

This installs the server into the `traad-environment-name'
virtual environment, creating the virtualenv if necessary.

By default, then, it installs traad into
`PYTHON-ENVIRONMENT_DIRECTORY/traad`.

To install Traad for a different version of Python than the
default, ensure the virtual environment exists (and is running
that version of Python) before calling `traad-install-server'." t nil)

(register-definition-prefixes "traad" '("traad-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; traad-autoloads.el ends here
