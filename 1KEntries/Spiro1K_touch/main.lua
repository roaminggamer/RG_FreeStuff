local p=require"physics"
p.start()
p.setGravity(0,0)
cx=384
cy=512
zz=display
y=p.addBody
x = math.random
w = zz.newCircle
v = p.newJoint 
u = "pivot"
t=function(a)a.isSensor=true;end
s=function(a)a.alpha=0;end
gg=zz.newGroup()

function z(a,b,c,d) 
local h = w(gg, cx, cy, a, a )
local i = w(gg, cx + c, cy, b )
local j = w(gg, cx + d, cy, 8 )
y(h,"static")
y(i)
y(j)
t(h)
t(i)
t(j)
s(h)
s(i)
s(j)
v( u, i, h, i.x , i.y )
v( u, j, i, j.x , j.y )
doit = function ()
h.rotation = h.rotation + 1
i.rotation = i.rotation - 5
local m = w( gg, j.x, j.y, 3 )
m:setFillColor(x(),x(),x())
end
timer.performWithDelay(10, doit, 750)
end
r=function(a)if(a.phase=="ended")then 
print(a.x-a.xStart)
if((a.x-a.xStart)>40) then
	gg:removeSelf()
	gg=zz.newGroup()
else
z(x(50,300),80+ x(150, 200),x(50, 150), x(150, 350))
end
end
end
Runtime:addEventListener("touch",r)


