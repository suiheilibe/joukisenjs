#!coffeescript

enchant()

Constants =
  width : 640
  height : 480
  rdn :
    [0,6,12,18,24,31,37,43,48,54,60,65,71,76,81,85
    ,90,94,98,102,106,109,112,115,118,120,122,124,125,126,127,127
    ,127,127,127,126,125,124,122,120,118,115,112,109,106,102,98,94
    ,90,85,81,76,71,65,60,54,48,43,37,31,24,18,12,6
    ,0,-6,-12,-18,-24,-31,-37,-43,-48,-54,-60,-65,-71,-76,-81,-85
    ,-90,-94,-98,-102,-106,-109,-112,-115,-118,-120,-122,-124,-125,-126,-127,-127
    ,-127,-127,-127,-126,-125,-124,-122,-120,-118,-115,-112,-109,-106,-102,-98,-94
    ,-90,-85,-81,-76,-71,-65,-60,-54,-48,-43,-37,-31,-24,-18,-12,-6]
  wdx : 2

WaveSurface = enchant.Class.create enchant.Surface,
  initialize : (@wys, @wwidth) ->
    enchant.Surface.call @, @wwidth, Constants.height
    @clear()
    c = @context
    c.fillStyle = '#0000ff'
    wxcount = @wys.length
    i = 0
    x = 0
    wdx = Constants.wdx
    while @wwidth > 0
      c.fillRect x, @wys[i], wdx, @height - @wys[i]
      i++
      if i >= wxcount
        i = 0
      x += wdx
      @wwidth -= wdx
    return

Wave = enchant.Class.create enchant.Group,
  initialize : (@ww1, @ww2, @wv1, @wv2, @wsp1, @wsp2) ->
    enchant.Group.call @
    wxcount = Constants.rdn.length * @ww2 / @ww1
    @wys = for i in [0...wxcount]
      400 - (Constants.rdn[~~(i * @ww1 / @ww2) % 128] * @wv1 / @wv2)
    @wwidth = 0
    while @wwidth < Constants.width
      @wwidth += wxcount * Constants.wdx
    @wheight = Constants.height
    @wsp = @wsp2 / @wsp1
    sf = new WaveSurface @wys, @wwidth + @wsp
    @sp1 = new enchant.Sprite @wwidth + @wsp, @wheight
    @sp1.image = sf
    @sp1.x = 0
    @sp2 = new enchant.Sprite @wwidth + @wsp, @wheight
    @sp2.image = sf
    @sp1.x = @wwidth

    @addChild @sp1
    @addChild @sp2
    @addEventListener 'enterframe', @proc
    return
  proc : ->
    if @sp1.x + @wwidth <= 0
      @sp1.x = @sp2.x + @wwidth
    if @sp2.x + @wwidth <= 0
      @sp2.x = @sp1.x + @wwidth
    @sp1.x -= @wsp
    @sp2.x -= @wsp
    return

TheGame = enchant.Class.create enchant.Game,
  initialize : ->
    enchant.Game.call @, Constants.width, Constants.height
    @fps = 20
    @onload = ->
      @rootScene.addChild new Wave 1,2,1,2,1,4
      return
    @start()
    return

window.onload = -> new TheGame
