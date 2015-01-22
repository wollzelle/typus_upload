class Typus.Upload

  ##
  # Public interface

  constructor: (attrs) ->
    {@field_value, @preflight_url, @bucket_url} = attrs

  upload: (@file) ->
    @preflight()

  set: (attr, value) ->
    this[attr] = value
    @trigger 'change'

  reset: ->
    @set 'field_value', null
    @set 'progress', null
    @set 'status', null

  destroy: ->
    @req?.abort()
    @xhr?.upload.removeEventListener 'progress', @progress

  ##
  # Upload methods

  # Post to the server to get authorized form data.
  preflight: ->
    @req = $.post @preflight_url, filename: @file.name
    @req.done @prepare
    @req.fail @onError

  # Build the formData object for S3.
  prepare: (response) =>
    formData = new FormData
    formData.append key, value for key, value of response.form_data
    formData.append 'file', @file
    @store formData

  # Store file on S3.
  store: (formData) =>
    @set 'status', 'uploading'

    xhrProvider = =>
      xhr = $.ajaxSettings.xhr()
      xhr.upload.addEventListener 'progress', @onProgress
      @xhr = xhr

    @req = $.ajax @bucket_url,
      xhr: xhrProvider
      type: 'POST'
      data: formData
      processData: false
      contentType: false

    @req.done @onComplete
    @req.fail @onError

  onProgress: (e) =>
    @set 'progress', Math.round (e.loaded / e.total) * 100

  onComplete: (res, status, xhr) =>
    location = xhr.getResponseHeader('Location')
    @set 'field_value', decodeURIComponent(location)
    @set 'status', 'complete'

  onError: (xhr, type, error) =>
    @set 'status', 'error' unless type is 'abort'

# Mixin events
$.extend Typus.Upload.prototype, EventEmitter.prototype
