a=require"physics"
b=a.addBody
c=a.newJoint
d=display
e=d.newRect
f=Runtime
g=timer.performWithDelay
h=transition.to
function i(o)h(o,{x=n.x,y=n.y,time=l(2e3,3e3),onComplete=i});end
function j(e)e.q=e.target;e.l=e.q.removeSelf;y=e.other;if(y==n)then e.l(n);e.l(o);e.l(e.q);g(1e4,k);elseif(y==o)then m.text=m.text+1;e.l(e.q);end;end
k=function()os.exit()end
l=math.random
m=d.newText(40,100,20)
a.start()
a.setGravity(0,0)
a.setDrawMode("hybrid")
n=e(130,240,50,18)
b(n)
o=e(184,160,10,70)
b(o,{isBullet=true})
p=c("pivot",n,o,n.x+35,n.y)
p:setRotationLimits(-45,75)
p.isLimitEnabled=true
f.addEventListener(f,"touch",function(e)o.x=e.x;o.y=e.y;end)
function w(x1,x2,y1,y2)return function()y=e(l(x1,x2),l(y1,y2),9,9);b(y);i(y);y:addEventListener("collision",j);y:setFillColor(0,l(50,255),0)end end
q=w(-100,420,-150,-100)
r=w(-100,420,580,630)
s=w(-150,-100,-100, 580)
t=w(420,-4700,-100, 580)
g(1e3,function()g(1e3,q,0)end)
g(10e3,function()g(1e3,r,0)end)
g(20e3,function()g(2e3,s,0)end)
g(302e3,function()g(2e3,t,0)end)

