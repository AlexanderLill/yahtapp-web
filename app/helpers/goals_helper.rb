module GoalsHelper
  def color_bg_class(color)
    colors = {
      gray: "bg-gray-300",
      red:  "bg-red-300",
      yellow:  "bg-yellow-300",
      green:  "bg-green-300",
      blue:  "bg-blue-300",
      indigo:  "bg-indigo-300",
      purple:  "bg-purple-300",
      pink:  "bg-pink-300"
    }
    colors[color.to_sym]
  end
end