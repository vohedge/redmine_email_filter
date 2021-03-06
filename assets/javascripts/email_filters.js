(function($){
  $(document).ready(function() {

    var ConditionItem = function(html,index) {
      this.init(html,index);
    }
    ConditionItem.prototype = {
      init: function(html,index) {
        this.$ = $(html);
        this.i = index;
        this._bind_click_add_btn();
        this._bind_click_del_btn();
      },
      disable_del_btn: function() {
        this.$.find('.icon-del').hide();
      },
      enable_del_btn: function() {
        this.$.find('.icon-del').show();
      },
      index: function(index) {
        if ( index ) {
          this._set_index(index);
        } else {
          return this._get_index();
        }
      },
      get_id: function() {
        return this.$.find('input[name$="[id]"]').val();
      },
      destroy: function() {
        this.$.remove();
      },
      disable: function() {
        this.$.css({'visibility':'hidden','position':'absolute'});
        this.$.find('input[name$="[_destroy]"]').val(true);
      },
      _set_index: function(index) {
        var fields = this.$.find('select,input');
        for (var i = 0; i < fields.length; i++){
          var $field = $(fields[i]);
          var name = $field.attr('name');
          $field.attr('name', name.replace(/[0-9]+/, index))
          var id = $field.attr('id');
          $field.attr('id', id.replace(/[0-9]+/, index))
        }
        this.i = index;
      },
      _get_index: function() {
        return this.i;
      },
      _bind_click_add_btn: function() {
        this.$.find('.icon-add').click(function(){
          $(document).trigger('condition_add');
          return false;
        });
      },
      _bind_click_del_btn: function() {
        var self  = this;
        this.$.find('.icon-del').click(function(){
          var event = new $.Event('condition_del');
          $(document).trigger(event, {index: self.index()});
          return false;
        });
      }
    }

    var condition_manager = function() {
      this.wrapper = $();
      this.items   = [];
      this.count   = 0;
      this.init();
    }
    condition_manager.prototype = {
      init: function() {
        this.wrapper = $('#conditions');
        var self = this;
        this.wrapper.find('tr').each(function() {
          self._add_item(this);
        });

        this._init_count();
        this._init_template();
        this._init_del_btn();
        this._listen_condition_del_event();
        this._listen_condition_add_event();
      },

      /* Init condition length */
      _init_count: function() {
        this.count = this.items.length;
      },

      /* Save condition html template */
      _init_template: function() {
        var t = this.items[0].$.clone();
        this.template = $(t);
        this.template.find('input[type=text]').val('');
        this.template.find('input[type=hidden]').val('');
        this.template.find('select option').removeAttr('selected');
      },

      /* Fix index */
      _init_index: function() {
        for (var i = 0; i < this.items.length; i++) {
          this.items[i].index(i);
        }
      },

      /* Fix del button visibility */
      _init_del_btn: function() {
        for(var i = 0;i < this.items.length; i++ ){
          this.items[i].enable_del_btn();
        }
        this.items[0].disable_del_btn();
      },

      _add_item: function(html) {
        html = html || this.template.clone();
        var i = this.items.length;
        var item = new ConditionItem(html,i);
        this.items.push(item);
        return item;
      },

      _remove_item: function(index) {
        if ( this.items[index].get_id() == undefined ) {
          this.items[index].destroy();
          this.items.splice(index,1);
        } else {
          this.items[index].disable();
        }
      },

      _listen_condition_del_event: function(index) {
        var self = this;
        $(document).on('condition_del', function(event, params) {
          self._remove_item(params.index);
          self._init_index();
          self._init_del_btn();
        });
      },

      _listen_condition_add_event: function() {
        var self = this;
        $(document).on('condition_add', function() {
          var item = self._add_item();
          self.wrapper.find('table').append(item.$);
          self._init_index();
        });
      }

    }

    if ( $('#conditions').size() > 0 ) {
      new condition_manager();
    }

  });
})(jQuery)

