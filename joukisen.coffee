#!coffeescript
"use strict"

enchant()

Constants =
  WIDTH : 640
  HEIGHT : 480
  RDN : # sin テーブル (128 要素)
    [0,6,12,18,24,31,37,43,48,54,60,65,71,76,81,85
    ,90,94,98,102,106,109,112,115,118,120,122,124,125,126,127,127
    ,127,127,127,126,125,124,122,120,118,115,112,109,106,102,98,94
    ,90,85,81,76,71,65,60,54,48,43,37,31,24,18,12,6
    ,0,-6,-12,-18,-24,-31,-37,-43,-48,-54,-60,-65,-71,-76,-81,-85
    ,-90,-94,-98,-102,-106,-109,-112,-115,-118,-120,-122,-124,-125,-126,-127,-127
    ,-127,-127,-127,-126,-125,-124,-122,-120,-118,-115,-112,-109,-106,-102,-98,-94
    ,-90,-85,-81,-76,-71,-65,-60,-54,-48,-43,-37,-31,-24,-18,-12,-6]
  WDX : 2 # 波描画の粗さ
  WOC : 400 # 振動の中心
  WCOLOR : '#0000ff' # 波の色
  BGCOLOR : '#000000'

StageVars =

WaveSurface = Class.create Surface,
  initialize : (wys, wwidth, wheight) ->
    Surface.call @, wwidth, wheight
    @clear()
    @context.fillStyle = Constants.WCOLOR
    wxcount = wys.length
    i = 0
    x = 0
    wdx = Constants.WDX
    while wwidth > 0
      @context.fillRect x, wys[i] - (Constants.HEIGHT - wheight)
        , wdx, Constants.HEIGHT - wys[i]
      i++
      if i >= wxcount
        i = 0
      x += wdx
      wwidth -= wdx
    return

Wave = Class.create Group,
  initialize : (ww1, ww2, wv1, wv2, wsp1, wsp2) ->
    Group.call @
    wxcount = (if ww1 == 0 then 1 else Constants.RDN.length * ww2 / ww1)
    maxwy = 0
    minwy = Constants.HEIGHT
    wys = for i in [0...wxcount]
      wy = ~~(Constants.WOC - (Constants.RDN[~~(i * ww1 / ww2) % 128] * wv1 / wv2))
      maxwy = Math.max(maxwy, wy)
      minwy = Math.min(minwy, wy)
      wy
    wwidth = 0
    wheight = Constants.HEIGHT - minwy
    while wwidth < Constants.WIDTH
      wwidth += wxcount * Constants.WDX
    wsp = (if wsp1 == 0 then 0 else wsp2 / wsp1)
    ws = new WaveSurface wys, wwidth, wheight
    wx = 0

    sp1 = new Sprite wwidth, wheight
    sp1.image = ws
    sp1.x = wx
    sp1.y = minwy
    sp2 = new Sprite wwidth, wheight
    sp2.image = ws
    sp2.x = wx + wwidth
    sp2.y = minwy

    @addChild sp1
    @addChild sp2

    @addEventListener 'enterframe', ->
      wx -= wsp
      right = wx + wwidth # 左側の波の右端
      rspace = wwidth - right # 左側の波とステージ右端との間
      if right <= 0
        wx = 0
        right = wwidth
      else if rspace > 0
        sp2.x = right
      sp1.x = wx
      return

    @getWaveTop = (x) ->
      return wys[~~((x - wx) / Constants.WDX) % wxcount]

    return

TheShip = Class.create Sprite,
  initialize : (wave) ->
    Sprite.call @, 64, 32
    game = Core.instance
    @image = game.assets['res/img/char.gif']
    @frame = (0 for i in [1..game.fps]).concat(1 for i in [1..game.fps])
    @x = 240
    @y = 120
    @addEventListener 'enterframe', ->
      if game.input.right
        @x += 1
      else if game.input.left
        @x -= 1
      @y = wave.getWaveTop(@x + 32) - 28
      return

TheStage = Class.create Scene,
  initialize : ->
    Scene.call @
    game = Core.instance
    bgm = game.assets['res/snd/stage1.mp3']
    @backgroundColor = Constants.BGCOLOR
    #wave = new Wave 1,2,1,2,1,4
    wave = new Wave 1,2,1,4,1,8
    ship = new TheShip wave
    @addChild wave
    @addChild ship
    @addEventListener 'enter', ->
      if bgm.src # Web Audio API loop implementation in a very ugly way
        bufsrc = bgm.src
        bufsrc.loop = true
        bufsrc.buffer = bgm.buffer
        bufsrc.connect bgm.connectTarget
        bufsrc.noteOn 0
        return
    @addEventListener 'enterframe', ->
      if ! bgm.src
        bgm.play()
        return

TheGame = Class.create Core,
  initialize : ->
    Core.call @, Constants.WIDTH, Constants.HEIGHT
    @fps = 30
    @preload ['res/img/char.gif']
    @preload ['res/snd/stage1.mp3']
    @onload = ->
      @replaceScene new TheStage
      return
    @start()
    return

window.onload = -> new TheGame
