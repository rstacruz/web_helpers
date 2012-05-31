module TitleHelper
  def title(str=nil)
    @title = str  if str
    @title
  end
end
