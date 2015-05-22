`#target "aftereffects-13.0"`

class HylePanel

# ----------------------------------------
# initialize
# ----------------------------------------
  initialize: () ->
    @window = {}
    @ui =
      elements: {}
      sizes: {}

    @debug = true

    if @debug then @selfBuild "/Applications/Adobe After Effects CC 2014/Scripts/ScriptUI Panels"
    if @debug then @selfBuild (new File($.fileName)).parent.path

    @createWindow()

# ----------------------------------------
# selfBuild
# ----------------------------------------
  selfBuild: (path) ->
    currentPath = (new File($.fileName)).parent.path
    esy.file.buildExtendScript "#{currentPath}/lib/Hyle Panel.js", ["#{path}/Hyle Panel.jsx"]

# ----------------------------------------
# createWindow
# ----------------------------------------
  createWindow: () ->
    if panel.container instanceof Panel
      @window = panel.container
      @buildUi()
    else
      @window = new Window "window {orientation: 'row'}"
      @buildUi()
      @window.show()

# ----------------------------------------
# buildUi
# ----------------------------------------
  buildUi: () ->
    @ui = {}
    @ui.sizes =
      marginLeft: 10
      marginTop: 10
      width: 200
      heightIncrement: 0

    @ui.elements = {}
    @ui.elements.generateButton = @window.add 'button',  @returnGoodUIValues(30, true, [10, 10, -10, 0]), 'Generate'
    @ui.elements.pastePanel     = @window.add 'panel', @returnGoodUIValues(220, false, [0, 10, 0, 0]), 'Direct input'
    @ui.elements.textarea       = @window.add 'editText', @returnGoodUIValues(150, true, [10, 10, -10, 0]), "", {multiline: true}
    @ui.elements.submitButton   = @window.add 'button', @returnGoodUIValues(30, true, [10, 0, -10, 0]), 'Submit'
    @createEvents()

# ----------------------------------------
# createEvents
# ----------------------------------------
  createEvents: () ->
    @ui.elements.submitButton.onClick   = (e) => @handleSubmitButtonClick()
    @ui.elements.generateButton.onClick = (e) => @handleGenerateButtonClick()

# ----------------------------------------
# returnGoodUIValue
# ----------------------------------------
  returnGoodUIValues: (height, increment = true, adaptSizes = [0,0,0,0]) ->
    sizes = []
    i = 0
    for key, value of @ui.sizes
      sizes[key] = value + adaptSizes[i]
      i++

    values = [
      sizes.marginLeft,
      sizes.marginTop + @ui.sizes.heightIncrement,
      sizes.width,
      sizes.marginTop + @ui.sizes.heightIncrement + height
    ]

    @ui.sizes.heightIncrement += sizes.marginTop
    @ui.sizes.heightIncrement += height if increment

    return values

# ----------------------------------------
# handleGenerateButtonClick
# ----------------------------------------
  handleGenerateButtonClick: () ->
    app.beginUndoGroup 'Hyle'
    @ui.elements.textarea.text = hyle.api.compose()
    app.endUndoGroup()


# ----------------------------------------
# handleSubmitButtonClick
# ----------------------------------------
  handleSubmitButtonClick: () ->
    app.beginUndoGroup 'Hyle'
    if @ui.elements.textarea.text is ""
      hyle.logError("You need to enter some content.")
    else
      result = hyle.api.parse @ui.elements.textarea.text
    app.endUndoGroup()


# ----------------------------------------
# handleUploadButtonClick
# ----------------------------------------
  handleUploadButtonClick: () ->
    uploadDialog        = File.openDialog()
    if uploadDialog
      uploadDialog.open 'r'
      uploadedFileContent = uploadDialog.read()
      result = hyle.api.parse @ui.elements.textarea.text


panel = new HylePanel
panel.container = this
panel.initialize()

