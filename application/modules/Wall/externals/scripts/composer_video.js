/* $Id: composer_video.js 18.06.12 10:52 michael $ */



Wall.Composer.Plugin.Video = new Class({

  Extends : Wall.Composer.Plugin.Interface,

  name : 'video',

  options : {
    title : 'Add Video',
    lang : {},
    // Options for the link preview request
    requestOptions : {},
    // Various image filtering options
    imageMaxAspect : ( 10 / 3 ),
    imageMinAspect : ( 3 / 10 ),
    imageMinSize : 48,
    imageMaxSize : 5000,
    imageMinPixels : 2304,
    imageMaxPixels : 1000000,
    imageTimeout : 5000,
    // Delay to detect links in input
    monitorDelay : 250,
    autoDetect: true
  },

  initialize : function(options) {
    this.elements = new Hash(this.elements);
    this.params = new Hash(this.params);
    this.parent(options);
  },

  attach : function() {
    this.parent();
    this.makeActivator();
    return this;
  },

  detach : function() {
    this.parent();
    return this;
  },

  activate : function(no_focus) {
    if( this.active ) return;
    this.parent();

    this.makeMenu();
    this.makeBody();

    // Generate body contents
    // Generate form

    this.elements.formInput = new Element('select', {
      'class' : 'wall-compose-form-input wall-compose-video-form-type',
      'option' : 'test',
      'events' : {
        'change' : this.updateVideoFields.bind(this)
      }
    }).inject(this.elements.body);
    this.elements.formInput.options[0] = new Option(this._lang('Choose Source'), '0');
    this.elements.formInput.options[1] = new Option(this._lang('YouTube'), '1');
    this.elements.formInput.options[2] = new Option(this._lang('Vimeo'), '2');

    if (this.options.allowed == 1 && this.options.type != 'message'){
      this.elements.formInput.options[3] = new Option(this._lang('My Computer'), '3');  
    }
    //link to full composer for now
    //$('wall-compose-video-form-type').options[3] = new Option('My Computer','3');
    
    this.elements.formInput = new Element('input', {
      'class' : 'wall-compose-form-input wall-compose-video-form-input',
      'type' : 'text',
      'style': 'display:none;'
    }).inject(this.elements.body);

    this.elements.previewDescription = new Element('div', {
      'class' : 'wall-compose-video-upload',
      'html' : this._lang('To upload a video from your computer, please use our full uploader.'),
      'style': 'display:none;'
    }).inject(this.elements.body);


    this.elements.formSubmit = new Element('button', {
      'class' : 'wall-compose-form-submit wall-compose-video-form-submit',
      'style': 'display:none;',
      'html' : this._lang('Attach'),
      'events' : {
        'click' : function(e) {
          e.stop();
          this.doAttach();
        }.bind(this)
      }
    }).inject(this.elements.body);

    if (!no_focus){
      this.elements.formInput.focus();
    }
  },

  deactivate : function() {
    // clean video out if not attached
    if (this.params.video_id)
      new Request.JSON({
        url: en4.core.basePath + 'video/index/delete',
        data: {
          format: 'json',
          video_id: this.params.video_id
        }
      }).send();
    if( !this.active ) return;
    this.parent();
  },

  // Getting into the core stuff now

  doAttach : function(e) {

    var val = this.elements.formInput.value;
    if( !val )
    {
      return;
    }
    if( !val.match(/^[a-zA-Z]{1,5}:\/\//) )
    {
      val = 'http://' + val;
    }
    this.params.set('uri', val)
    // Input is empty, ignore attachment
    if( val == '' ) {
      e.stop();
      return;
    }

    var feed = Wall.feeds.get(this.getComposer().options.feed_uid).compose;
    var video_element = feed.container.getElement(".wall-compose-video-form-type");
    var type = video_element.value;
    // Send request to get attachment
    var options = $merge({
      'data' : {
        'format' : 'json',
        'uri' : val,
        'type': type
      },
      'onComplete' : this.doProcessResponse.bind(this)
    }, this.options.requestOptions);

    // Inject loading
    this.makeLoading('empty');

    // Send request
    this.request = new Request.JSON(options);
    this.request.send();
  },

  doProcessResponse : function(responseJSON, responseText) {

    var self = this;

    // Handle error
    if( ($type(responseJSON) != 'hash' && $type(responseJSON) != 'object') || $type(responseJSON.src) != 'string' || $type(parseInt(responseJSON.video_id)) != 'number' ) {
      //this.elements.body.empty();
      if( this.elements.loading ) this.elements.loading.destroy();
      //this.makeaError(responseJSON.message, 'empty');
      this.makeError(responseJSON.message);

      //wall-compose-video-error
      //ignore test
      this.elements.ignoreValidation = new Element('a', {
        'href' : this.params.uri,
        'html' : this.params.title,
        'events' : {
          'click' : function(e) {
            e.stop();
            self.doAttach(this);
          }
        }
      }).inject(this.elements.previewTitle);
      
      return;
      //throw "unable to upload image";
    }

    var title = responseJSON.title || this.params.get('uri').replace('http://', '');
    

    this.params.set('title', responseJSON.title);
    this.params.set('description', responseJSON.description);
    this.params.set('photo_id', responseJSON.photo_id);
    this.params.set('video_id', responseJSON.video_id);
    this.elements.preview = Asset.image(responseJSON.src, {
      'class' : 'wall-compose-preview-image wall-compose-video-preview-image',
      'onload' : this.doImageLoaded.bind(this)
    });
  },

  doImageLoaded : function() {
    var self = this;

    if( this.elements.loading ) this.elements.loading.destroy();
    this.elements.preview.erase('width');
    this.elements.preview.erase('height');
    this.elements.preview.inject(this.elements.body);

    this.elements.previewInfo = new Element('div', {
      'class' : 'wall-compose-preview-info wall-compose-video-preview-info'
    }).inject(this.elements.body);

    this.elements.previewTitle = new Element('div', {
      'class' : 'wall-compose-preview-title wall-compose-video-preview-title'
    }).inject(this.elements.previewInfo);

    this.elements.previewTitleLink = new Element('a', {
      'href' : this.params.uri,
      'html' : this.params.title,
      'events' : {
        'click' : function(e) {
          e.stop();
          self.handleEditTitle(this);
        }
      }
    }).inject(this.elements.previewTitle);

    this.elements.previewDescription = new Element('div', {
      'class' : 'wall-compose-preview-description wall-compose-video-preview-description',
      'html' : this.params.description,
      'events' : {
        'click' : function(e) {
          e.stop();
          self.handleEditDescription(this);
        }
      }
    }).inject(this.elements.previewInfo);
    this.makeFormInputs();
  },

  makeFormInputs : function() {
    this.ready();
    this.parent({
      'photo_id' : this.params.photo_id,
      'video_id' : this.params.video_id,
      'title' : this.params.title,
      'description' : this.params.description
    });
  },

  updateVideoFields : function(element) {

    var feed = Wall.feeds.get(this.getComposer().options.feed_uid).compose;

    var video_element =  feed.container.getElement(".wall-compose-video-form-type");
    var url_element = feed.container.getElement(".wall-compose-video-form-input");
    var post_element = feed.container.getElement(".wall-compose-video-form-submit");
    var upload_element = feed.container.getElement(".wall-compose-video-upload");
    // clear url if input field on change
    feed.container.getElement('.wall-compose-video-form-input').value = "";

  // If video source is empty
    if (video_element.value == 0)
    {
      upload_element.style.display = "none";
      post_element.style.display = "none";
      url_element.style.display = "none";
    }

    // If video source is youtube or vimeo
    if (video_element.value == 1 || video_element.value == 2)
    {
      upload_element.style.display = "none";
      post_element.style.display = "block";
      url_element.style.display = "block";
      url_element.focus();
    }

    // if video source is upload
    if (video_element.value == 3)
    {
      upload_element.style.display = "block";
      post_element.style.display = "none";
      url_element.style.display = "none";
    }
  },
  handleEditTitle : function(element) {
    element.setStyle('display', 'none');
    var input = new Element('input', {
      'type' : 'text',
      'value' : htmlspecialchars_decode(element.get('html').trim()),
      'events' : {
        'blur' : function() {
          if( input.value.trim() != '' ) {
            this.params.title = Wall.clearHTML(input.value);
            element.set('html', this.params.title);
            this.setFormInputValue('title', this.params.title);
          }
          element.setStyle('display', '');
          input.destroy();
        }.bind(this)
      }
    }).inject(element, 'after');
    input.focus();
  },
  handleEditDescription : function(element) {
    element.setStyle('display', 'none');
    var input = new Element('textarea', {
      'html' : htmlspecialchars_decode(element.get('html').trim()),
      'events' : {
        'blur' : function() {
          if( input.value.trim() != '' ) {
            this.params.description = Wall.clearHTML(input.value);
            element.set('html', this.params.description);
            this.setFormInputValue('description', this.params.description);
          }
          else{
            this.params.description = '';
            element.set('html', '');
            this.setFormInputValue('description', '');
          }
          element.setStyle('display', '');
          input.destroy();
        }.bind(this)
      }
    }).inject(element, 'after');
    input.focus();
  }
});