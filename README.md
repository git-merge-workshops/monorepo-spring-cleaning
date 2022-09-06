<h1 align="center">Monorepo Spring Cleaning</h1>
<h5 align="center">@pmartindev</h3>

<p align="center">
  <a href="#mega-prerequisites">Prerequisites</a> •  
  <a href="#books-resources">Resources</a>
</p>

> This workshop is a hands-on session to help you clean up your monorepo. We will be using popular open source tools to discover and clean up your monorepo.


## :mega: Prerequisites
There are 3 options for running this workshop:
### 1. Codespaces
Within this repository, click on the `Code` button and select `Open with Codespaces`. This will open a new Codespace with all the tools you need to run this workshop.

### 2. Local w/ Docker
If you have Docker installed, you can run the workshop locally. Run the following commands to start the workshop:
```bash
cd .devcontainer
docker build . -t monorepo-workshop
docker run -it -p 3000:3000 monorepo-workshop
```

### 3. Local
If you don't have Docker installed, you can run the workshop locally, you will need to install the following tools:
### Tools
- Git 2.34 or newer
  - [Linux](https://git-scm.com/download/linux)
  - [MacOS](https://git-scm.com/download/mac)
  - [Windows](https://git-scm.com/download/win)
- git filter-repo
- git-sizer 

### Steps
- Clone torvalds/linux
```bash
git clone https://github.com/torvalds/linux
```
- 

Activity 1: Analyse 


## :books: Resources
- [The Monorepo Book](https://monorepo-book.github.io/)
- [Resource 2]()