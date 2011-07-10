class MineView
  #attr_reader :state
  def initialize(h,w,m)
    @state=:GAMENOW
    @events={
      GAMECLEAR: method(:gameclear),
      GAMEOVER: method(:gameover)
      }
    initmap(h,w,m)
  end
  def initmap(h,w,m)
    @height=h
    @width=w
    setmodel(MineModel.new :h=>h,:w=>w,:mines=>m)
  end
  def update(arg)
    #@state=arg
  end
  def view
    print @m.view
    #@events[@state].call if @events.key?(@state)
  end
  def setmodel(m)
    @m=m
    @m.add_observer(self)
  end
  def openmap(x,y)
    @m.openmap(x,y)
  end
  def gameover()
    puts "GAMEOVER"
  end
  def gameclear()
    puts "GAMECLEAR!"
  end
end
