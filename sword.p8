pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--[[cursed sword by christopher gibilisco

credits:

deepest thanks to krystian majewski of lazydevs academy for the use of his game 
porklike as an engine for this game. much of the code of this game was designed 
by him, and i thank him especially for his ingenious level procedural generator, 
and the binary signature technique. porklike was released under the cc by-nc-sa 
4.0 license, which is linked below, as it is also this game's license.

maddog22, who conceived many of the power gems. thanks, md!

the json parser program was designed by tylerneylon, adapted by feneric, which 
tylerneylon has released into the public domain. feneric's adaptation of it is 
released under the gpl v3 license: https://www.gnu.org/licenses/gpl-3.0.en.html.

enemy artwork licensed from oryx design labs, www.oryxdesignlab.com. 
(tiles 192-203,208-213,224-31)

this game is released under the cc by-nc-sa 4.0 license, except for the above-
mentioned artwork licensed from oryx design labs. You can read the game's
license here: 
https://creativecommons.org/licenses/by-nc-sa/4.0/
--]]

function _init()
	
	t=0
	cartdata(cursed_sword)

	_gt=json_parse('{"mob_name":["hero","slime","eyeball","demon minion","demon mage","mindflayer","ghost","fire elemental","hellion","slayer"],"mob_atk":[1,1,1,2,2,2,2,3,3,4],"mob_hp":[10,1,1,2,3,5,6,7,7,8],"mob_los":[5,4,10,5,5,5,4,4,4,5],"mob_ani":[[214,214,215,215],[200,200,201,201],[210,210,211,211],[198,198,199,199],[192,192,193,193],[194,194,195,195],[212,212,213,213],[208,208,209,209],[196,196,197,197],[202,202,203,203]],"mob_col":[12,11,6,8,14,11,7,9,9,13],"mob_def":[0,0,0,0,0,0,0,0,0,0],"mob_int":[1,0,1,1,1,0,1,0,0,1],"mob_quench":[0,10,10,10,10,10,10,5,5,5],"mob_floor_min":[0,0,3,4,5,6,7,8,9,9,10],"mob_floor_max":[0,3,7,8,9,10,10,11,11,12,12],"mob_spec":["","","","","","","","","","",""],"maxmons":[6,10,14,0,18,20,22,0,22,21,20],"minmons":[3,5,7,0,9,10,11,0,12,13,13,0],"gems":{"amethyst":{"color":12,"mod":"atk","base":1},"ruby":{"color":14,"mod":"♥","base":3},"diamond":{"color":7,"mod":"⧗","base":1},"emerald":{"color":11,"mod":"luck","base":1},"chipped":{"mult":1},"rough":{"mult":2},"cut":{"mult":3},"flawless":{"mult":4},"relic":{"mult":5}},"powergemstypes":["doomsword","shovelsword","skippingstone","vampiretooth","witcheye","cleromancer","chain link","demon heart","quicksilver"],"powergemsprops":{"doomsword":{"name":"doomshock","color":8,"desc":[" 2x atk when hp"," drops below 50%!"],"price":250},"shovelsword":{"name":"sapper pick","color":8,"desc":[" dig through a wall"," for 25 ⧗! be careful!"],"price":750},"skippingstone":{"name":"skipping stone","color":8,"desc":[" bump walls to skip"," a turn"],"price":250},"vampiretooth":{"name":"vampire tooth","color":8,"desc":[" randomly drain ♥"," equal to your atk!"],"price":250},"witcheye":{"name":"witch eye","color":8,"desc":[" you can see through"," solid objects!"],"price":750},"cleromancer":{"name":"cleromancer","color":8,"desc":[" attack an enemy and"," see your prize!"],"price":500},"chain link":{"name":"chain link","color":8,"desc":["press 🅾️ to strike all","nearby squares for 50⧗"]},"wasp thorax":{"name":"wasp thorax","color":8,"desc":["2x atk, but halves max♥"]},"demon heart":{"name":"demon heart","color":8,"desc":["randomly gain 1 max ♥","when you slay an enemy"]},"quicksilver":{"name":"quicksilver","color":8,"desc":["enemy attacks miss","more often!"]}},"vases":[1,1,1,1,1,1,5,5,7,7,7],"npcs":{},"tools":{"dirx":[-1,1,0,0,1,1,-1,-1],"diry":[0,0,-1,1,-1,1,1,-1],"dpal":[0,1,1,2,1,13,6,4,4,9,3,13,1,13,14],"carve_signatures":["0b11111111","0b11010110","0b01111100","0b10110011","0b11101001"],"carve_masks":[0,"0b00001001","0b00000011","0b00001100","0b00000110"],"wall_sig":[251,233,253,84,146,80,16,144,112,208,241,248,210,177,225,120,179,0,124,104,161,64,240,128,224,176,242,244,116,232,178,212,247,214,254,192,48,96,32,160,245,250,243,249,246,252],"wall_msk":[0,6,0,11,13,11,15,13,3,9,0,0,9,12,6,3,12,15,3,7,14,15,0,15,6,12,0,0,3,6,12,9,0,9,0,15,15,7,15,14,0,0,0,0,0,0]}}')
	mob_name,mob_atk,mob_hp,mob_los,mob_ani,mob_col,mob_def,mob_int,mob_quench,mob_minf,mob_maxf,mob_spec,minmons,maxmons=_gt.mob_name,_gt.mob_atk,_gt.mob_hp,_gt.mob_los,_gt.mob_ani,_gt.mob_col,_gt.mob_def,_gt.mob_int,_gt.mob_quench,_gt.mob_floor_min,_gt.mob_floor_max,_gt.mob_spec,_gt.minmons,_gt.maxmons
	gem_types,gem_qual,gem_props,powergemsprops,powergemstypes,vases=_gt.gem_types,_gt.gem_qual,_gt.gems,_gt.powergemsprops,_gt.powergemstypes,_gt.vases

	tools=_gt.tools

	dpal,dirx,diry=tools.dpal,tools.dirx,tools.diry
	crv_sig,crv_msk,wall_sig,wall_msk=tools.carve_signatures,tools.carve_masks,tools.wall_sig,tools.wall_msk

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
	tani,fadeperc,buttonbuff=0,0,-1

	skipai,win=false,false

	mob,dmob={},{}
	p_mob=addmob(1,-100,-100)
	--★
	p_t=0
	
	timer,kills,thirst,turn,atkbonus=0,0,250,0,0
	clerotype={"♥","⧗"}
	inv,eqp,wind,float={},{},{},{},{}
	
	hpwind=addwind(5,5,80,13,{})

	_upd,_drw=update_game,draw_game
	genfloor(0)
	
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
	updatestats()
end




function update_inv()
	local curs=curwind.cur
	local invcurs=curs-4
	
	move_menu(curwind)

 if curwind==invwind then
		if curs<4 and eqp[curs] then
			infowind.txt=eqp[curs].desc
		elseif curs>4 and inv[curs-4] then
			infowind.txt=inv[curs-4].desc
		else
			infowind.txt=""
		end
	end

	if btnp(4) then
  if curwind==invwind then
    
   _upd=update_game
   invwind.dur,statwind.dur,infowind.dur=0,0,0
  else --★elseif curwind==usewind then
   usewind.dur=0
   curwind=invwind
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
			sfx(49)
	elseif btnp(3) then
			wnd.cur+=1
			sfx(49)
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
		if skipper then skipai=false end
		if checkend() and not skipai then
			do_ai()
			turn+=1
			--★ put floor list in json
			if thirst>0 and not isin(floor,{0,4,8,12}) then
				thirst-=1
			elseif thirst==0 and not isin(floor,{0,4,8,12}) then
				showmsg("your sword feasts on you!",120)					
				p_mob.hp-=1
			end
		end
		skipai=false
	end
end

function update_aiturn()
	dobuffer()
	p_t=min(p_t+0.125,1)
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
	elseif button==4 and chain then
		dochain()
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
	cls()
	if fadeperc==1 then return end --fixes flicker
		
	animap()

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

	for f=#float,1,-1 do
		ft=float[f]
		oprint8(ft.txt,ft.x,ft.y,ft.c,0)
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
	cls()
	if not win then
		palt(12,true)
	end
	spr(gover_spr,gover_x,24,gover_w,3)
	
	color(7)
	cursor(44,50)
	print("floor: "..floor)
	print("steps: "..turn)
	print("kills: "..kills)
	
	
	print("press ❎",44,90,5+abs(sin(time()/3)*2))
end

function draw_win()
	cls()
	print("you win",centx(8),centy(1),8)
end

function animap()
	tani+=1
	if (tani<30) return
	tani=0
	for x=0,15 do
		for y=0,15 do
			local tle=mget(x,y)
				--★
			if isin(tle,{73,75,174,232,234}) then
				tle+=1
			elseif isin(tle,{74,76,175,233,235}) then
				tle-=1
			end
		mset(x,y,tle)
		end
	end
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
	--★ might save some tokens getting ready of these safety valves
 if (spd==nil) spd=0.04
 if (_wait==nil) _wait=0
 repeat
  fadeperc=min(fadeperc+spd,1)
  dofade()
 	flip()
 until fadeperc==1
 wait(_wait)
end

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
	 	if first=="{" then
				pos=skip_delim(wrkstr,pos,':',true)  -- true -> error if missing.
				obj[key],pos=json_parse(wrkstr,pos)
		 else
				add(obj,key)
	 	end
	 	pos,delim_found=skip_delim(wrkstr, pos, ',')
		end
	elseif first=='"' then
		return parse_str_val(wrkstr,pos+1)
	elseif match(first,"-0123456789") then
		return parse_num_val(wrkstr, pos)
	elseif first==end_delim then  -- end of an object or array.
		return nil,pos+1
	else
			for lit_str,lit_val in pairs(_tok) do
		 local lit_end=pos+#lit_str-1
		 	if sub(wrkstr,pos,lit_end)==lit_str then return lit_val,lit_end+1 end
			end
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
  	if fog[x][y]==1 
  		and dist(px,py,x,y)<=p_mob.los 
  		and (
  			los(px,py,x,y) 
  			or xray) then
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

function isin(mem,set)
	for m in all(set) do
		if m==mem then
			return true
		end
	end
	return false
end

function copymap(x,y)
	local tle
	for _x=0,15 do
  for _y=0,15 do
  	tle=mget(_x+x,_y+y)
   mset(_x,_y,tle)
   if tle==15 then
   	p_mob.x,p_mob.y=_x,_y
   end
  end
 end
end


-->8
--gameplay

function moveplayer(dx,dy)
	local destx,desty=p_mob.x+dx,p_mob.y+dy
	local tle=mget(destx,desty)

	if iswalkable(destx,desty,"checkmobs") then
		sfx(63)
		mobwalk(p_mob,dx,dy)
		p_t=0
		_upd=update_pturn
	else
		mobbump(p_mob,dx,dy)
		p_t=0
		_upd=update_pturn

		local m=getmob(destx,desty)
		if m then
			hitmob(p_mob,m)
			sfx(60)
		else
			if fget(tle,1) then
				trig_bump(tle,destx,desty)
			elseif dig and fget(tle,7) then
					dodig(destx,desty)	
					sfx(47)
					thirst=max(thirst-25,0)
			else
				skipai=true
			end
		end
	end
	unfog()
end

function trig_bump(tle,destx,desty)
	if tle==12 then
		sfx(62)
		--★ pretty walls take 17 tokens
		local tleabove=1
		if fget(mget(destx,desty-1),7) then
			tleabove=3
		end
		mset(destx,desty,tleabove)
	elseif tle==5 then
		sfx(61)
		local amt=ceil((floor+1)/3)+flr(rnd(luck))
		treasure("♥",amt,destx,desty,8)
		mset(destx,desty,78)
	--[[elseif tle==6 then
		sfx(61)
		local amt=5*flr(ceil((floor+1)/2)+rnd(luck+3))
		treasure("◆",amt,destx,desty,9)
		mset(destx,desty,79)]]
	elseif isin(floor,{4,8}) and tle==236 then
		treasure("atk+1","",destx,desty,10)
		reset_store()
	elseif isin(floor,{4,8}) and tle==237 then
		treasure("def+1","",destx,desty,10)
		reset_store()
	elseif isin(floor,{4,8}) and tle==238 then
		treasure("max♥+10","",destx,desty,10)
		reset_store()
	elseif isin(tle,{174,175}) then
		win=true
	elseif tle==7 then
		sfx(61)
		mset(destx,desty,78)
	elseif tle==10 then
		treasure("●","",destx,desty,11)		
	elseif tle==204 then
		showtalk({""," i'm the last of my order.", " the rest were slain long", " ago, by that very sword", " you wield.",""}) 
	elseif isin(tle,{205,206,221,222})	then
		addfloat("choose!",50,64,8)
	end
	return
end

function trig_step()
 if mget(p_mob.x,p_mob.y)==14 then
  fadeout()
  sfx(46)
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
 local col,dmg,defmx,defmy=9,max(0,atkm.atk-defm.def),defm.x,defm.y
 if defm==p_mob then
		luckshot= 101+quick
		col=8
		if flr(rnd(luckshot+luck))>=98 then
			dmg=0
			addfloat("lucky!",defmx*8,defmy*8,11)
		end
	else
		if clero and flr(rnd(101))+luck>50 then
			treasure("bonus",1,atkm.x,atkm.y-1,11)
		end
		if vampire and flr(rnd(101))+luck>50 then
			treasure("vamp!","",atkm.x,atkm.y-1,14)
		end
	end
	
 defm.hp-=dmg
 defm.flash=10
	if dmg>0 and defm.hp>0 then
		addfloat("-"..dmg,defmx*8,defmy*8,col)
	end
	if defm.hp<=0 then
 	if defm!=p_mob then
  	treasure("⧗",defm.quench+timer,defmx,defmy,12)
	 	kills+=1
	 	if demon then
	 		if flr(rnd(101))+luck>90 then
	 			p_mob.basehpmax+=1
	 		end
	 	end
	 end
  add(dmob,defm)
  del(mob,defm)
  defm.dur=10
 end
end

function checkend()
	if win then
		--★ combine these two things
		wind={}
  gover_spr=24
  gover_x=31
  gover_w=32
		_upd=update_gameover
		_drw=draw_gameover
		fadeout(0.02)
		--★
		--might not need this: maybe for narrative levels?
		--reload(0x2000,0x2000,0x1000)
		return false
	elseif p_mob.hp<=0 then
		wind={}
  gover_spr=16
  gover_x=28
  gover_w=32
		_upd=update_gameover
		_drw=draw_gameover
		fadeout(0.02)
		sfx(44)
		--★
		--reload(0x2000,0x2000,0x1000)
		return false
	end
		return true
end

function updatestats()
	--★ cut the falses somehow?
	quick,timer,dig,xray,clero,skipper,chain,vampire,demon=0,0
	local atk,def,hpmax,lck=1+atkbonus,1,p_mob.basehpmax,0
	--bool loop
	for i=1,3 do
		if eqp[i] then
			local m=eqp[i]
			local nm=m.name
			if nm then
				if nm=="sapper pick" then
					dig=true
				elseif nm=="witch eye" then 
					xray=true
				elseif nm=="cleromancer" then
					clero=true
				elseif nm=="skipping stone" then
					skipper=true
				elseif nm=="chain link" then
					chain=true
				elseif nm=="vampire tooth" then
					vampire=true
				elseif nm=="demon heart" then
					demon=true
				elseif nm=="quicksilver" then
					quick+=10
				end
			end
		end
	end

	--multiplier loop
	for i=1,3 do
		local m=eqp[i]
		if m then
			if m.name=="doomshock" and (p_mob.hp/p_mob.hpmax)<0.5 then
				atk*=2
			elseif m.name=="wasp thorax" then
				hpmax=ceil(p_mob.hpmax/2)
				atk*=2
			end
		end
	end
	
	
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

	p_mob.atk,p_mob.hpmax,luck=atk,min(hpmax,99),lck
	p_mob.hp=min(p_mob.hp, p_mob.hpmax)
end

--7007
function treasure(txt,amt,destx,desty,col)
	local msg
	--★ ternary?
	if txt=="bonus" then
		 txt=rnd(clerotype)
		 msg="bonus"..txt.."!"
	else
			bonus=""
	end
		
	if txt=="♥" then
		p_mob.hp=min(p_mob.hp+amt,p_mob.hpmax)
	elseif txt=="●" then
		if freeslot(inv,6)>0 then
			takeitem(makegem())
			mset(destx,desty,1)
			sfx(61)
			if floor==0 then
				msg="press ❎ and equip!"
				destx=3
			end
		else
			msg="full!"
			mset(destx,desty,10)
			sfx(56)
		end
	elseif txt=="vamp!" then
		p_mob.hp=min(p_mob.hp+p_mob.atk,p_mob.hpmax)
	elseif txt=="⧗" then
		thirst=min(thirst+amt,999)
	elseif txt=="atk+1" then
		atkbonus+=1
	elseif txt=="def+1" then
		p_mob.def+=1
	elseif txt=="max♥+10" then
		p_mob.basehpmax+=10
		p_mob.hp+=10
	end
	if not msg then
		msg=txt..amt
	end
	addfloat(msg,destx*8,desty*8,col)
end

function dodig(destx,desty)
	if thirst>=25 then
		for i=1,8 do
			local blastx,blasty=destx+dirx[i],desty+diry[i]
			if not fget(mget(blastx,blasty),0) then
				mset(blastx,blasty,79)
			end
		end
		mset(destx,desty,79)
	end
end

function dochain()
	if thirst>=50 then
		for i=1,4 do	
			local _x,_y=
				p_mob.x+dirx[i],
				p_mob.y+diry[i]
			local m,w=
				getmob(_x,_y),
				mget(_x,_y)
	
			if m then
				hitmob(p_mob,m)
			elseif dig and fget(w,7) then
				dodig(_x,_y)
			elseif isin(w,{6,7}) then
				trig_bump(w,_x,_y)
			end
		end
		thirst-=50
		sfx(42)
	end
end

function reset_store()
	mset(6,8,253)
	mset(10,8,254)
	mset(8,11,252)
	mset(7,8,1)
	mset(8,8,1)
	mset(7,9,1)
	mset(8,9,1)
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
 hpwind.txt[1]=" ♥"..sub('0'..p_mob.hp,-2).."/"..sub('0'..p_mob.hpmax,-2).."  ⧗"..sub("000"..thirst,-3)--.."  ◆"..sub("000"..gold,-3)

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
	infowind=addwind(5,12,108,24,{})
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
--[[
function showstore()
	local txt={"buy gem: 300◆"}
	_upd=update_store
	storewind=addwind(28,80,80,13,txt)
	storewind.cur=1
	curwind=storewind	
end

function trigbuy(i)
	--local i=storewind.txt[storewind.cur],storewind.cur	
	if freeslot(inv,6)>0 then
		inv[freeslot(inv,6)]=makepowergem()
		sfx(52)
	else
		sfx(51)
		--★full!
		--★not enough gold!
	end
end
]]
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
 del(wind,infowind)
 showinv()
 invwind.cur=i
--elseif after=="game" then
--		usewind.dur,invwind.dur,statwind,infowind=0,0,0,0
--		_upd=update_game
--	end
end

function floormsg()
	showmsg("level b"..floor,120)
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
		ani=mob_ani[typ],
		atk=mob_atk[typ],
		def=0,
		hp=mob_hp[typ],
		basehpmax=mob_hp[typ],
		hpmax=mob_hp[typ],
		spec=mob_spec[typ],
		maxf=mob_maxf[typ],
		minf=mob_minf[typ],
		quench=mob_quench[typ],
		col=mob_col[typ],
		los=mob_los[typ],
		int=mob_int[typ],--could go, if tokens needed, but i doubt it
		x=mx,
		y=my,
		task=ai_wait}

	 add(mob,q)
		return q
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
	mb.ox,mb.oy=0,0
	mb.mov=mov_bump
end

function mobflip(mb,dx)
 mb.flp=dx==0 and mb.flp or dx<0
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

function ai_wait(m)
 if cansee(m,p_mob) then
  --aggro
  --★combine variables
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
  -- if m.spec=="placeholder" and m.charge>0then
  	--function(p_mob)
 -- 	m.charge-=1
 -- else
  	
 	hitmob(m,p_mob)
 --	end
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

function spawnmobs()
 
 mobpool={}
 for i=2,#mob_name do
  if mob_minf[i]<=floor and mob_maxf[i]>=floor then
   add(mobpool,i)
  end
 end
 
 if #mobpool==0 then return end
 
 local placed,rpot=0,{}
 
 for r in all(rooms) do
  add(rpot,r)
 end
 
 repeat
  local r=getrnd(rpot)
  placed+=infestroom(r)
  del(rpot,r)
 until #rpot==0 or placed>maxmons[floor]
 
 if placed<minmons[floor] then
  repeat
   local x,y
   repeat
    x,y=flr(rnd(16)),flr(rnd(16))
   until iswalkable(x,y,"checkmobs")
   addmob(getrnd(mobpool),x,y)
   placed+=1
  until placed>=minmons[floor]
 end
end

function infestroom(r)
 cls()
 local target,x,y=2+flr(rnd((r.w*r.h)/6-1))
 target=min(5,target)
 for i=1,target do
  repeat
   x=r.x+flr(rnd(r.w))
   y=r.y+flr(rnd(r.h))
  until iswalkable(x,y,"checkmobs") and (mget(x,y)==1 or mget(x,y)==3)
  addmob(getrnd(mobpool),x,y)
 end
 return target
end
-----------------------------
--items

function makegem()
	if rnd()>=.75 or floor==0 then
		return makepowergem()
	else
		return makeattrgem()
	end
end

function makeattrgem()
	local gqual,gtype,rnd1="relic","diamond",rnd()
	if rnd1<.5 then
		gqual="chipped"
	elseif rnd1<.85 then
		gqual="rough"
	elseif rnd1<.95 then
		gqual="cut"
	elseif rnd1<.99 then
		gqual="flawless"
	end
	
	local rnd2=rnd()
	 
	if rnd2<.35 then
		gtype="ruby"
	elseif rnd2<.60 then
		gtype="amethyst"
	elseif rnd2<.85 then
		gtype="emerald"
	end

	_gqp=gem_props[gqual]
	_gtp=gem_props[gtype]
	g= {
		name=gqual.." "..gtype,
		col=_gtp.color,
		mod=_gtp.mod,
		base=_gtp.base,
		mult=_gqp.mult,
		effect=_gtp.effect 
	}
	if g.mod=="⧗" then
		g.desc={g.mod..g.mult*g.base.." bonus per kill"}	
	else
		g.desc={g.mod.."+"..g.mult*g.base}
	end
	 
	return g
end

function makepowergem()
	local gem=rnd(powergemstypes)
	local pg=powergemsprops[gem]
	del(powergemstypes,gem)
	debug[1]=gem
	return {
		name=pg.name,
		col=pg.color,
		desc=pg.desc	
		}
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
	floor=f
	mob={}
	add(mob,p_mob)
	
	fog=blankmap(0)
	if floor==0 then
		copymap(16,0)
	elseif floor==4 or floor==8 then
		copymap(64,0)
	elseif floor==12 then
		copymap(32,0)
	else
		fog=blankmap(1)
		mapgen()
		unfog()
	end
end

function mapgen()
 --★
 --todo--re-add comments
 --more gems
	--special attacks, special movements
	--create instructions
	--fix thorax issue
	--add more clero effects
 --fix the door issue on the top border
 --center floats more, maybe -#txt/2? then do something so that it ensures it doesn't get cut off on righthand side
 repeat
  copymap(48,0)
  rooms={}
  roomap=blankmap(0)
  doors={}
  genrooms()
  mazeworm() 
  placeflags()
  carvedoors()
  --[[if #flaglib>1 then
   debug[1]="reconnected area"
  end]]
 until #flaglib==1
 
 carvescuts()
 startend()
 fillends()
 prettywalls()

 installdoors()
 
 spawnchests()
 spawnmobs()
 decorooms()
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
   roomap[_x+r.x][_y+r.y]=#rooms
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
    if cancarve(_x,_y,false) and not nexttoroom(_x,_y) then
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
 if not inbounds(x,y) then return false end
 local walk= walk==nil and iswalkable(x,y) or walk
 
 if iswalkable(x,y)==walk then
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
 flags,flaglib=blankmap(0),{}
 for _x=0,15 do
  for _y=0,15 do
   if iswalkable(_x,_y) and flags[_x][_y]==0 then
    growflag(_x,_y,curf)
    add(flaglib,curf)
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
   del(flaglib,d.f2)
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
 local filled,tle
 repeat
  filled=false
  for _x=0,15 do
   for _y=0,15 do
    tle=mget(_x,_y)
    --★
    if cancarve(_x,_y,true) and tle!=14 and tle!=15 then
     filled=true
     mset(_x,_y,2)
    end
   end
  end
 until not filled
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
     roomap[x+dirx[i]][y+diry[i]]!=0 then
   return true
  end
 end
 return false
end

function installdoors()
 for d in all(doors) do
  local dx,dy=d.x,d.y
  if (mget(dx,dy)==1 
   or mget(dx,dy)==3)
   and isdoor(dx,dy) 
   and not next2tile(dx,dy,12) then
   
   mset(dx,dy,12)
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
   if tmp>high and cancarve(x,y) then
    ex,ey,high=x,y,tmp
   end
  end
 end
 mset(ex,ey,14)
 
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>=0 and tmp<low and cancarve(x,y) then
    px,py,low=x,y,tmp
   end
  end
 end  
 --★
 mset(px,py,15)
 p_mob.x=px
 p_mob.y=py
end

function next2tile(_x,_y,tle)
 for i=1,4 do
  if inbounds(_x+dirx[i],_y+diry[i]) and mget(_x+dirx[i],_y+diry[i])==tle then
   return true
  end
 end
 return false
end

function prettywalls()
	for x=0,15 do
		for y=0,15 do
			local tle=mget(x,y)
			if tle==2 then
				local sig,tle=getsig(x,y),2
				for i=1,#wall_sig do
					if bcomp(sig,wall_sig[i],wall_msk[i]) then
						tle=i+79
						break
					end
				end
				mset(x,y,tle)
			elseif tle==1 then
				if not iswalkable(x,y-1) then
					mset(x,y,3)
				end
			end
		end
	end
end



function decorooms()
	--★ just stick them in this function?
 local funcs,func,placemax,curr={
   --deco_dirt,
   deco_torch,
   --deco_carpet,
  -- deco_farn,
  deco_vase
  },decovase,6
 
 for r in all(rooms) do
 	
  func=getrnd(funcs)
  
  for x=0,r.w-1 do
   for y=r.h-1,1,-1 do
    if mget(r.x+x,r.y+y)==1 then
     func(r,r.x+x,r.y+y,x,y)
    end
   end
  end
  
 end
end

function deco_torch(r,tx,ty,x,y)
 if rnd(3)>1 and y%2==1 and not next2tile(tx,ty,12) then
  if x==0 then
   mset(tx,ty,73)
  elseif x==r.w-1 then
   mset(tx,ty,75)
  end
 end
end
--[[
function deco_carpet(r,tx,ty,x,y)
 deco_torch(r,tx,ty,x,y)
 if x>0 and y>0 and x<r.w-1 and y<r.h-1 then
  mset(tx,ty,68)
 end
end
]]
function deco_vase(r,tx,ty,x,y)
 if iswalkable(tx,ty,"checkmobs") and 
    not next2tile(tx,ty,12) and
    not bcomp(getsig(tx,ty),0,0b00001111) then
    
  mset(tx,ty,getrnd(vases))
 end
end

function spawnchests()
	local rpot={}
	
	for r in all(rooms) do
  add(rpot,r)
 end
 
 local r=getrnd(rpot)
 placechest(r)
end

function placechest(r)
	local x,y
	 repeat
	  x=r.x+flr(rnd(r.w-2))+1
  y=r.y+flr(rnd(r.h-2))+1
	 until mget(x,y)==1
	 mset(x,y,10)
end
__gfx__
000000000000000000000000660606606606066000aaa00000aaa00000aaa000d0d0d07770d0d0d000000000000000000cccccc0000000000000000000000000
00000000000000000000000000000000000000000a000a000a000a000a000a00000007777700000000aaaa0000000000c0c00c0c00000000cc00000055000000
00700700000000000000000060666060606660660a000a000a000a000a000a00d0d077070770d0d0aa0000aa0000000000c00c0000000000cc0cc00055055000
000770000000000000000000000000000000000090aaa09090aaa09090aaa0900000700700700000a000000a00000000c000000c00000000cc0cc0c055055050
0007700000000000000000000000000066660660990009909900099099000990d0d077707770d0d0a000000a000000000c0aa0c000000000cc0cc0c055055050
007007000000000000000000000000000000000099999990999999909999999000000777770000000aa99aa000000000cc0aa0cc00000000000cc0c000055050
000000000000d000000000000000d00066066666099999000999990009999900d0d0d07770d0d0d000000000000000000c0000c000000000000000c000000050
00000000000000000000000000000000000000000099900000999000009990000000007770000000aaaaaaaa00000000cc0cc0cc000000000000000000000000
08800080000000000000000000000000800008888800000000000000000088800cc000c0000000000000000000c0c000000000c0c0c000000000000000000000
08880808800000000000000000000000080088880080000000000000000000800ccc0c0cc0000000000000000c0c0c0c0c000c0ccc0c00000000000000000000
8088800888000000000000000000000000880080000800000000000000000880c0ccc00ccc000000000000000000ccc0c0ccc000cc0000000000000000000000
008000080000000000000000000000000008808000088000000000000000008000c0000c00000000000000000000cc000cc0c00ccc0000000000000000000000
008800888000000000000000000000000008008000008000000000000000088000cc00ccc000000000000000000cc000cc00c000cc0000000000000000000000
008008080000000000000000000000000008808800088008800000000000008000c00c0c000000000000000000cc0000cc00c00ccc000cc00000000000000000
08880888800000000000000000000000000800808880808800000000000008800ccc0cccc00000000000000000c0000ccc00ccc0cc00cc000000000000000000
8080080800000000000000000000000000088080000080000000000000000080c0c00c0c00000000000000000cc00000cc00c00ccc000000c0cc000000000000
008808088008888008880080800066600008008000008080800888000088808000cc0c0cc00cccc00ccc00cc00c0000ccc00c000cc00c0cccc00c00000000000
0008080800808008008800880006666600088080888088080080008008000880000c0c0c00c0c00c00cc00c00cc00000cc00cccccc000c00c0000c0000000000
00008080080080088080008000668686600800880008808808000008800000800000c0c00c00c00cc0c000cc00c0000ccc00c000cc00cc0cc000cc0000000000
000008000880800880800088006886886008808000008008088888888000088000000c000cc0c00cc0c000c00cc00000cc00c00ccc000c00c0000c0000000000
00008000080080088080008000666866608800800000808808000000800000800000c0000c00c00cc0c000cc00cc00000c00c000cc00cc0cc000cc0000000000
0008008808808008808000880006666600000080000088080800000880000080000c00cc0cc0c00cc0c000c000ccc000ccc0c00ccc000c00c0000c0000000000
008008008080800800880080000066600008808000088008008000800800088000c00c00c0c0c00c00cc00c0000ccccc00ccc0cccccc0c0ccc00ccc000000000
0008080008088880000888088000666000800888008800008008880000888008000c0c000c0cccc0000ccc0c0000ccc00000ccc00cc000c0c0000c0000000000
0008800080000000000000000000000008000088880000000000000000000000000cc000c0000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8888888888888888888888888888888880800888888888888888888888888888cccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000
00000000000000000000000000000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888888888888888888888888888888888888888888888888888888888888800cccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0499994004999940000066666666000006660000066600000666000004999940000000000a00000000000000000000a000000000d0d0d0d0000000a000000060
04999944049999400006dccccccd60000060000000600000006000004499994044444444900000000a00000000000009000000a0000000000000000000000000
0499949904999940006dcc0000ccd600088700000cc7000005570000994999409999999999000000990000000000009900000099d0d0d0d00a00007006000060
049949990499994000ddc000000cdd0088888000ccccc000555550009994994099999999000000000000000000000000000000000000000000700a0000600600
049499990499994000ddc000000cdd00088800000ccc0000055500009999494099999999cc000000cc000000000000cc000000ccd0d0d0d00a00000a06000006
044999990499994000ddc000000cdd000000000000000000000000009999944099999999000000000000000000000000000000000000000000070000000d0000
044444440499994000ddc000000cdd000000000000000000000000004444444044444444c000d000c000d0000000d00c0000d00cd0d0d0d0000000f000000060
000000000499994000ddc000000cdd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000600
00000000000000000000000006666600066666000666666006666600666666000660660006666600000066606660000066666660000006600000666066000000
00000000000000000000000066666660666666606666666066666660666666606660666066666660000066606660000066666660000066600000666066600000
00000000000000000000000066606660666066606660666066000660666066606660066066666660000006606600000006666600000066600000066066600000
00000000000000000000000066000000000006606600000066606660000006606660000000000000000000000000000000000000000066600000000066600000
00000660066666006600000066600000000066606660066066606660660066606660066066000660660006606600066000000660660066600666660066600660
00006600666666606660000066600000000066606660666066606660666066606660666066606660666066606660666000006660666066606666666066606660
00006660666666606060000006600000000066006660666066606660666066600660660006606600666066606660666000006660666006606666666066006660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000660066666006600000006600000000066000666666006606600666666000660660006606600666066606660666066006660666000006660066066666660
00006660660606606660000066600000000066606666666066606660666666606660666066606660666066606660666066606660666000006660666066666660
00006660600600606660000066600000000066606606666066000660666606606600066066006660660006606600066066600660660000006600666006666600
00006660666066606660000066000000000006606600000000000000000006600000000000006660000000000000000066600000000000000000666000000000
00006660600600606660000066606660666066606606666066000660666606606666666066006660000006606600000066600000066666000000666066000000
00006660660606606660000066666660666666606666666066606660666666606666666066606660000066606660000066600000666666600000666066600000
00000660066666006600000006666600066666000666666006606600666666000666660006606600000066606660000066000000666666600000066066600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006060666666606660000066666660660066600660660066606660666066000000666066600000000066600000000066606660666000000000000000000000
00006660666666600660000066666660666066606660666066606660666066600000666066600000000066600000000066606660666000000000000000000000
00000660066666006600000066666600666066606660066066606660660066600000066066000000000006600000000066000660660000000000000000000000
00000000000000000000000000000000666066606600000066606660000006600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000006666660666066606660666066000660666066606600000000000660000006606600066000000000660000000000000000000000
00000000000000000000000066666660666066606666666066666660666666606660000000006660000066606660666000000000666000000000000000000000
00000000000000000000000066666660666006600666660006666600066666006660000000006660000066606660666000000000666000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700777700007000000000000000000000000000000000077700070000070000000000000000000000000000000000000000000000000007770000000
00000000007000777770000000000000000000000000000000000000700070000070000000000000000000000000000000000000000000000000000070000000
00000007070000707700000000000000000000000000000000000007700070000070000000777770700000000000000000000000000000000000000770000000
00000070700000700700000000000000000000000000000000000000700070000070000007000077000000000000000000000000000000000000000070000000
00000770700000770000000000000000000000000000000000000007700070000070000070000007000000000000000000000000000000000000000770000000
00000077700000700000000000000000000000000000000000000000700070000070000770000000000000000000000000000000000000000000000070000000
00000770700000700000000000000000000000000000000000000007700070000070007070000000007000000000000000000000000000000000000770000000
00000070700000700000000000000000000000000000000000000000700070000070007070000000070000000000000000000000000000000000000070000000
00000770070000070007770007770777700077700007770000777707700070000070007070000000700000777077707770077770070777700077770770000000
00000070000000070000770007007700070770070070007007700077700070000070000707777777777000007007000700707007007700070770007770000000
00000770000000070000700007000700077700000700000770700000700070000070000070000070000700077007000707007007700700077070000070000000
00000070000000070000700007007700707700000777777770700007700070000070000007777777770070007007000707707007707700707070000770000000
00000770000000070000700007000700000777770700000070700000700070000070000000007000007007077007000707007007700700007070000070000000
00000070000000070000700007007700000000007700000770700007700070000070000000070000000707007007000707707007707700007070000770000000
00000770000000070000770007000700007000007070007007700077700070000070007700700000000077077000700700707007000700000770007770000000
00000077000000070070077770707770000777770007770000777700770070000070070777000000000007007770077700077770007770000077770077000000
00000007700000070700000000000000000000000000000000000000000070000070700770000000000070000000000070000000000000002bbbbbbb2b2b2bbb
0000000077000007700000000000000000000000000000000000000000007000007070077700000000070000000000000000000000000000bb22bb2bb2bb2bb2
0000000007777777000000000000000000000000000000000000000000007000007007700777777777700000000000000000000000000000bbbb22bbbbbbb2bb
00000000000000000000000000000000000000000000000000000000000070000070000000000000000000000000000000000000000000002b2bbbbbb2b2bbbb
0000000000000000000000000000000000000000000000000000000000007000007000000000000000000000000000000000000000000000b2bb2b222bbbb2b2
0000000000000000000000000000000000000000000000000000000000007000007000000000000000000000000000000000000000000000bbbbb2bbb2b2bbbb
00000000000000000000000000000000000000000000000000000000000070000070000000000000000000000000000000000000000000002222bbbb2bb2bb2b
0000000000000000000000000000000000000000000000007777777777777777777777777777777000000000000000000000000000000000bb2bb2bb2bb2b2b2
00000077700000000000700700700000000070070070000077777777777777777777777777777770d0d0d0d00880880880880880d0d0d0d00000000000000000
00000777770000000000700700700000000070070070000077000000000070000070000000000770000000000880880880880880000000000000000000000000
00007707077000000000700700700000000070070070000077000000000070000070000000000770d0d0d008088088088088088080d0d0d00000000000000000
00007007007000000000700700700000000007070700000077700000000070000070000000007770000000880880880880880880880000000000000000000000
00007770777000000000700700700000000007070700000007700000000070000070000000007700d0d0088008808808808808800880d0d00000000000000000
00000777770000000000700700700000000000777000000000700000000070000070000000007000000088080880880880880880808800000000000000000000
00007077707000000000700700700000000000777000000000000000000070000070000000000000d00880880880880880880880880880d00000000000000000
00007077707000000000700700700000000000070000000000000000000070000070000000000000008808800880880880880880088088000000000000000000
000000080000000900666000000000000606060000000000060006000000000000066000000000000000000c0000000000666000000000022200000008888000
006006040060060406666600006660006060660006060600066666000600060000660600000660000060060c0000000c06666600000000220200000088878800
006666040066660466660660066666000606666060606600066969000666660006606060006606000066660c0060060c0660f000000002200020000088887800
066868640668686466606060666606606066666006066660066666000669690006660660066060600666066c0066660c056fff000000020b0b20000088888800
66666664666666646666666066606060066666666066666666666660666666600666666006660660666666640666066c555666f0000002000020000088888800
606666046066660406666600066666006666060606660606666666606666666006666660666666666066660066666664f5566600000002000020000008888000
06666600066666000660660006606600006666660066666606000600000060000066660066666666066666006066660005555500000000200200b00000000000
66666600666666000060600000606000000666600006666000000000000000000000000000000000666666000666660004000400000002222220b00000000000
6660660600000000006666000000000000666000006660000066600c0000000000aaa00000000000000000000000000000000000000002222222400000000000
0666666666606606066666600066660006666600066666000666660c0066600c0a000a0000aaa000000000000000000000000000000022222222700000000000
0666060606666666666600660660066006606000066060000660000c0666660c0a000a000a000a00000000000000000000000000000022222222400000000000
00666660066606066660bb06660bb06666666660666666600666060c0660000c90aaa0900a000a00000000000000000000000000000022222220400000000000
06066666006666606660bb06660bb06606660600066606006666664c0666060c9900099090aaa090000000000000000000000000000072222220400000000000
000666060606666666660066666006666666660006666600466666000666664c9999999099000990000000000000000000000000000002222222400000000000
00066600000666060666666006666660066666006666660006666600466666000999990009999900000000000000000000000000000022222222400000000000
00600600000060000066660000666600066660000666600005000500050005009000009090000090000000000000000000000000000222222222420000000000
666066066660660600000000000000000066660000666600000000000000000008888888088888888888888088888880c00000000c0c0c000880880000000000
0666666606666666666066066660660606666660066666600066660000666600880000808800008008000088080000880c0c0000ccccccc08888e88000000000
066606060666060606666666066666666666006666660066066006600660066080888808808888088088880880888808008000000cacac0088888e8000000000
006666600066666006660606066606066660bb066660bb06660bb066660bb066088000880880008888000880880008800c0600000ceaec008888888000000000
060666660606666600666660006666606660bb066660bb06660bb066660bb0668808882b880888bb2b8880882b888088000060000c6e6c000888880000000000
0006660600066606060666660606666666660066666600666660066666600666808b2b22808b2bbbb2b2b8082bb2b808000006000c666c000088800000000000
000666000006660000066606000666060666666006666660066666600666666008bbb2bb08b2b22bb2bbbb80bbbb2b800000006000ccc0000008000000000000
00600600006006000000600000006000006666000066660000666600006666008bb2b2bb82bbbbb2bb222b282bb22bb800000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000000060606000550550070000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005050000666666605555655077000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000067676005555565077700000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000506000006d7d6005555555077000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000065d56000555550070000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600065556000055500000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060006660000005000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000777000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007777700000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000077070770000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000077707770000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007777700000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070777070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070777070000000000000000000000000000000000000000000000000000000000000
00000000070077770007000000000000000000000000000000000077700070000070000000000000000000000000000000000000000000000000007770000000
00000000700700077770000000000000000000000000000000000000700070000070000000000000000000000000000000000000000000000000000070000000
00000007007000077700000000000000000000000000000000000007700070000070000000777770700000000000000000000000000000000000000770000000
00000070070000070700000000000000000000000000000000000000700070000070000007000077000000000000000000000000000000000000000070000000
00000770770000070000000000000000000000000000000000000007700070000070000070000007000000000000000000000000000000000000000770000000
00000077070000070000000000000000000000000000000000000000700070000070000770000000000000000000000000000000000000000000000070000000
00000770070000070000000000000000000000000000000000000007700070000070007070000000007000000000000000000000000000000000000770000000
00000070070000070000000000000000000000000000000000000000700070000070007070000000070000000000000000000000000000000000000070000000
00000770070000070007770007770777700077700007770000777707700070000070007070000000700000777077707770077770070777700077770770000000
00000070000000070000770007007700070770070070007007700077700070000070000707777777777000007007000700707007007700070770007770000000
00000770000000070000700007000700077700000700000770700000700070000070000070000070000700077007000707007007700700077070000070000000
00000070000000070000700007007700707700000777777770700007700070000070000007777777770070007007000707707007707700707070000770000000
00000770000000070000700007000700000777770700000070700000700070000070000000007000007007077007000707007007700700007070000070000000
00000070000000070000700007007700000000007700000770700007700070000070000000070000000707007007000707707007707700007070000770000000
00000770000000070000770007000700007000007070007007700077700070000070007700700000000077077000700700707007000700000770007770000000
00000077000000070070077770707770000777770007770000777700770070000070070777000000000007007770077700077770007770000077770077000000
00000007700000070700000000000000000000000000000000000000000070000070700770000000000070000000000000000000000000000000000000000000
00000000770000077000000000000000000000000000000000000000000070000070700777000000000700000000000000000000000000000000000000000000
00000000077777770000000000000000000000000000000000000000000070000070077007777777777000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070000070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070000070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070000070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070000070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777777777777777777777777777770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777777777777777777777777777770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077000000000070000070000000000770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077000000000070000070000000000770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077700000000070000070000000007770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700000000070000070000000007700000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000700000000070000070000000007000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070000070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070000070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070070070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007070700000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007070700000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000777000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000777000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000

__gff__
0000050000030303000003000700020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030000000000030300000000050000858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585850000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030000000000000000000000050500000000000000000000000000000003030303000000000000000003030000000303000000000000000000000000000303030000000000000000000000000003030301
__map__
3f3f3f3f3f3f3fb0b13f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f02020202020202023f3f3f02023f3f023f020202020202020202020202020202020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8081823f3f3f868788898a8b8c3f8e8f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f0202020202020202020202020202020202020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
909192939495969798999a9b9c9d9e9f3f3f3f3f3f3f505151523f3f3f3f3f3f023f3f3f3f3f3f3f3f3f3f3f3f3f3f020202020202020202020202020202020202003f02020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0a1a23f3f3fa6a7a8a9aa8c8c3f3f3f3f3f3f3f3f3f600e03623f3f3f3f3f3f023f3f505151515151515151515152020202020202020202020202020202020202000002020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3fb6b7b8b93f8c3f3f3f3f3f3f3f3f50516442436351523f3f3f3f3f3f3f604d4d4d4d08094d4d4d4d620202020202020202020202020202020202020000003f3f3f3f3f3f3f3f3f020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f60030301cc0303623f3f3f3f023f3f604d4d4dbae8eabd4d4d4d620202020202020202020202020202020202020202023f3f3f3f3f3f3f3f3f3f0202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f60010101010101623f3f3f3f023f3f604d4d4dbbaeafbc4d4d4d62020202020202020202020202020202020202020202505151515151515152020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f6049010a01014b623f3f3f3f023f3f604d4d4dbbafaebc4d4d4d620202020202020202020202020202020202020202026003030303030303623f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f60010101010101623f3f3f3f3f3f3f604d4d4dbbaeafbc4d4d4d620202020202020202020202020202020202020202026049edcdce01ee4b623f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f60070101010107623f3f3f3f3f3f3f744901010101010101014b74020202020202020202020202020202020202020202600101ddde010101623f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f60070701010707623f3f3f3f3f3f3f744901010101010101014b7402020202020202020202020202020202020202023f604901010101014b623f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f70715401015371723f3f3f3f3f3f3f744901010101010101010f74020202020202020202020202020202020202023f0060010101ec010101623f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f3f3f60010f623f3f3f3f3f3f3f3f3f717171717171717171717171020202020202020202020202020202020202020002600e01010101010f62003f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f3f3f3f71713f3f3f3f3f3f3f023f3f023f023f3f3f3f0202023f3f3f02020202020202020202020202020202020202027071717171717171723f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb2b33f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000003f3f3f3f02020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3fb4b53f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f0000000000000000003f3f02020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f0000000000000000003f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002f000240001e0002900038000320002c000280001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
6b0101012d7502d7502d7502a6502a6502c7502b7502b550297502a55025650277502675021650247501e65021740205401c6401d730196301a53018700156101271012600000000d70000000000000000000000
000100002e7502e7502e7502e7502d7502d7502d7502c7502b7502a75026750237502375024750267502875028750000000000000000000000000000000000000000000000000000000000000000000000000000
00100000277502675024750227502175020750207502075020750207502075020750207502c7002f7003370000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001c7401b7501b7501b7501b7501c7601d7601e7401f7302072025720297302973000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
491000001a7301a7301c7301d7301f7300000021730000002473000000247302b7303073000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
57010000167401d640167401e6401d640177401c640177401b650167501e6501e6501e6501d650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
47010000167401d640167401e6401d640177401c640177401b650167501e6501e6501e6501d650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b10100002971027710237101f7101a710187001570013700187002d71035710357103471019700177001770019700197001a7001b7001b7001a7001a70019700177001570014700137001270011700107000f700
980100001e1301f130201302113023130241302513026130241301c130151301713018130191301b1301f130201302413026130231301f1301a13016130181301c13022130000000000000000000000000000000
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
