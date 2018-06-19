-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
--呼叫composer函式庫
local composer = require( "composer" )
collectgarbage("collect")
--導入土星
local sheetInfo = require("saturn")
--呼叫BitmapFont函式庫
local BFont = require("BitmapFont")
--導入字型
local titleFont = BFont.new("GameTitle.png")
local menuFont = BFont.new("Menu.png")

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--設定Ｘ中心點
local centerX = display.contentCenterX
--設定Ｙ中心點
local centerY = display.contentCenterY
--建立background群組
local backgroundGroup = display.newGroup()
--建立menu群組
local menu=display.newGroup()
--建立layer群組
local layerGroup = display.newGroup()
--定義計時器
local tPrevious = system.getTimer()
local checkMemoryTimer 
--檢查解析度
local imageSuffix = display.imageSuffix
print( imageSuffix  )
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 --讀取聲音
 sounds = {
  menu = audio.loadSound("menu.mp3"),
  start = audio.loadSound("start.wav"),
}
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local bg = display.newImageRect( "background_Green.jpg", 480, 320 )
    local bg1 = display.newImageRect( "background_Green.jpg", 480, 320 )
       bg.anchorX = 0
       bg.x = 0
       bg.y = centerY
       bg.speed = 1 --新增速度
       bg1.anchorX = 0
       bg1.x = 480
       bg1.y=centerY
       bg1.speed = 1
       backgroundGroup:insert(display.newGroup(bg,bg1))
       sceneGroup:insert(backgroundGroup)
    local layer1 = display.newImageRect( "spaceLayer1.png", 480, 320 )
    local layer2 = display.newImageRect( "spaceLayer2.png", 480, 320 )
       layer1.anchorX = 0
       layer1.x = 0
       layer1.y = centerY
       layer1.speed = 1.5
       layer2.anchorX = 0
       layer2.x = 480
       layer2.y=centerY
       layer2.speed = 2
       layerGroup:insert(display.newGroup(layer1,layer2))
       sceneGroup:insert(layerGroup)  

    --土星
    local saturnSheet = graphics.newImageSheet( "saturn.png", sheetInfo:getSheet() )
    local SaturnOptions = {
    
        name = "saturn",
        sheet = saturnSheet,
        start = sheetInfo:getFrameIndex("saturn1"),
        count = 8,   --張數
        time = 1000, --轉換時間,1000＝１秒
        loopCount=0
    }

    local Saturn = display.newSprite( saturnSheet, SaturnOptions)
    Saturn.x=centerX*0.4
    Saturn.y=centerY*0.7
    Saturn.xScale = 0.5 --Ｘ軸縮放比例
    Saturn.yScale = 0.5 --Ｙ軸縮放比例
    Saturn:play()
    
    sceneGroup:insert(Saturn)

    --星光
  

    --標題Ｘ位置,Ｙ位置,內容
    title = titleFont:newBitmapString(centerX,0, "Catchdog" )
  
    sceneGroup:insert(title)
    
    --Menu
    
    local menuPlay= menuFont:newBitmapString(0,centerY*1.2, " START" )
    menuPlay.name="play"
    local menuExit= menuFont:newBitmapString(0,centerY*1.6, "Exit" )
    menuExit.name="exit"

    menu:insert(menuPlay)--menu群組加入menuPlay
    menu:insert(menuExit)--menu群組加入menuExit
    
    sceneGroup:insert(menu)
end
--設置移動功能
local function move(event)
    local tDelta = event.time - tPrevious
    tPrevious = event.time
local i
--背景的移動功能,並檢測背景是否完全超出左側螢幕,如果是擇立即移動到畫面右側螢幕
    for i = 1, backgroundGroup.numChildren do
        backgroundGroup[i][1].x = backgroundGroup[i][1].x - backgroundGroup[i][1].speed / 10*tDelta
        backgroundGroup[i][2].x = backgroundGroup[i][2].x - backgroundGroup[i][2].speed / 10*tDelta
        if (backgroundGroup[i][1].x +backgroundGroup[i][1].contentWidth) < 0 then
            backgroundGroup[i][1]:translate( 480 * 2, 0)
        end
         if (backgroundGroup[i][2].x +backgroundGroup[i][2].contentWidth) < 0 then
            backgroundGroup[i][2]:translate( 480 * 2, 0)
        end     
    end
    for i = 1, layerGroup.numChildren do
        layerGroup[i][1].x =layerGroup[i][1].x-layerGroup[i][1].speed /10*tDelta
        layerGroup[i][2].x =layerGroup[i][2].x-layerGroup[i][2].speed /10*tDelta
        if (layerGroup[i][1].x +layerGroup[i][1].contentWidth) < 0 then
            layerGroup[i][1]:translate( 480 * 2, 0)

        end
        if (layerGroup[i][2].x +layerGroup[i][2].contentWidth) < 0 then
            layerGroup[i][2]:translate( 480 * 2, 0)

        end
    end
 end

--換場景的功能
 local function changeScene()
  print("changeScene")
   composer.gotoScene("game",{effect ="fade",time=400}) --變換場景至game
end
--觸碰事件
local function menuTouch(event)
  if event.phase=="began" then
    print("touch_"..event.target.name)
    if event.target.name == "play" then
      audio.play( sounds.start,{channel=2,onComplete = function() 
                                      audio.dispose( sounds.start ) 
                                      sounds.start=nil
                                      end})
      transition.to(menu,  {time = 400, x = 480+event.target.contentWidth/2,onComplete = changeScene})
    else
      os.exit ( )
    end
    for i = 1, menu.numChildren do
          menu[i]:removeEventListener("touch",menuTouch)
        end
  end
end

--將menu群組中的兩個圖(menuPlay,menuExit)加上touch監聽事件
local function addTouch( )
  for i = 1, menu.numChildren do
          menu[i]:addEventListener("touch",menuTouch)
    end
end

 local function checkMemory()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        Runtime:addEventListener( "enterFrame", move )
        transition.to(title,  {time = 400, y = centerY*0.6})
        transition.to(menu,  {time = 400, x = centerX,onComplete = addTouch})--將menu群組的x座標移往centerX,移動完成呼叫addTouch函式
    elseif ( phase == "did" ) then
      -- Code here runs when the scene is entirely on screen
        composer.removeScene("game") --移除上個場景
        print("menu")
        
        audio.play( sounds.menu, { channel=1, loops=-1})
        
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        audio.stop(1)

        audio.dispose( sounds.menu )
        sounds.menu = nil

        Runtime:removeEventListener( "enterFrame", move )
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    print("destroy_menu")
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene

