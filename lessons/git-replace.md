### Git replace
Rewriting history can be expensive, time consuming, and is not always the correct solution. An organization may be so heavily invested in their monorepo, that a rewrite is totally unrealistic `git replace` is a useful tool for rewriting history. Given a particular commit SHA, it allows you to replace a commit in history with another commit. 

```
--graft <commit> [<parent>…​]
Create a graft commit. A new commit is created with the same content as <commit> except that its parents will be [<parent>…​] instead of <commit>'s parents. A replacement ref is then created to replace <commit> with the newly created commit. Use --convert-graft-file to convert a $GIT_DIR/info/grafts file and use replace refs instead.
```

How can we use this with the monorepo? Since we don't want to rewrite history, we can create two copies of the repository, one containing all of the historical data and the other with the HEAD of the historical repository and any other future commits. With this approach, the historical repository will remain untouched (read-only) and the new repository will be used for all future development.

:arrow_backward: [Back to Main](../README.md)
