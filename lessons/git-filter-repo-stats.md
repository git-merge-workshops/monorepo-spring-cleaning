### Gathering blob sizing with git filter-repo
For the second activity, we will be using git filter-repo to determine and analyse large blobs in a repository.
While the main purpose of `git filter-repo` is to rewrite history, it can also be used to gather information about blobs in your repository.

Navigate to the monorepo directory and run the following command:
```bash
cd a-bad-monorepo
git filter-repo --analyze
```
`git filter-repo` begin to process all of the objects in the repository. Once ithas finished, within the repository, navigate to `.git/filter-repo/analysis`

```bash
cd .git/filter-repo/analysis
```

You will notice a handful of files, but the one we are interested in for now is the `blobs-shas-and-path.txt` file.
Open the file:
```bash
code blobs-shas-and-path.txt
```

You will notice a list of files, some repeated multiple times.
```bash
=== Files by sha and associated pathnames in reverse size ===
Format: sha, unpacked size, packed size, filename(s) object stored as
  e71dc841d36bfa926e13974b45cdcf3bd2d893cb   52428800   52444806 data/backup_1.bak
  43f93d994fd67db15869fa8995ef59ff720f26e3   52428800   52444806 data/backup_1.bak
  38db2f5d807eba530969165b73f6b57b159e1fd1   52428800   52444806 data/backup_1.bak
  d5985754530d1fe3e02d7cb5943a07f1be33b5c9        690        314 hello_world_db.py
  ba9e4bc0dc047625da3f38a23c035dc5c3a36e9f        237        165 hello_world.py
  d5c0fa6d0681252d6d68613f3128af2672cd0ea4        187        132 hello_world_helpers.py
  7c3148fee37b5a571f47e283416bff165c6f20c4         99         89 README.md
  a0dcf02cf8aae2939c18c94bc4f28d10be49bfb7         49         53 README.md
  09b06a87738d6b111d968006d4336647357ecf10        118         37 hello_world.py
  2fd2ea94a2b879397d6509d5a9c50952515ee941        171         22 hello_world.py
  1f4049640e26bd48cd1b561bce667db620358986        394         20 hello_world_db.py
```
Let's break down what we are seeing here:

- `sha` refers to the SHA of the git object itself. We an use this to do things such as list the contents of the blob with `git cat-file` similar to the `git sizer` excercise. 
- `unpacked size` refers to the decompressed size of the blob in bytes. This is the size of the file as it would be if it were extracted from the git repository. (i.e. upon running `git checkout`)
- `packed size` refers to the compressed size of the blob in bytes. This is the size of the file as it is stored in the git repository.
- `filename(s)` refers to the path of the file within the repository. If the file is located in multiple places, it will be listed as a comma separated list.

With this information, we can now determine the largest blobs in the repository history, and investigate them further. One example may be that we want to find which particular commit a large file was introduced. We can do this by running the following command:

```bash 
git --no-pager log --follow  --diff-filter=A -- data/backup_1.bak
```
<details><summary>Output</summary>

```bash
commit 892d146b368d74a64ad8a83af8ecc949ff20a408
Author: Preston Martin <pmartindev@github.com>
Date:   Fri Jul 29 17:32:54 2022 -0500

    Add database backup.
```
</details>

With this, we can now see that the file was first introduced in commit `892d14` along with the author and date of the commit. We can verify and see all files that were added in this commit by running the following command:

```bash
git diff-tree --no-commit-id --name-only -r 892d146b368d74a64ad8a83af8ecc949ff20a408
```
<details><summary>Output</summary>

```bash
data/backup_1.bak
```
</details>

You will notice that in some cases, a filename is listed multiple times. This indicates that changes to the file have been commited multiple times in the history of the repository. For large files (in particular large, compressed binary files), this can be problematic as large binaries do not tend to compress nor diff well. 

## Conclusion
In this lesson, we learned how to use `git filter-repo` to gather information about blobs in a repository. In particular, we learned how to use `git filter-repo` to find the largest blob in our repository, find the commit that it was introduced, and determine what other files were introduced in the same commit.

:arrow_backward: [Back to Main](../README.md)
