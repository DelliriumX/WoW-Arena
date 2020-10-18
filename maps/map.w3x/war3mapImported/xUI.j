library xUI initializer init
  globals
    private constant string TOC_FILE = "war3mapimported\\xUI.toc"
    private constant boolean HIDE_DEFAULT_FRAMES = true
    private constant integer RES_DESIGN_WIDTH = 1440
    private constant integer RES_DESIGN_HEIGHT = 900
    //  ==============================================================
    private constant real PX2GRID = 0.6 / I2R(RES_DESIGN_HEIGHT)
    private constant real GRID2PX = I2R(RES_DESIGN_HEIGHT) / 0.6
    private integer ResolutionWidth = 1440
    private integer ResolutionHeight = 900
    private timer t
    private Frame Frames
    private integer simpleTextContext = 0
    private integer textContext = 0
    private integer simpleTextureContext = 0
    private integer textureContext
    private integer panelContext = 0
    private integer buttonContext = 0
    private integer barContext = 0
  endglobals
  
  function getXFactor takes nothing returns real
    return 0.6 / I2R(RES_DESIGN_WIDTH) * ResolutionWidth / ResolutionHeight
  endfunction

  function getSubFrame takes string name, string sub, integer context returns framehandle
    local framehandle h = BlzGetFrameByName(name + sub, context)
    if (h == null) then
      return BlzGetFrameByName(name, context)
    endif
    return h
  endfunction

  struct DefaultFrames
    readonly static framehandle         Game            = null
    readonly static framehandle         World           = null
    readonly static framehandle         HeroBar         = null
    readonly static framehandle array   HeroButton
    readonly static framehandle array   HeroHPBar
    readonly static framehandle array   HeroMPBar
    readonly static framehandle array   HeroIndicator
    readonly static framehandle array   ItemButton
    readonly static framehandle array   CommandButton
    readonly static framehandle array   SystemButton
    readonly static framehandle         Portrait        = null
    readonly static framehandle         Minimap         = null
    readonly static framehandle array   MinimapButton
    readonly static framehandle         Tooltip         = null
    readonly static framehandle         UberTooltip     = null
    readonly static framehandle         ChatMsg         = null
    readonly static framehandle         UnitMsg         = null
    readonly static framehandle         TopMsg          = null

    readonly static framehandle         Console         = null
    readonly static framehandle         GoldText        = null
    readonly static framehandle         LumberText      = null
    readonly static framehandle         FoodText        = null
    readonly static framehandle         UnitNameText    = null
    readonly static framehandle         ResourceBar     = null
    readonly static framehandle         UpperButtonBar  = null
  
    private static method onInit takes nothing returns nothing
        local integer i

        set Game        = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
        set World       = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
        set HeroBar     = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BAR, 0)
        set Portrait    = BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT, 0)
        set Minimap     = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP, 0)
        set Tooltip     = BlzGetOriginFrame(ORIGIN_FRAME_TOOLTIP, 0)
        set UberTooltip = BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0)
        set ChatMsg     = BlzGetOriginFrame(ORIGIN_FRAME_CHAT_MSG, 0)
        set UnitMsg     = BlzGetOriginFrame(ORIGIN_FRAME_UNIT_MSG, 0)
        set TopMsg      = BlzGetOriginFrame(ORIGIN_FRAME_TOP_MSG, 0)

        set i = 0
        loop
            exitwhen i > 11
            set HeroButton[i]    = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i)
            set HeroHPBar[i]     = BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR, i)
            set HeroMPBar[i]     = BlzGetOriginFrame(ORIGIN_FRAME_HERO_MANA_BAR, i)
            set HeroIndicator[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON_INDICATOR, i)
            set ItemButton[i]    = BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON, i)
            set CommandButton[i] = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, i)
            set SystemButton[i]  = BlzGetOriginFrame(ORIGIN_FRAME_SYSTEM_BUTTON, i)
            set MinimapButton[i] = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP_BUTTON, i)
            set i = i + 1
        endloop

        set Console    = BlzGetFrameByName("ConsoleUI", 0)
        set GoldText   = BlzGetFrameByName("ResourceBarGoldText", 0)
        set LumberText = BlzGetFrameByName("ResourceBarLumberText", 0)
        set FoodText   = BlzGetFrameByName("ResourceBarSupplyText", 0)
        set ResourceBar = BlzGetFrameByName("ResourceBarFrame", 0)
        set UnitNameText = BlzGetFrameByName("SimpleNameValue", 0)
        set UpperButtonBar = BlzGetFrameByName("UpperButtonBarFrame", 0)

    endmethod
    
    public static method hide takes nothing returns nothing
      local integer i
    
      call BlzEnableUIAutoPosition(false)
      call BlzFrameClearAllPoints(DefaultFrames.World)
      call BlzFrameClearAllPoints(DefaultFrames.Console)
      call BlzFrameClearAllPoints(DefaultFrames.Minimap)
      call BlzFrameClearAllPoints(DefaultFrames.GoldText)
      call BlzFrameClearAllPoints(DefaultFrames.LumberText)
      call BlzFrameClearAllPoints(DefaultFrames.FoodText)
      call BlzFrameClearAllPoints(DefaultFrames.ResourceBar)
      call BlzFrameClearAllPoints(DefaultFrames.UnitMsg)
      call BlzFrameSetAllPoints(DefaultFrames.World, DefaultFrames.Game)
      call BlzFrameSetAbsPoint(DefaultFrames.Console, FRAMEPOINT_TOPRIGHT, -999.0, -999.0)
      call BlzFrameSetAbsPoint(DefaultFrames.Minimap, FRAMEPOINT_TOPRIGHT, -999.0, -999.0)   
      call BlzFrameSetAbsPoint(DefaultFrames.GoldText, FRAMEPOINT_BOTTOMLEFT, -999.0, -999.0)
      call BlzFrameSetAbsPoint(DefaultFrames.LumberText, FRAMEPOINT_BOTTOMLEFT, -999.0, -999.0)
      call BlzFrameSetAbsPoint(DefaultFrames.FoodText, FRAMEPOINT_BOTTOMLEFT, -999.0, -999.0)
      call BlzFrameSetAbsPoint(DefaultFrames.ResourceBar, FRAMEPOINT_BOTTOMLEFT, -999.0, -999.0)
      call BlzFrameSetAbsPoint(DefaultFrames.UnitMsg, FRAMEPOINT_BOTTOMLEFT, -100 * PX2GRID, 250 * PX2GRID)
      call BlzFrameSetAbsPoint(DefaultFrames.ChatMsg, FRAMEPOINT_BOTTOMLEFT, 300 * PX2GRID, 250 * PX2GRID)
      call BlzFrameSetAbsPoint(DefaultFrames.ChatMsg, FRAMEPOINT_BOTTOMRIGHT, 900 * PX2GRID, 250 * PX2GRID)
      call BlzFrameSetAbsPoint(DefaultFrames.ChatMsg, FRAMEPOINT_TOPLEFT, 300 * PX2GRID, 500 * PX2GRID)
      call BlzFrameSetAbsPoint(DefaultFrames.ChatMsg, FRAMEPOINT_TOPRIGHT, 900 * PX2GRID, 500 * PX2GRID)

      set i = 0
      loop
          exitwhen DefaultFrames.CommandButton[i] == null
          call BlzFrameClearAllPoints(DefaultFrames.CommandButton[i])
          call BlzFrameSetAbsPoint(DefaultFrames.CommandButton[i], FRAMEPOINT_BOTTOMLEFT, -999.0, -999.0)
          set i = i + 1
      endloop

      set i = 0
      loop
          exitwhen DefaultFrames.SystemButton[i] == null
          call BlzFrameClearAllPoints(DefaultFrames.SystemButton[i])
          call BlzFrameSetAbsPoint(DefaultFrames.SystemButton[i], FRAMEPOINT_BOTTOMLEFT, -999.0, -999.0)
          set i = i + 1
      endloop
    endmethod
  endstruct
  
  struct Frame
    readonly static hashtable HT
    readonly static integer GAME_ORIGIN_FRAME = 0
    readonly static string FRAMETYPE_SIMPLE = "simple"
    readonly static string FRAMETYPE_NORMAL = "normal"
    readonly static string DEFAULT_FONT = "Fonts\\FRIZQT__.TTF"
    readonly static string TYPE_SIMPLE_TEXT = "xUI_SimpleText"
    readonly static string TYPE_TEXT = "xUI_Text"
    readonly static string TYPE_SIMPLE_TEXTURE = "xUI_SimpleTexture"
    readonly static string TYPE_TEXTURE = "xUI_Texture"
    readonly static string TYPE_PANEL = "xUI_SimplePanel"
    readonly static string TYPE_BUTTON = "xUI_Button"
    readonly static string TYPE_BAR = "xUI_Bar"
    // readonly static string TYPE_EFFECT = "xUI_SimpleModel"

    readonly framehandle frame
    readonly framehandle parent
    readonly thistype tooltipStruct
    readonly integer context = 0
    readonly string name = ""
    readonly string type = ""
    readonly string frameType
    private boolean inverse = false
    private integer vertexColor = -1
    private real x  = 0.0
    private real y  = 0.0
    private real widthGrid = 0.032
    private real widthPx = 48.0
    private real heightGrid = 0.048
    private real heightPx = 48.0
    private framepointtype pivotpoint = FRAMEPOINT_CENTER
    private framepointtype anchorpoint = FRAMEPOINT_CENTER

    private framehandle textFrameHandle
    private framehandle mainTextureHandle
    private framehandle disabledTextureHandle
    private framehandle pushedTextureHandle
    // private framehandle highlightTextureHandle
    private framehandle backgroundTextureHandle
    private framehandle borderTextureHandle
    private framehandle modelFrameHandle

    private string mainTextureFile = ""
    private string disabledTextureFile = ""
    private string pushedTextureFile = ""
    // private string highlightTextureFile = ""
    private string backgroundTextureFile = "Replaceabletextures\\Teamcolor\\Teamcolor27.blp"
    private string borderTextureFile = "Textures\\Transparent.tga"
    private string modelFile = ""

    method operator width= takes real px returns nothing
      set this.widthPx = px
      set this.widthGrid = px * PX2GRID
      call this.SetSize()
    endmethod

    method operator width takes nothing returns real
      return this.widthPx
    endmethod

    method operator height= takes real px returns nothing
      set this.heightPx = px
      set this.heightGrid = px * PX2GRID
      call this.SetSize()
    endmethod

    method operator height takes nothing returns real
      return this.heightPx
    endmethod

    method operator value= takes real r returns nothing
      if (this.inverse) then
        call BlzFrameSetValue(this.frame, 100 - r)
      else
        call BlzFrameSetValue(this.frame, r)
      endif
    endmethod

    method operator value takes nothing returns real
      if (this.inverse) then
        return 100 - BlzFrameGetValue(this.frame)
      endif
      return BlzFrameGetValue(this.frame)
    endmethod

    method operator inverseDirection= takes boolean inverse returns nothing
        local real val = this.value        
        if (StringLength(this.mainTextureFile) == 0) then
          set this.mainTextureFile = "Replaceabletextures\\Teamcolor\\Teamcolor00.blp"
        endif
        set this.inverse = inverse
        if (inverse) then
          call BlzFrameSetVertexColor(this.backgroundTextureHandle, this.vertexColor)
          call BlzFrameSetVertexColor(this.mainTextureHandle, BlzConvertColor(255,255,255,255))
          call BlzFrameSetTexture(this.mainTextureHandle, this.backgroundTextureFile, 0, true)
          call BlzFrameSetTexture(this.backgroundTextureHandle, this.mainTextureFile, 0, true)
          set this.value = val
        endif
    endmethod

    method operator inverseDirection takes nothing returns boolean
        return this.inverse
    endmethod

    method operator pivot= takes framepointtype framepoint returns nothing
      set this.pivotpoint = framepoint
      call this.MoveFrame(this.x, this.y)
      // call BJDebugMsg(R2S(this.x) + " " + R2S(this.y))
    endmethod

    method operator pivot takes nothing returns framepointtype
      return this.pivotpoint
    endmethod

    method operator anchor= takes framepointtype framepoint returns nothing
      set this.anchorpoint = framepoint
      call this.MoveFrame(this.x, this.y)
    endmethod

    method operator anchor takes nothing returns framepointtype
      return this.anchorpoint
    endmethod

    method operator enabled= takes boolean enabled returns nothing
      call BlzFrameSetEnable(this.frame, enabled)
    endmethod

    method operator enabled takes nothing returns boolean
      return BlzFrameGetEnable(this.frame)
    endmethod

    method operator visible= takes boolean visible returns nothing
      call BlzFrameSetVisible(this.frame, visible)
    endmethod

    method operator visible takes nothing returns boolean
      return BlzFrameIsVisible(this.frame)
    endmethod

    method operator opacity= takes integer opacity returns nothing
      call BlzFrameSetAlpha(this.frame, opacity)
    endmethod

    method operator opacity takes nothing returns integer
      return BlzFrameGetAlpha(this.frame)
    endmethod

    method operator tooltip= takes thistype frame returns nothing
      set this.tooltipStruct = frame
      call BlzFrameSetTooltip(this.frame, frame.frame)
    endmethod

    method operator tooltip takes nothing returns thistype
      return this.tooltipStruct
    endmethod

    method operator text= takes string str returns nothing
      call BlzFrameSetText(this.textFrameHandle, str)
    endmethod

    method operator text takes nothing returns string
      return BlzFrameGetText(this.textFrameHandle)
    endmethod

    method operator maxLength= takes integer length returns nothing
      call BlzFrameSetTextSizeLimit(this.textFrameHandle, length)
    endmethod

    method operator maxLength takes nothing returns integer
      return BlzFrameGetTextSizeLimit(this.textFrameHandle)
    endmethod

    method operator textColor= takes integer color returns nothing
      call BlzFrameSetTextColor(this.textFrameHandle, color)
    endmethod

    method operator texture= takes string filePath returns nothing
        set this.mainTextureFile = filePath
        if StringLength(this.disabledTextureFile) == 0 then
            set this.disabledTexture = filePath
            call BlzFrameSetTexture(this.disabledTextureHandle, filePath, 0, true)
        endif
        if StringLength(this.pushedTextureFile) == 0 then
            set this.pushedTexture = filePath
            call BlzFrameSetTexture(this.pushedTextureHandle, filePath, 0, true)
        endif

        if (this.type == Frame.TYPE_BAR and this.inverse) then
          call BlzFrameSetTexture(this.backgroundTextureHandle, this.mainTextureFile, 0, true)  
        else
          call BlzFrameSetTexture(this.mainTextureHandle, filePath, 0, true)
        endif
    endmethod

    method operator texture takes nothing returns string
        return .mainTextureFile
    endmethod

    method operator disabledTexture= takes string filePath returns nothing
        set this.disabledTextureFile = filePath
        call BlzFrameSetTexture(this.disabledTextureHandle, filePath, 0, true)
    endmethod

    method operator disabledTexture takes nothing returns string
        return this.disabledTextureFile
    endmethod

    // method operator highlightTexture= takes string filePath returns nothing
    //     set this.highlightTextureFile = filePath
    //     call BlzFrameSetTexture(this.highlightTextureHandle, filePath, 0, true)
    // endmethod

    // method operator highlightTexture takes nothing returns string
    //     return this.highlightTextureFile
    // endmethod

    method operator pushedTexture= takes string filePath returns nothing
        set this.pushedTextureFile = filePath
        call BlzFrameSetTexture(this.pushedTextureHandle, filePath, 0, true)
    endmethod

    method operator pushedTexture takes nothing returns string
        return this.pushedTextureFile
    endmethod

    method operator backgroundTexture= takes string filePath returns nothing
        set this.backgroundTextureFile = filePath
        if (this.type == Frame.TYPE_BAR and this.inverse) then
          call BlzFrameSetTexture(this.mainTextureHandle, this.backgroundTextureFile, 0, true)  
        else
          call BlzFrameSetTexture(this.backgroundTextureHandle, filePath, 0, true)
        endif
    endmethod

    method operator backgroundTexture takes nothing returns string
        return this.backgroundTextureFile
    endmethod

    method operator borderTexture= takes string filePath returns nothing
        set this.borderTextureFile = filePath
        call BlzFrameSetTexture(this.borderTextureHandle, filePath, 0, true)
    endmethod

    method operator borderTexture takes nothing returns string
        return this.borderTextureFile
    endmethod

    // method operator model= takes string filePath returns nothing
    //     set .modelFile = filePath
    //     call BlzFrameSetModel(.modelFrameH, filePath, 0)
    // endmethod

    // method operator model takes nothing returns string
    //     return .modelFile
    // endmethod

    private method SetSize takes nothing returns nothing
      call BlzFrameSetSize(this.frame, this.widthGrid, this.heightGrid)
      if (this.type == Frame.TYPE_SIMPLE_TEXT or this.type == Frame.TYPE_BAR)then
        call BlzFrameSetSize(this.textFrameHandle, this.widthGrid, this.heightGrid)
      endif
    endmethod

    method SetParent takes thistype parent returns nothing
      if (parent == Frame.GAME_ORIGIN_FRAME) then
        set this.parent = DefaultFrames.Game
      elseif (parent.frameType == this.frameType) then
        set this.parent = parent.frame
      else
        call BJDebugMsg("WRONG PARENT TYPE")
        return
      endif
      call this.MoveFrame(this.x, this.y)
    endmethod

    method MoveFrame takes real x, real y returns nothing
      // if (this.parent == DefaultFrames.GAME)then
      //   call this.MoveFrameAbsolute(x,y)
      //   return
      // endif
      call BlzFrameClearAllPoints(this.frame)
      call BlzFrameSetPoint(this.frame, this.pivotpoint, this.parent, this.anchorpoint, x * PX2GRID, y * PX2GRID)
    endmethod

    method MoveFrameAbsolute takes real x, real y returns nothing
      local real Xfactor = getXFactor()
      call BlzFrameClearAllPoints(this.frame)
      call BlzFrameSetAbsPoint(this.frame, this.pivotpoint, x * Xfactor + 0.4, y * PX2GRID + 0.3)
    endmethod

    method SetVertexColor takes integer color returns nothing
      set this.vertexColor = color
      if (this.type == Frame.TYPE_BAR and this.inverse) then
        call BlzFrameSetVertexColor(this.backgroundTextureHandle, this.vertexColor)
      else
        call BlzFrameSetVertexColor(this.mainTextureHandle, this.vertexColor)
      endif
    endmethod

    method SetBorderColor takes integer color returns nothing
      if (this.type == Frame.TYPE_BAR or this.type == Frame.TYPE_PANEL or this.type == Frame.TYPE_SIMPLE_TEXTURE or this.type == Frame.TYPE_TEXTURE) then
        call BlzFrameSetVertexColor(this.borderTextureHandle, color)
      endif
    endmethod

    method SetBackgroundColor takes integer color returns nothing
      if (this.type == Frame.TYPE_BAR or this.type == Frame.TYPE_PANEL or this.type == Frame.TYPE_SIMPLE_TEXTURE or this.type == Frame.TYPE_TEXTURE) then
        call BlzFrameSetVertexColor(this.backgroundTextureHandle, color)
      endif
    endmethod

    method SetTextFont takes string font, real height, integer flags returns nothing
      if this.type == TYPE_SIMPLE_TEXT then
        call BlzFrameSetFont(this.textFrameHandle, font, PX2GRID * height, flags)          
      endif
    endmethod

    method SetTextAlignment takes textaligntype vertical, textaligntype horizontal returns nothing
      call BlzFrameSetTextAlignment(this.textFrameHandle, vertical, horizontal)
    endmethod

    method ClearFocus takes nothing returns nothing
      local boolean temp = BlzFrameGetEnable(this.frame)
      if (this.type == Frame.TYPE_BUTTON) then
        call BlzFrameSetEnable(this.frame, false)
        call BlzFrameSetEnable(this.frame, temp)
      endif
    endmethod

    method destroy takes nothing returns nothing
      call BlzDestroyFrame(this.frame)
      call deallocate()
      set this.frame                    = null
      set this.parent                   = null
      set this.pivotpoint               = null
      set this.anchorpoint              = null

      set this.textFrameHandle          = null
      set this.mainTextureHandle        = null
      set this.disabledTextureHandle    = null
      // set this.highlightTextureHandle   = null
      set this.pushedTextureHandle      = null
      set this.backgroundTextureHandle  = null
      set this.borderTextureHandle      = null
      set this.modelFrameHandle         = null
    endmethod

    static method create takes string frameType, thistype parent, real x, real y, integer level returns thistype
      local thistype this = thistype.allocate()
      local framehandle parentFrame = DefaultFrames.Game
      //  ========================
      //          CONTEXT 
      //  ========================
      if (frameType == TYPE_SIMPLE_TEXT) then
        set simpleTextContext = simpleTextContext + 1
        set this.context = simpleTextContext
      elseif (frameType == TYPE_SIMPLE_TEXTURE) then
        set simpleTextureContext = simpleTextureContext + 1
        set this.context = simpleTextureContext
      elseif (frameType == TYPE_PANEL) then
        set panelContext = panelContext + 1
        set this.context = panelContext
      elseif (frameType == TYPE_BUTTON) then
        set buttonContext = buttonContext + 1
        set this.context = buttonContext
      elseif (frameType == TYPE_BAR) then
        set barContext = barContext + 1
        set this.context = barContext
      endif

      set this.x = x
      set this.y = y
      set this.name = frameType + I2S(this.context)
      set this.type = frameType
      if (frameType == TYPE_BUTTON or frameType == TYPE_TEXT or frameType == TYPE_TEXTURE ) then
        set this.frameType = Frame.FRAMETYPE_NORMAL
      else
        set this.frameType = Frame.FRAMETYPE_SIMPLE
      endif

      if (parent == Frame.GAME_ORIGIN_FRAME) then
        set this.parent = DefaultFrames.Game
      else
        set this.parent = parent.frame
        if (parent.frameType == this.frameType) then 
          set parentFrame = parent.frame
        endif
      endif

      if (this.frameType == Frame.FRAMETYPE_SIMPLE) then
        set this.frame = BlzCreateSimpleFrame(frameType, parentFrame, this.context)
      else
        set this.frame = BlzCreateFrame(frameType, parentFrame, 0, this.context)
      endif
            

      set this.textFrameHandle         = getSubFrame(frameType, "Text", this.context)
      set this.mainTextureHandle       = getSubFrame(frameType, "Texture", this.context)
      set this.disabledTextureHandle   = getSubFrame(frameType, "Disabled", this.context)
      // set this.highlightTextureHandle  = getSubFrame(frameType, "Highlight", this.context)
      set this.pushedTextureHandle     = getSubFrame(frameType, "Pushed", this.context)
      set this.backgroundTextureHandle = getSubFrame(frameType, "Background", this.context)
      set this.borderTextureHandle     = getSubFrame(frameType, "Border", this.context)
      // set this.modelFrameHandle        = getSubFrame(frameType, "Model", this.context)

      // set this.mainTextureFile       = ""
      // set this.disabledTextureFile   = ""
      // set this.pushedTextureFile     = ""
      // set this.highlightTextureFile  = ""
      // set this.backgroundTextureFile = "Replaceabletextures\\Teamcolor\\Teamcolor27.blp"
      // set this.borderTextureFile     = "Textures\\Transparent.tga"
      // set this.modelFile             = ""

      call this.MoveFrame(x, y)
      call SaveInteger(HT,GetHandleId(this.frame), 0, this)

      if (BlzGetFrameByName(frameType, this.context) == null) then
        call BJDebugMsg("|cffff0000Frame creation failed|r")
      endif

      return this
    endmethod

    private static method onInit takes nothing returns nothing
      set HT = InitHashtable()
      call BlzLoadTOCFile(TOC_FILE)
    endmethod

  endstruct

  function RefreshResolution takes nothing returns nothing
    if(ResolutionWidth != BlzGetLocalClientWidth() or ResolutionHeight != BlzGetLocalClientHeight()) then
      set ResolutionWidth = BlzGetLocalClientWidth()
      set ResolutionHeight = BlzGetLocalClientHeight()
      // call BJDebugMsg("setting points")
      call BlzFrameClearAllPoints(DefaultFrames.Game)
      call BlzFrameSetAbsPoint(DefaultFrames.Game, FRAMEPOINT_BOTTOMLEFT, -0.08, 0)
      call BlzFrameSetAbsPoint(DefaultFrames.Game, FRAMEPOINT_TOPLEFT, -0.08, 0.6)
      call BlzFrameSetAbsPoint(DefaultFrames.Game, FRAMEPOINT_BOTTOMRIGHT, 0.96, 0)
      call BlzFrameSetAbsPoint(DefaultFrames.Game, FRAMEPOINT_TOPRIGHT, 0.96, 0.6)
      call BlzFrameSetAllPoints(DefaultFrames.World, DefaultFrames.Game)
    endif
  endfunction

  private function init takes nothing returns nothing
    call RefreshResolution()
    if (HIDE_DEFAULT_FRAMES)then
      call BlzHideOriginFrames(true)
      call DefaultFrames.hide()
    endif
    set t = CreateTimer()
    call TimerStart(t, 1.0, true, function RefreshResolution)
  endfunction

  // function xUISetFramePosition takes framehandle frame, framepointtype point, real x, real y returns nothing
  //   local real Xfactor = 0.6 / I2R(RES_DESIGN_WIDTH) * 500 / 1024
  //   call BlzFrameSetAbsPoint(frame, point, x * Xfactor + 0.4 , y * PX2GRID + 0.3)
  // endfunction
endlibrary

function clickTriggerActions takes nothing returns nothing
  local Frame f = LoadInteger(Frame.HT, GetHandleId(BlzGetTriggerFrame()), 0)
  call BJDebugMsg("Frame was clicked")
  call BJDebugMsg(BlzFrameGetName(BlzGetTriggerFrame()))
endfunction

function TestFrames takes nothing returns nothing
  local Frame text
  local Frame texture
  local Frame panel
  local Frame btn
  local Frame bar
  local Frame bar2
  local Frame party
  local Frame arena
  local hashtable hs = InitHashtable()
  local framehandle a

  set party = Frame.create(Frame.TYPE_BAR, Frame.GAME_ORIGIN_FRAME, -300, 0, 0)
  set party.texture = "Textures\\Glamour2.tga"
  call party.SetVertexColor(BlzConvertColor(255,255,1,1))
  set party.text = ""
  set party.value = 30

  set arena = Frame.create(Frame.TYPE_BAR, Frame.GAME_ORIGIN_FRAME, 300, 0, 0)
  set arena.texture = "Textures\\Glamour2.tga"
  call arena.SetVertexColor(BlzConvertColor(255,255,1,1))
  set arena.inverseDirection = true
  set arena.text = ""
  set arena.value = 30

    // local trigger clickTrigger = CreateTrigger()
  // call TriggerAddAction(clickTrigger, function clickTriggerActions)
  
  // set text = Frame.create(Frame.TYPE_SIMPLE_TEXT, Frame.GAME_ORIGIN_FRAME, 0, 300, 0)

  // set texture = Frame.create(Frame.TYPE_SIMPLE_TEXTURE, text, 0, -80, 0)
  // set texture.texture = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp"
  // call texture.SetVertexColor(125,125,255,255)

  // set panel = Frame.create(Frame.TYPE_PANEL, texture, 0, -80, 0) 
  // set panel.texture = "ReplaceableTextures\\CommandButtons\\BTNHeroMountainKing.blp"
  // call BlzTriggerRegisterFrameEvent(clickTrigger, panel.frame, FRAMEEVENT_CONTROL_CLICK)
  // call panel.SetVertexColor(125,125,255,255)

  // set btn = Frame.create(Frame.TYPE_BUTTON, panel, 0, -80, 0)
  // set btn.texture = "ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp"
  // call BlzTriggerRegisterFrameEvent(clickTrigger, btn.frame, FRAMEEVENT_CONTROL_CLICK)
  
  set bar = Frame.create(Frame.TYPE_BAR, Frame.GAME_ORIGIN_FRAME, 0, -80, 0)
  set bar.texture = "Textures\\Glamour2.tga"
  set bar.value = 75
  set bar.width = 256
  set bar.height = 48
  set bar.text = ""
  call bar.SetVertexColor(BlzConvertColor(255,255,1,1))
  call SaveInteger(hs, 0, 0, bar)
  set text = LoadInteger(hs, 0, 0)
  call BJDebugMsg(R2S(text.value))


  set bar2 = Frame.create(Frame.TYPE_BAR, Frame.GAME_ORIGIN_FRAME, 0, 80, 0)
  set bar2.texture = "Textures\\Glamour2.tga"
  set bar2.inverseDirection = true
  set bar2.value = 75
  set bar2.width = 256
  set bar2.height = 48
  set bar2.text = ""
  call bar2.SetVertexColor(BlzConvertColor(255,255,1,1))
  call SaveInteger(hs, 1, 0, bar)
  set texture = LoadInteger(hs, 1, 0)
  call BJDebugMsg(R2S(texture.value))



  set a = BlzCreateFrame("xUI_Text", DefaultFrames.Game, 0, 0)
  call BlzFrameClearAllPoints(a)
  call BlzFrameSetAbsPoint(a, FRAMEPOINT_CENTER, 0.4,0.3)
  call BlzFrameSetSize(a, 0.1,0.1)
  call BJDebugMsg(I2S(GetHandleId(BlzGetFrameByName("xUI_Text",0))))


endfunction
