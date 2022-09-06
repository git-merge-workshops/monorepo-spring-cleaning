### Rewriting History with git filter-repo
Now that we have gathered information on our large files, lets see how we can rewrite history to remove them. We will use the `git filter-repo` tool for this.

In our example, let's propose that we want to remove all instances of the file `drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h` from the repository history. `git filter-repo` allows us to pass in a single path, or a list of paths to remove from the repository history. We can do this by running the following command:

```bash
git filter-repo --path drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h
```

Your output should resemble something like this:
```bash
git filter-repo --force --path drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h

warning: Tag points to object of unexpected type tree, skipping.
warning: Tag points to object of unexpected type tree, skipping.
Parsed 1074803 commitswarning: Omitting tag 5dc01c595e6c6ec9ccda4f6f69c131c0dd945f8c,
since tags of trees (or tags of tags of trees, etc.) are not supported.
warning: Omitting tag 5dc01c595e6c6ec9ccda4f6f69c131c0dd945f8c,
since tags of trees (or tags of tags of trees, etc.) are not supported.
Parsed 1075328 commits
New history written in 214.86 seconds; now repacking/cleaning...
Repacking your repo and cleaning out old unneeded objects
warning: unable to unlink 'scripts/dtc/include-prefixes/arc': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/arm': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/arm64': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/dt-bindings': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/h8300': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/microblaze': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/mips': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/nios2': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/openrisc': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/powerpc': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/sh': Operation not permitted
warning: unable to unlink 'scripts/dtc/include-prefixes/xtensa': Operation not permitted
Updating files: 100% (75109/75109), done.
HEAD is now at 9c95ec5b3ea1 drm/amdgpu: clean up some leftovers from bring up
Enumerating objects: 18093, done.
Counting objects: 100% (18093/18093), done.
Delta compression using up to 8 threads
Compressing objects: 100% (16464/16464), done.
Writing objects: 100% (18093/18093), done.
Total 18093 (delta 1485), reused 18015 (delta 1429), pack-reused 0
Completely finished after 226.84 seconds.
```

This will remove all instances of the file from the repository history. We can verify this by running the same command from early to output the first commit the file was introduced in:

```bash
git log --follow --diff-filter=A drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h
```

After performing a`git filter-repo` will also output a list of rewritten shas. This can be useful for any implementations that specifically reference commits by their sha. 

```
old                                      new
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 76c3073a888ae7f4790a146784bb5c34fc24b9d2
8d38eadb7a97f265f7b3a9e8a30df358c3a546c8 2a27805127aee1e7e62854bcf9ca8c355c23b73e
baaa2c512dc1c47e3afeb9d558c5323c9240bd21 db4686812835a497d6f5de1e6cf6e8010a3fc0c7
2d137c24e9f433e37ffd10b3d5f418157589a8d2 2f4cfacecd522849dac254f87273525eeca33d1d
```
