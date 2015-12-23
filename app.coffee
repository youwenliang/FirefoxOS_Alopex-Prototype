# This imports all the layers for "Alopex Mockup" into alopexMockupLayers7
sketch = Framer.Importer.load "imported/Alopex Mockup"

# Initialization
sketch.Screen.x = 0
sketch.Screen.y = 47
sketch.Screen.width = 753

sketch.SearchBar.x = -1
sketch.SearchBar.y = 47
sketch.SearchBar.width = 752
sketch.SearchBar.bringToFront()

sketch.Icon.opacity = 0

sketch.NavBar.x = 0
sketch.NavBar.y = 1220
sketch.NavBar.bringToFront()

sketch.statusBar.x = 0
sketch.statusBar.y = 0

sketch.Notification.x = 0
sketch.Notification.y = 47
sketch.Notification.sendToBack()

searchText = new Layer
	superLayer:  sketch.search
	width: sketch.search.width
	backgroundColor: null
	html: "Search the Web"
	style: {
		"padding-top": "45px"
		"font-size": "26pt"
		"text-align" : "center"
		"font-family" : "Fira Sans"
	}

sketch.NavBar.draggable.enabled = true
sketch.NavBar.draggable.speedX = 0
sketch.NavBar.draggable.speedY = 0

# Drag Notification
sketch.statusBar.draggable.enabled = true
sketch.statusBar.draggable.speedX = 0
sketch.statusBar.draggable.speedY = 0

# Interaction Stages
stage = "home"
pagerCount = 1
pages = []

# page swipes
pager = new PageComponent
	width: Screen.width
	height: Screen.height
	backgroundColor: null
	scrollVertical: false
	scrollHorizontal: false
	directionLock: true
	
pager.addPage sketch.Screen
pages.push(sketch.Screen)
pager.placeBehind sketch.statusBar

current = pager.currentPage

pager.on "change:currentPage", ->
	current = pager.currentPage
	i = pager.horizontalPageIndex(current)

	if i == 0
		stage = "home"
		searchText.html = "Search the Web"
		sketch.Icon.animate
			properties:
				opacity: 0
			delay: .6
			time: .4
		sketch.Arrow.animate
			properties:
				opacity: 0
			delay: .6
			time: .4
	else 
		searchText.html = appObjs[current.name].url
		sketch.Icon.placeBehind searchText
		sketch.Icon.animate
			properties:
				opacity: 1
			time: .2
		sketch.Arrow.animate
    		properties: 
	    		opacity: 1
			time: .2
			
# pager.draggable.enabled = true
# pager.draggable.speedX = 0
# 
# pager.draggable.maxDragFrame = pager.frame
# pager.draggable.maxDragFrame.height *= 2
# 
# # If dragged beyond half of screen, swipe
# pager.on Events.DragStart, ->
# 	# sketch.Notification.placeBefore background
# pager.on Events.DragEnd, ->
#   if pager.y > ((@).height / 3)
#     pager.animate
#       properties:
#         y: Screen.height
#       curve: "ease"
#       time: 0.6
#   else
#     pager.animate
#       properties:
#         y: 0
#       curve: "spring(200,30,0)"

# background
background = new Layer
	width: Screen.width
	height: Screen.height
	backgroundColor: "#000"
background.placeBehind pager

sketch.SearchBar.states.add
	stateA:
		y:47
		opacity:1
	stateB:
		y:-150
		opacity:0

pager.states.add
    stateA:
        y: 0
    stateB:
    	y: Screen.height

sketch.statusBar.on Events.DragStart, (e) ->
	pager.states.switch("stateB", time: .6, curve: "ease-in")
	sketch.Notification.placeBefore background
	stage = "noti"

tabScroll = new ScrollComponent
	width: Screen.width
	height: Screen.height
	backgroundColor: null
	visible: false
    
sketch.NavBar.on Events.DragStart, (e) ->
	if stage == "noti"
		pager.states.switch("stateA", time: 1, curve: "spring(200,35,0)")
		sketch.SearchBar.states.switch("stateA", time: .4, delay: .6)
		pager.scrollHorizontal = false
		stage = "home"
# 	else if stage != "noti"
# 		print pagerCount
# 		print pages
# 		i = 0
# 		currentMask = new Layer
# 			superLayer: current
# 			width: current.width
# 			height: current.height
# 			y: 150
# 			backgroundColor: appObjs[current.name].color
# 			opacity: 0
# 		
# 		for app in pages
# 			i++
# 			if app == current || pagerCount == 1
# 			else
# 				tabs = app.copy()
# 				tabScroll.visible = true
# 				tabScroll.content.addSubLayer tabs
# 				print tabs
# 				tabs.frame = app.screenFrame
# 				tabs.placeBehind sketch.NavBar
# 				sketch.NavBar.bringToFront()
# 				mask = new Layer
# 					superLayer: tabs
# 					width: tabs.width
# 					height: tabs.height
# 					y: 150
# 					backgroundColor: appObjs[tabs.name].color
# 					opacity: .5
# 					
# 					
# 				tabs.x = 0
# 				tabs.y = Screen.height
# 				if pagerCount > 4
# 					move = (Screen.height-118)/4
# 				else
# 					move = (Screen.height-118)/pagerCount
# 				tabs.animate
# 					properties:
# 						y : i*move
# 					time: .6
# 				sketch.SearchBar.states.switch("stateB", time: .6, delay: .4+.2*(pagerCount-2))
# 				currentMask.animate
# 					properties:
# 						opacity: .5
# 					time: .6
# 					delay: .4+.2*(pagerCount-2)
# 				stage = "tabs"
		# Tabs
pager.on Events.StateDidSwitch, (previousState, newState) ->
	return if previousState == newState
	if newState == "stateA"
		sketch.Notification.placeBehind background
		pager.scrollHorizontal = true
	else
		sketch.SearchBar.states.switch("stateB", time: .6)


	

# App information
appObjs = {
	contacts:{"color":"f18a22", "icon": sketch.Icon1, "name": "Contacts", "content": sketch.contacts, "url": "contacts.gaiamobile.org"},
	theverge:{"color":"cd2477", "icon": sketch.Icon2, "name": "The Verge", "content": sketch.theverge, "url":"theverge.com" },
	teamliquid:{"color":"8ab0e8", "icon": sketch.Icon3, "name": "Team Liquid", "content": sketch.teamliquid, "url":"teamliquid.com"},
	vine:{"color":"55bd94", "icon": sketch.Icon4, "name": "Vine", "content": sketch.vine, "url":"vine.com"},
	camera:{"color":"3361b0", "icon": sketch.Icon5, "name": "Camera", "content": sketch.camera, "url":"camera.gaiamobile.org"},
	nytimes:{"color":"000000", "icon": sketch.Icon6, "name": "The New York Times", "content": sketch.nytimes, "url":"nytimes.com"},
	wired:{"color":"FFFFFF", "icon": sketch.Icon7, "name": "Wired", "content": sketch.wired, "url":"wired.com"},
	bbc:{"color":"9d140e", "icon": sketch.Icon8, "name": "BBC", "content": sketch.bbc, "url":"bbc.com" },
	huffingtonpost:{"color":"2e7161", "icon": sketch.Icon9, "name": "Huffington Post", "content": sketch.huffingtonpost, "url":"huffingtonpost.com"},
	marketplace:{"color":"eb9202", "icon": sketch.Icon10, "name": "Facebook", "content": sketch.marketplace, "url":"marketplace.gaiamobile.org"},
	kotaku:{"color":"431f26", "icon": sketch.Icon11, "name": "Kotaku", "content": sketch.kotaku, "url":"kotaku.com"},
	squarespace:{"color":"FFFFFF", "icon": sketch.Icon12, "name": "Squarespace", "content": sketch.squarespace, "url":"squarespace.com"},
	Screen: {"color":"3f3f3f", "url":"Search the Web"}
}

appScroll = []

scroll = ScrollComponent.wrap sketch.scroll
scroll.scrollHorizontal = false
scroll.directionLock = true
scroll.contentInset =
    bottom: 70
scroll.on Events.Scroll, ->
    if scroll.scrollY <=0 then scroll.scrollY = 0

sketch.Arrow.opacity = 0

# Home Click Event
sketch.Home.on Events.Click, ->
    if stage == "home"
        scroll.draggable.enabled = false
        scroll.animate
            properties:
                scrollY: 0
            time: .5
            curve: "spring(200,35,0)"
        scroll.on Events.AnimationEnd, ->
            scroll.draggable.enabled = true
    else if stage == "app"
    	pager.snapToPage sketch.Screen, true
    	stage = "home"
    		    		
# Back Click Event
sketch.Arrow.on Events.Click, ->
	pager.snapToNextPage("left", true)
	current = pager.currentPage
	i = pager.horizontalPageIndex(current)
	if i == 0
    	stage = "home"

# Set directionLock and threshold
scroll.content.draggable.directionLock = true
scroll.content.draggable.directionLockThreshold = {x:25, y:25}
    	
# Dynamically creating apps
apps = []
for i in [0 .. 11]
    apps.push new Layer
        superLayer: scroll.content
        midX: 140+(i%3)*235
        midY: 279+Math.floor(i/3)*276
        height: 221
        width: 221
        name: Object.keys(appObjs)[i]
        backgroundColor: null
        # backgroundColor: appObjs[Object.keys(appObjs)[i]].color
        style: {"overflow":"visible"}
    apps[i].placeBehind sketch.Icons
    appObjs[Object.keys(appObjs)[i]].content.sendToBack()
    appScroll.push ScrollComponent.wrap appObjs[Object.keys(appObjs)[i]].content.subLayers[0]
    appScroll[i].scrollHorizontal = false
#     textbox = new Layer
#         superLayer: apps[i]
#         width: 221
#         height: 40
#         y: 230
#         backgroundColor: null;
#         style: {
#             "font-size": "15pt"
#             "font-family" : "Fira Sans"
#         }
#         html: appObjs[apps[i].name].name


for app in apps
    app.on Events.Click, (event, layer)->
        if not scroll.isMoving and stage == "home" and pager.isMoving == false
            # print stage
            currentIcon = appObjs[layer.name].icon.copy()
            currentIcon.frame = appObjs[layer.name].icon.screenFrame
            currentApp = layer.copy()
            currentApp.backgroundColor = appObjs[layer.name].color
            currentApp.bringToFront()
            currentIcon.placeBefore currentApp
            currentApp.frame = layer.screenFrame

            currentApp.animate
                properties:
                    scale: 20
                time: 1.2
                curve: "ease-out"
            currentIcon.animate
                properties:
                    scale: 1.6
                time: .4
                curve: "ease-out"

            Utils.delay .2, () ->
                currentIcon.animate
                    properties:
                        opacity: 0
                    time: .6

            Utils.delay .8, () ->
                # appContents.visible = true
                appObjs[layer.name].content.x = 0
                appObjs[layer.name].content.y = 47
                appObjs[layer.name].content.width = 753
                # appObjs[layer.name].content.superLayer = appContents
                appObjs[layer.name].content.placeBefore sketch.Screen
                copy = appObjs[layer.name].content.copy()
                copy.frame = appObjs[layer.name].content.screenFrame
                searchText.html = appObjs[layer.name].name

                pager.addPage copy
                pager.scrollHorizontal = true
                pages.push(copy)
                pagerCount++
                pager.snapToPage copy, false
                currentApp.animate
                    properties:
                        opacity: 0
                    time: .5
                currentApp.on Events.AnimationEnd, ->
                    currentApp.destroy()
                    currentIcon.destroy()
                    stage = "app"
