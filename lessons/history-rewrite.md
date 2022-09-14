### Rewriting History with git filter-repo
Now that we have gathered information on our large files, lets see how we can rewrite history to remove them. We will be using the `git filter-repo` tool for this.

In our example, we used `git-sizer` and `git filter-repo` to determine that our repository contained a database backup file that was accidentally commited... For this exercise, let's clean up our repo andremove all instances of the `data/backup_1.bak` file from the repository history. `git filter-repo` allows us to pass in a single path, or a list of paths to all instances of the file from the repository history. 

To start, let's navigate to a fresh copy of our repository and run the following command:

```bash
cd /source/a-bad-monorepo-filter-repo
git filter-repo --path data/backup_1.bak --invert-paths
```
NOTE: Verify that the `--invert-paths` flag is included in your command, otherwise, you will instead remove all instances of all files **except** the `data/backup_1.bak` file.

Your output should resemble something similar to:
```bash
Parsed 10 commits
New history written in 0.05 seconds; now repacking/cleaning...
Repacking your repo and cleaning out old unneeded objects
HEAD is now at 44d80e9 Update README.md
Enumerating objects: 20, done.
Counting objects: 100% (20/20), done.
Delta compression using up to 2 threads
Compressing objects: 100% (15/15), done.
Writing objects: 100% (20/20), done.
Total 20 (delta 4), reused 10 (delta 3), pack-reused 0
Completely finished after 0.13 seconds.
```

This will remove all instances of the file from the repository history. We can verify this by running the same command from early to output the first commit the file was introduced in:

```bash
git --no-pager log --follow  --diff-filter=A -- data/backup_1.bak
```
Which should produce no output....

We can also run `git log --oneline | wc -l` to get the repository count:
```bash
git log --oneline | wc -l
```
<details><summary>Output</summary>

```bash
6
```
</details>

And we should notice that our number of commits has been reduced as well from 10 to 6. Any commits where the file was the sole object being added/modified were removed from the history.

Finally, let's take a look at our `git-sizer` output again to see if anything has changed:
```bash
git-sizer --verbose
```
<details><summary>Output</summary>

```bash
Processing blobs: 8                        
Processing trees: 6                        
Processing commits: 6                        
Matching commits to trees: 6                        
Processing annotated tags: 0                        
Processing references: 7                        
| Name                         | Value     | Level of concern               |
| ---------------------------- | --------- | ------------------------------ |
| Overall repository size      |           |                                |
| * Commits                    |           |                                |
|   * Count                    |     6     |                                |
|   * Total size               |  1.41 KiB |                                |
| * Trees                      |           |                                |
|   * Count                    |     6     |                                |
|   * Total size               |   712 B   |                                |
|   * Total tree entries       |    17     |                                |
| * Blobs                      |           |                                |
|   * Count                    |     8     |                                |
|   * Total size               |  1.90 KiB |                                |
| * Annotated tags             |           |                                |
|   * Count                    |     0     |                                |
| * References                 |           |                                |
|   * Count                    |     7     |                                |
|     * Branches               |     1     |                                |
|     * Other                  |     6     |                                |
|                              |           |                                |
| Biggest objects              |           |                                |
| * Commits                    |           |                                |
|   * Maximum size         [1] |   265 B   |                                |
|   * Maximum parents      [2] |     1     |                                |
| * Trees                      |           |                                |
|   * Maximum entries      [3] |     4     |                                |
| * Blobs                      |           |                                |
|   * Maximum size         [4] |   690 B   |                                |
|                              |           |                                |
| History structure            |           |                                |
| * Maximum history depth      |     6     |                                |
| * Maximum tag depth          |     0     |                                |
|                              |           |                                |
| Biggest checkouts            |           |                                |
| * Number of directories  [3] |     1     |                                |
| * Maximum path depth     [3] |     1     |                                |
| * Maximum path length    [3] |    22 B   |                                |
| * Number of files        [3] |     4     |                                |
| * Total size of files    [3] |  1.18 KiB |                                |
| * Number of symlinks         |     0     |                                |
| * Number of submodules       |     0     |                                |

[1]  a2ce1524dfa283ead397744df0d793b6e489c885 (refs/replace/175de6c41a58b34716f6b9dec016f23c6053f2eb)
[2]  44d80e944e7a13a301b7b5f0021f8ae5e3707b6c (refs/heads/main)
[3]  f2ccbd6818580e28919957bb97e5360a05c00ea9 (refs/heads/main^{tree})
[4]  d5985754530d1fe3e02d7cb5943a07f1be33b5c9 (refs/heads/main:hello_world_db.py)
```
</details>

From the output, we can see that we no longer have any commits that contain the `data/backup_1.bak` file. We can also see that the maximum blob size has been reduced from 50.0 MiB to 690 B in addition to the total blob size decreasing from 150.0 MiB to 1.90 KiB.

After performing a rewrite, `git filter-repo` will also output a list of rewritten shas. This can be useful for any implementations that specifically reference commits by their sha. 

```
old                                      new
892d146b368d74a64ad8a83af8ecc949ff20a408 0000000000000000000000000000000000000000
12f9bdd865d5f8b19eaaff8c94af10ec1d7f6e27 26b42504e90f3cb96e684be18ffbc3ff42d12383
6c81b906e1c32efacda4c89e2b16bf0d23841f7d 487ad5f18cb89923c9a46e20176152bca2a4ab7b
175de6c41a58b34716f6b9dec016f23c6053f2eb a2ce1524dfa283ead397744df0d793b6e489c885
5088f67fd2541f3d70ce09cc63c1175f3f7aae15 0000000000000000000000000000000000000000
af6e62f64a3e02274aeba8a8db09d0735a8a0140 0000000000000000000000000000000000000000
da18c9bf3059181d157612c0ef187bfb469fa787 7c80e25273092c9f57bfefed12f5d3b5d2f6ed62
2e06d2e1e3876209a91b1dd7dda6299db37f2cf4 9513a474a6d7ed308ce803c7600e57361d9b5207
13e0565ffb0160eb66003aa12e83de1ce1b95a7d 0000000000000000000000000000000000000000
dbd4363b4b714b13bdb054aac8dc0da5f565867f 44d80e944e7a13a301b7b5f0021f8ae5e3707b6c
```

In the case of all 0's being output, this means that the commit was removed from the history.

It important to note that subsequent `git filter-repo` executions will rewrite the history multiple times, and thus the shas and this file will change again. It is important to combine your parameters into a single command so as to only have to execute `git filter-repo` and rewrite the history once.

## Conclusion
In this lesson, we learned how to use `git filter-repo` to remove large files from our repository history. In particular, we learned how to remove all instances of a single large blob from the commit history, and to verify that it has been successfully removed. 

:arrow_backward: [Back to Main](../README.md)