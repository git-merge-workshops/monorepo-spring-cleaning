<h1 align="center">Monorepo Spring Cleaning</h1>
<h5 align="center">@pmartindev</h3>

<p align="center">
  <a href="#mega-prerequisites">Prerequisites</a> •  
  <a href="#books-resources">Resources</a>
</p>

> This workshop is a hands-on session to help you clean up your monorepo. We will be using popular open source tools to discover and clean up your monorepo.


## :mega: Prerequisites
There are 2 options for running this workshop:

### 1. Codespaces w/ linux monorepo
Within this repository, click on the `Code` button and select `Open with Codespaces`. This will open a new Codespace with all the tools you need to run this workshop.

### 3. Local w/ BYOM (Bring Your Own Monorepo)
If you don't have Docker installed, you can run the workshop locally, you will need to install the following tools:
### Tools
- Git 2.34 or newer
  - [Linux](https://git-scm.com/download/linux)
  - [MacOS](https://git-scm.com/download/mac)
  - [Windows](https://git-scm.com/download/win)
- git filter-repo
- git-sizer 

# If you also do not have a monorepo of your own, you may also clone the linux monorepo
# NOTE: This will take a while to download...
- Clone torvalds/linux
```bash
git clone https://github.com/torvalds/linux
```

## :mag: Activity 1: Analyse 

### Gathering overall stats with `git-sizer`
For the first activity, we will be using git-sizer to analyse the state of your monorepo. git-sizer is a tool that will help you understand the size of your repository and identify large files and commits.

Navaigate to the monorepo directory and run the following command:
```bash
git sizer
```

<details><summary>You should see an output similar to the following:</summary>

```bash
Processing blobs: 2378805                        
Processing trees: 5145540                        
Processing commits: 1075328                        
Matching commits to trees: 1075328                        
Processing annotated tags: 735                        
Processing references: 740                        
| Name                         | Value     | Level of concern               |
| ---------------------------- | --------- | ------------------------------ |
| Overall repository size      |           |                                |
| * Commits                    |           |                                |
|   * Count                    |  1.08 M   | **                             |
|   * Total size               |   858 MiB | ***                            |
| * Trees                      |           |                                |
|   * Count                    |  5.15 M   | ***                            |
|   * Total size               |  14.5 GiB | *******                        |
|   * Total tree entries       |   421 M   | ********                       |
| * Blobs                      |           |                                |
|   * Count                    |  2.38 M   | *                              |
|   * Total size               |  87.6 GiB | *********                      |
|                              |           |                                |
| Biggest objects              |           |                                |
| * Commits                    |           |                                |
|   * Maximum size         [1] |  72.7 KiB | *                              |
|   * Maximum parents      [2] |    66     | ******                         |
| * Trees                      |           |                                |
|   * Maximum entries      [3] |  2.42 k   | **                             |
| * Blobs                      |           |                                |
|   * Maximum size         [4] |  15.7 MiB | *                              |
|                              |           |                                |
| Biggest checkouts            |           |                                |
| * Number of directories  [5] |  4.92 k   | **                             |
| * Maximum path depth     [6] |    13     | *                              |
| * Maximum path length    [7] |   134 B   | *                              |
| * Number of files        [5] |  75.1 k   | *                              |
| * Total size of files    [5] |  1.03 GiB | *                              |

[1]  91cc53b0c78596a73fa708cceb7313e7168bb146
[2]  2cde51fbd0f310c8a2c5f977e665c0ac3945b46d
[3]  1ccbef33c394ffba7c18b44c8e78b24a08fd6c33 (refs/heads/master:arch/arm/boot/dts)
[4]  e27fdc0c643c689883b111dc271f8cdadac72d57 (25875aa71dfefd1959f07e626c4d285b88b27ac2:drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h)
[5]  d56d5609e4b290baa9b46a48b123ab9c4f23f073 (refs/heads/master^{tree})
[6]  78a269635e76ed927e17d7883f2d90313570fdbc (dae09011115133666e47c35673c0564b0a702db7^{tree})
[7]  b0da5ce619daec8138cf92dfcf00e7a51ce856a9 (d8763340d2cb6262fb86424315a1f92cabc0e23c^{tree}
```

</details>

What simple information from this table can we gather immediately from this table?

1. 
```bash
| Overall repository size      |           |                                |
| * Commits                    |           |                                |
|   * Count                    |  1.08 M   | **                             |
|   * Total size               |   858 MiB | ***                            |
```
Commit count is synonymous with  ```bash git log --oneline | wc -l```. 
This is the overall number of commits in a repo. Total size is the uncompressed size of all the commits in the repo.
The overall repository size in general is a good indicator of how expensive certain traversal operations 
(such as fetch and clone) will perform on the repository. 

2. 
```bash
| Biggest objects              |           |                                |
| * Commits                    |           |                                |
|   * Maximum size         [1] |  72.7 KiB | *                              |
|   * Maximum parents      [2] |    66     | ******                         |
| * Trees                      |           |                                |
|   * Maximum entries      [3] |  2.42 k   | **                             |
| * Blobs                      |           |                                |
|   * Maximum size         [4] |  15.7 MiB | *                              |
```
The maximum blob size indicates the largest single file that exists in any single commit in a repository's history.
We can determine that 

3. 
```bash
| Biggest checkouts            |           |                                |
| * Number of directories  [5] |  4.92 k   | **                             |
| * Maximum path depth     [6] |    13     | *                              |
| * Maximum path length    [7] |   134 B   | *                              |
| * Number of files        [5] |  75.1 k   | *                              |
| * Total size of files    [5] |  1.03 GiB | *                              |
```

In addition to the table, git-sizer also displays the SHAs and commit paths of the largest git objects.

```bash
[1]  91cc53b0c78596a73fa708cceb7313e7168bb146
[2]  2cde51fbd0f310c8a2c5f977e665c0ac3945b46d
[3]  1ccbef33c394ffba7c18b44c8e78b24a08fd6c33 (refs/heads/master:arch/arm/boot/dts)
[4]  e27fdc0c643c689883b111dc271f8cdadac72d57 (25875aa71dfefd1959f07e626c4d285b88b27ac2:drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h)
[5]  d56d5609e4b290baa9b46a48b123ab9c4f23f073 (refs/heads/master^{tree})
[6]  78a269635e76ed927e17d7883f2d90313570fdbc (dae09011115133666e47c35673c0564b0a702db7^{tree})
[7]  b0da5ce619daec8138cf92dfcf00e7a51ce856a9 (d8763340d2cb6262fb86424315a1f92cabc0e23c^{tree})
```

These SHAs or paths can be used to investigate problem files in a repository. 
For example, `git cat-file` can be used to view the contents of the largest blob in the repository.
In this case, we can view the contents of a header file. 
```bash
git cat-file -p 25875aa71dfefd1959f07e626c4d285b88b27ac2:drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h | head -50
```
```C++
/*
 * Copyright (C) 2020  Advanced Micro Devices, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
#ifndef _nbio_7_2_0_SH_MASK_HEADER
#define _nbio_7_2_0_SH_MASK_HEADER


// addressBlock: nbio_nbif0_bif_cfg_dev0_rc_bifcfgdecp
//BIF_CFG_DEV0_RC_VENDOR_ID
#define BIF_CFG_DEV0_RC_VENDOR_ID__VENDOR_ID__SHIFT                                                           0x0
#define BIF_CFG_DEV0_RC_VENDOR_ID__VENDOR_ID_MASK                                                             0xFFFFL
//BIF_CFG_DEV0_RC_DEVICE_ID
#define BIF_CFG_DEV0_RC_DEVICE_ID__DEVICE_ID__SHIFT                                                           0x0
#define BIF_CFG_DEV0_RC_DEVICE_ID__DEVICE_ID_MASK                                                             0xFFFFL
//BIF_CFG_DEV0_RC_COMMAND
#define BIF_CFG_DEV0_RC_COMMAND__IOEN_DN__SHIFT                                                               0x0
#define BIF_CFG_DEV0_RC_COMMAND__MEMEN_DN__SHIFT                                                              0x1
#define BIF_CFG_DEV0_RC_COMMAND__BUS_MASTER_EN__SHIFT                                                         0x2
#define BIF_CFG_DEV0_RC_COMMAND__SPECIAL_CYCLE_EN__SHIFT                                                      0x3
#define BIF_CFG_DEV0_RC_COMMAND__MEM_WRITE_INVALIDATE_EN__SHIFT                                               0x4
#define BIF_CFG_DEV0_RC_COMMAND__PAL_SNOOP_EN__SHIFT                                                          0x5
#define BIF_CFG_DEV0_RC_COMMAND__PARITY_ERROR_RESPONSE__SHIFT                                                 0x6
#define BIF_CFG_DEV0_RC_COMMAND__AD_STEPPING__SHIFT                                                           0x7
#define BIF_CFG_DEV0_RC_COMMAND__SERR_EN__SHIFT                                                               0x8
#define BIF_CFG_DEV0_RC_COMMAND__FAST_B2B_EN__SHIFT                                                           0x9
#define BIF_CFG_DEV0_RC_COMMAND__INT_DIS__SHIFT                                                               0xa
#define BIF_CFG_DEV0_RC_COMMAND__IOEN_DN_MASK                                                                 0x0001L
#define BIF_CFG_DEV0_RC_COMMAND__MEMEN_DN_MASK                                                                0x0002L
#define BIF_CFG_DEV0_RC_COMMAND__BUS_MASTER_EN_MASK                                                           0x0004L
#define BIF_CFG_DEV0_RC_COMMAND__SPECIAL_CYCLE_EN_MASK                                                        0x0008L
#define BIF_CFG_DEV0_RC_COMMAND__MEM_WRITE_INVALIDATE_EN_MASK                                                 0x0010L
#define BIF_CFG_DEV0_RC_COMMAND__PAL_SNOOP_EN_MASK                                                            0x0020L
```

### Gathering blob sizing with git filter-repo
For the second activity, we will be using git filter-repo to determine and analyse large blobs in a repository.
While the main purpose of `git filter-repo` is to rewrite history, it can also be used to gather information about blobs in your repository.

### Note: this command may take a while to run... for simplicity, please consider using 
Navaigate to the monorepo directory and run the following command:
```bash
git filter-repo --analyze
```
Within the repository, navigate to the `.git/filter-repo/analysis`

```bash
cd .git/filter-repo/analysis
```

You will notice a handful of files, but the one we are interested in for now is the `blobs-shas-and-path.txt` file.
Open the file
```bash
code blobs-shas-and-path.txt
```

You will notice a large list of files
```bash
=== Files by sha and associated pathnames in reverse size ===
Format: sha, unpacked size, packed size, filename(s) object stored as
  e27fdc0c643c689883b111dc271f8cdadac72d57   16415223    1209962 drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h
  54b0e4623971993d933472b104485a0219b2e19e   16414003    1185013 drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h
  198c14a3b3d3795bd6cf5237cf179b512aed6114   12839488     986979 drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_2_3_sh_mask.h
  a02b6794337286bc12c907c33d5d75537c240bd0   14151474     925100 [drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_6_1_sh_mask.h, drivers/gpu/drm/amd/include/asic_reg/vega10/NBIO/nbio_6_1_sh_mask.h]
  068f3b16a56b41cc8fc2b6b2aad0750935219382   11368060     795948 drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_4_2_0_sh_mask.h
  ee8c15e4543d7922cb11341e03d3c9da7b091285   12748346     769404 drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_0_sh_mask.h
  88602479a1aa97480e65e976fff8211bb39353b4   12745358     769105 [drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_0_sh_mask.h, drivers/gpu/drm/amd/include/asic_reg/raven1/NBIO/nbio_7_0_sh_mask.h]
  d8ad862b3a748dd82780ab7295e989d60892dfa3    6812925     484277 drivers/gpu/drm/amd/include/asic_reg/vega10/DC/dce_12_0_sh_mask.h
  1f22c9ab66d407accb797e532ab194b043970a85    1112908     464689 drivers/net/bnx2x_init_values.h
  396c33fafc9140b47cb0a56eb0746024891f0b05    6642978     452649 drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_3_0_2_sh_mask.h
  63019055e4bb56962ba5767f662136a787921c4f    1000677     413803 drivers/net/bnx2x_init_values.h
```
Let's break down what we are seeing here:

- `sha` refers to the SHA of the git object itself. We an use this to do things such as list the contents of the blob, 
- `unpacked size` refers to the decompressed size of the blob in bytes. This is the size of the file as it would be if it were extracted from the git repository. (i.e. upon running `git checkout`)
- `packed size` refers to the compressed size of the blob in bytes. This is the size of the file as it is stored in the git repository.
- `filename(s)` refers to the path of the file within the repository. If the file is located in multiple places, it will be listed as a comma separated list.

With this information, we can now determine the largest blobs in the repository history, and investigate them further. One example may be that we want to find which particular commit a large file was introduced. We can do this by running the following command:

```bash 
git log --follow --diff-filter=A drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_2_0_sh_mask.h
commit c4dc7b1a54a043d08172f2d3de02578667a7595c
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Thu May 4 13:06:58 2017 -0400

    drm/amdgpu: add register headers for NBIO 7.0
    
    Add registers for NBIO 7.0
    
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
```
And we can verify and see all files that were added in this commit by running the following command:

```bash
git diff-tree --no-commit-id --name-only -r c4dc7b1a54a043d08172f2d3de02578667a7595c
drivers/gpu/drm/amd/include/asic_reg/raven1/NBIO/nbio_7_0_default.h
drivers/gpu/drm/amd/include/asic_reg/raven1/NBIO/nbio_7_0_offset.h
drivers/gpu/drm/amd/include/asic_reg/raven1/NBIO/nbio_7_0_sh_mask.h
```

You will notice that in some cases, a filename is listed multiple times. This indicates that changes to the file have been commited multiple times in the history of the repository. For large files (in particular large, compressed binary files), this can be problematic as large binaries do not tend to compress nor diff well. 



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

### Git replace
Rewriting history can be expensive, time consuming, and is not always the correct solution. An organization may be so heavily invested in their monorepo, that a rewrite is totally unrealistic `git replace` is a useful tool for rewriting history. Given a particular commit SHA, it allows you to replace a commit in history with another commit.

```mermaid
gitGraph;
  checkout main;
  checkout monorepo;
```

- [The Monorepo Book](https://monorepo-book.github.io/)
- [Measuring the Many Sizes of a Git Repository](https://github.blog/2018-03-05-measuring-the-many-sizes-of-a-git-repository/)
- [git-replace](https://git-scm.com/docs/git-replace)