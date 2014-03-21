Refinery::PagePart.class_eval do
  attr_accessible :color, :display_type, :margin, :title

  def self.color_options
    [['Default', nil],
     ['Blue', 'blue'],
     ['Yellow', 'yellow'],
     ['Green', 'green'],
     ['Grey', 'grey']]
  end

  def self.display_types
    [['Default', nil],
     ['Title', 'title'],
     ['Image-Left', 'img-left'],
     ['Image-Right', 'img-right'],
     ['Grid', 'grid']]
  end

  def self.margin_options
    [['Default', nil],
     ['No margin', 'no-margin']
    ]
  end
end