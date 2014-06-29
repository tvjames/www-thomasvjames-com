# Forked from: https://github.com/docpad/docpad-plugin-tags
# Copyright © 2013+ Bevry Pty Ltd us@bevry.me (http://bevry.me)
# Additions/Modifications Copyright © 2014+ Thomas James <thomasvjames@gmail.com> (https://github.com/tvjames)
# Export
module.exports = (BasePlugin) ->
	# Define
	class ArchivePlugin extends BasePlugin
		# Name
		name: 'archive'

		# Archives
		archives: null

		# Config
		config:
			relativeDirPath: "archive"
			extension: ".json"
			injectDocumentHelper: null
			collectionName: "archives"
			findCollectionName: "database"
			logLevel: 'info'

		# Setup archives object
		constructor: ->
			@archives ?= {}
			super


		# =============================
		# Events

		# Extend Collections
		# Create our live collection for our archives
		extendCollections: ->
			# Prepare
			plugin = @
			config = @getConfig()
			docpad = @docpad

			console.log "extendCollections"

			# Create the collections for the archives
			docpad.setCollection config.collectionName, docpad.getDatabase().findAllLive({
				archivePath: $exists: true
			}, [title:1])

			console.log "extendCollections collection #{config.collectionName} created"

			# Listen for year archive-able pages
			docpad.getCollection(config.findCollectionName).findAllLive({archiveYear: $exists: true}).on 'add', (model) ->
				# Prepare
				archiveForYear = model.get('archiveYear') or ""

				console.log "extendCollections collection found #{archiveForYear} #{model.get('filename')}"

				# Check
				return  if archiveForYear.length is 0

				# Add the document tags to the index
				path = archiveForYear
				plugin.archives[archiveForYear] ?= plugin.createArchiveDocument archiveForYear, null, path, (err) ->
					docpad.error(err)  if err

				# Complete
				return true

			# Listen for year-month archive-able pages
			docpad.getCollection(config.findCollectionName).findAllLive({archiveYearMonth: $exists: true}).on 'add', (model) ->
				# Prepare
				archiveForYearMonth = model.get('archiveYearMonth') or ""

				console.log "extendCollections collection found #{archiveForYearMonth} #{model.get('filename')}"

				# Check
				return  if archiveForYearMonth.length is 0

				# Add the document tags to the index
				path = archiveForYearMonth.replace(/-/g, '/')
				plugin.archives[archiveForYearMonth] ?= plugin.createArchiveDocument null, archiveForYearMonth, path, (err) ->
					docpad.error(err)  if err

				# Complete
				return true

			console.log "extendCollections collection #{config.findCollectionName} subscribed"
			# Chain
			@

		# Create Tag Document
		createArchiveDocument: (year, yearMonth, path, next) ->
			console.log "Creating archive page for #{year ? yearMonth} at #{path}"

			# Prepare
			plugin = @
			config = @getConfig()
			docpad = @docpad

			# Fetch
			document = docpad.getFile({archiveForYear:year, archiveForYearMonth: yearMonth})

			# Create
			documentAttributes =
				data: JSON.stringify({archiveForYear:year, archiveForYearMonth: yearMonth}, null, '\t')
				meta:
					mtime: new Date()
					title: "Archive for #{year ? yearMonth}"
					archivePath: path
					archiveForYear: year
					archiveForYearMonth: yearMonth
					relativePath: "#{config.relativeDirPath}#{path}#{config.extension}"

			# Existing document
			if document?
				document.set(documentAttributes)

			# New Document
			else
				# Create document from opts
				document = docpad.createDocument(documentAttributes)

			# Inject helper
			config.injectDocumentHelper?.call(plugin, document)

			# Load the document
			document.action 'load', (err) ->
				# Check
				return next(err)  if err

				# Add it to the database (with b/c compat)
				docpad.addModel?(document) or docpad.getDatabase().add(document)

				# Log
				docpad.log(config.logLevel, "Created archive page for #{year ? yearMonth} (#{path}) at #{document.getFilePath()}")

				# Complete
				return next()

			# Return the document
			return document