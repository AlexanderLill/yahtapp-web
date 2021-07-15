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

  def color_text_class(color)
    colors = {
      gray: "text-gray-400",
      red:  "text-red-400",
      yellow:  "text-yellow-400",
      green:  "text-green-400",
      blue:  "text-blue-400",
      indigo:  "text-indigo-400",
      purple:  "text-purple-400",
      pink:  "text-pink-400"
    }
    colors[color.to_sym]
  end

  def chart_color_value(color, opacity=0.5)
    colors = {
      gray: "rgba(75, 85, 99, #{opacity})",
      red:  "rgba(239, 68, 68, #{opacity})",
      yellow:  "rgba(245, 158, 11, #{opacity})",
      green:  "rgba(16, 185, 129, #{opacity})",
      blue:  "rgba(59, 130, 246, #{opacity})",
      indigo:  "rgba(99, 102, 241, #{opacity})",
      purple:  "rgba(139, 92, 246, #{opacity})",
      pink:  "rgba(236, 72, 153, #{opacity})"
    }
    colors[color.to_sym]
  end
end