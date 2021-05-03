pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--[[cursed sword by christopher gibilisco

credits:

deepest thanks to krystian majewski of lazydevs academy for the use of his game porklike as an engine for this game. much of the code of this game was designed by him, and i thank him especially for his ingenious level procedural generator, and the binary signature technique. porklike was released under the cc by-nc-sa 4.0 license, which is linked below, as it is also this game's license.

michael s, who conceived many of the power gems. thanks, michael!

the json parser program was designed by tylerneylon, adapted by feneric, which tylerneylon has released into the public domain. feneric's adaptation of it is released under the gpl v3 license: https://www.gnu.org/licenses/gpl-3.0.en.html.

enemy and potion artwork licensed from oryx design labs, www.oryxdesignlab.com. (includes tiles 35-37,192-254)

this game is released under the cc by-nc-sa 4.0 license, except for the above-mentioned artwork licensed from oryx design labs, which you can read here: https://creativecommons.org/licenses/by-nc-sa/4.0/
--]]


function _init()
	t=0

	_gt=json_parse('{"mob_name":["hero","slime","eyeball","demon minion","demon mage","mindflayer","ghost","fire elemental","hellion","slayer"],"mob_atk":[1,1,1,1,1,1,1,1,1,1],"mob_hp":[10,1,1,1,1,1,1,1,1,1],"mob_los":[5,4,10,5,5,5,4,4,4,5],"mob_ani":[240,212,228,208,192,196,244,224,200,216],"mob_col":[12,3,6,8,14,11,7,9,9,13],"mob_def":[0,0,0,0,0,0,0,0,0,0],"mob_int":[1,0,1,1,1,0,1,0,0,1],"mob_quench":[0,10,10,10,10,10,10,10,10,10],"gems":{"a":{"name":"amethyst","color":12,"mod":"atk","base":1},"r":{"name":"ruby","color":14,"mod":"♥","base":5},"d":{"name":"diamond","color":7,"mod":"⧗","base":1},"e":{"name":"emerald","color":11,"mod":"luck","base":1},"c":{"name":"chipped","mult":1},"rh":{"name":"rough","mult":2},"ct":{"name":"cut","mult":3},"f":{"name":"flawless","mult":5},"rc":{"name":"relic","mult":10}},"gem_types":["e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a ","e","r","a","e","r","a","e","r","a","e","r","a","e","r","a","d","d","d","d"],"gem_qual":["c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","c","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","rh","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","ct","f","f","rc"],"powergems":{"powercut":{"name":"power cut","color":8,"desc":[" 2x atk, slower swings"]}},"npcs":{},"tools":{"dirx":[-1,1,0,0,1,1,-1,-1],"diry":[0,0,-1,1,-1,1,1,-1],"dpal":[0,1,1,2,1,13,6,4,4,9,3,13,1,13,14],"carve_signatures":["0b11111111","0b11010110","0b01111100","0b10110011","0b11101001"],"carve_masks":[0,"0b00001001","0b00000011","0b00001100","0b00000110"]}}')
	mob_name=_gt.mob_name
	mob_atk=_gt.mob_atk
	mob_hp= _gt.mob_hp
	mob_los=_gt.mob_los
	mob_ani=_gt.mob_ani
	mob_col=_gt.mob_col
	mob_def=_gt.mob_def
	mob_int=_gt.mob_int
	mob_quench=_gt.mob_quench

	gem_types,gem_qual,gem_props,powergems=_gt.gem_types,_gt.gem_qual,_gt.gems,_gt.powergems

	tools=_gt.tools

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
	mob,dmob={},{}
	p_mob=addmob(1,0,0)

	--★
	p_t=0
	--keep dig at the end
	level,luck,thirst,thirstrate,gold,turn,dig=1,0,999,1,0,0
	inv,eqp={},{}
	inv[1]=makepowergem()
	wind,float={},{}

	fog=blankmap(0)
	hpwind=addwind(5,5,108,13,{})

	_upd,_drw=update_game,draw_game

	genfloor(0)
	unfog()
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
		trig_step()
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
		skipai=false
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
 local cand,step,candnew={},0
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
	local destx,desty=p_mob.x+dx,p_mob.y+dy
	local tle=mget(destx,desty)
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
			end
		end
	end
	unfog()
end

function trig_bump(tle,destx,desty)
	--sfx(tle.sfx)
	--mset(destx,desty,tle.after_tile
	--destx and desty *8 local variable
		if tle==12 then
			sfx(62)
			mset(destx,desty,1)
		end
		if tle==8 then
		--★ randomization with luck
			sfx(61)
			local amt=5--ceil(level/2)*5
			addfloat("♥"..amt,destx*8,desty*8,8)
			treasure("♥",amt)
			mset(destx,desty,1)
		end
		if tle==9 then
			sfx(61)
			--★ randomization with luck
			local amt=5--ceil(level/2)*f.gold+flr(rnd(luck+1))
			addfloat("◆"..amt,destx*8,desty*8,9)
			treasure("◆",amt)
			mset(destx,desty,1)
		end
		if tle==2 then
			skipai=true
		end
		return
end

function trig_step()
 if mget(p_mob.x,p_mob.y)==14 then
  fadeout()
  genfloor(floor+1)
  floormsg()
  return true --trigger something just in case
 end
 return false
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
 local wid=(#txt+4)*4+7
 local w=addwind(63-wid/2,50,wid,13,{" "..txt})
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

function floormsg()
	showmsg("floor b"..floor,120)
end
-->8
--mobs and items

function addmob(typ,mx,my)
	local q={
		n=mob_name[typ],
		ox=0,
		oy=0,
		flp=false,
		flash=0,
		ani={},
		atk=mob_atk[typ],
		def=0,
		hp=mob_hp[typ],
		basehpmax=mob_hp[typ],
		hpmax=mob_hp[typ],
		quench=mob_quench[typ],
		col=mob_col[typ],
		los=mob_los[typ],
		int=mob_int[typ],--could go, if tokens needed, but i doubt it
		x=mx,
		y=my,
		task=ai_wait}

	 for i=0,3 do
	  add(q.ani,mob_ani[typ]+i)
 	end

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
	  add(cand,i)
	 end
	end
   end
   if #cand>0 then
	local c=getrnd(cand)
	mobwalk(m,dirx[c],diry[c])
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
function genfloor(f)
	--★ add message for floor #
	floor=f
	mapgen()
end

function mapgen()
 --★
 for x=0,15 do
  for y=0,15 do
   mset(x,y,2)
  end
 end
 --todo

 --no doors next to doors
 --entry not in an alcove
 --check for isolated rooms
 --re-add comments
 --play a sound when you move a menu arrow
	--get sounds for all object interactions
			--happy vase,sad vase
	--hub level
 --monsters
 --items
 --decorations

 rooms={}
 roommap=blankmap(0)
 doors={}
 genrooms()
 mazeworm()
 placeflags()
 carvedoors()
 carvescuts()
 startend()
	fillends()
 installdoors()
end

----------------
-- rooms
----------------

function genrooms()
 -- tweak dis
 local fmax,rmax=5,5 --5,4?
 local mw,mh=5,5     --5,5?

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
 mh=mid(35/_w,3,mh)
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
 add(rooms,r)
 for _x=0,r.w-1 do
  for _y=0,r.h-1 do
   mset(_x+r.x,_y+r.y,1)
   roommap[_x+r.x][_y+r.y]=#rooms
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
  if not cancarve(x+dirx[dr],y+diry[dr],false) or (rnd()<0.5 and stp>2) then
   stp=0
   local cand={}
   for i=1,4 do
    if cancarve(x+dirx[i],y+diry[i],false) then
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

function cancarve(x,y,walk)
 if inbounds(x,y) and iswalkable(x,y)==walk then
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
 flags[_x][_y]=flg
 repeat
  candnew={}
  for c in all(cand) do
   for d=1,4 do
    local dx,dy=c.x+dirx[d],c.y+diry[d]
    if iswalkable(dx,dy) and flags[dx][dy]!=flg then
     flags[dx][dy]=flg
     add(candnew,{x=dx,y=dy})
    end
   end
  end
  cand=candnew
 until #cand==0
end

function carvedoors()
 local x1,y1,x2,y2,found,_f1,_f2,drs=1,1,1,1
 repeat
  drs={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) then
     local sig=getsig(_x,_y)
     found=false
     if bcomp(sig,0b11000000,0b00001111) then
      x1,y1,x2,y2,found=_x,_y-1,_x,_y+1,true
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
   --★
   add(doors,d)
   mset(d.x,d.y,1)
   growflag(d.x,d.y,d.f1)
  end
 until #drs==0
end

function carvescuts()
 local x1,y1,x2,y2,cut,found,drs=1,1,1,1,0
 repeat
  drs={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) then
     local sig=getsig(_x,_y)
     found=false
     if bcomp(sig,0b11000000,0b00001111) then
      x1,y1,x2,y2,found=_x,_y-1,_x,_y+1,true
     elseif bcomp(sig,0b00110000,0b00001111) then
      x1,y1,x2,y2,found=_x+1,_y,_x-1,_y,true
     end
     if found then
      calcdist(x1,y1)
      if distmap[x2][y2]>20 then
       add(drs,{x=_x,y=_y})
      end
     end
    end
   end
  end

  if #drs>0 then
   local d=getrnd(drs)
   add(doors,d)
   mset(d.x,d.y,1)
   cut+=1
  end
 until #drs==0 or cut>=3
end

function fillends()
 local cand,tle
 repeat
  cand={}
  for _x=0,15 do
   for _y=0,15 do
   	tle=mget(_x,_y)
    if cancarve(_x,_y,true) and tle!=14 and tle!=15 then
     add(cand,{x=_x,y=_y})
    end
   end
  end

  for c in all(cand) do
   mset(c.x,c.y,2)
  end
 until #cand==0
end

function isdoor(x,y)
 local sig=getsig(x,y)
 if bcomp(sig,0b11000000,0b00001111) or bcomp(sig,0b00110000,0b00001111) then
  return nexttoroom(x,y)
 end
 return false
end


function nexttoroom(x,y)
 for i=1,4 do
  if inbounds(x+dirx[i],y+diry[i]) and
     roommap[x+dirx[i]][y+diry[i]]!=0 then
   return true
  end
 end
 return false
end

function installdoors()
 for d in all(doors) do
  if mget(d.x,d.y)==1 and iswalkable(d.x,d.y) and isdoor(d.x,d.y) then
   mset(d.x,d.y,12)
  end
 end
end

----------------
-- decoration
----------------
function startend()
 local high,low,px,py,ex,ey=0,9999
 repeat
  px,py=flr(rnd(16)),flr(rnd(16))
 until iswalkable(px,py)

 calcdist(px,py)
 --★ callback function
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if iswalkable(x,y) and tmp>high then
    px,py,high=x,y,tmp
   end
  end
 end
 calcdist(px,py)
 high=0
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>high and cancarve(x,y,false) then
    ex,ey,high=x,y,tmp
   end
  end
 end
 mset(ex,ey,14)

 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>=0 and tmp<low and cancarve(x,y,false) then
    px,py,low=x,y,tmp
   end
  end
 end
 --★
 mset(px,py,15)
 p_mob.x=px
 p_mob.y=py
end
__gfx__
0000000000000000666660609aa9aa990ccccc0000ccc00000ccc00000ccc000000000000000000000000000000000000cccccc0000000000000000000000000
0000000000000000ddddd0d0a9a99a9acccc0cc00c000c000c000c000c000c0000cccc0000cccc0000cccc0000000000c0c00c0c00000000cc00000055000000
0070070000000000000000009999aa9acc0000c00c000c000c000c000c000c00cc0000cccc0000cccc0000cc0000000000c00c0000000000cc0cc00055055000
0007700000000000660666609999a999ccc0ccc0c0ccc0c0c0ccc0c0c0ccc0c0c000000cc000000cc000000c00000000c000000c00000000cc0cc0c055055050
0007700000000000dd0dddd0aaa99aa9c0000cc0cc000cc0cc000cc0cc000cc0c000000cc000000cc000000c000000000c0aa0c000000000cc0cc0c055055050
007007000000000000000000aa9a999acc0cccc0ccccccc0ccccccc0ccccccc00ccaacc00ccaacc00ccaacc000000000cc0aa0cc00000000000cc0c000055050
000000000000d000666066609a999999ccccccc00ccccc000ccccc000ccccc00000000000000000000000000000000000c0000c000000000000000c000000050
000000000000000000000000a9999a990000000000ccc00000ccc00000ccc000cccccccccccccccccccccccc00000000cc0cc0cc000000000000000000000000
00000000dddddddddddddd500000000000000000dd0660dd000099a9444499a900000000000099a90000000000000000000000000000006c0000000008808800
77777777ddddddddddddd5007000000077777777ddd00ddd000099a9444499a900000009000099a9990000000000000000000000000006c600dddd002888e880
ccccccccdddddddddddd5000c7000000ccccccccdddddddd000099a9444499a90000009900009a9099900000000000000000000000006c600d66666028888880
ccccccccddddddddddd50000cc700000ccccccccdddddddd999999a9444499a900000999090099900090000000000000000000000906c6000d60060028888880
ccccccccdddddddddd500000ccc70000ccccccccdddddddd444499a9555599a90000999a09999900000000000000000000000000009960000d66606002888800
ccccccccddddddddd5000000cccc7000ccccccccdddddddd444499a9000099a9000099a9000990000000000000000000000000000599000000d666d000288000
cccccccc1111111150000000ccccc700ccc00ccc11111111444499a9000099a9000099a900000000000000000000000000000000545090000006060000020000
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
0066600c0066600c0000000000000000006660000066600000666000006660000000000000000000000000000000000000000000000000000000000070000000
0666660c0666660c0066600c0066600c066666000666660006666600066666000000000000000000000000000000000000000000000000000000000077000000
0660000c0660000c0666660c0666660c066d6d00066d6d00066d6d00066d6d000000000000000000000000000000000000000000000000000000000077700000
0666060c0666060c0660000c0660000c666666606666666066666660666666600000000000000000000000000000000000000000000000000000000077000000
6666664c6666664c0666060c0666060c0666d6000666d6000666d6000666d6000000000000000000000000000000000000000000000000000000000070000000
46666600466666000666664c0666664c666666006666660006666600066666000000000000000000000000000000000000000000000000000000000000000000
06666600066666004666660046666600066666000666660066666600666666000000000000000000000000000000000000000000000000000000000000000000
05000500050005000500050005000500066660000666600006666000066660000000000000000000000000000000000000000000000000000000000000000000
__label__
1dd1dd111dd1dd111dd1dd111dd1dd111dd1dd111dd1dd1100ccc00c1dd1dd111dd1dd11000000000000000000000000000000001dd1dd110000000000000000
d1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1d0ccccc0cd1d11d1dd1d11d1d00000000000000000000000000000000d1d11d1d00000000cc000000
1111dd1d1111dd1d1111dd1d1111dd1d1111dd1d1111dd1d0cc0000c1111dd1d1111dd1d000000000000000000000000000000001111dd1d00000000cc0cc000
1111d1111111d1111111d1111111d1111111d1111111d1110ccc0c0c1111d1111111d111000000000000000000000000000000001111d11100000000cc0cc0c0
ddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd1cccccc4cddd11dd1ddd11dd100000000000000000000000000000000ddd11dd100000000cc0cc0c0
dd1d111ddd1d111ddd1d111ddd1d111ddd1d111ddd1d111d4ccccc00dd1d111ddd1d111d00000000000000000000000000000000dd1d111d00000000000cc0c0
1d1111111d1111111d1111111d1111111d1111111d1111110ccccc001d1111111d111111000010000000100000001000000010001d11111100001000000000c0
d1111d11d1111d11d1111d11d1111d11d1111d11d1111d1105000500d1111d11d1111d1100000000000000000000000000000000d1111d110000000000000000
1dd1dd111dd1dd1100000000000000000000000000000000000000001dd1dd111dd1dd11000000001dd1dd111dd1dd110000000000000000000000001dd1dd11
d1d11d1dd1d11d1d0000000000000000000000000000000000000000d1d11d1dd1d11d1d00000000d1d11d1dd1d11d1d000000000000000000000000d1d11d1d
1111dd1d1111dd1d00000000000000000000000000000000000000001111dd1d1111dd1d000000001111dd1d1111dd1d0000000000000000000000001111dd1d
1111d1111111d11100000000000000000000000000000000000000001111d1111111d111000000001111d1111111d1110000000000000000000000001111d111
ddd11dd1ddd11dd10000000000000000000000000000000000000000ddd11dd1ddd11dd100000000ddd11dd1ddd11dd1000000000000000000000000ddd11dd1
dd1d111ddd1d111d0000000000000000000000000000000000000000dd1d111ddd1d111d00000000dd1d111ddd1d111d000000000000000000000000dd1d111d
1d1111111d11111100001000000010000000100000001000000010001d1111111d111111000010001d1111111d1111110000100000001000000010001d111111
d1111d11d1111d110000000000000000000000000000000000000000d1111d11d1111d1100000000d1111d11d1111d11000000000000000000000000d1111d11
1dd1dd111dd1dd1100000000000000000000000000000000000000001dd1dd111dd1dd11000000001dd1dd111dd1dd111dd1dd111dd1dd11000000001dd1dd11
d1d11d1dd1d11d1d0000000000000000000000000000000000000000d1d11d1dd1d11d1d00000000d1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000d1d11d1d
1111dd1d1111dd1d00000000000000000000000000000000000000001111dd1d1111dd1d000000001111dd1d1111dd1d1111dd1d1111dd1d000000001111dd1d
1111d1111111d11100000000000000000000000000000000000000001111d1111111d111000000001111d1111111d1111111d1111111d111000000001111d111
ddd11dd1ddd11dd10000000000000000000000000000000000000000ddd11dd1ddd11dd100000000ddd11dd1ddd11dd1ddd11dd1ddd11dd100000000ddd11dd1
dd1d111ddd1d111d0000000000000000000000000000000000000000dd1d111ddd1d111d00000000dd1d111ddd1d111ddd1d111ddd1d111d00000000dd1d111d
1d1111111d11111100001000000010000000100000001000000010001d1111111d111111000010001d1111111d1111111d1111111d111111000010001d111111
d1111d11d1111d110000000000000000000000000000000000000000d1111d11d1111d1100000000d1111d11d1111d11d1111d11d1111d1100000000d1111d11
000000000cccccc000000000000000000000000000000000000000001dd1dd111dd1dd11000000001dd1dd111dd1dd111dd1dd111dd1dd11000000001dd1dd11
00000000cc1111cc0000000000000000000000000000000000000000d1d11d1dd1d11d1d00000000d1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000d1d11d1d
00000000c111111c00000000000000000000000000000000000000001111dd1d1111dd1d000000001111dd1d1111dd1d1111dd1d1111dd1d000000001111dd1d
00000000c111111c00000000000000000000000000000000000000001111d1111111d111000000001111d1111111d1111111d1111111d111000000001111d111
00000000c111191c0000000000000000000000000000000000000000ddd11dd1ddd11dd100000000ddd11dd1ddd11dd1ddd11dd1ddd11dd100000000ddd11dd1
00000000c111111c0000000000000000000000000000000000000000dd1d111ddd1d111d00000000dd1d111ddd1d111ddd1d111ddd1d111d00000000dd1d111d
00001000c111111c00001000000010000000100000001000000010001d1111111d111111000010001d1111111d1111111d1111111d111111000010001d111111
00000000cccccccc0000000000000000000000000000000000000000d1111d11d1111d1100000000d1111d11d1111d11d1111d11d1111d1100000000d1111d11
000000001dd1dd111dd1dd111dd1dd111dd1dd111dd1dd111dd1dd111dd1dd111dd1dd11000000001dd1dd111dd1dd111dd1dd111dd1dd110000000000000000
00000000d1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000d1d11d1dd1d11d1dd1d11d1dd1d11d1d0000000000000000
000000001111dd1d1111dd1d1111dd1d1111dd1d1111dd1d1111dd1d1111dd1d1111dd1d000000001111dd1d1111dd1d1111dd1d1111dd1d0000000000000000
000000001111d1111111d1111111d1111111d1111111d1111111d1111111d1111111d111000000001111d1111111d1111111d1111111d1110000000000000000
00000000ddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd100000000ddd11dd1ddd11dd1ddd11dd1ddd11dd10000000000000000
00000000dd1d111ddd1d111ddd1d111ddd1d111ddd1d111ddd1d111ddd1d111ddd1d111d00000000dd1d111ddd1d111ddd1d111ddd1d111d0000000000000000
000010001d1111111d1111111d1111111d1111111d1111111d1111111d1111111d111111000010001d1111111d1111111d1111111d1111110000100000001000
00000000d1111d11d1111d11d1111d11d1111d11d1111d11d1111d11d1111d11d1111d1100000000d1111d11d1111d11d1111d11d1111d110000000000000000
000000000000000000000000000000001dd1dd111dd1dd111dd1dd111dd1dd111dd1dd110cccccc01dd1dd111dd1dd111dd1dd111dd1dd111dd1dd1100000000
00000000000000000000000000000000d1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1dcc1111ccd1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000
000000000000000000000000000000001111dd1d1111dd1d1111dd1d1111dd1d1111dd1dc111111c1111dd1d1111dd1d1111dd1d1111dd1d1111dd1d00000000
000000000000000000000000000000001111d1111111d1111111d1111111d1111111d111c111111c1111d1111111d1111111d1111111d1111111d11100000000
00000000000000000000000000000000ddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd1c111191cddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd100000000
00000000000000000000000000000000dd1d111ddd1d111ddd1d111ddd1d111ddd1d111dc111111cdd1d111ddd1d111ddd1d111ddd1d111ddd1d111d00000000
000010000000100000001000000010001d1111111d1111111d1111111d1111111d111111c111111c1d1111111d1111111d1111111d1111111d11111100001000
00000000000000000000000000000000d1111d11d1111d11d1111d11d1111d11d1111d11ccccccccd1111d11d1111d11d1111d11d1111d11d1111d1100000000
1dd1dd111dd1dd111dd1dd110cccccc01dd1dd111dd1dd1100000000000000000000000000000000000000001dd1dd111dd1dd111dd1dd111dd1dd1100000000
d1d11d1dd1d11d1dd1d11d1dcc1111ccd1d11d1dd1d11d1d0000000000000000000000000000000000000000d1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000
1111dd1d1111dd1d1111dd1dc111111c1111dd1d1111dd1d00000000000000000000000000000000000000001111dd1d1111dd1d1111dd1d1111dd1d00000000
1111d1111111d1111111d111c111111c1111d1111111d11100000000000000000000000000000000000000001111d1111111d1111111d1111111d11100000000
ddd11dd1ddd11dd1ddd11dd1c111191cddd11dd1ddd11dd10000000000000000000000000000000000000000ddd11dd1ddd11dd1ddd11dd1ddd11dd100000000
dd1d111ddd1d111ddd1d111dc111111cdd1d111ddd1d111d0000000000000000000000000000000000000000dd1d111ddd1d111ddd1d111ddd1d111d00000000
1d1111111d1111111d111111c111111c1d1111111d11111100001000000010000000100000001000000010001d1111111d1111111d1111111d11111100001000
d1111d11d1111d11d1111d11ccccccccd1111d11d1111d110000000000000000000000000000000000000000d1111d11d1111d11d1111d11d1111d1100000000
00000000000000000000000000000000000000001dd1dd1100000000000000000000000000000000000000000cccccc000000000000000001dd1dd1100000000
0000000000000000000000000000000000000000d1d11d1d0000000000000000000000000000000000000000cc1111cc0000000000000000d1d11d1d00000000
00000000000000000000000000000000000000001111dd1d0000000000000000000000000000000000000000c111111c00000000000000001111dd1d00000000
00000000000000000000000000000000000000001111d1110000000000000000000000000000000000000000c111111c00000000000000001111d11100000000
0000000000000000000000000000000000000000ddd11dd10000000000000000000000000000000000000000c111191c0000000000000000ddd11dd100000000
0000000000000000000000000000000000000000dd1d111d0000000000000000000000000000000000000000c111111c0000000000000000dd1d111d00000000
00001000000010000000100000001000000010001d1111110000100000001000000010000000100000001000c111111c00001000000010001d11111100001000
0000000000000000000000000000000000000000d1111d110000000000000000000000000000000000000000cccccccc0000000000000000d1111d1100000000
00000000000000000000000000000000000000000cccccc000000000000000000000000000000000000000001dd1dd111dd1dd110cccccc01dd1dd110cccccc0
0000000000000000000000000000000000000000cc1111cc0000000000000000000000000000000000000000d1d11d1dd1d11d1dcc1111ccd1d11d1dcc1111cc
0000000000000000000000000000000000000000c111111c00000000000000000000000000000000000000001111dd1d1111dd1dc111111c1111dd1dc111111c
0000000000000000000000000000000000000000c111111c00000000000000000000000000000000000000001111d1111111d111c111111c1111d111c111111c
0000000000000000000000000000000000000000c111191c0000000000000000000000000000000000000000ddd11dd1ddd11dd1c111191cddd11dd1c111191c
0000000000000000000000000000000000000000c111111c0000000000000000000000000000000000000000dd1d111ddd1d111dc111111cdd1d111dc111111c
0000100000001000000010000000100000001000c111111c00001000000010000000100000001000000010001d1111111d111111c111111c1d111111c111111c
0000000000000000000000000000000000000000cccccccc0000000000000000000000000000000000000000d1111d11d1111d11ccccccccd1111d11cccccccc
00000000000000000000000000000000000000001dd1dd111dd1dd111dd1dd111dd1dd110cccccc01dd1dd111dd1dd1100000000000000000000000000000000
0000000000000000000000000000000000000000d1d11d1dd1d11d1dd1d11d1dd1d11d1dcc1111ccd1d11d1dd1d11d1d00000000000000000000000000000000
00000000000000000000000000000000000000001111dd1d1111dd1d1111dd1d1111dd1dc111111c1111dd1d1111dd1d00000000000000000000000000000000
00000000000000000000000000000000000000001111d1111111d1111111d1111111d111c111111c1111d1111111d11100000000000000000000000000000000
0000000000000000000000000000000000000000ddd11dd1ddd11dd1ddd11dd1ddd11dd1c111191cddd11dd1ddd11dd100000000000000000000000000000000
0000000000000000000000000000000000000000dd1d111ddd1d111ddd1d111ddd1d111dc111111cdd1d111ddd1d111d00000000000000000000000000000000
00001000000010000000100000001000000010001d1111111d1111111d1111111d111111c111111c1d1111111d11111100001000000010000000100000001000
0000000000000000000000000000000000000000d1111d11d1111d11d1111d11d1111d11ccccccccd1111d11d1111d1100000000000000000000000000000000
1dd1dd110cccccc01dd1dd111dd1dd111dd1dd111dd1dd111dd1dd110000000000000000000000001dd1dd111dd1dd1100000000000000000000000000000000
d1d11d1dcc1111ccd1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1d000000000000000000000000d1d11d1dd1d11d1d00000000000000000000000000000000
1111dd1dc111111c1111dd1d1111dd1d1111dd1d1111dd1d1111dd1d0000000000000000000000001111dd1d1111dd1d00000000000000000000000000000000
1111d111c111111c1111d1111111d1111111d1111111d1111111d1110000000000000000000000001111d1111111d11100000000000000000000000000000000
ddd11dd1c111191cddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd1000000000000000000000000ddd11dd1ddd11dd100000000000000000000000000000000
dd1d111dc111111cdd1d111ddd1d111ddd1d111ddd1d111ddd1d111d000000000000000000000000dd1d111ddd1d111d00000000000000000000000000000000
1d111111c111111c1d1111111d1111111d1111111d1111111d1111110000100000001000000010001d1111111d11111100001000000010000000100000001000
d1111d11ccccccccd1111d11d1111d11d1111d11d1111d11d1111d11000000000000000000000000d1111d11d1111d1100000000000000000000000000000000
1dd1dd11000000000000000000000000000000001dd1dd111dd1dd110cccccc01dd1dd111dd1dd111dd1dd111dd1dd1100000000000000000000000000000000
d1d11d1d00000000000000000000000000000000d1d11d1dd1d11d1dcc1111ccd1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000000000000000000000000000
1111dd1d000000000000000000000000000000001111dd1d1111dd1dc111111c1111dd1d1111dd1d1111dd1d1111dd1d00000000000000000000000000000000
1111d111000000000000000000000000000000001111d1111111d111c111111c1111d1111111d1111111d1111111d11100000000000000000000000000000000
ddd11dd100000000000000000000000000000000ddd11dd1ddd11dd1c111191cddd11dd1ddd11dd1ddd11dd1ddd11dd100000000000000000000000000000000
dd1d111d00000000000000000000000000000000dd1d111ddd1d111dc111111cdd1d111ddd1d111ddd1d111ddd1d111d00000000000000000000000000000000
1d111111000010000000100000001000000010001d1111111d111111c111111c1d1111111d1111111d1111111d11111100001000000010000000100000001000
d1111d1100000000000000000000000000000000d1111d11d1111d11ccccccccd1111d11d1111d11d1111d11d1111d1100000000000000000000000000000000
1dd1dd111dd1dd111dd1dd111dd1dd11000000001dd1dd11000000000000000000000000000000001dd1dd111dd1dd111dd1dd111dd1dd111dd1dd110cccccc0
d1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000d1d11d1d00000000000000000000000000000000d1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1dcc1111cc
1111dd1d1111dd1d1111dd1d1111dd1d000000001111dd1d000000000000000000000000000000001111dd1d1111dd1d1111dd1d1111dd1d1111dd1dc111111c
1111d1111111d1111111d1111111d111000000001111d111000000000000000000000000000000001111d1111111d1111111d1111111d1111111d111c111111c
ddd11dd1ddd11dd1ddd11dd1ddd11dd100000000ddd11dd100000000000000000000000000000000ddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd1c111191c
dd1d111ddd1d111ddd1d111ddd1d111d00000000dd1d111d00000000000000000000000000000000dd1d111ddd1d111ddd1d111ddd1d111ddd1d111dc111111c
1d1111111d1111111d1111111d111111000010001d111111000010000000100000001000000010001d1111111d1111111d1111111d1111111d111111c111111c
d1111d11d1111d11d1111d11d1111d1100000000d1111d1100000000000000000000000000000000d1111d11d1111d11d1111d11d1111d11d1111d11cccccccc
1dd1dd111dd1dd111dd1dd111dd1dd11000000000cccccc0000000000000000000000000000000001dd1dd111dd1dd111dd1dd111dd1dd111dd1dd1100000000
d1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000cc1111cc00000000000000000000000000000000d1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000
1111dd1d1111dd1d1111dd1d1111dd1d00000000c111111c000000000000000000000000000000001111dd1d1111dd1d1111dd1d1111dd1d1111dd1d00000000
1111d1111111d1111111d1111111d11100000000c111111c000000000000000000000000000000001111d1111111d1111111d1111111d1111111d11100000000
ddd11dd1ddd11dd1ddd11dd1ddd11dd100000000c111191c00000000000000000000000000000000ddd11dd1ddd11dd1ddd11dd1ddd11dd1ddd11dd100000000
dd1d111ddd1d111ddd1d111ddd1d111d00000000c111111c00000000000000000000000000000000dd1d111ddd1d111ddd1d111ddd1d111ddd1d111d00000000
1d1111111d1111111d1111111d11111100001000c111111c000010000000100000001000000010001d1111111d1111111d1111111d1111111d11111100001000
d1111d11d1111d11d1111d11d1111d1100000000cccccccc00000000000000000000000000000000d1111d11d1111d11d1111d11d1111d11d1111d1100000000
1dd1dd111dd1dd111dd1dd111dd1dd111dd1dd111dd1dd11000000000000000000000000000000000cccccc0000000001dd1dd111dd1dd111dd1dd1100000000
d1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1dd1d11d1d00000000000000000000000000000000cc1111cc00000000d1d11d1dd1d11d1dd1d11d1d00000000
1111d111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111dd1d00000000
1111d166666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666661111d11100000000
ddd11161111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111161dd11dd100000000
dd1d1161111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111161d1d111d00000000
1d111161111111111166166116611666111616611666111111111166666116661666166611111111111161111666166616661111111111161d11111100001000
d11111611111111111666661116116161161116116161111111111166611161611161611111111111116661116161616161611111111111611111d1100000000
1dd1d161111111111166666111611616116111611616111111111111611116661116166611111111116666611616161616161111111111161000000000000000
d1d11161111111111116661111611616116111611616111111111116661116161116111611111111111666111616161616161111111111161000000000000000
1111d161111111111111611116661666161116661666111111111166666116661116166611111111111161111666166616661111111111161000000000000000
1111d161111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111161000000000000000
ddd11161111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111161000000000000000
dd1d1166666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666661000000000000000
1d111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000100000001000
d1111d11d1111d11d1111d11d1111d11d1111d11d1111d1100000000000000000000000000000000d1111d110000000000000000000000000000000000000000

__gff__
0000050503030303030303030703020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
__map__
01010101010101010101010101010101181a0303030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010116141414101010101010101010101013010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010117151515111111111111111111111112010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010119030303030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010103030303030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010101010101010303f01b030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010101010101010303011b030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010101010101010303011b030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010101010101010303011b030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010101010101010303011b030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010101010101010303011b030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010101010101010303011b030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010101010101010303011b030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010103030303030303030303030303030303010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
