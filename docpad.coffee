# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {
	templateData:
		site:
			title: "thomasvjames.com"

		getPreparedTitle: -> if @document.title then "#{@document.title} | #{@site.title}" else @site.title

	collections:
		pages: -> @getCollection("html").findAllLive({isPage:true}).on "add", (model) -> model.setMetaDefaults({layout:"default"})
		posts: -> @getCollection("html").findAllLive({post:true})

	plugins:
		plugins:
			moment:
				formats: [
					{raw: 'date', format: 'MMMM Do YYYY', formatted: 'humanDate'}
					{raw: 'date', format: 'YYYY-MM-DD', formatted: 'computerDate'}
				]
		rss:
			default:
				collection: 'posts'
				url: '/rss.xml' # optional, this is the default
}

# Export the DocPad Configuration
module.exports = docpadConfig
