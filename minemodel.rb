require 'observer'

class MineModel
  attr_reader :map,:opened,:h,:w
  include Observable
  BOMB=-1
  CLOSE=-2
  DX=[1,1,1,0,0,-1,-1,-1]
  DY=[1,0,-1,1,-1,1,0,-1]
  def initialize(args)
    @h=args[:h]
    @w=args[:w]
    @mine_n=args[:mines]
    @map=Array.new(@h).map!{ Array.new(@w,0) }
    @opened=Array.new(@h).map!{ Array.new(@w,false) }
    @opencount=0
  end
  def initmap(sx,sy)
    mines=Array.new(@h*@w-1,0)
    mines.fill(BOMB,0..@mine_n-1)
    mines.shuffle!
    count=0
    @h.times do |i|
      @w.times do |j|
        next if sx==i&&sy==j
        @map[i][j]=mines[count]
        count+=1
      end
    end
    @h.times do |i|
      @w.times do |j|
        if(@map[i][j]==BOMB)
          8.times do |k|
            next if out?(i+DX[k],j+DY[k])||@map[i+DX[k]][j+DY[k]]==BOMB
            @map[i+DX[k]][j+DY[k]]+=1
          end
        end
      end
    end
  end
  private :initmap
  def openmap(x,y)
    return if out?(x,y)||opened?(x,y)
    initmap(x,y) if @opencount==0
    @opened[x][y]=true
    @opencount+=1
    if @map[x][y]==BOMB
      changed
      notify_observers(:GAMEOVER)
      return
    elsif end?
      changed
      notify_observers(:GAMECLEAR)
      return
    elsif @map[x][y]==0
      8.times do |i|
        openmap(x+DX[i],y+DY[i])
      end
    end
  end
  def out?(x,y)
    x>@h-1||y>@w-1||x<0||y<0
  end
  def opened?(x,y)
    @opened[x][y]
  end
  def end?
    @opencount==@h*@w-@mine_n
  end
  def viewmap(x,y)
    if(!@opened[x][y])
      CLOSE
    else 
      @map[x][y]
    end
  end
end