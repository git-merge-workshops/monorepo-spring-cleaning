### Grafting a repository
When rewriting the history of our repostiory is not an option, we can use `git replace` to graft two repositories together. This will allow us to keep an archived history of our repository while still being able to maintain future development. We start this process with a fresh clone of our repository.

![Main Repository](../images/main_transparent.png "Main Repository")

Our first step is to copy our monorepo into a new directory. We will use one as the historical repository and the other as the future repository.

```bash
cp -r /source/a-bad-monorepo /source/a-bad-monorepo-historical
```

Next, we will take our future development repository (a-bad-monorepo) and create it as a new repository, with the base commit as the HEAD of the historical repository. The easiest and simplest method of doing this is to delete our `.git` directory, and re-initialize it as a new git repo. We can do this by running the following commands:

```bash
cd /source/a-bad-monorepo
rm -rf .git
git init
```

Next, we need to add and commit all of the new files to our repository. Remember, this is the new starting for all future development, so it is a good idea to leave behind a trace of the historical repository. We can do this by adding a commit message that references the historical repository. 

```bash
git add --all
git commit -m "Initial commit of monorepo. You can find the historical repository at https://github.com/git-merge-workshops/a-bad-monorepo"
```

Once completed, we should now have two different repositories, one with only 1 commit and another replica of the monorepo with the entire history.

![Separated Repository](../images/separated_transparent.png "Main Repository")

Now that we have a new repository, we can add our historical repo as a remote and fetch the history from it:
NOTE: We will be using the local copy of the historical monorepo, but in a real world collaborative setting, you would most likely fetch a remote repostiory hosted by a 3rd party source provider.

```bash
git remote add historical ../a-bad-monorepo-historical
git fetch historical
```

At this point, you should still only have one commit in your repository. We can verify this by running `git log`:

```bash
git --no-pager log --oneline
```

You should however see your remote historical repository listed as a source:
```bash
git remote -v
```

You should also be able to see both the local and fetched HEAD files, and they should be identical.
```bash
git ls-tree --name-only -r HEAD
git ls-tree --name-only -r FETCH_HEAD
```

Finally, we can graft the FETCH_HEAD to the HEAD our monorepo.

![Main Repository](../images/grafted_transparent.png "Main Repository")

This can be achieved with `git replace` by the following command:

```bash
git replace --graft HEAD FETCH_HEAD
```

In our example, the HEAD commit is our first commit in the repository, but going forward, developers will want to replace HEAD with the SHA of the first commit in the new repository. 
```bash
git replace --graft c40e8341e3b3 FETCH_HEAD
```

The repository should look now appear as a single repository with the entire history of the monorepo.

![Final Repository](../images/final_transparent.png "Final Repository")

Running `git log` should now correctly output the latest commit along with the entire history of the monorepo. You should also be able to see the exact commit where the repositories were grafted together.

```bash
git --no-pager log --oneline
```

<details><summary>Output</summary>

```bash
b0aff3 (HEAD -> master) Empty commit
29a2dd0 (replaced) Initial commit of monorepo. You can find the historical repository at https://github.com/git-merge-workshops/a-bad-monorepo
13e0565 (historical/main) Removed binaries. Gone forever!!
dbd4363 Update README.md
2e06d2e Add logging functions.
af6e62f Added new greetings db backup.
5088f67 Added backup load for greetings db.
da18c9b Added database load from SQL backup.
892d146 Add database backup.
175de6c Added database module to fetch greeting.
6c81b90 Added initial application entrypoint.
12f9bdd Initial commit
```
We can also verify that commits are still being correctly added to the new repository, and not the historical one:
```bash
git commit --allow-empty -m "Empty commit"
git log --oneline | head -n 10
```
</details>

## Conclusion
As metioned, repository grafting with `git replace` is a useful technique for preserving the history of a monorepo while still being able to maintain future development. Most often, source control providers will provide a way to archive or set the state of the repo as read-only. Grafting allows users to seemlessly integrate the archived history into a new repository. And with that, we've successfully grafted our repositories together, and concluded the final lesson! 🎉 🎉

:arrow_backward: [Back to Main](../README.md)
