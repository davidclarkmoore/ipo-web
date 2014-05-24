# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Added by Refinery CMS Pages extension
# Refinery::Pages::Engine.load_seed

home_page = Refinery::Page.create!(title: "Home", link_url: "/")
home_page.view_template = "home"
home_page.layout_template = "home"
home_page.save!

vid_thumb_path = Rails.root.join('app/assets/images/vid_thumb1.jpg')
r = Refinery::Image.new(image: File.new(vid_thumb_path))
r.save(validate: false)
vid_thumb = Refinery::Image.last

field_experience_path = Rails.root.join('app/assets/images/field_experience_1.jpg')
r = Refinery::Image.create(image: File.new(field_experience_path))
r.save(validate: false)
field_experience = Refinery::Image.last

lightbulbs_path = Rails.root.join('app/assets/images/lightbulbs.png')
Refinery::Image.create(image: File.new(lightbulbs_path))
lightbulbs = Refinery::Image.last

infographic_path = Rails.root.join('app/assets/images/infographic.png')
Refinery::Image.create(image: File.new(infographic_path))
infographic = Refinery::Image.last

sharing_options_path = Rails.root.join('app/assets/images/sharing_options.jpg')
Refinery::Image.create(image: File.new(sharing_options_path))
sharing_options = Refinery::Image.last


Refinery::PagePart.create!([
  {
    refinery_page_id: home_page.id,
      title: "Search",
      body: "<h2>Don't see your field? <br />Search all of our projects. Boom, its that easy.</h2>",
      position: 3
  },
  {
    refinery_page_id: home_page.id,
    title: "Ipo",
    body: "<img src=\"%s\" title=\"Vid Thumb1\" alt=\"Vid Thumb1\" width=\"487\" height=\"297\" />\r\n<h1 class=\"text-align-left\"><span style=\"background-color: transparent;\" class=\"font-size-normal\">What makes IPO different?</span>\r\n</h1>\r\n<div><div><h2><span>Choose a missional internship that matches your field of study,&#160;area of passion, and availability. Because sometimes you just need to get out of the classroom.</span>\r\n</h2>\r\n</div>\r\n</div>" % vid_thumb.url,
    position: 4,
    display_type: "img-right"
  },
  {
    refinery_page_id: home_page.id,
    title: "Stories Title",
    body: "<p>This could be you! Hear stories from the field.</p>",
    position: 6
  },
  {
    refinery_page_id: home_page.id,
    title: "Story1",
    body: "<p><img src=\"%s\" title=\"Field Experience 1\" alt=\"Field Experience 1\" data-rel=\"225x255\" width=\"244\" height=\"153\" /></p>\r\n<h1>Xianyi Wu</h1>\r\n<p>One student who changed 17 million lives</p>" % field_experience.url,
    position: 7
  },
  {
    refinery_page_id: home_page.id,
    title: "Story2",
    body: "<p><img src=\"%s\" title=\"Field Experience 1\" alt=\"Field Experience 1\" data-rel=\"225x255\" width=\"244\" height=\"153\" /></p>\r\n<h1>Xianyi Wu</h1>\r\n<p>One student who changed 17 million lives</p>" % field_experience.url,
    position: 8
  },
  {
    refinery_page_id: home_page.id,
    title: "Story3",
    body: "<p><img src=\"%s\" title=\"Field Experience 1\" alt=\"Field Experience 1\" data-rel=\"225x255\" width=\"244\" height=\"153\" /></p>\r\n<h1>Xianyi Wu</h1>\r\n<p>One student who changed 17 million lives</p>" % field_experience.url,
    position: 9
  },
  {
    refinery_page_id: home_page.id,
    title: "Story4",
    body: "<p><img src=\"%s\" title=\"Field Experience 1\" alt=\"Field Experience 1\" data-rel=\"225x255\" width=\"244\" height=\"153\" /></p>\r\n<h1>Xianyi Wu</h1>\r\n<p>One student who changed 17 million lives</p>" % field_experience.url,
    position: 10
  },
  {
    refinery_page_id: home_page.id,
    title: "Motto",
    body: "<p class=\"text-align-center\"><img src=\"#{lightbulbs.url}\" title=\"Lightbulbs\" alt=\"Lightbulbs\" data-rel=\"225x255\" width=\"268\" height=\"104\" /></p>\r\n<h2 class=\"text-align-center\">Customized, Missional, Interships</h2>\r\n<p class=\"text-align-center\">70% of Christ's followers live in the Global South.&#160;70% of Christ's followers live in the Global South.&#160;70% of Christ's followers live in the Global South.</p>",
    position: 2
  },
  {
    refinery_page_id: home_page.id,
    title: "Internship",
    body: "<img src=\"%s\" title=\"Infographic\" alt=\"Infographic\" data-rel=\"225x255\" width=\"428\" height=\"371\" />\r\n<h1>A global internship model for the 21st century</h1>\r\n<h2>Choose a missional internship that matches your field of study, area of passion, and availability. Because sometimes you just need to get out of the classroom.</h2>\r\n<h3>Truly global internships</h3>\r\n<p>Lorem ipsum is simply dummy text of the printing and typesetting industry.</p>\r\n<h3>Your major, outside the classroom</h3>\r\n<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry.</p>\r\n<h3>Virtual Cross-Cultural Missions Training</h3>\r\n<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry.</p>\r\n<h3>Amazing, Commited Mentors</h3>\r\n<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry.</p>" % infographic.url,
    position: 5,
    display_type: "img-left"
  },
  {
    refinery_page_id: home_page.id,
    title: "Share",
    body: "<h2>Share this!</h2>\r\n<p><img src=\"%s\" title=\"Sharing Options\" alt=\"Sharing Options\" data-rel=\"225x255\" width=\"275\" height=\"65\" /></p>" % sharing_options.url,
    position: 11
  },
  {
    refinery_page_id: home_page.id,
    title: "Events",
    body: "<h2>Events</h2>\r\n<h3>Check out one of our  mobilization events, webinars, or fundraisers!</h3>",
    position: 12
  },
  {
    refinery_page_id: home_page.id,
    title: "Support",
    body: "<h2>Support IPO</h2>\r\n<h3>Give to students &amp; projects or tell the World about us!</h3>",
    position: 13
  }])

