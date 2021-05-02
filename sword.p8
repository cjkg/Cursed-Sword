pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-Cursed Sword by Chris Gibilisco

--This game is released under the CC BY-NC-SA 4.0 license, which you can read here: https://creativecommons.org/licenses/by-nc-sa/4.0/

--Krystian Majewski of LazyDevs academy for the use of his game Porklike as an engine for this game.

--Many of the power gems were conceived by Michael S. Thanks, Michael!

--Enemy and potion artwork licensed from Oryx Design Labs, www.oryxdesignlab.com.
	
--The JSON parser program was designed by tylerneylon, adapted by feneric, which tylerneylon has released into the public domain. Feneric's adaptation of it is released under the GPL v3 license: https://www.gnu.org/licenses/gpl-3.0.en.html.

function _init()
	t=0

	_gt=json_parse('{"mobs":[{"n":"hero","ani":[240,241,242,243],"atk":1,"def":0,"hp":10,"hpmax":10,"col":3,"los":10,"quench":0},{"n":"slime","ani":[212,213,214,215],"atk":1,"def":0,"hp":1,"col":3,"los":5,"int":0,"quench":10},{"n":"eyeball","ani":[228,229,230,231],"atk":1,"def":0,"hp":2,"col":6,"los":5,"int":1,"quench":10},{"n":"demon minion","ani":[208,209,210,211],"atk":1,"def":0,"hp":2,"col":8,"los":5,"int":1,"quench":10},{"n":"demon mage","ani":[192,193,194,195],"atk":1,"def":0,"hp":2,"col":14,"los":5,"int":1,"quench":10},{"n":"mind flayer","ani":[196,197,198,199],"atk":1,"def":0,"hp":2,"col":11,"los":5,"int":0,"quench":10},{"n":"ghost","ani":[244,245,246,247],"atk":1,"def":0,"hp":2,"col":7,"los":5,"int":1,"quench":10},{"n":"fire elemental","ani":[224,225,226,227],"atk":1,"def":0,"hp":2,"col":9,"los":5,"int":0,"quench":10},{"n":"hellion","ani":[200,201,202,203],"atk":1,"def":0,"hp":2,"col":9,"los":5,"int":0,"quench":10},{"n":"slayer","ani":[216,217,218,219],"atk":1,"def":0,"hp":2,"col":13,"los":5,"int":1,"quench":10}],"features":[{"n":"welcome tablet","fx":62,"init_tile":4,"after_tile":4,"message":["welcome"],"lines":3},{"n":"heal chest","fx":61,"init_tile":8,"heal":5,"after_tile":1},{"n":"gold chest","fx":61,"init_tile":9,"gold":5,"after_tile":1},{"n":"unlocked door","fx":62,"init_tile":12,"after_tile":1},{"n":"locked door","fx":59,"init_tile":13,"after_tile":1},{"n":"floor","fx":58,"init_tile":1,"after_tile":1,"floor":true},{"n":"stairs down","fx":58,"init_tile":14,"after_tile":14,"floor":true},{"n":"stairs up","fx":58,"init_tile":15,"after_tile":15,"floor":true},{"n":"empty vase","fx":61,"init_tile":5,"after_tile":1},{"n":"heal vase","fx":61,"heal":1,"init_tile":6,"after_tile":1},{"n":"gold vase","fx":61,"gold":2,"init_tile":7,"after_tile":1}],"gems":{"a":{"name":"amethyst","color":12,"mod":"atk","base":1},"r":{"name":"ruby","color":14,"mod":"♥","base":5},"d":{"name":"diamond","color":7,"mod":"⧗","base":1},"e":{"name":"emerald","color":11,"mod":"luck","base":1},"c":{"name":"chipped","mult":1},"rh":{"name":"rough","mult":2},"ct":{"name":"cut","mult":3},"f":{"name":"flawless","mult":5},"rc":{"name":"relic","mult":10}},"gem_types":["e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a ","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","d","d","d","d"],"gem_qual":["c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","f","f","rc"],"powergems":{"powercut":{"name":"power cut","color":8,"desc":[" 2x atk, slower swings"]}},"npcs":{},"tools":{"dirx":[-1,1,0,0,1,1,-1,-1],"diry":[0,0,-1,1,-1,1,1,-1],"dpal":[0,1,1,2,1,13,6,4,4,9,3,13,1,13,14],"carve_signatures":["0b11111111","0b11010110","0b01111100","0b10110011","0b11101001"],"carve_masks":[0,"0b00001001","0b00000011","0b00001100","0b00000110"]}}')
	mobs,features,tools=_gt.mobs,_gt.features,_gt.tools
	gem_types,gem_qual,gem_props=_gt.gem_types,_gt.gem_qual,_gt.gems
	powergems=_gt.powergems
	--tools
	dpal,dirx,diry=tools.dpal,tools.dirx,tools.diry
	crv_sig,crv_msk=_gt.tools.carve_signatures,_gt.tools.carve_masks
	--palette, lrud, & diag coordinates

	--★
	debug={}

	startgame()
end

function _update60()
	t+=1

	_upd()

	dofloats()
	dohpwind()
end

function _draw()
	_drw()
	drawwind()
	checkfade()
	--★
	cursor(4,4)
	color(8)
	for txt in all(debug) do
		print(txt)
	end
end

function startgame()
	fadeperc=1
	buttonbuff=-1 --queues button presses
	skipai=false
	mob,dmob,feat={},{},{}
	debug[2]=crv_sig
	for x=0,15 do
		for y=0,15 do
			for m in all(mobs) do
				if m.ani[1]==mget(x,y) then
					--★
					if m.n=="hero" then
						p_mob=addmob(m,x,y)
					else
						--★addmob(m,x,y)
					end
					mset(x,y,1)
				end
			end

			for f in all(features) do
				if f.init_tile==mget(x,y) then
					addfeat(f,x,y)
				end
			end
		end
	end
--]]	
	
	--★
	p_t=0
	--keep dig at the end	
	level,luck,thirst,thirstrate,gold,turn,dig=1,0,999,1,0,0,true
	inv,eqp={},{}
	inv[1]=makepowergem()
	wind,float={},{}

	fog=blankmap(0)
	hpwind=addwind(5,5,108,13,{})

	_upd,_drw=update_game,draw_game
	unfog()
	calcdist(p_mob.x,p_mob.y)
	
	mapgen()
--	for i=1,6 do
--		inv[i]=makegem()
--	end
end
-->8
--updates

function update_game()
	if talkwind then
		if getbutton()==5 then
			talkwind.dur,talkwind=0
		end
	else
		dobuffer()
		dobutton(buttonbuff)
	
		buttonbuff=-1
	end
	debug[1]=getsig(p_mob.x,p_mob.y)
end

function update_inv()
	local curs=curwind.cur
	local invcurs=curs-4
	--★
	--3963
 --build a table with parent child relationships, so this is just one if statement or something similar
 move_menu(curwind)

 if curwind==invwind then
	--★gem vs power gems
		if curs<4 and eqp[curs] and not eqp[curs].desc then
			swordwind.txt={eqp[curs].mod.."+"..eqp[curs].mult*eqp[curs].base}
		elseif curs>4 and inv[curs-4] and not inv[curs-4].desc then
				swordwind.txt={inv[curs-4].mod.."+"..inv[curs-4].mult*inv[curs-4].base}
		elseif curs<4 and eqp[curs] and eqp[curs].desc then
				swordwind.txt=eqp[curs].desc
		elseif curs>4 and inv[curs-4] and inv[curs-4].desc then
				swordwind.txt=inv[curs-4].desc
		else
			swordwind.txt=""
		end
	end
	
	if btnp(4) then
  if curwind==invwind then
   _upd=update_game
   invwind.dur,statwind.dur,swordwind.dur=0,0,0
  elseif curwind==usewind then
   usewind.dur=0
   curwind=invwind
	 --★ else?
  end
 elseif btnp(5) then
  if curwind==invwind then
			showuse()
	 elseif curwind==usewind then
			triguse()
		end
 end
end

function move_menu(wnd)
	if btnp(2) then
			wnd.cur-=1
	elseif btnp(3) then
			wnd.cur+=1
	end
	wnd.cur=(wnd.cur-1)%#wnd.txt+1
end

function update_pturn()
	dobuffer()
	p_t=min(p_t+0.125,1) --advance the ani timer

	p_mob:mov()
	if p_t==1 then
		_upd=update_game
		if checkend() and not skipai then
			do_ai()
			turn+=1
		end
		if checkend() and not skipai then
			if turn%thirstrate==0 then
				if thirst>0 then
					thirst-=1
				else
					--★ add popup window, your sword feasts on your blood!
					p_mob.hp-=1
				end
			end
		end
		calcdist(p_mob.x,p_mob.y)
	end
	
	
end

function update_aiturn()
	dobuffer()
	p_t=min(p_t+0.125,1) --advance the ani timer

	for m in all(mob) do
		if m!=p_mob and m.mov then
			m:mov()
		end
	end

	if p_t==1 then
		_upd=update_game
		checkend()
	end
end

function update_gameover()
	if btnp(❎) then
		fadeout()
		startgame()
	end
end

function getbutton()
	for i=0,5 do
		if btnp(i) then
			return i
		end
	end
	return -1 --imaginary button
end

function dobutton(button)
	if button>=0 and button<4 then
		moveplayer(dirx[button+1],diry[button+1])
	elseif button==5 then
		showinv()
	--★ debug:
	elseif button==4 then
		mapgen()
	end
end

function dobuffer()
	if buttonbuff==-1 then
		buttonbuff=getbutton()
	end
end
-->8
--draws

function draw_game()
	cls(0) --clear screen
	map()

	for m in all(dmob) do
		if (sin(time()*8)>0)	drawmob(m)
		m.dur-=1
		if (m.dur<=0)	del(dmob,m)
	end

	for i=#mob,1,-1 do
		drawmob(mob[i])
	end

	for x=0,15 do
		for y=0,15 do
			if fog[x][y]==1 then
				rectfill2(x*8,y*8,8,8,0)
			end
		end
	end

--[[	
 for x=0,15 do
  for y=0,15 do
   if flags[x][y]!=0 then
    pset(x*8+3,y*8+5,flags[x][y])
   end
  end
 end
--]]

	for f in all(float) do
		oprint8(f.txt,f.x,f.y,f.c,0)
	end
end

function drawmob(m)
	local col=m.col
		if m.flash>0 then
			m.flash-=1
			col=7
		end
	_drawspr(getframe(m.ani),m.x*8+m.ox,m.y*8+m.oy,col,m.flp)

end

function draw_gameover()
	cls(0)
	print("you died",centx(8),centy(1),8)
end
-->8
--tools

function getframe(ani)
	return ani[flr(t/8)%#ani+1]
end

function _drawspr(_spr,_x,_y,_c,_flip)
	palt(0,false)
	pal(6,_c)
	spr(_spr,_x,_y,1,1,_flip)
	pal()
end

function rectfill2(_x,_y,_w,_h,_c)
	--★
	rectfill(_x,_y,_x+max(_w-1,0),_y+max(_h-1,0),_c)
end

function oprint8(_t,_x,_y,_c,_c2)
	--prints texts with a thick outline
 --moves text in outline color in 8 directions
 --then prints text in middle in text color
 for i=1,8 do
  print(_t,_x+dirx[i],_y+diry[i],_c2)
 end
 print(_t,_x,_y,_c)
end

function dist(fx,fy,tx,ty)
	return sqrt((fx-tx)^2+(fy-ty)^2)
end

function dofade()
local p,kmax,col,k=flr(mid(0,fadeperc,1)*100)
 for j=1,15 do
  col = j
  kmax=flr((p+j*1.46)/22)
  for k=1,kmax do
   col=dpal[col]
  end
  pal(j,col,1)
 end
end

function checkfade()
 if fadeperc>0 then
  fadeperc=max(fadeperc-0.04,0)
  dofade()
 end
end

function wait(_wait)
 repeat
  _wait-=1
  flip()--?
 until _wait<0
end

function fadeout(spd,_wait)
 if (spd==nil) spd=0.04
 if (_wait==nil) _wait=0
 repeat
  fadeperc=min(fadeperc+spd,1)
  dofade()
  flip()
 until fadeperc==1
 wait(_wait)
end

-- register json context here
_tok={
 ['true']=true,
 ['false']=false}
_g={}

-- json parser
-- from: https://gist.github.com/tylerneylon/59f4bcf316be525b30ab
table_delims={['{']="}",['[']="]"}

function match(s,tokens)
  for i=1,#tokens do
	if(s==sub(tokens,i,i)) return true
  end
  return false
end

function skip_delim(wrkstr, pos, delim, err_if_missing)
 if sub(wrkstr,pos,pos)!=delim then
  -- if(err_if_missing) assert'delimiter missing'
  return pos,false
 end
 return pos+1,true
end

function parse_str_val(wrkstr, pos, val)
  val=val or ''
  local c=sub(wrkstr,pos,pos)
  if(c=='"') return _g[val] or val,pos+1
  return parse_str_val(wrkstr,pos+1,val..c)
end

function parse_num_val(wrkstr,pos,val)
  val=val or ''
  local c=sub(wrkstr,pos,pos)

  if(not match(c,"-xb0123456789abcdef.")) return tonum(val),pos
  return parse_num_val(wrkstr,pos+1,val..c)
end

function json_parse(wrkstr, pos, end_delim)
  pos=pos or 1

  local first=sub(wrkstr,pos,pos)
  if match(first,"{[") then
	local obj,key,delim_found={},true,true
	pos+=1
	while true do
	  key,pos=json_parse(wrkstr, pos, table_delims[first])
	  if(key==nil) return obj,pos
	  -- if not delim_found then assert'comma missing between table items.' end
	  if first=="{" then
		pos=skip_delim(wrkstr,pos,':',true)  -- true -> error if missing.
		obj[key],pos=json_parse(wrkstr,pos)
	  else
		add(obj,key)
	  end
	  pos,delim_found=skip_delim(wrkstr, pos, ',')
  end
  elseif first=='"' then
	-- parse a string (or a reference to a global object)
	return parse_str_val(wrkstr,pos+1)
  elseif match(first,"-0123456789") then
	-- parse a number.
	return parse_num_val(wrkstr, pos)
  elseif first==end_delim then  -- end of an object or array.
	return nil,pos+1
  else  -- parse true, false
	for lit_str,lit_val in pairs(_tok) do
	  local lit_end=pos+#lit_str-1
	  if sub(wrkstr,pos,lit_end)==lit_str then return lit_val,lit_end+1 end
	end
	-- assert'invalid json token'
  end
end

function blankmap(_dflt)
 local ret={}
 if (_dflt==nil) _dflt=0

 for x=0,15 do
  ret[x]={}
  for y=0,15 do
   ret[x][y]=_dflt
  end
 end
 return ret
end


function inbounds(x,y)
	return x>=0 and y>=0 and x<16 and y<16
end

function los(x1,y1,x2,y2)
 local frst,sx,sy,dx,dy=true
 --★
 if dist(x1,y1,x2,y2)==1 then return true end
 if x1<x2 then
  sx,dx=1,x2-x1
 else
  sx,dx=-1,x1-x2
 end
 if y1<y2 then
  sy,dy=1,y2-y1
 else
  sy,dy=-1,y1-y2
 end
 local err,e2=dx-dy

 while not(x1==x2 and y1==y2) do
  if not frst and not iswalkable(x1,y1,"sight") then return false end
	  frst,e2=false,err*2
	  if e2>-dy then
	   err-=dy
	   x1+=sx
	  end
	  if e2<dx then
	   err+=dx
	   y1+=sy
	  end
 end
 return true
end

function unfog()
 local px,py=p_mob.x,p_mob.y
 for x=0,15 do
  for y=0,15 do
   if fog[x][y]==1 and dist(px,py,x,y)<=p_mob.los and los(px,py,x,y) then
	unfogtile(x,y)
   end
  end
 end
end

function unfogtile(x,y)
 fog[x][y]=0
 if iswalkable(x,y,"sight") then
  for i=1,4 do
   local tx,ty=x+dirx[i],y+diry[i]
   if inbounds(tx,ty) and not iswalkable(tx,ty,"sight") then
	fog[tx][ty]=0
   end
  end
 end
end

function inbounds(x,y)
	return x>=0 and y>=0 and x<16 and y<16
end


function calcdist(tx,ty)
 local cand,step={},0
 distmap=blankmap(-1)
 add(cand,{x=tx,y=ty})
 distmap[tx][ty]=0
 repeat
  step+=1
  candnew={}
  for c in all(cand) do
   for d=1,4 do
	local dx=c.x+dirx[d]
	local dy=c.y+diry[d]
	if inbounds(dx,dy) and distmap[dx][dy]==-1 then
	 distmap[dx][dy]=step
	 if iswalkable(dx,dy) then
	  add(candnew,{x=dx,y=dy})
	 end
	end
   end
  end
  cand=candnew
 until #cand==0
end

function getrnd(arr)
	return arr[1+flr(rnd(#arr))]
end

--★ combine these two into dual return if never used separately to save 4 tokens
function centx(w)
	return 65-((w+2)*4+7)/2
end

function centy(h)
	return 65-(h*6+17)/2
end

--function sin_time()
	--★ needs to be used 3 times to be token savings
	--return min(sin(time()))
--end

function isin(mem,set)
	for m in all(set) do
		if m==mem then
			return true
		end
	end
	return false
end
-->8
--gameplay

function moveplayer(dx,dy)
	local destx,desty,tle=p_mob.x+dx,p_mob.y+dy,mget(destx,desty)
	--★ add modulo for thirst bonuses

	if iswalkable(destx,desty,"checkmobs") then
		sfx(63)
		skipai=false
		mobwalk(p_mob,dx,dy)
		p_t=0 --reset timer
		_upd=update_pturn
	else
		skipai=false
		mobbump(p_mob,dx,dy)
		
		--★ combine variables
		p_t=0
		_upd=update_pturn


		local m=getmob(destx,desty)
		if m then
			hitmob(p_mob,m)
			sfx(60)
		else
			if fget(tle,1) then
				trig_bump(tle,destx,desty)
			else 
				skipai=true
				--digging
				if dig then
					mset(destx,desty,1)
				end
				mazeworm()
			end
		end
	end
	unfog()
end

function trig_bump(tle,destx,desty)
	--sfx(tle.sfx)
	--mset(destx,desty,tle.after_tile
	--destx and desty *8 local variable
	for f in all(feat) do
		if destx==f.x and desty==f.y then
			sfx(f.fx)
			mset(destx,desty,f.after_tile)
			if f.message then
				showtalk(f.message)
			end
			if f.heal then
				--★ randomization with luck
				local amt=f.heal--ceil(level/2)*5
				addfloat("♥"..amt,destx*8,desty*8,8)
				treasure("♥",amt)
			end
			if f.gold then
				--★ randomization with luck
				local amt=f.gold--ceil(level/2)*f.gold+flr(rnd(luck+1))
				addfloat("◆"..amt,destx*8,desty*8,9)
				treasure("◆",amt)
			end
			if f.wall then
				skipai=true
			end
			return
		end
	end
end

function getmob(x,y)
 for m in all(mob) do
  if m.x==x and m.y==y then
   return m
  end
 end
 return false
end

function iswalkable(x,y,mode)
	local mode=mode or ""
	--★ check tle.floor instead?
 --sight
 if inbounds(x,y) then
  local tle=mget(x,y)
  if mode=="sight" then
			return not fget(tle,2)
  else
	  if not fget(tle,0) then
	   if mode=="checkmobs" then
	    return not getmob(x,y)
	   end
	   return true
	  end
	 end
 end
 return false
end

function hitmob(atkm,defm)
	--★ refactor
 local col,dmg=9,max(0,atkm.atk-defm.def)
 if defm==p_mob then
		col=8
		if flr(rnd(50-luck))<=0 then
			dmg=0
			addfloat("lucky!",defm.x*8,defm.y*8,11)
		end
	end
 defm.hp-=dmg
 defm.flash=10
	if dmg>0 and defm.hp>0 then
		addfloat("-"..dmg,defm.x*8,defm.y*8,col)
	end
	if defm.hp<=0 then
  thirst=min(999,thirst+defm.quench)
  if defm!=p_mob then
  	addfloat("⧗"..defm.quench,defm.x*8,defm.y*8,12)
	 end
  add(dmob,defm)
  del(mob,defm)
  defm.dur=10
 end
end

function checkend()
	if p_mob.hp<=0 then
		wind={}
		_upd=update_gameover
		_drw=draw_gameover
		fadeout(0.015)
		--★
		reload(0x2000,0x2000,0x1000)
		return false
	end
		return true
end

function updatestats()
	local atk,def,hpmax,timer,lck=1,1,p_mob.basehpmax,1,0
	--addition loop
	for i=1,3 do
		local m=eqp[i]
		if m then
			if m.mod=="atk" then
				atk+=m.base*m.mult
			elseif m.mod=="⧗" then
				timer+=m.base*m.mult
			elseif m.mod=="♥" then
				hpmax+=m.base*m.mult
			elseif m.mod=="luck" then
				lck+=m.base*m.mult
			end
		end
	end
	--multiplier loop

	for i=1,3 do
		if eqp[i] then
			local m=eqp[i]
			local nm=m.name
			if nm then
				if nm=="power cut" then
					atk*=2
					--★figure out player skip a turn
				elseif nm=="extendo sword" then
					--reach=2
				elseif nm=="sword of souls" then
					--★inverse proportion ⧗
				elseif nm=="sword of coins" then
					--★adding gold adds to atk
				elseif nm=="laser blade" then
					--★adding laser
				elseif nm=="sword of thunder" then
					--change sound effect only?
				elseif nm=="sword of lightning" then
					--attack all enemies adjacent to you, chaining (this is tough!)
				elseif nm=="sword of doom" then
					--atk*2 when hp<=.20hpmax
				elseif nm=="sword of vengeance" then
					--doubles attack on person who has hit the player					
				end
			end
		end
	end

	thirstrate,p_mob.atk,p_mob.hpmax,luck=timer,atk,hpmax,lck
end

function treasure(txt,amt)
	if txt=="♥" then
		local hpmod=p_mob.hp+amt
		p_mob.hp=min(hpmod,p_mob.hpmax)
	elseif txt=="◆" then
		local goldmod=gold+amt
		gold=min(goldmod,999)
	elseif txt=="●" then
		--
	elseif txt=="⧗" then
		--
		local thirstmod=thirst+amt
		thirst=min(thirstmod,999)
	end
end


-->8
	--ui

function addwind(_x,_y,_w,_h,_txt)
 local w={x=_x,
		  y=_y,
		  w=_w,
		  h=_h,
		  txt=_txt}
 add(wind,w)
 return w
end

function drawwind()
 for w in all(wind) do
  local wx,wy,ww,wh=w.x,w.y,w.w,w.h
  rectfill2(wx,wy,ww,wh,1)
  rect(wx+1,wy+1,wx+ww-2,wy+wh-2,6)
  wx+=4
  wy+=4
  clip(wx,wy,ww-8,wh-8)
  if w.cur then
	wx+=6
  end

  for i=1,#w.txt do
   local txt,c=' '..w.txt[i],6
   print(txt,wx,wy,6)
   if w.col and w.col[i] then
	c=w.col[i]
	print(txt,wx,wy,c)
   end
	if i==w.cur then
		spr(255,wx-5+min(sin(time())),wy)
	end

   wy+=6
  end
  clip()
  if w.dur then
   w.dur-=1
   if w.dur<=0 then
	local dif=w.h/4
	w.y+=dif/2
	w.h-=dif
	if w.h<3 then
	 del(wind,w)
	end
   end
  else
   if w.button then
	oprint8("❎",wx+ww-15,wy-1+min(sin(time())),6,0)
   end
  end
 end
end

function showmsg(txt,dur)
	--every char is 4 pixels, 7 for edges in width
	local w=addwind(centx(#txt),centy(1),wid,13," "..txt)
	w.dur=dur
end

function showtalk(txt)
	local mw,i=0,1
	for t in all(txt) do
		if (#t>mw)	mw=#t
	end
	talkwind=addwind(centx(mw),centy(#txt),(mw+2)*4+7,#txt*6+7,txt)
	talkwind.button=true
end

function addfloat(_txt,_x,_y,_c)
	add(float,{txt=_txt,x=_x,y=_y,c=_c,ty=_y-10,dur=70})
end

function dofloats()
	for f in all(float) do
		f.y+=(f.ty-f.y)/10
		f.dur-=1
		if f.dur==0 then
			del(float,f)
		end
	end
end

function dohpwind()
	--★ could save 10 tokens by getting rid of the fancy bit
 hpwind.txt[1]=" ♥"..sub('0'..p_mob.hp,-2).."/"..p_mob.hpmax.."  ⧗"..sub("000"..thirst,-3).."  ◆"..sub("000"..gold,-3)

 local hpy=0
 if p_mob.y<8 then
  hpy=115
 end
 hpwind.y+=(hpy-hpwind.y)/5
end

function showinv()
	local txt,colors={},{}
	_upd=update_inv

	for i=1,3 do
		local itm=eqp[i]
		if itm then
			add(txt,"● "..itm.name)
			add(colors,itm.col)
		else
			add(txt,"● empty")
			add(colors,6)
		end
	end
	add(colors,6)
	add(txt,"…………………………")

	for i=1,6 do
		local itm,eq_txt=inv[i]
		if itm then
			add(txt,"● "..itm.name)
			add(colors,6)
		else
			add(txt,"●  ...")
			add(colors,6)
		end
	end
	swordwind=addwind(5,12,108,24,{})
	invwind=addwind(5,48,108,67,txt)
	statwind=addwind(5,36,108,13,{"  atk:"..p_mob.atk.."   df:"..p_mob.def.."   lk:"..luck})

	invwind.cur=1
	invwind.col=colors
	add(colors,6)

	curwind=invwind
	end


--★ parent child table
function showuse()
	local txt,itm={}
	--★how to handle empty slots. depends on type, i think
	if invwind.cur<4 and eqp[invwind.cur] then
		add(txt,"remove")
		--★need to either build an exchange or trash
		itm=eqp[i]
	elseif invwind.cur>4 and inv[invwind.cur-4] then
		add(txt,"equip")
		add(txt,"trash")
		itm=inv[i]
	else
		sfx(51)
		return
	end

	usewind=addwind(68,invwind.cur*6+42,57,7+#txt*6,txt)
	usewind.cur=1
	curwind=usewind
end

function triguse()
	local verb,i,after=usewind.txt[usewind.cur],invwind.cur,"back"
	local itm=i<4 and eqp[i] or inv[i-4]
	if verb=="trash" then
		inv[i-4]=nil
		sfx(53)
	elseif verb=="equip" then
		--★ put in function?
		if freeslot(eqp,3)>0 then
			eqp[freeslot(eqp,3)]=itm
			inv[i-4]=nil
			sfx(54)
		else
			sfx(51)
		end
	--★
	elseif verb=="remove" then
		if freeslot(inv,6)>0 then
			inv[freeslot(inv,6)]=itm
			eqp[i]=nil
			sfx(52)
		else
			sfx(51)
		end
	end
	--?

	updatestats()
--	if after=="back" then
	usewind.dur=0
 del(wind,invwind)
 del(wind,statwind)
 del(wind,swordwind)
 showinv()
 invwind.cur=i
--elseif after=="game" then
--		usewind.dur,invwind.dur,statwind,swordwind=0,0,0,0
--		_upd=update_game
--	end
end

-->8
--mobs and items

function addmob(mb,mx,my)
	local q={
		n=mb.n,
		ox=0,
		oy=0,
		flp=false,
		flash=0,
		ani=mb.ani,
		atk=mb.atk,
		def=mb.def,
		hp=mb.hp,
		basehpmax=mb.hpmax,
		hpmax=mb.hpmax,
		quench=mb.quench,
		col=mb.col,
		los=mb.los,
		int=mb.int,--could go, if tokens needed, but i doubt it
		x=mx,
		y=my,
		task=ai_wait}
	add(mob,q)
	return q
end

function addfeat(f,f_x,f_y)
	local q={
		x=f_x,
		y=f_y,
		n=f.n,
		fx=f.fx,
		message=f.message,
		init_tile=f.init_tile,
		after_tile=f.after_tile,
		heal=f.heal,
		gold=f.gold,
		wall=f.wall,
		floor=f.floor
	}
	add(feat,q)
end

function mobwalk(mb,dx,dy)
		mb.x+=dx
		mb.y+=dy

		mobflip(mb,dx)
		mb.sox,mb.soy=-dx*8,-dy*8
		mb.ox,mb.oy=mb.sox,mb.soy --set the offset to the starting value, prevents stutter

		mb.mov=mov_walk
end

function mobbump(mb,dx,dy)
	mobflip(mb,dx)
	mb.sox,mb.soy=dx*8,dy*8
	--★ combine for cut tokens
	mb.ox,mb.oy=0,0 --set the return spot value
	mb.mov=mov_bump
end

function mobflip(mb,dx)
 mb.flp = dx==0 and mb.flp or dx<0
end

function mov_walk(self)
	local tme=1-p_t
	self.ox=self.sox*tme
	self.oy=self.soy*tme
end


function mov_bump(self)
 local tme= p_t>0.5 and 1-p_t or p_t
 self.ox=self.sox*tme
 self.oy=self.soy*tme
end

function do_ai()
 local moving=false
 for m in all(mob) do
  if m!=p_mob then
   m.mov=nil
   moving=m.task(m) or moving
  end
 end
 if moving then
  _upd=update_aiturn
  p_t=0
 end
end

--★ cleanup tokens below

function ai_wait(m)
 if cansee(m,p_mob) then
  --aggro
  m.task=ai_attac
  m.tx,m.ty=p_mob.x,p_mob.y
  addfloat("!",m.x*8+2,m.y*8,10)
  sfx(55)
  return true
 end
 return false
end

function ai_attac(m)
	--★cut 2 tokens here, go to sword11 for old function
	local px,py,mx,my=p_mob.x,p_mob.y,m.x,m.y
 if dist(m.x,m.y,px,py)==1 then
  --attack player
  local dx,dy=px-mx,py-my
  mobbump(m,dx,dy)
  hitmob(m,p_mob)
  _upd=update_aiturn
	sfx(58)
	return true
 else
  --move to player
  if cansee(m,p_mob) then
   m.tx,m.ty=px,py
  end

  if mx==m.tx and my==m.ty then
   --de aggro
   m.task=ai_wait
   addfloat("?",mx*8+2,my*8,10)
   sfx(50)
  else
   local bdst,cand=999,{}
   calcdist(m.tx,m.ty)
   for i=1,4 do
	local dx,dy=dirx[i],diry[i]
	local tx,ty=mx+dx,my+dy
	if iswalkable(tx,ty,"checkmobs") then
	 local dst=distmap[tx][ty]
	 if dst<bdst then
	  cand={}
	  bdst=dst
	 end
	 if dst==bdst then
	  add(cand,{x=dx,y=dy})
	 end
	end
   end
   if #cand>0 then
	local c=getrnd(cand)
	mobwalk(m,c.x,c.y)
	return true
   end
   --re-acquire target? hard mode?
   if cansee(m,p_mob) and m.int > 0 then
	m.tx,m.ty=px, py
   end
   return true
  end

 end
 return false
end

function cansee(m1,m2)
	return dist(m1.x,m1.y,m2.x,m2.y)<=m1.los and los(m1.x,m1.y,m2.x,m2.y)
end

-----------------------------
--items

function makegem()
	--★

	local _gtp=gem_props[gem_types[min(100,flr(rnd(100))+1+luck)]]
	local _gqp=gem_props[gem_qual[min(100,flr(rnd(100))+1+luck)]]	--★
	local g={
		name=_gqp.name.." ".._gtp.name,
		col=_gtp.color,
		mod=_gtp.mod,
		base=_gtp.base,
		mult=_gqp.mult,
		effect=_gtp.effect
	}
	return g
end

function makepowergem()
	local pg=powergems.powercut
	local p={
		name=pg.name,
		col=pg.color,
		desc=pg.desc	}
	return p
end


function takeitem(itm)
	local i=freeslot(inv,6)
	if (i==0) return false
	inv[i]=itm
	return true
end

function freeslot(set,slots)
	for i=1,slots do
		if not set[i] then
			return i
		end
	end
	return 0
end
-->8
--gen


function mapgen()
 --★
 for x=0,15 do
  for y=0,15 do
   mset(x,y,2)
  end
 end
 
 genrooms()
 mazeworm()
 placeflags()
 carvedoors()
end

----------------
-- rooms
----------------

function genrooms()
 -- tweak dis
 local fmax,rmax=5,4 --5,4?
 local mw,mh=6,6     --5,5?
 
 repeat
  --todo: 1st room bigger?
  local r=rndroom(mw,mh)
  if placeroom(r) then
   rmax-=1
  else
   fmax-=1
   --★
   if r.w>r.h then
    mw=max(mw-1,3)
   else
    mh=max(mh-1,3)
   end
  end
 until fmax<=0 or rmax<=0
 --debug[1]="fails: "..fmax
 --debug[2]="rooms: "..rmax
end

function rndroom(mw,mh)
 --clamp max area
 local _w=3+flr(rnd(mw-2))
 mh=max(35/_w,3)
 local _h=3+flr(rnd(mh-2))
 return {
  x=0,
  y=0,
  w=_w,
  h=_h
 }
end

function placeroom(r)
 local cand,c={}
 
 for _x=0,16-r.w do
  for _y=0,16-r.h do
   if doesroomfit(r,_x,_y) then
    add(cand,{x=_x,y=_y})
   end
  end
 end
 
 if #cand==0 then return false end
 
 c=getrnd(cand)
 r.x=c.x
 r.y=c.y
  
 for _x=0,r.w-1 do
  for _y=0,r.h-1 do
   mset(_x+r.x,_y+r.y,1)
  end
 end
 return true
end

function doesroomfit(r,x,y)
 for _x=-1,r.w do
  for _y=-1,r.h do
   if iswalkable(_x+x,_y+y) then
    return false
   end
  end
 end
 
 return true
end

----------------
-- maze
----------------

function mazeworm()
 repeat
  local cand={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) and getsig(_x,_y)==255 then
     add(cand,{x=_x,y=_y})
    end
   end
  end
 
  if #cand>0 then
   local c=getrnd(cand)
   digworm(c.x,c.y)
  end
 until #cand<=1
end

function digworm(x,y)
 local dr,stp=1+flr(rnd(4)),0
 
 repeat
  mset(x,y,1)
  if not cancarve(x+dirx[dr],y+diry[dr]) or (rnd()<0.5 and stp>2) then
   stp=0
   local cand={}
   for i=1,4 do
    if cancarve(x+dirx[i],y+diry[i]) then
     add(cand,i)
    end
   end
   if #cand==0 then
    dr=8
   else
    dr=getrnd(cand)
   end
  end
  x+=dirx[dr]
  y+=diry[dr]
  stp+=1
 until dr==8 
end

function cancarve(x,y)
 if inbounds(x,y) and not iswalkable(x,y) then
  local sig=getsig(x,y)
  for i=1,#crv_sig do
   if bcomp(sig,crv_sig[i],crv_msk[i]) then 
    return true 
   end
  end
 end
 return false
end

function bcomp(sig,match,mask)
 local mask=mask and mask or 0
 return bor(sig,mask)==bor(match,mask)
end

function getsig(x,y)
 local sig,digit=0
 for i=1,8 do
  local dx,dy=x+dirx[i],y+diry[i]
  --★
  if iswalkable(dx,dy) then
   digit=0
  else
   digit=1
  end
  sig=bor(sig,shl(digit,8-i))
 end
 return sig
end

----------------
-- doorways
----------------

function placeflags()
 local curf=1
 flags=blankmap(0)
 for _x=0,15 do
  for _y=0,15 do
   if iswalkable(_x,_y) and flags[_x][_y]==0 then
    growflag(_x,_y,curf)
    curf+=1
   end
  end
 end
end


function growflag(_x,_y,flg)
 local cand,candnew={{x=_x,y=_y}}
  
 repeat
  candnew={}
  for c in all(cand) do
   flags[c.x][c.y]=flg
   for d=1,4 do
    local dx,dy=c.x+dirx[d],c.y+diry[d]
    if iswalkable(dx,dy) and flags[dx][dy]!=flg then
     add(candnew,{x=dx,y=dy})
    end
   end
  end
  cand=candnew
 until #cand==0
end

function carvedoors()
 local x1,y1,x2,y2,found,_f1,_f2=1,1,1,1
 repeat
  local drs={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) then
     local sig=getsig(_x,_y)
     found=false
     --horiz, mask shows we don't care about diagonals
     if bcomp(sig,0b11000000,0b00001111) then
      x1,y1,x2,y2,found=_x,_y-1,_x,_y+1,true
      --same thing here but vert
     elseif bcomp(sig,0b00110000,0b00001111) then
      x1,y1,x2,y2,found=_x+1,_y,_x-1,_y,true
     end
     _f1=flags[x1][y1]
     _f2=flags[x2][y2]
     if found and _f1!=_f2 then
      add(drs,{x=_x,y=_y,f1=_f1,f2=_f2})
     end
    end
   end
  end
  
  if #drs>0 then
   local d=getrnd(drs)
   --punch door in wall
   mset(d.x,d.y,1)
   --pick a flag, and then grow it, to show the algorithm that no door is needed, as it is all one room
   growflag(d.x,d.y,d.f1)  
  end
 until #drs==0
end
__gfx__
00000000000000001dd1dd119aa9aa990ccccc0000ccc00000ccc00000ccc000000000000000000000000000000000000cccccc0000000000000000000000000
0000000000000000d1d11d1da9a99a9acccc1cc00c000c000c000c000c000c0001c11c1001c11c1001c11c1000000000cc1111cc00000000cc000000dd000000
00700700000000001111dd1d9999aa9acc1111c00c000c000c000c000c000c00ccc11cccccc11cccccc11ccc00000000c111111c00000000cc0cc000dd0dd000
00077000000000001111d1119999a999ccc1ccc0c0ccc0c0c0ccc0c0c0ccc0c0c111111cc111111cc111111c00000000c111111c00000000cc0cc0c0dd0dd0d0
0007700000000000ddd11dd1aaa99aa9c1111cc0cc000cc0cc000cc0cc000cc0c111111cc111111cc111111c00000000c111191c00000000cc0cc0c0dd0dd0d0
0070070000000000dd1d111daa9a999acc1cccc0ccccccc0ccccccc0ccccccc01cc99cc11cc99cc11cc99cc100000000c111111c00000000000cc0c0000dd0d0
00000000000010001d1111119a999999ccccccc00ccccc000ccccc000ccccc0011111111111111111111111100000000c111111c00000000000000c0000000d0
0000000000000000d1111d11a9999a990000000000ccc00000ccc00000ccc000cccccccccccccccccccccccc00000000cccccccc000000000000000000000000
00000000dddddddddddddd500000000000000000dd0660dd000099a9444499a900000000000099a90000000000000000000000000000006c0000000008808800
77777777ddddddddddddd5007000000077777777ddd00ddd000099a9444499a900000009000099a9990000000000000005ccc600000006c600dddd002888e880
ccccccccdddddddddddd5000c7000000ccccccccdddddddd000099a9444499a90000009900009a9099900000000000005ccccc6000006c600d66666028888880
ccccccccddddddddddd50000cc700000ccccccccdddddddd999999a9444499a900000999090099900090000000000000511111c00906c6000d60060028888880
ccccccccdddddddddd500000ccc70000ccccccccdddddddd444499a9555599a90000999a0999990000000000000000005cc1ccc0009960000d66606002888800
ccccccccddddddddd5000000cccc7000ccccccccdddddddd444499a9000099a9000099a90009900000000000000000005cc1ccc00599000000d666d000288000
cccccccc1111111150000000ccccc700ccc00ccc11111111444499a9000099a9000099a90000000000000000000000005cc1ccc0545090000006060000020000
111111110000000000000000111111101106701100000000444499a9000099a9000099a900000000000000000000000000000000450000000000000000000000
00111100000000000000000006660000066600000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0119a110707067007000000000600000006000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000
019aaa106060607070606000088700000cc700000557000000000000000000000000000000000000000000000000000000000000000000000000000000000000
019aaa10070060607060670088888000ccccc0005555500000000000000000000000000000000000000000000000000000000000000000000000000000000000
019aaa100600660077606700088800000ccc00000555000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0199a910607060000006070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01199110606060000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000008000000090000000000000000006660000066600000000000000000000606060006060600000000000000000000000000000000000000000000000000
00600604006006040060060800600609066666000666660000666000006660006060660060606600060606000606060000000000000000000000000000000000
00666604006666040066660400666604666606606666066006666600066666000606666006066660606066006060660000000000000000000000000000000000
06686864066868640668680406686804666060606660606066660660666606606066666060666660060666600606666000000000000000000000000000000000
66666664666666646666666466666664666666606666666066606060666060600666666606666666606666666066666600000000000000000000000000000000
60666604606666046066666460666664066666000666660006666600066666006666060666660606066606060666060600000000000000000000000000000000
06666600066666000666660406666604066066000660660006606600066066000066666600666666006666660066666600000000000000000000000000000000
66666600666666006666660066666600006060000060600000606000006060000006666000066660000666600006666000000000000000000000000000000000
06000600060006000000000000000000000660000006600000000000000000000000000c0000000c000000000000000000000000000000000000000000000000
06666600066666000600060006000600006606000066060000066000000660000060060c0060060c0000000c0000000c00000000000000000000000000000000
06696900066969000666660006666600066060600660606000660600006606000066660c0066660c0060060c0060060c00000000000000000000000000000000
06666600066666000669690006696900066606600666066006606060066060600666066c0666066c0066660c0066660c00000000000000000000000000000000
666666606666666066666660666666600666666006666660066606600666066066666664666666640666066c0666066c00000000000000000000000000000000
66666660666666606666666066666660066666600666666066666666666666666066660060666600666666646666666400000000000000000000000000000000
06000600060006000000600000006000006666000066660066666666666666660666660006666600606666006066660000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006666660066666600066666000666660000000000000000000000000000000000
66606606666066060000000000000000006666000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666066666666660660666606606066666600666666000666600006666000000000000000000000000000000000000000000000000000000000000000000
06660606066606060666666606666666666600666666006606600660066006600000000000000000000000000000000000000000000000000000000000000000
006666600066666006660606066606066660bb066660bb06660bb066660bb0660000000000000000000000000000000000000000000000000000000000000000
060666660606666600666660006666606660bb066660bb06660bb066660bb0660000000000000000000000000000000000000000000000000000000000000000
00066606000666060606666606066666666600666666006666600666666006660000000000000000000000000000000000000000000000000000000000000000
00066600000666000006660600066606066666600666666006666660066666600000000000000000000000000000000000000000000000000000000000000000
00600600006006000000600000006000006666000066660000666600006666000000000000000000000000000000000000000000000000000000000000000000
00ccc00c00ccc00c0000000000000000006660000066600000666000006660000000000000000000000000000000000000000000000000000000000070000000
0ccccc0c0ccccc0c00ccc00c00ccc00c066666000666660006666600066666000000000000000000000000000000000000000000000000000000000077000000
0cc0000c0cc0000c0ccccc0c0ccccc0c066d6d00066d6d00066d6d00066d6d000000000000000000000000000000000000000000000000000000000077700000
0ccc0c0c0ccc0c0c0cc0000c0cc0000c666666606666666066666660666666600000000000000000000000000000000000000000000000000000000077000000
6666664c6666664c0ccc0c0c0ccc0c0c0666d6000666d6000666d6000666d6000000000000000000000000000000000000000000000000000000000070000000
46666600466666000666664c0666664c666666006666660006666600066666000000000000000000000000000000000000000000000000000000000000000000
06666600066666004666660046666600066666000666660066666600666666000000000000000000000000000000000000000000000000000000000000000000
06000600060006000600060006000600066660000666600006666000066660000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888777777888eeeeee888eeeeee888eeeeee888eeeeee888eeeeee888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88778877788ee888ee88ee888ee88ee8e8ee88ee888ee88ee8eeee88888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee8777787778eeeee8ee8eeeee8ee8eee8e8ee8eee8eeee8eee8eeee88888e88888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8777787778eee888ee8eeee88ee8eee888ee8eee888ee8eee888ee8888eee8888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee8777787778eee8eeee8eeeee8ee8eeeee8ee8eeeee8ee8eee8e8ee88888e88888888888ff888ff888822228888228222888882282888222288888
888eee888ee8777888778eee888ee8eee888ee8eeeee8ee8eee888ee8eee888ee888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee8777777778eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee11111bbb1bbb1bb11bbb11711c1c117111111eee1e1e1eee1ee11111111111111111111111111111111111111111111111111111111111111111
111111e11e1111111b1b11b11b1b1b1b17111c1c1117111111e11e1e1e111e1e1111111111111111111111111111111111111111111111111111111111111111
111111e11ee111111bb111b11b1b1bbb17111ccc1117111111e11eee1ee11e1e1111111111111111111111111111111111111111111111111111111111111111
111111e11e1111111b1b11b11b1b1b111711111c1117111111e11e1e1e111e1e1111111111111111111111111111111111111111111111111111111111111111
11111eee1e1111111bbb11b11b1b1b111171111c1171111111e11e1e1eee1e1e1111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111116161666166111111616166616611666166616661111116616661666166611111111111111111111111111111111111111111111111111111111
11111111111116161616161617771616161616161616116116111111161116161666161111111111111111111111111111111111111111111111111111111111
11111111111116161666161611111616166616161666116116611111161116661616166111111111111111111111111111111111111111111111111111111111
11111111111116161611161617771616161116161616116116111111161616161616161111111111111111111111111111111111111111111111111111111111
11111111166611661611166611111166161116661616116116661666166616161616166611111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111166616611616161616661661166111111661161616661111116616661666166616161666166116611661111116611616166611111166161611661666
11111111116116161616161611611616161611111616161616161111161111611616116116161161161616161161111116161616161611111611161616161616
11111111116116161616161611611616161611111616161616611111166611611666116116161161161616161161111116161616166111111666161616161661
11111111116116161666166611611616161611111616161616161171111611611616116116661161161616161161111116161616161611711116166616161616
11111111166616161161166616661616166611711666116616161711166111611616116116661666161616661666117116661166161617111661166616611616
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1ee11ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1e1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ddd1d1d1ddd1ddd11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111d1d1d111d1d1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ddd1ddd11dd1ddd111d1ddd11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111d111d111d111d11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ddd111d111d1ddd11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111116661166161616661111166616661661161611711616166116611171111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111116661616161616111111166616111616161617111616161616161117111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111116161616161616611111161616611616161617111616161616161117111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111116161616166616111111161616111616161617111666161616161117111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116161661116116661666161616661616116611711666161616661171111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e1111111666116616161666166611111cc1111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e111e1e1e11111116661616161616111616177711c1111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e111eee1e11111116161616161616611661111111c1111111111111111111111111111111111111111111117111111111111111111111111111
11111e111e1e1e111e1e1e11111116161616166616111616177711c1111111111111111111111111111111111111111111117711111111111111111111111111
11111eee1ee111ee1e1e1eee11111616166111611666161611111ccc111111111111111111111111111111111111111111117771111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117777111111111111111111111111
11111eee1eee11111bbb1bbb1bb11bbb11711ccc117111111eee1e1e1eee1ee11111111111111111111111111111111111117711111111111111111111111111
111111e11e1111111b1b11b11b1b1b1b1711111c1117111111e11e1e1e111e1e1111111111111111111111111111111111111171111111111111111111111111
111111e11ee111111bb111b11b1b1bbb17111ccc1117111111e11eee1ee11e1e1111111111111111111111111111111111111111111111111111111111111111
111111e11e1111111b1b11b11b1b1b1117111c111117111111e11e1e1e111e1e1111111111111111111111111111111111111111111111111111111111111111
11111eee1e1111111bbb11b11b1b1b1111711ccc1171111111e11e1e1eee1e1e1111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee111116661166166616611171161616611661111111661616166611111cc1111116161661166111111166161616661666117111111eee1e1e
1111111111e11e111111116116111161161617111616161616161111161116161616111111c11111161616161616111116111616116116161117111111e11e1e
1111111111e11ee11111116116661161161617111616161616161111161116161661177711c11111161616161616111116661661116116661117111111e11eee
1111111111e11e111111116111161161161617111666161616161111161116161616111111c11171166616161616111111161616116116111117111111e11e1e
111111111eee1e11111116661661166616161171166616161666117111661166161611111ccc1711166616161666117116611616166616111171111111e11e1e
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111116161661166111111166161616661111111116661166161616661666111111111111111111111111111111111111111111111111111111111111
11111111111116161616161611111611161616161111177716661616161616111616111111111111111111111111111111111111111111111111111111111111
11111111111116161616161611111611161616611777111116161616161616611661111111111111111111111111111111111111111111111111111111111111
11111111111116661616161611111611161616161111177716161616166616111616111111111111111111111111111111111111111111111111111111111111
11111111111116661616166611711166116616161111111116161661116116661616111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1ee11ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1e1e1eee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1111ee1eee1eee1eee11111bbb1bbb1bb11bbb11711ccc117111111eee1e1e1eee1ee1111111111111111111111111111111111111111111111111
11111e111e111e111e1111e11e1111111b1b11b11b1b1b1b1711111c1117111111e11e1e1e111e1e111111111111111111111111111111111111111111111111
11111ee11e111eee1ee111e11ee111111bb111b11b1b1bbb171111cc1117111111e11eee1ee11e1e111111111111111111111111111111111111111111111111
11111e111e11111e1e1111e11e1111111b1b11b11b1b1b111711111c1117111111e11e1e1e111e1e111111111111111111111111111111111111111111111111
11111eee1eee1ee11eee1eee1e1111111bbb11b11b1b1b1111711ccc1171111111e11e1e1eee1e1e111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee111116661166166616611171161616611661111111661616166611111cc1111116161661166111111166161616661666117111111eee1e1e
1111111111e11e111111116116111161161617111616161616161111161116161616117111c11111161616161616111116111616116116161117111111e11e1e
1111111111e11ee11111116116661161161617111616161616161111161116161661177711c11111161616161616111116661661116116661117111111e11eee
1111111111e11e111111116111161161161617111666161616161111161116161616117111c11171166616161616111111161616116116111117111111e11e1e
111111111eee1e11111116661661166616161171166616161666117111661166161611111ccc1711166616161666117116611616166616111171111111e11e1e
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111616166116611111116616161666111111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111161616161616111116111616161611711777111c1111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111616161616161111161116161661177711111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111666161616161111161116161616117117771c111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111666161616661171116611661616111111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1e1111ee1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e111e111e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e111eee1ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e11111e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee1ee11eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111616166116611111116616161666111111111cc11111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111116161616161611111611161616161171177711c11111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111116161616161611111611161616611777111111c11111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111116661616161611111611161616161171177711c11111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111666161616661171116611661616111111111ccc1111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1ee11ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822282228882822882288222888888888888888888888888888888888888888882228282828282228882822282288222822288866688
82888828828282888888888282828828882888288282888888888888888888888888888888888888888888828282828288828828828288288282888288888888
82888828828282288888822282228828882888288282888888888888888888888888888888888888888888228222822288228828822288288222822288822288
82888828828282888888828882828828882888288282888888888888888888888888888888888888888888828882888288828828828288288882828888888888
82228222828282228888822282228288822282228222888888888888888888888888888888888888888882228882888282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000050503030303030303030703020200000000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
__map__
02020202020202020202020202020202181a0303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020ff006060201010101020201010e0216141414101010101010101010101013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0206060606020102020c02020101010217151515111111111111111111111112000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0205060606020102010101020102010219030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020c02020c020101c8020102010203030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020101010101d402c8010502080201020303f01b030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020102020202020202020202020201020303011b030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201020501e4010201010101010c01020303011b030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020102010101010201020202020201020303011b030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020102010101010201020901d00201020303011b030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02d402010101010201020101010201020303011b030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010202020c02020c020102020201020303011b030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101010201d0010c01020303011b030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020203030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002f050240501e0502905038050320502c050280501e0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
980100001e1201f120201202112023120241202512026120241201c120151201712018120191201b1201f120201202412026120231201f1201a12016120181201c12022120000000000000000000000000000000
980100001802018020180201802018020180201802018020180201302013020130201302015020180201d02022020000000000000000000000000000000000000000000000000000000000000000000000000000
9801000025020250202502025020250202502025020250202902029020290202902029020290202902029020290002900029000290003f0003f0003f000000000000000000000000000000000000000000000000
b901000024110241102411024110241101c1101c1101c1101c1101c1101f1101f1101f1101f1101f110317003570035700327002c700257001f7001e7001f70022700277002a7000000000000000000000000000
b9010000220202202022020220202202028020280202802028020280202801038010380103f7003f7003f7002d0002d0000000000000000000000000000000000000000000000000000000000000000000000000
090100002b7202d7202f72032720327202f7202d7202a7202572023720237202472025720287202e7203572038720387200000024200000002120000000232000000000000000000000000000000000000000000
90010000143101431014310143101431013310133101231012310260002b000113102f00010310103101031039000390002d00000000000003900000000000000000000000000000000000000000000000000000
90010000167201d620167201e6201d620177101c610177101c600247001b6001b6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900100002f1402b140291402614023140211301f130216300b5300a5300b530246302363022630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b101000017110171101d110221100c5100d5100d510216100b5100a5100b510246102361022610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020100001773528735237351f7351a72518725157251372518725282251f22515225142250d2150b2150a2150961507615056150561505615056150561506615066150761507615137051270511705107050f705
000100001773028730237301f7301a720187201572013720187202d72035720357203472019700177001770019700197001a7001b7001b7001a7001a70019700177001570014700137001270011700107000f700
180100002203024030240301d030170201501013000110000f0000d0000b0000a0000800004100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900100000e720147200e7200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
