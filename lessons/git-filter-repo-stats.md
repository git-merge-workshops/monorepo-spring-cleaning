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

