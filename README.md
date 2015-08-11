##thumbscrew
A git clean filter to help work with Keynote files in git.

*"Works"* by adding thumbnails to a per-presentation directory so that diffs in the Keynote binary are *visible* in some way (*i.e. as diffs of the thumbnails*).

**TODO:**
* [ ] Installer would be nice
* [ ] `git thumbscrew` command option *a la* [git-lfs](https://github.com/github/git-lfs)
* [ ] single commit?
* [ ] License
* [ ] CONTRIBUTING.md

### Installation

* In your `.git/config` file add the following:

```
[filter "thumbscrew"]
  clean = thumbscrew-clean %f
```

* Make sure that the `thumbscrew-clean` script is available in `PATH`

### How to use

Add your file to the `.gitattributes` add the file you want tracked like in the following example:

```
*.key    filter=thumbscrew
Example  filter=thumbscrew
```

Use `git add` and `git commit` the way you would regularly do this.

## NOTE
If using `git-lfs` please make sure that the above filters come **BEFORE** the git-lfs filters in `.gitattributes`.
