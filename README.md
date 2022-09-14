<h1 align="center">Monorepo Spring Cleaning</h1>
<h5 align="center">@pmartindev</h3>

<p align="center">
  <a href="#mega-prerequisites">Prerequisites</a> •  
  <a href="#books-resources">Resources</a>
</p>

> This workshop is a hands-on session to help you clean up your monorepo. We will be using popular open source tools to discover and aid in the removal of large binaries. We will also learn methods of decreaqsing the size of our repository, but still preserving git history by using git replace to graft two repositories together.

## :mega: Prerequisites
There are 2 options for running this workshop:

### 1. Codespaces
Within this repository, click on the `Code` button and select [`Open with Codespaces`](https://github.com/codespaces/new?repo=git-merge-workshops/monorepo-spring-cleaning). Select all of the default options. This will open a new Codespace with all the tools you need to run this workshop.

### 2. Local w/ BYOM (Bring Your Own Monorepo)
If you don't have Docker installed, you can run the workshop locally, you will need to install the following tools:

### Tools
- Git 2.34 or newer
  - [Linux](https://git-scm.com/download/linux)
  - [MacOS](https://git-scm.com/download/mac)
  - [Windows](https://git-scm.com/download/win)
- git filter-repo
- git-sizer 

# If you also do not have a monorepo of your own, you may also clone from the example repo that is used within codespaces:
- Clone git-merge-workshops/a-bad-monorepo
```bash
https://github.com/git-merge-workshops/a-bad-monorepo.git
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

### :star: Conclusion 
Thank you for taking the time to walkthrough this workshop on cleaning up a monorepo!:tada: I hope you learned something new and are able to apply some of these techniques in your own monorepo analysis. Please check out the other presentations on Monorepos at Git Merge 2022.

## :books: Resources
- [The Monorepo Book](https://monorepo-book.github.io/)
- [Measuring the Many Sizes of a Git Repository](https://github.blog/2018-03-05-measuring-the-many-sizes-of-a-git-repository/)
- [git-replace](https://git-scm.com/docs/git-replace)