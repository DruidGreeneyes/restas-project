A simple project skeleton generator for Restas projects.

`restas-project` exports one symbol, nameing a function: `start-restas-project`. It's lambda list is:

```
(name &key depends-on (test nil))
```

Where `:depends-on` is a list of dependencies, in addition to Restas, which is included by default, and `:test` is a flag, which if set to non-nil will cause restas-project to also generate a five-am test system. The project is generated in the first path in `ql:*local-project-directories*`. 

example:

```common-lisp
(restas:project "hello-world" :depends-on '(sexml postmodern) :test t)
```


