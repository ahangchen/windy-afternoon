# kit

一些工具的心得

* [vim](note.md)
* [git/github/gitbook](note-1/)
* [markdown](markdown/)
* [Latex](latex/)
* [科学上网](ss.md)
* [虚拟机](vmware.md)
* ffmpeg
  - 图片list转视频：ffmpeg -y -f concat -safe 0 -i "imagepaths.txt" -c:v libx264 -vf "fps=25,format=yuv420p" "out.mp4"
