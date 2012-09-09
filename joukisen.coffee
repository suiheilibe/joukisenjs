#!coffeescript

enchant()

Constants =
  width : 640
  height : 480
  rdn : # sin テーブル (128 要素)
    [0,6,12,18,24,31,37,43,48,54,60,65,71,76,81,85
    ,90,94,98,102,106,109,112,115,118,120,122,124,125,126,127,127
    ,127,127,127,126,125,124,122,120,118,115,112,109,106,102,98,94
    ,90,85,81,76,71,65,60,54,48,43,37,31,24,18,12,6
    ,0,-6,-12,-18,-24,-31,-37,-43,-48,-54,-60,-65,-71,-76,-81,-85
    ,-90,-94,-98,-102,-106,-109,-112,-115,-118,-120,-122,-124,-125,-126,-127,-127
    ,-127,-127,-127,-126,-125,-124,-122,-120,-118,-115,-112,-109,-106,-102,-98,-94
    ,-90,-85,-81,-76,-71,-65,-60,-54,-48,-43,-37,-31,-24,-18,-12,-6]
  wdx : 2 # 波描画の粗さ
  woc : 400 # 振動の中心
  wcolor : '#0000ff' # 波の色
  bgcolor : '#000000'

StageVars =

WaveSurface = Class.create Surface,
  initialize : (wys, wwidth, wheight) ->
    Surface.call @, wwidth, wheight
    @clear()
    @context.fillStyle = Constants.wcolor
    wxcount = wys.length
    i = 0
    x = 0
    wdx = Constants.wdx
    while wwidth > 0
      @context.fillRect x, ~~(wys[i] - (Constants.height - wheight))
        , wdx, ~~Math.ceil(Constants.height - wys[i])
      i++
      if i >= wxcount
        i = 0
      x += wdx
      wwidth -= wdx
    return

Wave = Class.create Sprite,
  initialize : (ww1, ww2, wv1, wv2, wsp1, wsp2) ->
    wxcount = (if ww1 == 0 then 1 else Constants.rdn.length * ww2 / ww1)
    maxwy = 0
    minwy = Constants.height
    wys = for i in [0...wxcount]
      wy = Constants.woc - (Constants.rdn[~~(i * ww1 / ww2) % 128] * wv1 / wv2)
      maxwy = Math.max(maxwy, wy)
      minwy = Math.min(minwy, wy)
      wy
    wwidth = 0
    wheight = ~~Math.ceil(Constants.height - minwy)
    while wwidth < Constants.width
      wwidth += wxcount * Constants.wdx
    wsp = (if wsp1 == 0 then 0 else wsp2 / wsp1)
    ws = new WaveSurface wys, wwidth, wheight
    wx = 0

    Sprite.call @, Constants.width, wheight
    @x = 0
    @y = minwy
    @image = new Surface @width, @height
    @addEventListener 'enterframe', ->
      @image.clear()
      wx -= wsp
      right = wx + wwidth # 左側の波の右端
      rspace = @width - right # 左側の波とステージ右端との間
      if right <= 0
        wx = 0
        right = wwidth
      else if rspace > 0
        # 右側の波も描画する
        @image.draw ws, 0, 0, rspace, wheight, right, 0, rspace, wheight
      # 左側の並の描画
      sw = Math.min(@width, right)
      @image.draw ws, -wx, 0, sw, wheight, 0, 0, sw, wheight
      return
    return

TheShip = Class.create Sprite,
  initialize : ->
    Sprite.call @, 64, 32
    game = Game.instance
    @image = game.assets['ship.gif']
    @x = 240
    @y = 120

TheGame = Class.create Game,
  initialize : ->
    Game.call @, Constants.width, Constants.height
    @fps = 30
    @preload ['ship.gif']
    @onload = ->
      @rootScene.backgroundColor = Constants.bgcolor
      @rootScene.addChild new Wave 1,2,1,2,1,4
      @rootScene.addChild new TheShip
      return
    @start()
    return

window.onload = -> new TheGame
