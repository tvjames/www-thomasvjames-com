# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
# http://learn.bevry.me/queryengine/guide#-beginswith-aka-startswith-
moment = require('moment')

docpadConfig = {
	environments:
		static:
			templateData:
				site:
					url: "http://www.thomasvjames.com"
	templateData:
		production:
			url: "http://www.thomasvjames.com"
			github: "https://github.com/tvjames/www-thomasvjames-com/tree/master"
		site:
			title: "thomasvjames.com"
			archives: ""
			styles: [
				"/css/foundation.css",
				"/css/default.css"
			]
			scripts: [
				"/js/vendor/jquery.js",
				"/js/vendor/jquery.tagcloud.js",
				"/js/foundation.min.js"
			]
			sections: [
				{title: "links", links: [
					{text: "Photography", alt: "Photography", href: "http://www.thomasvjames.com/photography"}
				]}
			]
			disqus:
				shortname: "www-thomasvjames-com"
			authors:
				tvjames:
					name: "Thomas James"
					email: "thomasvjames@gmail.com"
					href: (site) -> site.url + "/about"

		getPreparedTitle: -> if @document.title then "#{@document.title} | #{@site.title}" else @site.title
		getPreparedDisqusUrl: -> @production.url + @document.url
		getPreparedDisqusShortname: -> @site.disqus.shortname
		getPreparedRssUrl: -> @site.url + '/rss.xml'
		getPreparedEmail: -> "mailto:#{@site.authors.tvjames.email}"
		getPreparedArchiveUrl: (archive) -> @site.url + @site.archives + "/" + archive
		getPreparedTagUrl: (tag) -> @site.url + "/tag/" + tag.toLowerCase().replace(/[^a-z0-9]/g, '-').replace(/-+/g, '-').replace(/^-|-$/g, '')
		getPreparedCategoryUrl: (category) -> @site.url + "/category/" + category.toLowerCase().replace(/[^a-z0-9]/g, '-').replace(/-+/g, '-').replace(/^-|-$/g, '')
		getPreparedPostForkUrl: (doc) -> @production.github + "/src/documents/" + doc.relativePath
		getNavClass: (page) -> if (page.id is @document.id or @document.active is page.nav) then 'active' else 'inactive'
		getAuthor: (author) -> @site.authors[author]
		getGravatarUrl: (email, size, type, rating) ->
			hash = require('crypto').createHash('md5').update(email).digest('hex')
			url = "//www.gravatar.com/avatar/#{hash}?"
			if size then url += "s=#{size}&"
			if type then url += "d=#{type}&"
			if rating then url += "r=#{rating}"
			return url
		getTagCloud: -> []

	collections:
		pages: ->
			collection = @getCollection("html").findAllLive({title: $exists: true})
			collection.on "add", (model) ->
					model.setMetaDefaults({layout:"default"})
		nav: ->
			@getCollection("html").findAllLive({nav: $exists: true},[{filename:1}])
		posts: ->
			parent = @
			collection = @getCollection("html").findAllLive({relativeOutDirPath: 'posts'},[{date:-1}])
			collection.on "add", (model) ->
				dateMoment = moment(model.get('date'))
				model.setMetaDefaults({
					active: "Archive",
					author: "tvjames",
					archiveYear: dateMoment.format('YYYY'),
					archiveYearMonth: dateMoment.format('YYYY-MM')})
		cleanurls: (database) ->
			database.findAllLive() #({$or: {layout: {$exists: true}, layout: {$exists: true} }})

	plugins:
		cleanurls:
			collectionName: 'cleanurls'
		moment:
			formats: [
				{raw: 'date', format: 'MMMM Do YYYY', formatted: 'humanDate'}
				{raw: 'date', format: 'YYYY-MM-DD', formatted: 'computerDate'}
			]
		dateurls:
			cleanurl: true
			trailingSlashes: true
			dateFormat: '/YYYY/MM'
		rss:
			default:
				collection: 'posts'
				url: '/rss.xml' # optional, this is the default
		alias:
			hard: false
			aliases: {
				'/rss.xml': '/feed/index.html'
			}
		tagcloud:
			databaseCache: false
		tags:
			relativeDirPath: 'tag'
			extension: '.html.eco'
			injectDocumentHelper: (document) ->
				document.setMeta(
					layout: 'page'
					data: """
						<%- @partial('tag', @) %>
						"""
				)
		category:
			relativeDirPath: 'category'
			metaProperty: 'categories'
			extension: '.html.eco'
			injectDocumentHelper: (document) ->
				document.setMeta(
					layout: 'page'
					data: """
						<%- @partial('category', @) %>
						"""
				)
		archive:
			findCollectionName: 'posts'
			relativeDirPath: ''
			extension: '.html.eco'
			injectDocumentHelper: (document) ->
				document.setMeta(
					layout: 'page'
					data: """
						<%- @partial('archives', @) %>
						"""
				)
}

# Export the DocPad Configuration
module.exports = docpadConfig
