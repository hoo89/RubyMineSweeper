require 'gtk2'
require './minemodel.rb'
require './mineviewer.rb'

class MineGuiView<MineView
  def initialize(h,w,m)
    super
    @window = Gtk::Window.new
    @window.title = "RMine"
    @window.signal_connect("delete_event") do
      Gtk.main_quit
      false
    end
    inittable(h,w)
  end
  
  def inittable(h,w)
    @table = Gtk::Table.new(h, w, true)
    @buttons=Hash.new
    @window.add(@table)
    h.times do |i|
      w.times do |j|
        button = Gtk::Button.new(Gtk::Stock::OK)
        button.signal_connect("clicked") do
          openmap(i,j)
        end
        @table.attach_defaults(button, i, i+1, j, j+1)
        @buttons[[i,j]]=button
      end
    end
    updatebutton
  end
  
  def update(arg)
    @events[arg].call if @events.key?(arg)
  end
  
  def gameover
    print "gameover"
  end
  def gameclear
    print "gameclear"
    #@buttons[0].set_label("clear")
  end
  
  def openmap(x,y)
    super
    updatebutton
  end
  def updatebutton
    @height.times do |i|
      @width.times do |j|
        case @m.viewmap(i,j)
        when MineModel::CLOSE
          @buttons[[i,j]].set_label("-")
        when MineModel::BOMB
          @buttons[[i,j]].set_label("#")
        else
          @buttons[[i,j]].set_label(@m.viewmap(i,j).to_s)
        end
      end
    end
  end
  
  def mainloop
    @window.show_all
    Gtk.main
  end
end