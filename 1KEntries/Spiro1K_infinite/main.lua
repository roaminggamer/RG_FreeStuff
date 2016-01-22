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
yy=timer.performWithDelay
ww=zz.newGroup
gg=ww()


function z(a,b,c,d,e,f,g) 
local h = w( cx, cy, a )
local i = w( cx + c, cy, b )
local j = w( cx + d, cy, 8 )
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
local function doit()
h.rotation = h.rotation + 1
i.rotation = i.rotation - 5
local m = w( gg, j.x, j.y, 3 )
m:setFillColor(x(),x(),x())
end
yy(30, doit, 750)
end
r=function(a)z(x(50,300),80+ x(150, 200),x(50, 150), x(150, 350));end
r2=function()gg:removeSelf();gg=ww();end
r3=function()r();r();r();r();yy(3e4,function()r2();r3();end,-1);end
r3()
