##header div固定，content div填充父容器

- HTML
```html
<div class="parent">
    <div class="header">
        header
    </div>
    <div class="content">
        content
    </div>
</div>
```

- CSS
```css
.header {
    height: 50px;
}
.content {
    margin-top: -50px;
    padding-top: 50px;
    height: 100%;
}
```
通过负的margin-top来实现，好可耻233333

