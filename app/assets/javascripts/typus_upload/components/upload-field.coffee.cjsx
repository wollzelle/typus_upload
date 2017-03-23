Typus.UploadField = React.createClass

  getInitialState: ->
    {model: new Typus.Upload @props}

  componentWillMount: ->
    @state.model.on 'change', => @forceUpdate()

  componentWillUnmount: ->
    @state.model.off 'change'
    @state.model.destroy()

  render: ->
    content = @renderAddButton()
    content = @renderItem() if @state.model.field_value
    content = @renderProgress() if @state.model.status is 'uploading'

    <div className="form-group">
      <label className="control-label">{@props.field_label}</label>
      <div className="controls">
        <ul className="list-group">
          {content}
        </ul>
      </div>
    </div>

  renderItem: ->
    {field_value} = @state.model
    filename = field_value.split('/').pop()

    <li className="list-group-item">
      <a href="#" className="close" onClick=@onRemove>&times;</a>
      <span className="glyphicon glyphicon-file"></span> {filename}
      <input type="hidden" name={@props.field_name} value={field_value} />
    </li>

  renderAddButton: ->
    <li className="list-group-item">
      <a href="#" className="btn btn-default" onClick=@onClickAdd>Add attachments +</a>
      <input type="file" className="hidden" ref="input" onChange=@onFileSelected />
      <input type="hidden" name={@props.field_name} value="" />
    </li>

  renderProgress: ->
    {file, progress} = @state.model
    style = { width: progress + '%' }

    <li className="list-group-item">
      <span className="glyphicon glyphicon-file"></span> {file.name}
      <div className="progress">
        <div className="progress-bar" style={style}></div>
      </div>
    </li>

  onClickAdd: (e) ->
    input = @refs.input
    $(input).trigger 'click'
    e.preventDefault()

  onFileSelected: (e) ->
    file = e.target.files[0]
    @state.model.upload(file)

  onRemove: (e) ->
    @state.model.reset()
    e.preventDefault()
