$(function ($) {
    TagHelper = function () {
        this.$element_;
        this.selection = {start:0,end:0};
        this.actions_ = this.createActions_();
    };
    TagHelper.prototype = {
        /**
         * アクションを定義する
         */
        createActions_() {
            return [{
                id : 'ruby',
                handler : this.onClickRuby_.bind(this),
                caption : 'ルビ'
            }];
        },
        onClickRuby_(e) {
            var val = this.$element_.val();
            var inserted = this.insertRuby_(val,this.selection);
            this.$element_.val(inserted);
            var cursor = TagHelper.RUBY.start.length + this.selection.end + TagHelper.RT.start.length;
            this.$element_[0].focus();
            this.$element_[0].setSelectionRange(cursor,cursor);
        },
        insertRuby_(val,selection) {
            return val.slice(0,selection.start) 
            + TagHelper.RUBY.start + val.slice(selection.start,selection.end)
            + TagHelper.RT.start + TagHelper.RT.end + TagHelper.RUBY.end 
            + val.slice(selection.end,val.length);
        },

        decorate($elem) {
            this.$element_ = $elem;
            this.$element_.popover({content:this.createPopOverContent_(this.actions_), html: true, placement: 'bottom', offset: '70px 0'});
            this.enterDocument();
        },
        enterDocument() {
            this.bindEvents_();
        },
        bindEvents_() {
            $(this.$element_).on('select.taghelper keyup.taghelper focus.taghelper click.taghelper', this.onSelect_.bind(this));

            this.actions_.forEach(action=>{
                $(document).on('click.taghelper', `#${action.id}`,this.onClickHelperItem_.bind(this,action));
            });

            // iOS support
            $(document).on('selectionchange.taghelper',this.onSelect_.bind(this));
        },
        onSelect_(e) {
            this.selection = {
                start: this.$element_.prop('selectionStart'),
                end: this.$element_.prop('selectionEnd')
            };
            if (this.selection.start == this.selection.end || !this.$element_.is(':focus')) {
                this.$element_.popover('hide');
                return;
            }
            this.$element_.popover('show');
        },
        onClickHelperItem_(action,e) {
            if (this.selection.start === this.selection.end) {
                this.$element_.popover('hide');
                return;
            }
            action.handler(e);           
            this.$element_.popover('hide');
        },
        exitDocument() {
            this.unBindEvents_();
            this.$element_.popover('dispose');
        },
        unBindEvents_() {
            $(document).off('.taghelper');
            this.$element_.off('.taghelper');
        },
        createPopOverContent_(actions) {
            return actions.map(action=>{
                var $el = $(TagHelper.POPOVER_CONTENT_BUTTON);
                $el.prop('id',action.id);
                $el.text(action.caption);
                return $el[0].outerHTML;
            }).join('');
        }
    };
    TagHelper.RUBY = { start: '<ruby>', end: '</ruby>' };
    TagHelper.RT = { start: '<rp>（</rp><rt>', end: '</rt><rp>）</rp>' };
    TagHelper.POPOVER_CONTENT_BUTTON = '<button class="btn pd0"></button>';
});
