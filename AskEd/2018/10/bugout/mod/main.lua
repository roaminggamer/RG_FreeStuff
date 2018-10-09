background = display.newImage("background.png")
background.x = 250
background.y = 160
btnStart = display.newImage("button.png")
btnStart.x = 250
btnStart.y = 250
btnStart.xScale = 0.4
btnStart.yScale = 0.2
floorLvl = 0
strStart = "Start"
textTitle = "Dungeon"
textTitle2 = "Delver"
textStart = display.newText(strStart, 250, 250, "SKB.ttf", 36)
textTitle = display.newText(textTitle, 225, 115, "SKB.ttf", 48)
textTitle2 = display.newText(textTitle2, 300, 150, "SKB.ttf", 48)

--x 240 y 160 center of grid or GX
A = 10
B = 46
C = 86
D = 125
E = 163
F = 201
G = 240
H = 278
I = 317
J = 354
K = 393
L = 432
M = 470
Z = 63
Y = 112
X = 162
W = 210
V = 260

	function layoutOpt1 (event)
		ob1 = display.newImage("TLCorner.png")
			ob1.xScale = 0.45
			ob1.yScale = 0.45
			ob1.x = 201
			ob1.y = 112
		ob2 = display.newImage("TMidCent.png")
			ob2.xScale = 0.45
			ob2.yScale = 0.45
			ob2.x = 240
			ob2.y = 112
		ob3 = display.newImage("TRCorner.png")
			ob3.xScale = 0.45
			ob3.yScale = 0.45
			ob3.x = 278
			ob3.y = 112
		ob4 = display.newImage("StubLeft.png")
			ob4.xScale = 0.45
			ob4.yScale = 0.50
			ob4.x = 160
			ob4.y = 158
		ob5 = display.newImage("mid.png")
			ob5.xScale = 0.45
			ob5.yScale = 0.55
			ob5.x = 201
			ob5.y = 157
		ob6 = display.newImage("mid.png")
			ob6.xScale = 0.45
			ob6.yScale = 0.55
			ob6.x = 240
			ob6.y = 157
		
		
	end
	function Start (event)
	
		floorLvl = 1
		btnStart.isVisible = false
		textStart.isVisible = false
		background.isVisible = false
		textTitle.isVisible = false
		textTitle2.isVisible = false
		room = display.newImage("room.png")
		room.x = 240
		room.y = 160
		room.xScale = 1.55
		room.yScale = 1.55
		sprPlayer = display.newImage("Player.png")
		sprPlayer.x = G
		sprPlayer.y = X
		sprPlayer.xScale = 0.5
		sprPlayer.yScale = 0.5
		mveSqrTL = display.newImage("movementSQR.png")
			mveSqrTL.xScale = 0.65
			mveSqrTL.yScale = 0.65
		mveSqrL = display.newImage("movementSQR.png")
			mveSqrL.xScale = 0.65
			mveSqrL.yScale = 0.65
		mveSqrBL = display.newImage("movementSQR.png")
			mveSqrBL.xScale = 0.65
			mveSqrBL.yScale = 0.65
		mveSqrB = display.newImage("movementSQR.png")
			mveSqrB.xScale = 0.65
			mveSqrB.yScale = 0.65
		mveSqrT = display.newImage("movementSQR.png")
			mveSqrT.xScale = 0.65
			mveSqrT.yScale = 0.65
		mveSqrTR = display.newImage("movementSQR.png")
			mveSqrTR.xScale = 0.65
			mveSqrTR.yScale = 0.65
		mveSqrR = display.newImage("movementSQR.png")
			mveSqrR.xScale = 0.65
			mveSqrR.yScale = 0.65
		mveSqrBR = display.newImage("movementSQR.png")
			mveSqrBR.xScale = 0.65
			mveSqrBR.yScale = 0.65
		
		cnfMveSqr = display.newImage("movementSQRConf.png")
			cnfMveSqr.xScale = 0.65
			cnfMveSqr.yScale = 0.65
			cnfMveSqr.isVisible = false
	
	
		
		if (mveSqrTL.isVisible == true)
		then
		mveSqrTL.isVisible = false
		end
		if (mveSqrL.isVisible == true)
		then
		mveSqrL.isVisible = false
		end
		if (mveSqrBL.isVisible == true)
		then
		mveSqrBL.isVisible = false
		end
		if (mveSqrT.isVisible == true)
		then
		mveSqrT.isVisible = false
		end
		if (mveSqrB.isVisible == true)
		then
		mveSqrB.isVisible = false
		end
		if (mveSqrT.isVisible == true)
		then
		mveSqrT.isVisible = false
		end
		if (mveSqrTR.isVisible == true)
		then
		mveSqrTR.isVisible = false
		end
		if (mveSqrR.isVisible == true)
		then
		mveSqrR.isVisible = false
		end
		if (mveSqrBR.isVisible == true)
		then
		mveSqrBR.isVisible = false
	end
	end
	
	function startTurn (event)
	
	if (cnfMveSqr.isVisible == true)
	then
	cnfMveSqr.isVisible = false
	end
	
	
	
	function movementCNF (event)
	
		sprPlayer.x = cnfMveSqr.x
		sprPlayer.y = cnfMveSqr.y
	
	end
	
		if (mveSqrTL.isVisible == true)
		then
		mveSqrTL.isVisible = false
		end
		if (mveSqrL.isVisible == true)
		then
		mveSqrL.isVisible = false
		end
		if (mveSqrBL.isVisible == true)
		then
		mveSqrBL.isVisible = false
		end
		if (mveSqrT.isVisible == true)
		then
		mveSqrT.isVisible = false
		end
		if (mveSqrB.isVisible == true)
		then
		mveSqrB.isVisible = false
		end
		if (mveSqrT.isVisible == true)
		then
		mveSqrT.isVisible = false
		end
		if (mveSqrTR.isVisible == true)
		then
		mveSqrTR.isVisible = false
		end
		if (mveSqrR.isVisible == true)
		then
		mveSqrR.isVisible = false
		end
		if (mveSqrBR.isVisible == true)
		then
		mveSqrBR.isVisible = false
	end
	
		if (sprPlayer.x == A and sprPlayer.y == Z)
		then
			mveSqrB.isVisible = true
			mveSqrB.x = A
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = B
			mveSqrBR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = B
			mveSqrR.y = Z
		end
		if (sprPlayer.x == B and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = A
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = A
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = B
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = C
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = C
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == C and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = B
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = B
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = C
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = D
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = D
			mveSqrTR.y = Z
			end
		if (sprPlayer.x == D and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = C
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = C
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = D
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = E
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = E
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == E and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = D
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = D
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = E
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = F
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = F
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == F and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = E
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = E
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = F
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = G
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = G
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == G and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = F
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = F
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = G
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = H
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = H
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == H and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = G
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = G
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = H
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = I
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = I
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == I and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = H
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = H
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = I
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = J
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = J
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == J and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = I
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = I
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = J
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = K
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = K
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == K and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = J
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = J
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = K
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = L
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = L
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == L and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = K
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = K
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = L
			mveSqrB.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = M
			mveSqrBR.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = M
			mveSqrTR.y = Z
		end
		if (sprPlayer.x == M and sprPlayer.y == Z)
		then
			mveSqrL.isVisible = true
			mveSqrL.x = L
			mveSqrL.y = Z
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = L
			mveSqrBL.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = M
			mveSqrB.y = Y
		end
		
		if (sprPlayer.x == A and sprPlayer.y == Y)
		then
			mveSqrT.isVisible = true
			mveSqrT.x = A
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = B
			mveSqrTR.y = Z
			
			mveSqrR.isVisible = true
			mveSqrR.x = B
			mveSqrR.y = Y
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = B
			mveSqrBR.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = A
			mveSqrB.y = X
		end
		if (sprPlayer.x == B and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = A
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = B
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = C
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = A
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = C
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = A
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = B
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = C
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == C and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = B
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = C
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = D
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = B
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = D
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = B
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = C
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = D
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == D and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = C
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = D
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = E
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = C
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = E
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = C
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = D
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = E
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == E and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = D
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = E
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = F
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = D
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = F
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = D
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = E
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = F
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == F and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = E
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = F
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = G
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = E
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = G
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = E
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = F
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = G
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == G and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = F
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = G
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = H
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = F
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = H
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = F
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = G
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = H
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == H and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = G
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = H
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = I
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = G
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = I
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = G
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = H
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = I
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == I and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = H
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = I
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = J
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = H
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = J
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = H
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = I
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = J
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == J and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = I
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = J
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = K
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = I
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = K
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = I
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = J
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = K
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == K and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = J
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = K
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = L
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = J
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = L
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = J
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = K
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = L
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == L and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = K
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = L
			mveSqrT.y = Z
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = M
			mveSqrTR.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = K
			mveSqrL.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = M
			mveSqrR.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = K
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = L
			mveSqrB.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = M
			mveSqrBR.y = X
		
		end
		if (sprPlayer.x == M and sprPlayer.y == Y)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = L
			mveSqrTL.y = Z
			
			mveSqrT.isVisible = true
			mveSqrT.x = M
			mveSqrT.y = Z
			
			mveSqrL.isVisible = true
			mveSqrL.x = L
			mveSqrL.y = Y
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = L
			mveSqrBL.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = M
			mveSqrB.y = X
		
		end
		
		if (sprPlayer.x == A and sprPlayer.y == X)
		then
			mveSqrT.isVisible = true
			mveSqrT.x = A
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = B
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = B
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = B
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = A
			mveSqrB.y = W
		end
		if (sprPlayer.x == B and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = A
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = B
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = C
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = C
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = C
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = B
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = A
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = A
			mveSqrL.y = X
		end
		if (sprPlayer.x == C and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = B
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = C
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = D
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = D
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = D
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = C
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = B
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = B
			mveSqrL.y = X
		end
		if (sprPlayer.x == D and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = C
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = D
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = E
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = E
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = E
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = D
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = C
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = C
			mveSqrL.y = X
		end
		if (sprPlayer.x == E and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = D
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = E
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = F
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = F
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = F
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = E
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = D
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = D
			mveSqrL.y = X
		end
		if (sprPlayer.x == F and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = E
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = F
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = G
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = G
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = G
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = F
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = E
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = E
			mveSqrL.y = X
		end
		if (sprPlayer.x == G and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = F
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = G
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = H
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = H
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = H
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = G
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = F
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = F
			mveSqrL.y = X
		end
		if (sprPlayer.x == H and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = G
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = H
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = I
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = I
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = I
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = H
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = G
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = G
			mveSqrL.y = X
		end
		if (sprPlayer.x == I and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = H
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = I
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = J
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = J
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = J
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = I
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = H
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = H
			mveSqrL.y = X
		end
		if (sprPlayer.x == J and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = I
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = J
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = K
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = K
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = K
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = J
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = I
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = I
			mveSqrL.y = X
		end
		if (sprPlayer.x == K and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = J
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = K
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = L
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = L
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = L
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = K
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = J
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = J
			mveSqrL.y = X
		end
		if (sprPlayer.x == L and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = K
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = L
			mveSqrT.y = Y
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = M
			mveSqrTR.y = Y
			
			mveSqrR.isVisible = true
			mveSqrR.x = M
			mveSqrR.y = X
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = M
			mveSqrBR.y = W
			
			mveSqrB.isVisible = true
			mveSqrB.x = L
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = K
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = K
			mveSqrL.y = X
		end
		if (sprPlayer.x == M and sprPlayer.y == X)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = L
			mveSqrTL.y = Y
			
			mveSqrT.isVisible = true
			mveSqrT.x = M
			mveSqrT.y = Y
			
			mveSqrB.isVisible = true
			mveSqrB.x = M
			mveSqrB.y = W
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = L
			mveSqrBL.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = L
			mveSqrL.y = X
		end
		
		if (sprPlayer.x == A and sprPlayer.y == W)
		then
			mveSqrT.isVisible = true
			mveSqrT.x = A
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = B
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = B
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = B
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = A
			mveSqrB.y = V
		end
		if (sprPlayer.x == B and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = A
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = B
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = C
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = C
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = C
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = B
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = A
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = A
			mveSqrL.y = W
		end
		if (sprPlayer.x == C and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = B
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = C
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = D
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = D
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = D
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = C
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = B
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = B
			mveSqrL.y = W
		end
		if (sprPlayer.x == D and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = C
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = D
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = E
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = E
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = E
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = D
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = C
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = C
			mveSqrL.y = W
		end
		if (sprPlayer.x == E and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = D
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = E
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = F
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = F
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = F
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = E
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = D
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = D
			mveSqrL.y = W
		end
		if (sprPlayer.x == F and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = E
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = F
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = G
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = G
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = G
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = F
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = E
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = E
			mveSqrL.y = W
		end
		if (sprPlayer.x == G and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = F
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = G
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = H
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = H
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = H
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = G
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = F
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = F
			mveSqrL.y = W
		end
		if (sprPlayer.x == H and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = G
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = H
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = I
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = I
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = I
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = H
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = G
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = G
			mveSqrL.y = W
		end
		if (sprPlayer.x == I and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = H
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = I
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = J
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = J
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = J
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = I
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = H
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = H
			mveSqrL.y = W
		end
		if (sprPlayer.x == J and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = I
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = J
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = K
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = K
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = K
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = J
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = I
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = I
			mveSqrL.y = W
		end
		if (sprPlayer.x == K and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = J
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = K
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = L
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = L
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = L
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = K
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = J
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = J
			mveSqrL.y = W
		end
		if (sprPlayer.x == L and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = K
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = L
			mveSqrT.y = X
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = M
			mveSqrTR.y = X
			
			mveSqrR.isVisible = true
			mveSqrR.x = M
			mveSqrR.y = W
			
			mveSqrBR.isVisible = true
			mveSqrBR.x = M
			mveSqrBR.y = V
			
			mveSqrB.isVisible = true
			mveSqrB.x = L
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = K
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = K
			mveSqrL.y = W
		end
		if (sprPlayer.x == M and sprPlayer.y == W)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = L
			mveSqrTL.y = X
			
			mveSqrT.isVisible = true
			mveSqrT.x = M
			mveSqrT.y = X
			
			mveSqrB.isVisible = true
			mveSqrB.x = M
			mveSqrB.y = V
			
			mveSqrBL.isVisible = true
			mveSqrBL.x = L
			mveSqrBL.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = L
			mveSqrL.y = W
		end
		
		if (sprPlayer.x == A and sprPlayer.y == V)
		then
			mveSqrT.isVisible = true
			mveSqrT.x = A
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = B
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = B
			mveSqrR.y = V
		end
		if (sprPlayer.x == B and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = A
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = B
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = C
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = C
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = A
			mveSqrL.y = V
		end
		if (sprPlayer.x == C and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = B
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = C
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = D
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = D
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = B
			mveSqrL.y = V
		end
		if (sprPlayer.x == D and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = C
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = D
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = E
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = E
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = C
			mveSqrL.y = V
		end
		if (sprPlayer.x == E and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = D
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = E
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = F
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = F
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = D
			mveSqrL.y = V
		end
		if (sprPlayer.x == F and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = E
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = F
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = G
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = G
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = E
			mveSqrL.y = V
		end
		if (sprPlayer.x == G and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = F
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = G
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = H
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = H
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = F
			mveSqrL.y = V
		end
		if (sprPlayer.x == H and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = G
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = H
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = I
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = I
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = G
			mveSqrL.y = V
		end
		if (sprPlayer.x == I and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = H
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = I
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = J
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = J
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = H
			mveSqrL.y = V
		end
		if (sprPlayer.x == J and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = I
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = J
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = K
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = K
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = I
			mveSqrL.y = V
		end
		if (sprPlayer.x == K and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = J
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = K
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = L
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = L
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = J
			mveSqrL.y = V
		end
		if (sprPlayer.x == L and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = K
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = L
			mveSqrT.y = W
			
			mveSqrTR.isVisible = true
			mveSqrTR.x = M
			mveSqrTR.y = W
			
			mveSqrR.isVisible = true
			mveSqrR.x = M
			mveSqrR.y = V
			
			mveSqrL.isVisible = true
			mveSqrL.x = K
			mveSqrL.y = V
		end
		if (sprPlayer.x == M and sprPlayer.y == V)
		then
			mveSqrTL.isVisible = true
			mveSqrTL.x = L
			mveSqrTL.y = W
			
			mveSqrT.isVisible = true
			mveSqrT.x = M
			mveSqrT.y = W
			
			mveSqrL.isVisible = true
			mveSqrL.x = L
			mveSqrL.y = V
		end
		
	function movementTL (event)
		if (mveSqrTR.isVisible == false)
		then
		mveSqrTR.isVisible = true
		end
		
		if (mveSqrT.isVisible == false)
		then
		mveSqrT.isVisible = true
		end
		
		if (mveSqrR.isVisible == false)
		then
		mveSqrR.isVisible = true
		end
		
		if (mveSqrBR.isVisible == false)
		then
		mveSqrBR.isVisible = true
		end
		
		if (mveSqrB.isVisible == false)
		then
		mveSqrB.isVisible = true
		end
		
		if (mveSqrBL.isVisible == false)
		then
		mveSqrBL.isVisible = true
		end
		
		if (mveSqrL.isVisible == false)
		then
		mveSqrL.isVisible = true
		end
		
		mveSqrTL.isVisible = false
		cnfMveSqr.x = mveSqrTL.x
		cnfMveSqr.y = mveSqrTL.y
		cnfMveSqr.isVisible = true
		cnfMveSqr:addEventListener("tap", movementCNF)
	end
		
	function movementTR (event)
		
		if (mveSqrTL.isVisible == false)
		then
		mveSqrTL.isVisible = true
		end
		
		if (mveSqrT.isVisible == false)
		then
		mveSqrT.isVisible = true
		end
		
		if (mveSqrR.isVisible == false)
		then
		mveSqrR.isVisible = true
		end
		
		if (mveSqrBR.isVisible == false)
		then
		mveSqrBR.isVisible = true
		end
		
		if (mveSqrB.isVisible == false)
		then
		mveSqrB.isVisible = true
		end
		
		if (mveSqrBL.isVisible == false)
		then
		mveSqrBL.isVisible = true
		end
		
		if (mveSqrL.isVisible == false)
		then
		mveSqrL.isVisible = true
		end
	
		mveSqrTR.isVisible = false
		cnfMveSqr.x = mveSqrTR.x
		cnfMveSqr.y = mveSqrTR.y
		cnfMveSqr.isVisible = true
		cnfMveSqr:addEventListener("tap", movementCNF)
	end
	
	function movementT (event)
		
		if (mveSqrTL.isVisible == false)
		then
		mveSqrTL.isVisible = true
		end
		
		if (mveSqrTR.isVisible == false)
		then
		mveSqrTR.isVisible = true
		end
		
		if (mveSqrR.isVisible == false)
		then
		mveSqrR.isVisible = true
		end
		
		if (mveSqrBR.isVisible == false)
		then
		mveSqrBR.isVisible = true
		end
		
		if (mveSqrB.isVisible == false)
		then
		mveSqrB.isVisible = true
		end
		
		if (mveSqrBL.isVisible == false)
		then
		mveSqrBL.isVisible = true
		end
		
		if (mveSqrL.isVisible == false)
		then
		mveSqrL.isVisible = true
		end
	
		mveSqrT.isVisible = false
		cnfMveSqr.x = mveSqrT.x
		cnfMveSqr.y = mveSqrT.y
		cnfMveSqr.isVisible = true
		cnfMveSqr:addEventListener("tap", movementCNF)
	end
	
	function movementR (event)
		
		if (mveSqrTL.isVisible == false)
		then
		mveSqrTL.isVisible = true
		end
		
		if (mveSqrTR.isVisible == false)
		then
		mveSqrTR.isVisible = true
		end
		
		if (mveSqrT.isVisible == false)
		then
		mveSqrT.isVisible = true
		end
		
		if (mveSqrBR.isVisible == false)
		then
		mveSqrBR.isVisible = true
		end
		
		if (mveSqrB.isVisible == false)
		then
		mveSqrB.isVisible = true
		end
		
		if (mveSqrBL.isVisible == false)
		then
		mveSqrBL.isVisible = true
		end
		
		if (mveSqrL.isVisible == false)
		then
		mveSqrL.isVisible = true
		end
	
		mveSqrR.isVisible = false
		cnfMveSqr.x = mveSqrR.x
		cnfMveSqr.y = mveSqrR.y
		cnfMveSqr.isVisible = true
		cnfMveSqr:addEventListener("tap", movementCNF)
	end
	
	function movementBR (event)
		
		if (mveSqrTL.isVisible == false)
		then
		mveSqrTL.isVisible = true
		end
		
		if (mveSqrTR.isVisible == false)
		then
		mveSqrTR.isVisible = true
		end
		
		if (mveSqrT.isVisible == false)
		then
		mveSqrT.isVisible = true
		end
		
		if (mveSqrR.isVisible == false)
		then
		mveSqrR.isVisible = true
		end
		
		if (mveSqrB.isVisible == false)
		then
		mveSqrB.isVisible = true
		end
		
		if (mveSqrBL.isVisible == false)
		then
		mveSqrBL.isVisible = true
		end
		
		if (mveSqrL.isVisible == false)
		then
		mveSqrL.isVisible = true
		end
	
		mveSqrBR.isVisible = false
		cnfMveSqr.x = mveSqrBR.x
		cnfMveSqr.y = mveSqrBR.y
		cnfMveSqr.isVisible = true
		cnfMveSqr:addEventListener("tap", movementCNF)
	end
	
	function movementB (event)
		
		if (mveSqrTL.isVisible == false)
		then
		mveSqrTL.isVisible = true
		end
		
		if (mveSqrTR.isVisible == false)
		then
		mveSqrTR.isVisible = true
		end
		
		if (mveSqrT.isVisible == false)
		then
		mveSqrT.isVisible = true
		end
		
		if (mveSqrR.isVisible == false)
		then
		mveSqrR.isVisible = true
		end
		
		if (mveSqrBR.isVisible == false)
		then
		mveSqrBR.isVisible = true
		end
		
		if (mveSqrBL.isVisible == false)
		then
		mveSqrBL.isVisible = true
		end
		
		if (mveSqrL.isVisible == false)
		then
		mveSqrL.isVisible = true
		end
	
		mveSqrB.isVisible = false
		cnfMveSqr.x = mveSqrB.x
		cnfMveSqr.y = mveSqrB.y
		cnfMveSqr.isVisible = true
		cnfMveSqr:addEventListener("tap", movementCNF)
	end
	
	function movementBL (event)
		
		if (mveSqrTL.isVisible == false)
		then
		mveSqrTL.isVisible = true
		end
		
		if (mveSqrTR.isVisible == false)
		then
		mveSqrTR.isVisible = true
		end
		
		if (mveSqrT.isVisible == false)
		then
		mveSqrT.isVisible = true
		end
		
		if (mveSqrR.isVisible == false)
		then
		mveSqrR.isVisible = true
		end
		
		if (mveSqrBR.isVisible == false)
		then
		mveSqrBR.isVisible = true
		end
		
		if (mveSqrB.isVisible == false)
		then
		mveSqrB.isVisible = true
		end
		
		if (mveSqrL.isVisible == false)
		then
		mveSqrL.isVisible = true
		end
	
		mveSqrBL.isVisible = false
		cnfMveSqr.x = mveSqrBL.x
		cnfMveSqr.y = mveSqrBL.y
		cnfMveSqr.isVisible = true
		cnfMveSqr:addEventListener("tap", movementCNF)
	end
	
	function movementL (event)
		
		if (mveSqrTL.isVisible == false)
		then
		mveSqrTL.isVisible = true
		end
		
		if (mveSqrTR.isVisible == false)
		then
		mveSqrTR.isVisible = true
		end
		
		if (mveSqrT.isVisible == false)
		then
		mveSqrT.isVisible = true
		end
		
		if (mveSqrR.isVisible == false)
		then
		mveSqrR.isVisible = true
		end
		
		if (mveSqrBR.isVisible == false)
		then
		mveSqrBR.isVisible = true
		end
		
		if (mveSqrB.isVisible == false)
		then
		mveSqrB.isVisible = true
		end
		
		if (mveSqrBL.isVisible == false)
		then
		mveSqrBL.isVisible = true
		end
	
		mveSqrL.isVisible = false
		cnfMveSqr.x = mveSqrL.x
		cnfMveSqr.y = mveSqrL.y
		cnfMveSqr.isVisible = true
		cnfMveSqr:addEventListener("tap", movementCNF)
	end
		
		mveSqrTL:addEventListener("tap", movementTL)
		mveSqrTR:addEventListener("tap", movementTR)
		mveSqrT:addEventListener("tap", movementT)
		mveSqrR:addEventListener("tap", movementR)
		mveSqrBR:addEventListener("tap", movementBR)
		mveSqrB:addEventListener("tap", movementB)
		mveSqrBL:addEventListener("tap", movementBL)
		mveSqrL:addEventListener("tap", movementL)
	end
	
	
	function debugEvent (event)
		grid = display.newImage("grid.png")
		grid.x = 239
		grid.y = 160
		grid.xScale = 1.099
		grid.yScale = 1.4
		GA = display.newText ("A", A, 20, "SKB.ttf", 12)
		GB = display.newText ("B", B, 20, "SKB.ttf", 12)
		GC = display.newText ("C", C, 20, "SKB.ttf", 12)
		GD = display.newText ("D", D, 20, "SKB.ttf", 12)
		GE = display.newText ("E", E, 20, "SKB.ttf", 12)
		GF = display.newText ("F", F, 20, "SKB.ttf", 12)
		GG = display.newText ("G", G, 20, "SKB.ttf", 12)
		GH = display.newText ("H", H, 20, "SKB.ttf", 12)
		GI = display.newText ("I", I, 20, "SKB.ttf", 12)
		GJ = display.newText ("J", J, 20, "SKB.ttf", 12)
		GK = display.newText ("K", K, 20, "SKB.ttf", 12)
		GL = display.newText ("L", L, 20, "SKB.ttf", 12)
		GM = display.newText ("M", M, 20, "SKB.ttf", 12)
		GZ = display.newText ("Z", -25, Z, "SKB.ttf", 12)
		GY = display.newText ("Y", -25, Y, "SKB.ttf", 12)
		GX = display.newText ("X", -25, X, "SKB.ttf", 12)
		GW = display.newText ("W", -25, W, "SKB.ttf", 12)
		GV = display.newText ("V", -25, V, "SKB.ttf", 12)
		testBtn = display.newImage("button.png")
			testBtn.xScale = 0.1
			testBtn.yScale = 0.1
			testBtn.x = 10
			testBtn.y = 300
		testBtn:addEventListener("tap", layoutOpt1)
		testBtn2 = display.newImage("button.png")
			testBtn2.xScale = 0.1
			testBtn2.yScale = 0.1
			testBtn2.x = 75
			testBtn2.y = 300
		testBtn2:addEventListener("tap", startTurn)
	end
btnStart:addEventListener("tap", Start)
btnStart:addEventListener("tap", startTurn)
Runtime:addEventListener("key", debugEvent)






