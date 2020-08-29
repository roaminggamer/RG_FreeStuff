-- =============================================================
-- Game Module
-- =============================================================
game = {}

-- =============================================================
-- Function Localizations
-- =============================================================
-- Commonly used Lua & Corona Functions
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs; local mFloor = math.floor; local mCeil = math.ceil
local strGSub = string.gsub; local strSub = string.sub
-- Common SSK Features
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert

-- =============================================================
-- Locals
-- =============================================================
local layers
local unsolvedPieces = {}
local ignoringTouches = false
local maxRows = 5
local maxCols = 5

-- =============================================================
-- Function Forward Delcarations 
-- =============================================================
local preparePuzzle
local onTwoTouchLeft
local onTwoTouchRight


-- =============================================================
-- Module Function Definitions
-- ============================================================

--
-- Create game
--
function game.create( group, puzzleNum )

    -- Use destroy to prep and ensure game is in clean state
	game.destroy()
	
    -- Create display groups in layers suited to our needs.
	layers = ssk.display.quickLayers( group,  "underlay", "input", "solvedPuzzle", "singlePiece", "overlay" )
    
    -- Adjust position of solved and single_piece puzzle groups to be centered on screen
    layers.solvedPuzzle.x = centerX
    layers.solvedPuzzle.y = centerY
    layers.singlePiece.x = centerX
    layers.singlePiece.y = centerY

    -- Draw an underlay image with a repeating fill
    display.setDefault( "textureWrapX", "repeat" )
    display.setDefault( "textureWrapY", "repeat" )
    local back = newImageRect( layers.underlay, centerX, centerY, "images/back1.png", { w = fullw, h = fullh } ) 
    back.fill.scaleX = 0.15
    back.fill.scaleY = 0.15
    display.setDefault( "textureWrapX", "clampToEdge" )
    display.setDefault( "textureWrapY", "clampToEdge" )

    -- Prepare the puzzle
    preparePuzzle( layers.solvedPuzzle, layers.singlePiece, puzzleNum )

    -- Use SSK 'easyInputs' two-touch builder to create a split-screen two-button input for rotating left and right
    -- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/easy_inputs/
    ssk.easyInputs.twoTouch.create( layers.input, { debugEn = _G.enableDebugSettings , keyboardEn = true } )
   
    -- Add arrow images as 'HINTS' to users to persist
    local arrow = newImageRect( layers.overlay, right - 60, bottom - 80, "images/arrowRight.png", { size = 140, alpha = 0.5 }  )
    local arrow = newImageRect( layers.overlay, left + 60, bottom - 80, "images/arrowLeft.png", { size = 140, alpha = 0.5 }  )

    -- Define listeners and start listening for events from the two-touch helper easy input
    onTwoTouchRight = function( event )
        if( event.phase == "ended" ) then
            ignoringTouches = True
            local function onComplete( )
                -- Ensure rotation is in range [0,360) e.g. Normalized rotation
                normRot( layers.solvedPuzzle )
                ignoringTouches = False
            end
            transition.to( layers.solvedPuzzle, { rotation = layers.solvedPuzzle.rotation + 90, time = 350, transition = easing.outQuad, onComplete = onComplete })
        end
        return true
    end
    listen("onTwoTouchRight", onTwoTouchRight)

    onTwoTouchLeft = function( event )
        if( event.phase == "ended" ) then
            ignoringTouches = True
            local function onComplete( )
                -- Ensure rotation is in range [0,360) e.g. Normalized rotation
                normRot( layers.solvedPuzzle )
                ignoringTouches = False
            end
            transition.to( layers.solvedPuzzle, { rotation = layers.solvedPuzzle.rotation - 90, time = 350, transition = easing.outQuad, onComplete = onComplete })
        end
        return true
    end
    listen("onTwoTouchLeft", onTwoTouchLeft)

end

--
-- Destroy game and clean up
--
function game.destroy( )
	display.remove(layers)
	layers = nil

    unsolvedPieces = {}

    ignoringTouches = false

    if( onTwoTouchLeft ) then
        ignore("onTwoTouchLeft", onTwoTouchLeft)
        onTwoTouchLeft = nil
    end

    if( onTwoTouchRight ) then
        ignore("onTwoTouchRight", onTwoTouchRight)
        onTwoTouchRight = nil
    end
end

-- =============================================================
-- (Private) Function Definitinos
-- =============================================================

--
-- Function to build puzzle and prepare if for game play
--
preparePuzzle = function( solvedGroup, singlePieceGroup, puzzleNum )

    -- Declare some variables for ensure visibility throughout function.    
    local slices

    -- Assemble 'puzzlePath' from path strings and puzzle number.
    local puzzlePath = "images/puzzles/p" .. tostring(puzzleNum) .. ".png"

    -- Ensure that rotated solved puzzle will be visible in any rotation, by scaling
    local scale = ( fullw > fullh ) and fullh/300 or fullw/240
    scale = scale * 0.9
    --
    -- Puzzle Piece Touch Handler
    --
    local function puzzlePieceTouch( self, event )
        -- If ignoring touches, do nothing.
        if( ignoringTouches ) then return true end
        
        if(event.phase == "ended") then
            -- table.dump(self) -- debug feature added by SSK to dump content of table

            -- If solveGroup rotated to matching position for this piece, then put piece back, transition it.
            -- If more pieces remain, show next piece or do 'solved' action(s).
            if( self.matchRotation == solvedGroup.rotation ) then
                -- Stop listening to touches for this piece.
                self:removeEventListener("touch")

                ignoringTouches = True

                -- On complete
                local function onComplete()
                    -- remove last piece
                    table.remove(unsolvedPieces)

                    if( #unsolvedPieces > 0 ) then
                        -- show next piece and stop ignoring touches
                        unsolvedPieces[#unsolvedPieces].isVisible = true
                        ignoringTouches = False
                    else
                        print( "Solved" )
                        local function onRotationComplete()
                            -- Dispatch 'onSolved' event so any listener can catch it.
                            post("onSolved")
                        end
                        transition.to( solvedGroup, { rotation = 0, onComplete = onRotationComplete })
                    end

                end
                solvedGroup:insert(self)
                self.rotation = 0
                transition.to( self, { x = self.x0, y = self.y0, time = 250, onComplete = onComplete} )
            
            -- Wrong!  Jiggle screen: https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/misc/#easyshake
            --         Tip: Amplitude and Time are in wrong order in docs.
            --
            else
                ignoringTouches = true
                ssk.misc.easyShake( layers, 10, 500, 0 )
                timer.performWithDelay( 750, function() ignoringTouches = false end)
            end
        end
        return true
    end

    -- Create puzzle (using SSK game logic helper); Cuts an image up into rectangles, where each rectangle 
    -- is a portion of the whole image.
    --
    -- Returns display group, containing puzzle pieces.
    --
    -- I (RG) used this helper to simplify makig the example.  It is NOT YET documented in the SSK guide and 
    -- I don't think you'll end up needing it.
    local puzzle = ssk.logic.grid.createImageGrid( solvedGroup, 0, 0, puzzlePath, 
                                                   { w = 300 * scale, h = 240 * scale, rows = maxRows, cols = maxCols, 
                                                     destroyLast = false,  touch = puzzlePieceTouch } )

    -- Grab slices table from the 'puzzle'.    
    slices = puzzle.slices -- 'slices' was declared at top of function ...

    -- Table of legal 'matching' rotations.
    local rotations = { 0, 90, 180, 270 }

    -- Operate on all pieces:
    for _, piece in pairs(slices) do
        -- Save solved position
        piece.x0 = piece.x
        piece.y0 = piece.y

        -- If this is a non-border piece, 
        if( piece.row > 1 and piece.row < maxRows and piece.col > 1 and piece.col < maxCols) then

            -- A Choose a random solved rotation
            piece.matchRotation = rotations[ math.random(1,4) ]
            piece.rotation = piece.matchRotation

            -- B. Choose copy reference to piece in unsolvedPieces table
            unsolvedPieces[#unsolvedPieces+1] = piece

            -- C. Move Piece to single piece group at <0, 0>
            singlePieceGroup:insert( piece )
            piece.x = 0
            piece.y = 0

            -- D. Hide the piece
            piece.isVisible = false
        else
            -- Remove the touch listener from border pieces
            piece:removeEventListener("touch")

        end
    end

    -- Re-show the last solved-piece.
    unsolvedPieces[#unsolvedPieces].isVisible = true
    -- table.dump(puzzle)  -- debug feature added by SSK to dump content of table

end



return game