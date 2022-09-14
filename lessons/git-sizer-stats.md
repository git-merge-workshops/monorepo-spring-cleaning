### Gathering overall stats with `git-sizer`
For the first activity, we will be using git-sizer to analyse the state of your monorepo. git-sizer is a tool that will help you understand the size of your repository and identify large files and commits.

Before we begin, let's take a look at the contents of our current monorepo.

```bash
cd /source/a-bad-monorepo
ls -l -h
```

<details><summary>Output</summary>

```bash
total 16K    
-rw-r--r--    1 root     root          99 Sep 13 15:56 README.md
-rw-r--r--    1 root     root         237 Sep 13 15:56 hello_world.py
-rw-r--r--    1 root     root         690 Sep 13 15:56 hello_world_db.py
-rw-r--r--    1 root     root         187 Sep 13 15:56 hello_world_helpers.py
```
</details>

```bash
git ls-tree --name-only -r HEAD
```

<details><summary>Ouput</summary>

```bash
README.md
hello_world.py
hello_world_db.py
hello_world_helpers.py
```
</details>

There doesn't appear to be anything unusual here. We have a handful of python files and a README all of a reasonable size. 

From the surface, things seem good, but now lets see if `git-sizer` can tell us give us a better idea of the history of our repository. Run the following command in the monorepo directory:

```bash
git sizer --verbose
```

You should see an output similar to the following:
<details><summary>Output</summary>

```bash
| Name                         | Value     | Level of concern               |
| ---------------------------- | --------- | ------------------------------ |
| Overall repository size      |           |                                |
| * Commits                    |           |                                |
|   * Count                    |    10     |                                |
|   * Total size               |  3.33 KiB |                                |
| * Trees                      |           |                                |
|   * Count                    |    13     |                                |
|   * Total size               |  1.53 KiB |                                |
|   * Total tree entries       |    39     |                                |
| * Blobs                      |           |                                |
|   * Count                    |    11     |                                |
|   * Total size               |   150 MiB |                                |
| * Annotated tags             |           |                                |
|   * Count                    |     0     |                                |
| * References                 |           |                                |
|   * Count                    |     3     |                                |
|     * Branches               |     1     |                                |
|     * Remote-tracking refs   |     2     |                                |
|                              |           |                                |
| Biggest objects              |           |                                |
| * Commits                    |           |                                |
|   * Maximum size         [1] |   702 B   |                                |
|   * Maximum parents      [2] |     1     |                                |
| * Trees                      |           |                                |
|   * Maximum entries      [3] |     5     |                                |
| * Blobs                      |           |                                |
|   * Maximum size         [4] |  50.0 MiB | *****                          |
|                              |           |                                |
| History structure            |           |                                |
| * Maximum history depth      |    10     |                                |
| * Maximum tag depth          |     0     |                                |
|                              |           |                                |
| Biggest checkouts            |           |                                |
| * Number of directories  [3] |     2     |                                |
| * Maximum path depth     [3] |     2     |                                |
| * Maximum path length    [5] |    22 B   |                                |
| * Number of files        [3] |     5     |                                |
| * Total size of files    [3] |  50.0 MiB |                                |
| * Number of symlinks         |     0     |                                |
| * Number of submodules       |     0     |                                |

[1]  dbd4363b4b714b13bdb054aac8dc0da5f565867f
[2]  13e0565ffb0160eb66003aa12e83de1ce1b95a7d (refs/heads/main)
[3]  5fdbcd4cff31fee89e070827c264f97b736b277f (dbd4363b4b714b13bdb054aac8dc0da5f565867f^{tree})
[4]  43f93d994fd67db15869fa8995ef59ff720f26e3 (dbd4363b4b714b13bdb054aac8dc0da5f565867f:data/backup_1.bak)
[5]  f2ccbd6818580e28919957bb97e5360a05c00ea9 (refs/heads/main^{tree})
```

</details>

What simple information from this table can we gather immediately from this table?

```bash
| Overall repository size      |           |                                |
| * Commits                    |           |                                |
|   * Count                    |    10     |                                |
|   * Total size               |  3.33 KiB |                                |
```
Commit count is synonymous with  `git log --oneline | wc -l`. 
This is the overall number of commits in a repo. Total size is the total size of all the commits in the repo. This does not include blob or tree sizes, which are calculated in a different section.

```bash
| Biggest objects              |           |                                |
| * Commits                    |           |                                |
|   * Maximum size         [1] |   702 B   |                                |
|   * Maximum parents      [2] |     1     |                                |
| * Trees                      |           |                                |
|   * Maximum entries      [3] |     5     |                                |
| * Blobs                      |           |                                |
|   * Maximum size         [4] |  50.0 MiB | *****                          |
```
The maximum blob size indicates the largest single file that exists in any single commit in a repository's history.

```bash
| Biggest checkouts            |           |                                |
| * Number of directories  [3] |     2     |                                |
| * Maximum path depth     [3] |     2     |                                |
| * Maximum path length    [5] |    22 B   |                                |
| * Number of files        [3] |     5     |                                |
| * Total size of files    [3] |  50.0 MiB |                                |
| * Number of symlinks         |     0     |                                |
| * Number of submodules       |     0     |                                |
```

Biggest checkouts tells us in a single checkout at any points in the repository's history, what are the largest/maximum sizes of files, directories, etc. In our case, a checkout of the main branch at HEAD does not contain 50.0MiB, but at some point in the repo's history, we can see that it is much larger...

In addition to the table, git-sizer also displays the git object SHAs, the commit SHAs, and paths of any relevant git objects.

```bash
[1]  dbd4363b4b714b13bdb054aac8dc0da5f565867f
[2]  13e0565ffb0160eb66003aa12e83de1ce1b95a7d (refs/heads/main)
[3]  5fdbcd4cff31fee89e070827c264f97b736b277f (dbd4363b4b714b13bdb054aac8dc0da5f565867f^{tree})
[4]  43f93d994fd67db15869fa8995ef59ff720f26e3 (dbd4363b4b714b13bdb054aac8dc0da5f565867f:data/backup_1.bak)
[5]  f2ccbd6818580e28919957bb97e5360a05c00ea9 (refs/heads/main^{tree})
```

These SHAs or paths can be used to investigate problem git objects in a repository. 
For example, `git cat-file` can be used to view the contents of the largest blob in the repository.
In this case, we can view the contents of the largest blob given the object SHA. 

```bash
git cat-file -p 43f93d994fd67db15869fa8995ef59ff720f26e3 | head -n 10
```

<details><summary>Output</summary>

```bash
BvP�`�n�+ktVTM��T˸
    F���
       ¢�z���Z��        �����H8�Z(��Qm7�Ki~�N&�Rb�G��s-40#i,}�_�ړ�'M�h׉|0�CE��e���V:�ͷ��
\
>�p?-�p"Ic���fX~����h��ھ
                        ~M�/'�R�^�i�z@Po����B�P׶�Q�ّ&(¡#����`eA�9��U���%;
Pޚ�w
    ��W[c�}���K��#��e��9��s�
                            �sHRӯD�љK&�'1أLw���_
v�'ïS��j��K<_˸�����x�&>�G/ڬ_��ѥz҃�;����3�jP����?��d��r�vtם���p'|��s�1U���Ďg����t�����p2�����6��uq��C�����U &!O5i��ɵ�'��70�$�r0&A&=~����.?z�r���Bx]Ei��T��"���V�l�_�ٽx��.Km�wE��F}GV3_f�n�����d�����+�kAV
���W�r����ǈhQ瓟8ʹ�쪗KI�����&���{���Q�[��W���疧��.uY��YPT�{�^Ȇ�iƚ�������"�)$m��ګ6�W���y��8]      �+D��LJz�Ne�g;������q�W;a���ž���O�������mN�gZM�:�:�8{�3�SOd~�_)~c       ��x���~�>,  3�
ͭ�q�L_�}�L�ܢ��>� ,c��
h��b�D�:��J�1Z��     �$�t��儺I��KrS)%�#�(=��#�g6��=����u@���Y�����7���
���:��7�`�{C���*V7=!fI� S%�=�����
                                 �}Jl�zeBNg��.�x��Fd��A.H���5   �O�R����0�1�����[X�c�
s����y�&� �  �q�V����^%TQk/1��G=ɿ�A����S֎�z2sja�C�)X�                                ю����e7*_���g�R�(�`!�=,x��A�4�Y̪C<zo�������E�A�&#
^�*���u��^d�� ����r�yr��[��%
/��S*�(�^��D �M�C
76t35_�)�X
*v��*ƈ�;٢�ʥ�1�Q�:�᭵���bq�qa�zG�Y�*�J�'D�G�y+u�(��Uf��@i.�Uv5{�<�Q�bDz����4�KJųh*F����;���`o��ް1����5��d
```

</details>

From the output, we can clearly tell that the object is a binary file... Let's use the commit SHA and `git ls-tree` to see what repository contains:

```bash
git ls-tree --name-only -r dbd4363b4b714b13bdb054aac8dc0da5f565867f
```

<details><summary>Output</summary>

```bash
README.md
data/backup_1.bak
hello_world.py
hello_world_db.py
hello_world_helpers.py
```
</details>

As expected, we can see that at this point in the history, the repository contained `data/backup_1.bak` which was later deleted, but remains in the history of the repo.

## Conclusion
Git sizer is a fast and simple method to get a quick overview of the size and health of a git repository. It can be used to help identify large files, directories, and commits in the history of a repository.

:arrow_backward: [Back to Main](../README.md)
