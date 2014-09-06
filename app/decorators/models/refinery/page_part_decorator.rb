Refinery::PagePart.class_eval do
  attr_accessible :color, :display_type, :margin, :title, :column_image, :column_image_id
  belongs_to :column_image, class_name: Refinery::Image


  #searchkick mappings: {
  #  'refinery/page_part' => {
  #    properties: {
  #      body: {type: "string", analyzer: {myanalyzer: {type: 'custom', char_filter: ['html_strip'], tokenizer: 'standard', filter: ['lowercase','stopwords']}}}
  #    }
  #  }
  #}
        
  
  #def search_data
  #  as_json only: [:body]
  #end


  
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
