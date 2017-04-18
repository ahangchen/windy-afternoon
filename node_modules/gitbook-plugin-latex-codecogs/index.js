var url = require('url');

module.exports =  {
    book: {
        assets: "./static",
        js: [],
        css: [
            "latex-codecogs.css"
        ]
    },
    ebook: {
        assets: "./static",
        css: [
            "latex-codecogs.css"
        ]
    },
    blocks: {
        math: {
            shortcuts: {
                parsers: ["markdown", "asciidoc", "restructuredtext"],
                start: "$$",
                end: "$$"
            },
            process: function(blk) {
                var tex = blk.body;
                var isInline = !(tex[0] == "\n");

                var config = this.book.config.get('pluginsConfig.latex-codecogs', {});
                var type = config.type || 'gif';

                var imgSrc = url.format({
                    protocol: 'https',
                    host: 'latex.codecogs.com',
                    pathname: '/'+type+'.latex',
                    search: tex
                });

                return '<img src="'+imgSrc+'" class="latex-codecogs mode-'+(isInline? 'inline' : 'block')+'" />';
            }
        }
    }
};
