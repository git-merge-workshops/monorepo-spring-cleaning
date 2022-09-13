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

:arrow_backward: [Back to Main](../README.md)
