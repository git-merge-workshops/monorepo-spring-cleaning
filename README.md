<h1 align="center">Monorepo Spring Cleaning</h1>
<h5 align="center">@pmartindev</h3>

<p align="center">
  <a href="#mega-prerequisites">Prerequisites</a> •  
  <a href="#books-resources">Resources</a>
</p>

> This workshop is a hands-on session to help you clean up your monorepo. We will be using popular open source tools to discover and aid in the removal of large binaries. We will also learn methods of decreaqsing the size of our repository, but still preserving git history by using git replace to graft two repositories together.

## :mega: Prerequisites
To run the workshop locally, you will need to install the following:

### Tools
- Git 2.34 or newer
  - [Linux](https://git-scm.com/download/linux)
  - [MacOS](https://git-scm.com/download/mac)
  - [Windows](https://git-scm.com/download/win)
- [git filter-repo](https://github.com/newren/git-filter-repo)
  - Requires python3 >= 3.5
  - `pip3 install git-filter-repo`
- [git-sizer](https://github.com/github/git-sizer)
  - Download and extract a .zip for the appropriate platform

If you do not have a local fresh clone of a monorepo of your own to experiment with, you may also clone from the example repo that is used throughout the examples in the workshop:
- Clone git-merge-workshops/a-bad-monorepo
```bash
git clone https://github.com/git-merge-workshops/a-bad-monorepo.git
```

You will then want to make numerous copies of the repository as we experiment with different methods of cleaning up the repository. 

```bash
cp -r a-bad-monorepo a-bad-monorepo-filter-repo
cp -r a-bad-monorepo a-bad-monorepo-graft
```

## :mag: Activity 1: Analyse 

### Gathering overall stats with `git-sizer`
[Git Sizer Stats](lessons/git-sizer-stats.md)

### Gathering blob sizing with git filter-repo
[Git Filter-repo Stats](lessons/git-filter-repo-stats.md)

## :broom: Activity 2: Clean up
### Rewriting History with git filter-repo
[History Rewrite](lessons/history-rewrite.md)

## :chains: Activity 3: Grafting 
### Git replace
[Git Replace](lessons/git-replace.md)

### Grafting a repository
[Repository Grafting](lessons/repository-grafting.md)

### :star: Final Conclusion 
Thank you for taking the time to walkthrough this workshop on cleaning your monorepo!:tada: I hope you learned something new and are able to apply some of these techniques in your own monorepo analysis. Please check out the other presentations on Monorepos at Git Merge 2022.

## :books: Resources
- [The Monorepo Book](https://monorepo-book.github.io/)
- [Measuring the Many Sizes of a Git Repository](https://github.blog/2018-03-05-measuring-the-many-sizes-of-a-git-repository/)
- [git-replace](https://git-scm.com/docs/git-replace)
