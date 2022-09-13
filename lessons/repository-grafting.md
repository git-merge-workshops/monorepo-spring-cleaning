### Grafting a repository
When rewriting the history of our repostiory is not an option, we can use `git replace` to graft two repositories together. This will allow us to keep an archived history of our repository while still being able to maintain future development. We start this process with a fresh clone of our repository.

![Main Repository](../images/main_transparent.png "Main Repository")

Our first step is to copy our monorepo into a new directory. We will use one as the historical repository and the other as the future repository.

```bash
cp -r a-bad-monorepo  a-bad-monorepo-historical
```

Next, we will take our future development repository (linux) and create it as a new repository, with the base commit as the HEAD of the historical repository. The easiest and simplest method of doing this is to delete our `.git` directory, and re-initialize it as a new git repo. We can do this by running the following commands:

```bash
rm -rf .git
git init
```

Next, we need to add and commit all of the new files to our repository. Remember, this is the new starting for all future development, so it is a good idea to leave behind a trace of the historical repository. We can do this by adding a commit message that references the historical repository. 

```bash
git add --all
git commit -m "Initial commit of linux repository. You can find the historical repository at https://github.com/torvalds/linux"
```

Once completed, we should now have two different repositories, one with only 1 commit and another replica of the monorepo with the entire history.

![Separated Repository](../images/separated_transparent.png "Main Repository")

Now that we have a new repository, we can add our historical repo as a remote and fetch the history from it:
NOTE: We will be using the local copy of the historical monorepo, but in a real world collaborative setting, you would most likely fetch a remote repostiory hosted by a 3rd party source provider.

```bash
git remote add historical ../linux-historical
git fetch historical
```

At this point, you should still only have one commit in your repository. We can verify this by running `git log`:

```bash
git log --oneline
```

You should however see your remote repository listed as a source:
```bash
git remote -v
```

You should also be able to see both the local and fetched HEAD and they should be the same.
```bash
git rev-parse --short HEAD
git rev-parse --short FETCH_HEAD
```

Finally, we can graft the FETCH_HEAD to the HEAD our monorepo.

![Main Repository](../images/grafted_transparent.png "Main Repository")

This can be achieved with `git replace` by the following command:

```bash
git replace --graft HEAD FETCH_HEAD
```

For our example, the HEAD commit is our first commit in the repository, but going forward, developers will want to replace HEAD with the SHA of the first commit in the new repository. 
```bash
git replace --graft c40e8341e3b3 FETCH_HEAD
```

The repository should look now appear as a single repository with the entire history of the monorepo.

![Final Repository](../images/final_transparent.png "Final Repository")

Running `git log` should now correctly output the lasted commit along with the entire history of the monorepo.

```bash
git log --oneline | head -n 10
```

We can also verify that commits are still being correctly added to the new repository, and not the historical one:
```bash
git commit --allow-empty -m "Empty commit"
git log --oneline | head -n 10
```

And with that, we've successfully grafted our repositories together! :tada: :tada:

:arrow_backward: [Back to Main](../README.md)
