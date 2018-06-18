// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require bootstrap-filestyle.min
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require toastr
//= require_tree .

$(function() {
  $('a[data-toggle="tab"]').on('click', function(e) {
        window.localStorage.setItem('activeTab', $(this).attr('href'))
  })
  var activeTab = window.localStorage.getItem('activeTab')
  if (activeTab) {
    $('#myTab a[href="' + activeTab + '"]').tab('show')
  }
})

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
          this.$element_.popover({content:this.createPopOverContent_(this.actions_),html:true});
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
  TagHelper.POPOVER_CONTENT_BUTTON = '<button class="btn"></button>';
});
