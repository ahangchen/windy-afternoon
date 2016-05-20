# PyCharm 笔记
## Exclude Directory
当我们的工程中有文件很多的目录，比如test folder, output folder, data folder，这时IDE启动或者运行时，由于会检查这些文件，所以会特别慢，因此有了将这些目录排除在工程之外的需求，实现方法如下：
- 在工程里右击那个目录，Mark this Directory as - Excluded
- 如果这个目录在工作目录下，还是会被index，需要File - setting - editor- file types - ignore files and folders - 添加要排除的目录名