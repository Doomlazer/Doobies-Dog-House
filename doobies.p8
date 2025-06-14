pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- doobies dog house
-- by doomlazer
-- version 0.3

function _init()
 _upd=update_title
 _drw=draw_title
 
 title=300
 ts=1
 dx=-120

 item={
 "pickens county tornado",
 "cheese burger",
 "slaw dog",
 "two chicken tenders",
 "extra chicken tender"
 }
 ingreduncooked={"raw "..item[1],
 "raw "..item[2],
 "raw "..item[3],
 "raw "..item[4],
 "raw "..item[5],
	}
	ingredcooked={"warmed "..item[1],
 "warmed "..item[2],
 "warmed "..item[3],
 "warmed "..item[4],
 "warmed "..item[5]
	}
 price={9,8,9,5,4}
 
 aprice={7,5,5,3,9}
 
 delay=20
 
 room=2
 served=0
 
 open=2
 signflicker=1
 hours=0
 min1=0
 min2=0
 ampm=1
 ap={'am','pm'}
 mof=0
 
 tash_ani={64,65}
 tash_x=4
 tash_y=5
 tash_s=1
 
 p_ani={49,50}
 p_x=3
 p_y=2
 p_s=1
 p_hold=0
 p_rest=20
 p_text=""
 p_speed=10
 t=0
 
 p={}
 p.shake=false
 p.colum=1
 p.row=1
 p.rowoffset=22
 p.x=-12
 p.y=81
 row1x=12
 row2x=17
 row3x=24
 p.prevtext=""
 p.newtext=""
 p.prevroom=0 
 p.itemnum=0
 p.one=2
 p.two=1
 p.three=3
 p.four=2
 p.five=1
 
 following=false
 
 cust={}
 cust.ani={}
 cust.poor=""
 cust.med=""
 cust.good=""
 cust.tol=flr(rnd(10)+1)
 cust.t=0
 cust.mode=0
 cust.prev=1
 cust.roll=2

 roll_cust()
 custdelay=10
 rating=2.1
 
 stove=99
 loctext=""
 stattext1=""
 stattext2=""
 stattext3=""
 s1col=6
 s2col=7
 s3col=11
 
 menuselect=4
 
	money=26
 order=1
 
 sfx(5)

end

function _update60()
 t+=1
 if (t%p_speed==0) then
  if (p_s==2) then p_s=1 else p_s=2 end
  if (tash_s==2) then tash_s=1 else tash_s=2 end
 end
 if (t%50==0) then 
  if (cust.s==2) then cust.s=1 else cust.s=2 end
 end
 if (t%5000==0) then
  adj_price()
 end
 _upd()
end

function _draw()
 _drw()
 --print(cust.mode,10,100)
 --print(custdelay,10,110)
end 

function adj_price()
 local c=flr(rnd(5)+1)
 local d=flr(rnd(3))
 if (flr(rnd(2))==1) then
  aprice[c]+=d
 else
  aprice[c]-=d
  if (aprice[c]<=0) then
   aprice[c]=1
  end
 end
end

function pricecheck()
 local mu = price[cust.want]-aprice[cust.want]
 if (mu<=flr((aprice[cust.want]/2)+cust.tol)) then
  return true
 else
  return false
 end
end


-->8
--draw 

function draw_game()
 cls()
 local x=8*8
 draw_smap()
 draw_ptime()
 
 if (open==2) then
  spr(18, 10*8,5*8)
 end
 spr(p_ani[p_s], p_x*8,p_y*8)
 draw_cust()
 draw_text()
 show_tash()
end 

function draw_cust()
 if not (cust.x==nil) then
  spr(cust.ani[cust.s], cust.x*8,cust.y*8)
 end
end

function draw_smap()
if ((ampm==1 and hours>6)	or (ampm==2 and hours<9)) then
  mof=0
  map(mof,0)
 else
  mof=16
  map(mof,0)
 end
end

function draw_text()
 print('money: $'..flr(money), 1, 2, 0)
 print('money: $'..flr(money), 2, 1, 7)
 print('doobies dog house', 18, 18, 0)
 print('doobies dog house', 19, 17, 1)
 if (open==1) then
  if (signflicker==5) then
  print(' oobie   og hous', 19, 17, 8)
  else 
  print('doobies dog house', 19, 17, 8)
  end 
 end
 print(loctext, 2, 9*8+1, 10)
 if not  (loctext=="refrigerator") then
  show_status()
 end
 if (p_hold>-10) then
  print(p_text, 2, 15*8, 4)
  print(p_text, 2-1, 15*8-1, 7)
 end
 if (cust.mode==0) and (loctext=="refrigerator") then
  show_stock()
 elseif (not (cust.mode==666)) and (open==2) and (loctext=="refrigerator") then
  show_stock()
 elseif (cust.mode==666) and (open==2) and (loctext=="refrigerator") then
  show_status()
 elseif (cust.mode==1) and (open==1) and (p_hold<1) and (loctext=="refrigerator") then
  if (pricecheck()==false) then
   print("", 10, 10*8, 7)
   print(item[cust.want], 10, 11*8, 8)
	  print(item[cust.want], 10-1, 11*8-1, 7)
   print("it's too expensive.", 10, 12*8, 8)
   print("customer will only pay $"..aprice[cust.want]+flr((aprice[cust.want]/2)+cust.tol), 10, 13*8, 7)
   print("current menu price: $"..price[cust.want], 10, 14*8, 7)
  else
   print("", 10, 10*8, 7)
   print("you're all out of:", 10, 11*8, 7)
   print(item[cust.want], 10, 12*8, 8)
   print("buy more at ashmore's.", 10, 13*8, 7)
   print("", 10, 14*8, 7)
  end
 elseif (cust.mode==1) and (p_hold>0) and (loctext=="refrigerator") then
  local prof=price[cust.want]-aprice[cust.want]
  if (pricecheck()==true) then
   print("", 10, 10*8, 7)
   print("ingredents taken for: ", 10, 11*8, 7)
   print(item[cust.want], 10, 12*8, 8)
   print(item[cust.want], 10-1, 12*8-1, 7)
   print("price: $"..price[cust.want].." (prft mrgn: $"..prof..")", 10, 13*8, 3)
   print("price: $"..price[cust.want].." (prft mrgn: $"..prof..")", 10-1, 13*8-1, 7)
   print("", 10, 14*8, 7)
  else
   print("the customer still isn't", 10, 10*8, 7)
   print("paying more than $"..aprice[cust.want]+flr((aprice[cust.want]/2)+cust.tol).." for:", 10, 11*8, 7)
   print(item[cust.want], 10, 12*8, 8)
   print(item[cust.want], 10-1, 12*8-1, 7)
   print("nice try, doob.", 10, 13*8, 7)
  end
 end
 --print("custdelay "..custdelay,9,60,11)
end

function draw_ptime()
 if ((ampm==1 and hours>6)	or (ampm==2 and hours<9)) then
  if (hours>9) then
   print('time: '..hours..":"..min1..min2.." "..ap[ampm], 8*8-1, 2, 0)
   print('time: '..hours..":"..min1..min2.." "..ap[ampm], 8*8, 1, 10)
  else
   print('time: 0'..hours..":"..min1..min2.." "..ap[ampm], 8*8-1, 2, 0)
   print('time: 0'..hours..":"..min1..min2.." "..ap[ampm], 8*8, 1, 10)
  end
 else 
  if (rating>2) and (custdelay>51) then 
   custdelay=50/flr(rating*3)
  end
  if (hours>9) then
   print('time: '..hours..":"..min1..min2.." "..ap[ampm], 8*8-1, 2, 0)
   print('time: '..hours..":"..min1..min2.." "..ap[ampm], 8*8, 1, 12)
  else
   print('time: 0'..hours..":"..min1..min2.." "..ap[ampm], 8*8-1, 2, 0)
   print('time: 0'..hours..":"..min1..min2.." "..ap[ampm], 8*8, 1, 12)
  end
 end
end

function draw_menu()
 cls()
 map(32,0)
 print("doobies dog house", 20, 1*8, 11)
 print("menu!!!", 55, 2*8, 0)
 print(item[1], 10, 3*8, 10)
 print("$"..price[1], 80, 4*8, 4)
 print("(mrkt.$"..aprice[1]..")", 10, 4*8, 5)
 print(item[2], 10, 5*8, 10)
 print("$"..price[2], 80, 6*8, 4)
 print("(mrkt.$"..aprice[2]..")", 10, 6*8, 5)
 print(item[3], 10, 7*8, 10)
 print("$"..price[3], 80, 8*8, 4)
 print("(mrkt.$"..aprice[3]..")", 10, 8*8, 5)
 print(item[4], 10, 9*8, 10)
 print("$"..price[4], 80, 10*8, 4)
 print("(mrkt.$"..aprice[4]..")", 10, 10*8, 5)
 print(item[5], 10, 11*8, 10)
 print("$"..price[5], 80, 12*8, 4)
 print("(mrkt.$"..aprice[5]..")", 10, 12*8, 5)
 print("         -->", 63, menuselect*8,3) 
 print("<--         ", 63, menuselect*8,8)
      
 print("'z' to rename. 'x' to exit.", 10, 14*8+1, 11)
end

function draw_home()
 cls()
 if ((ampm==1 and hours>6)	or (ampm==2 and hours<9)) then
  mof=49
  map(mof,0)
 else
  mof=66
  map(mof,0)
 end
 if (p_hold>-10) then
  print(p_text, 2, 15*8, 4)
 end
 print(loctext, 2, 9*8+1, 10)
 print('money: $'..flr(money), 1, 2, 0)
 print('money: $'..flr(money), 2, 1, 7)
 spr(p_ani[p_s], p_x*8,p_y*8)
 draw_ptime()
 show_tash()
 if (following==false) then
  tash_x=4
  tash_y=5
  spr(tash_ani[tash_s],tash_x*8,tash_y*8)
 end
end

function show_tash()
 if (following==true) then
  spr(tash_ani[tash_s],tash_x*8,tash_y*8)
 end
end

function draw_ash()
 cls()
 mof=83
 map(mof,0)
 if (p_hold>-10) then
  print(p_text, 2, 15*8, 4)
 end
 print(loctext, 2, 9*8+1, 10)
 print(stattext1, 10, 11*8, s1col)
 
 print(stattext2, 10, 12*8, 8)
 print(stattext2, 10-1, 12*8-1, 7)
 
 print(stattext3, 10, 13*8, s3col)
 print('money: $'..flr(money), 1, 2, 0)
 print('money: $'..flr(money), 2, 1, 7)
 spr(p_ani[p_s], p_x*8,p_y*8)
 draw_ptime()
 print("ashmore's fine foods",10,10*8, 3)
 print("ashmore's fine foods",10-1,10*8-1, 7)
 show_tash()
end

function show_stock()
 print(p.one.." "..item[1], 10, 10*8, 7)
  print(p.two.." "..item[2], 10, 11*8, 7)
  print(p.three.." "..item[3], 10, 12*8, 7)
  print(p.four.." "..item[4], 10, 13*8, 7)
  print(p.five.." "..item[5], 10, 14*8, 7)
end

function show_status()
 print(stattext1, 10, 11*8, s1col)
 print(stattext2, 10, 12*8, s2col)
 print(stattext3, 10, 13*8, s3col)
end
-->8
--update

function update_game()
 if (t%100==0) then
  if (cust.mode==0) or (open==2 and custdelay>1) then 
   custdelay-=1
  end
 end
 if (t%50==0) then 
  upd_time()
  do_time()
  if (custdelay<0) then custdelay=0 end
  signflicker=flr(rnd(400))
  if (custdelay<=0) then
   if (cust.mode<1) then
    if (rating>1) then 
     custdelay=23-flr(rating*4)
    else
     custdelay=flr(rnd(200)+10)
    end
    roll_cust()
    cust_ai()
   end  
  end
 end
 
 if (_drw==draw_game) then
 	 do_shop()
 	 do_cust_ai()
	elseif (_drw==draw_home) then
 	 do_home()
 elseif (_drw==draw_ash) then
 	 do_ash()
 end
 if (delay>-2) then delay-=1 end
 if (delay<1) then
  if (_drw==draw_game) then
 	 do_move()
 	elseif (_drw==draw_menu) then
 	 do_menu()
 	elseif (_drw==draw_home) then
 	 do_move()
 	elseif (_drw==draw_ash) then
 	 do_move()
 	elseif (_drw==draw_keyboard) then
 	 key_input()
 	end 
 end
end

function upd_time()
 min2+=1
end

function do_time()
	if (min2>=10) then
		min1+=1
		min2=0
		p_rest-=0.1
	end
	if (min1>=6) then
		hours+=1
		min1=0
	end
	if(hours>=13) then
	 ampm+=1
		hours=1
	end
	if (ampm==3) then
		ampm=1
	end
end

function do_move()
 local x=nil
 if (p_rest>75) then
  p_speed=10
 elseif (p_rest>50) then
  p_speed=15
 elseif (p_rest>25) then
  p_speed=20
 elseif (p_rest>1) then
  p_speed=35
 else
  p_speed=50
 end
	if btn(0) then
	delay=p_speed
	 x=mget(mof+p_x-1,p_y)
		if (fget(x,0)==false) then	 
    set_tash_loc()
    p_x -= 1
  end
 elseif btn(1) then
 delay=p_speed
  x=mget(mof+p_x+1,p_y)
		if (fget(x,0)==false) then	 
    set_tash_loc()
    p_x += 1
  end
 elseif btn(2) then
 delay=p_speed
  x=mget(mof+p_x,p_y-1)
		if (fget(x,0)==false) then	 
    set_tash_loc()
    p_y -= 1
  end  
 elseif btn(3) then
 delay=p_speed
  x=mget(mof+p_x,p_y+1)
		if (fget(x,0)==false) then	 
    set_tash_loc()
    p_y += 1
  end
 end
 
 --switch rooms
 if (p_x==13) and (p_y==8) and (_drw==draw_game) then
  _drw=draw_home
  p_x=7
  p_y=1
  tash_x=7
  tash_y=0
 elseif (p_x==7) and (p_y==0) and (_drw==draw_home) then
  _drw=draw_game
  p_x=13
  p_y=7
  tash_x=13
  tash_y=8
 elseif (p_x==15) and (p_y==7) and (_drw==draw_home) then
  _drw=draw_ash
  p_x=1
  p_y=7
  tash_x=0
  tash_y=7
 elseif (_drw==draw_ash) and (p_x==0) then
  _drw=draw_home
  p_x=14
  p_y=7
  tash_x=15
  tash_y=7
 end
end

function do_shop()
 x=mget(p_x,p_y)
 if (p_hold<1) then
  p_text=""
 else
  if (cust.cook<10) then 
   p_text="holding: "..ingreduncooked[p_hold]
  elseif (cust.cook<100) then
   p_text="holding: "..ingredcooked[p_hold]
  else
   p_text="holding: "..item[p_hold]
  end
 end
 if (fget(x,1)==true) then
 	if (open==2) then
 		loctext="press 'z' to open shop"
 	else
 	 loctext="press 'z' to close shop"
 	end
 elseif (fget(x,2)==true) then
  if (t%20==0) then
   hours+=1
   p_rest-=.5
   adj_price()
   if (custdelay>0) then
   	custdelay-=200
   	if (custdelay<0) then custdelay=0 end
   end
  end
  loctext="the toilet is out of order"
 elseif (fget(x,3)==true) then
  if (p_hold>0) then
   p_text="cooking: "..item[p_hold]
  end
  if (p_hold>0) then
   if (cust.cook<100) and (t%10==0) then
    cust.cook+=1
    stove-=0.25
    if (stove<0) then stove=0 end
    if (stove>75) then
     cust.cook+=3
    elseif (stove>40) then
     cust.cook+=1
    end
   end
   loctext="%"..cust.cook.." cooked"
  else
   if (open==2) then
    loctext="the stove is "..flr(stove).."% clean"
    if (t%50==0) then
     if (stove<100) then
      stove+=p_rest/5
      if (stove>100) then stove=100 end
      p_rest-=0.5
     end
    end
   else 
    if (stove<100) then
     loctext="stove "..flr(stove).."% (close shop to clean)"
    else
     loctext="stove "..flr(stove).."% clean."
    end
   end
  end
 elseif (fget(x,4)==true) then
  loctext="refrigerator"
  if (cust.mode==1) and (open==1) then
   if (pricecheck()==true) then
    if (p.one>=1) and (cust.want==1) and (p_hold<1) then
     p.one-=1
     p_hold=cust.want
    elseif (p.two>=1) and (cust.want==2) and (p_hold<1) then
     p.two-=1
     p_hold=cust.want
    elseif (p.three>=1) and (cust.want==3) and (p_hold<1) then
     p.three-=1
     p_hold=cust.want
    elseif (p.four>=1) and (cust.want==4) and (p_hold<1) then
     p.four-=1
     p_hold=cust.want
    elseif (p.five>=1) and (cust.want==5) and (p_hold<1) then
     p.five-=1
     p_hold=cust.want
    end
   end
  end
 elseif (fget(x,5)==true) then
  loctext="prezz 'z' to change menu"
 elseif (fget(x,6)==true) then
  if (p_hold>0) then
   if (pricecheck()==true) then
    loctext="press 'z' to serve customer"
   else
    loctext="warning: price too high!"
   end
  else
   if (cust.mode==1) and (open==1) and (p_hold<1) then
    loctext="'z' to kick customer out."
   elseif (cust.mode>1) and (open==1) then
    loctext=served.." customers served"
   else
    loctext="register. "..flr(p_rest).."% rested."
   end
  end
	elseif (fget(x,7)==true) then
  loctext="ket & mus on the table!"
	else
	 if (p_rest<=0) then
	  loctext="you're plum give out."
   p_rest=0
	 elseif (p_rest<15) then
   loctext="you're exausted."
  else
	  loctext=""
	 end
 end
 
 if btn(4) and (delay<1) then
 delay=20
 	if (fget(x,1)==true) then
 		if (open==1) then
 			open=2
 		else
 		 open=1
 		end
 	end	
 	if (fget(x,6)==true) then
 	 if (cust.mode==1) and (pricecheck()==true) and (p_hold>0) then
 	 	p_hold=0
 	 	cust.mode=2
 	 	cust_ai()
 	 else
 	  p_hold=0
 	  cust.mode=667
 	  cust_ai()
 		end
 	end	
 	if (fget(x,5)==true) then
 		_drw=draw_menu
 	end	
 end
end

function do_menu()
 local x=(menuselect/2)-1
	if btn(0) then
	delay=20
				price[x]-=1
 elseif btn(1) then
 delay=20
				price[x]+=1
 elseif btn(3) then
 delay=20
  if (menuselect < 12) then
   menuselect+=2
  else 
   menuselect=4
  end
 elseif btn(2) then
 delay=20
  if (menuselect > 4) then
   menuselect-=2
  else 
   menuselect=12
  end
 elseif btn(5) then
 delay=20
 _drw=draw_game
 elseif btn(4) then
 delay=20
 p.prevtext=item[x]
 p.newtext=""
 p.prevroom=draw_menu
 p.itemnum=x
 _drw=draw_keyboard
 end
end

function do_home()
 x=mget(mof+p_x,p_y)
 if (fget(x,2)==true) then
  if (p_rest>100) then p_rest=100 end
  loctext="it's broke."
 elseif (fget(x,3)==true) then
  loctext="you don't feel like cooking."
 elseif (fget(x,5)==true) then
  if (p_rest<0) then p_rest=0 end
  loctext="you are "..flr(p_rest).."% rested."
  if (t%100==0) then
   p_rest+=1
   if (p_rest>100) then p_rest=100 end
  end
 elseif (fget(x,4)==true) then
  if (t%20==0) then
 	 loctext="sleeping. you are "..flr(p_rest).."% rested."
 	 if (p_rest>=100) then
    loctext="you are "..flr(p_rest).."% rested."
   end
   if (p_rest<100) then 
    if (open==2) then
     p_rest+=10
     hours+=1
     if (p_rest>=100) then
      p_rest=100
     end
    else
     loctext="close shop to sleep. "..flr(p_rest).."% rested."
    end
   else
    min1+=1
   end 
  end
 elseif (p_x==6) and (p_y==5)  then
  loctext="computer. yelp rating: "..flr(rating).." stars."
 else
  if (p_rest<=0) then
	  loctext="you're plum give out."
	  p_rest=0
	 else
   loctext=""
  end
 end
 do_tash_ai()
end

function do_ash()
 if (p_y==5) and (p_x>1) and (p_x<5) then
  loctext="'z' to buy for \f3$"..aprice[1]
  stattext1="ingredents for:"
  stattext2=item[1]
  stattext3="owned: "..p.one
  if btn(4) and (delay<1) then delay=20,purc_item(1) end
 elseif (p_y==5) and (p_x>6) and (p_x<9) then
  loctext=""
 elseif (p_y==5) and (p_x>10) and (p_x<14) then
  loctext="'z' to buy for \f3$"..aprice[5]
  stattext1="ingredents for:"
  stattext2=item[5]
  stattext3="owned: "..p.five
  if btn(4) and (delay<1) then delay=20,purc_item(5) end
 elseif (p_y==3) and (p_x>1) and (p_x<5) then
  loctext="'z' to buy for \f3$"..aprice[2]
  stattext1="ingredents for:"
  stattext2=item[2]
  stattext3="owned: "..p.two
  if btn(4) and (delay<1) then delay=20,purc_item(2) end
 elseif (p_y==3) and (p_x>6) and (p_x<9) then
  loctext="'z' to buy for \f3$"..aprice[3]
  stattext1="ingredents for:"
  stattext2=item[3]
  stattext3="owned: "..p.three
  if btn(4) and (delay<1) then delay=20,purc_item(3) end
 elseif (p_y==3) and (p_x>10) and (p_x<14) then
  loctext="'z' to buy for \f3$"..aprice[4]
  stattext1="ingredents for:"
  stattext2=item[4]
  stattext3="owned: "..p.four
  if btn(4) and (delay<1) then delay=20,purc_item(4) end
 else
  if (p_rest<=0) then
	  loctext="you're plum give out."
   p_rest=0
 	elseif (p_rest<15) then
   loctext="you're exausted."
  else
   loctext=""
  end
  stattext1=""
  stattext2=""
  stattext3=""
 end
end

function purc_item(i)
 if (money >= aprice[i]) then
  sfx(4)
  money-=aprice[i]
  if (i==1) then
   p.one+=1
  elseif (i==2) then
   p.two+=1
  elseif (i==3) then
   p.three+=1
  elseif (i==4) then
   p.four+=1
  elseif (i==5) then
   p.five+=1 
  end
 else
  sfx(3)
 end
end

function set_tash_loc()
 tash_x=p_x
 tash_y=p_y
end
-->8
--customer ai
function do_cust_ai()
 if (t%200==0) then 
  cust_ai() 
	end
end

function cust_ai()
 	if (cust.mode==0) then 
	  cust.x=100
	  cust.y=100
	  stattext1=""
	  stattext2=""
	  stattext3=""
	 elseif (cust.mode==1) then
	  if (open==1) then
	   cust.x=8
	   cust.y=4
	   stattext1=cust.name.." wants:"
    stattext2=item[cust.want]
    if true then
     stattext3=""
    else
     stattext3="but it's too expensive."
     s3col=8
     p_hold=0
     cust.mode=668
    end 
    s1col=6
    s2col=7
    s3col=11
   else
    cust.mode=666
   end
  elseif (cust.mode==2) then
   cust.x=9
	  cust.y=4
   stattext1=cust.name.." is eating:"
   stattext2=item[cust.want]
   stattext3=""
   s2col=7
   s3col=11
   cust.mode=3
   money+=price[cust.want]
   p_hold=0
   cust.want=0
   served+=1
   sfx(2)
  elseif (cust.mode==3) then
   cust.x=9
	  cust.y=5
	  stattext1=cust.name.." says:"
   if (cust.cook>=0) and (cust.cook<40) then
    rating-=.25
    if rating<0 then rating=0 end
    stattext2=cust.poor
    stattext3="the customer is angry."
    s3col=8
    p_rest-=10
   elseif (cust.cook<75) then
    stattext2=cust.med
    stattext3="the customer is satisfied"
    s2col=7
    s3col=5
    p_rest-=2
   else
    stattext2=cust.good
    rating+=.15
    if (following==true) then 
     rating+=.35
    end
    if rating>5 then rating=5 end
    local tip = flr(rnd(5)+1)
    stattext3="they give you a tip of $"..tip
    s3col=11
    money+=tip
    sfx(1)  
   end
   cust.mode=0
	 elseif (cust.mode==666) then
	  cust.x=11
	  cust.y=6
	  stattext1=cust.name.." wants:"
   stattext2="hot, cheap snacks, but"
   stattext3="the doghouse is closed"
   s1col=6
   s2col=7
   s3col=7
   cust.mode=0
   p_hold=0
   rating-=.01
   if (rating<0) then rating=0 end
	 elseif (cust.mode==667) then
	  stattext1=cust.name.." whines:"  
   stattext2="'what a waste of my time!'"
   s3col=8
   stattext3="they give you a dirty look."
   p_rest-=3
   rating-=.25
   if (rating<0) then rating=0 end
   cust.mode=0
  elseif (cust.mode==668) then
	  stattext1=cust.name.." whines:"  
   stattext2="'you're prices are too high!'"
   s3col=11
   rating-=2
   if (rating<0) then rating=0 end
   stattext3="you reply, 'you complain everywhere you go.'"
   p_rest-=2
   cust.mode=0
  end	
end

function do_tash_ai()
 if (p_x==4) and (tash_x==4) and (p_y==5) and (tash_y==5) then
  loctext="your wife says, \"roll tide\"."
  following=true
 end
 if (p_x==5) and (p_y==5) then
  --loctext="your wife says, \"roll tide\"."
  following=false
  tash_x=4
  tash_y=5
 end
 if (p_x==3) and (p_y==2)  then
  tash_x=3
  tash_y=2
 end
end
-->8
--roll customer
function roll_cust()
-- if (open==1) then
  cust.mode=1
-- else
--  cust.mode=666
-- end
 cust.roll=flr(rnd(6)+1)
 if (cust.roll==cust.prev) then
  if (cust.roll>1) then
   cust.roll=1
  else
   cust.roll=flr(rnd(5)+2)
  end
 end
 local x = cust.roll
 cust.prev = cust.roll
 if (x==1) then
  cust.name="bad frogger"
  cust.ani={51,52}
  cust.poor="'i hope you croak, jerk!'"
  cust.med="'i wanted a combo meal.'"
  cust.good="'#teamfrogout'"
 elseif (x==2) then
  cust.name="entitled northerner"
  cust.ani={53,54}
  cust.poor="'this is inedible!'"
  cust.med="'i didn't expect much.'"
  cust.good="'pretty good, i guess.'"
 elseif (x==3) then
  cust.name="local idiot"
  cust.ani={55,56}
  cust.poor="'that was gross.'"
  cust.med="'see you at church, doob.'"
  cust.good="'you done good this time!'"
 elseif (x==4) then
  cust.name="odesseya"
  cust.ani={57,58}
  cust.poor="'i'll shut you down!'"
  cust.med="'not bad, except for the roach.'."
  cust.good="'100% heath inspection!'"
 elseif (x==5) then
  cust.name="yuppie scum"
  cust.ani={59,60}
  cust.poor="'that was putrid!'"
  cust.med="'get me out of here.'"
  cust.good="'tre bien!'"
 elseif (x==6) then
  cust.name="black lady hacker"
  cust.ani={61,62}
  cust.poor="'i'm complaining on yelp.'"
  cust.med="'i'm from up north.'"
  cust.good="'hack the planet!'"
 end
 cust.x=100
 cust.y=100
 cust.s=1
 cust.want=flr(rnd(count(item))) + 1
 cust.cook=0
end
-->8
--keyboard

function draw_keyboard()
 cls()
 --keyboard
 rectfill(0,85,127,127,1)
 rect(0,85,127,127,5)
 --keyboard uslesss lines
 rect(0,94,127,99,0) 
 rect(0,104,127,109,0)
 rect(0,114,127,119,0)

 rect(0,94,127,98,5) 
 rect(0,104,127,108,5)
 rect(0,114,127,118,5)
  
 --keyboard keys outline
 rect(10,91,110,102,0) 
 rect(15,101,105,112,0)
 rect(22,111,92,122,0)
 rectfill(10,91,110,101,6) 
 rectfill(15,101,105,111,6)
 rectfill(22,111,92,121,6)
 rect(10,91,110,101,5) 
 rect(15,101,105,111,5)
 rect(22,111,92,121,5)
 for i=1,9 do 
  line(10+(10*i),91,10+(10*i),101,5)
  line(15+(10*i),101,15+(10*i),111,5)
  if (i<7) do line(22+(10*i),111,22+(10*i),121,5) end
 end
 
 if (p.row==1) then
  p.rowoffset=row1x
 elseif (p.row==2) then
  p.rowoffset=row2x
 else 
  p.rowoffset=row3x
 end
 
-- spr(1,player.x+player.rowoffset+(10*player.colum),player.y+(player.row*10))
 rectfill(p.x+p.rowoffset+(10*p.colum),p.y+(p.row*10),p.x+p.rowoffset+(10*p.colum)+10,p.y+(p.row*10)+10,3)
 rect(p.x+p.rowoffset+(10*p.colum),p.y+(p.row*10),p.x+p.rowoffset+(10*p.colum)+10,p.y+(p.row*10)+10,8)
 
 row1={"q","w","e","r","t","y","u","i","o","p"}
 row2={"a","s","d","f","g","h","j","k","l"}
 row3={"z","x","c","v","b","n","m"}
 shake=0
 
 --keyboard shake and draw
 shakeit()
 for i=1,10 do
  shakeit()
  print(row1[i],3+(i*10)+shake,95+shake2,0)
  print(row1[i],4+(i*10)+shake,94+shake2,7)
 end
 for i=1,9 do
  shakeit()
  print(row2[i],8+(i*10)+shake,105+shake2,0)
  print(row2[i],9+(i*10)+shake,104+shake2,7)
 end
 for i=1,7 do
  shakeit()
  print(row3[i],15+(i*10)+shake,115+shake2,0)
  print(row3[i],16+(i*10)+shake,114+shake2,7)
 end
 print("backspace", 38,85,11)
 if (p.row==0) then
  print("backspace", 38-1,85-1,7)
 end
 print("space", 48,124,11)
 if (p.row==4) then
  print("space", 48-1,124-1,7)
 end
 
 --edit text
 print("change menu item name:", 5,10, 8)
 print("change menu item name:", 5-1,10-1, 7)
 
 print(item[p.itemnum],10,25,1)
 
 print("enter new item name:", 5,40, 11)
 print("enter new item name:", 5-1,40-1, 7)
 
 print(p.newtext,10,55,3)
 print(p.newtext,10-1,55-1,7)
 print("'z' select letter. 'x' when done.",1,75,9) 
 
end

function shakeit()

 if (p.shake==true) then 
  shake=flr(rnd(2))
  shake2=flr(rnd(2))
 else 
  shake=0
  shake2=0
 end
 
end

function key_input()
 
	 p.shake=false
	
	 --press up and down
  if (btn(2)) then
   --sfx(0)
   delay=10
   p.row-=1
   if (p.row<0) then p.row=0 end
  end
 
  if (btn(3)) then
   --sfx(0)
   delay=10
   p.row+=1
   if (p.row>4) then p.row=4 end
  end
  
  --press left and right
  if (btn(0)) then
   --sfx(0)
   delay=10
   p.colum-=1
   if (p.colum<1) then p.colum=1 end
  end
  
  if (btn(1)) then
   --sfx(0)
   delay=10
   p.colum+=1
  end
  
  --agjust for different colum lenght
   
   if (p.row==1) then
    if (p.colum>10) then p.colum=10 end
   elseif (p.row==2) then
    if (p.colum>9) then p.colum=9 end 
   else
    if (p.colum>7) then p.colum=7 end 
   end
   
   if (btn(4)) then 
    --do input for 'z'
    delay=20
    if (#p.newtext<22) then
     if (p.row==0) then
      if (#p.newtext>0) then
       p.newtext=sub(p.newtext,0,#p.newtext-1)
      else
       p.shake=true
      end
     else
      p.newtext=p.newtext..get_keyboard_letter()
     end
    else
     p.shake=true
    end
   end
   
   if (btn(5)) then
    delay=20
    if not (p.newtext=="") then
     item[p.itemnum]=p.newtext
    end
    _drw=draw_menu
   end
end

function get_keyboard_letter()

 --get the letter keyboard cursor is over
 local r1={"q","w","e","r","t","y","u","i","o","p"}
 local r2={"a","s","d","f","g","h","j","k","l"}
 local r3={"z","x","c","v","b","n","m"}
 local x
 if (p.row==1) then 
  x=r1[p.colum]
 elseif (p.row==2) then
  x=r2[p.colum]
 elseif (p.row==3) then
  x=r3[p.colum]
 elseif (p.row==4) then
  x=" "
 elseif (p.row==0) then
  x=" "
 end
 
 return x

end
-->8


function draw_title()
 cls()
 spr(98,30,10, 10,10)
 print("reform, alabama",37,85,8)
 print("reform, alabama",37-1,85-1,7)
  print("june 2014",50,95,2)
 print("june 2014",50-1,95-1,7)
 print("v1.2",60,123,7)
 spr(48, dx, 110)
 local ani={91,92}
 spr(ani[ts], dx-20,110)
end

function update_title()
 title-=1
 dx+=1
 if (t%20==0) then
  if (ts==2) then ts=1 else ts=2 end
 end
 if (title<1) then
  _upd=update_game
  _drw=draw_home
 end
 
end
__gfx__
00000000999999409999999900777700303330309999994044444444bbbbbbbb0000000b6676676677767767b3907000004440000000cc700000cc7000447770
00000000999999409999999907766770000000009966094044444444bbbbb3bb666666007666667677677777b3007000000000000000cc000000cc0000007670
00700700999999409999999907666670333033309656394044444244bbbbbbbb465656606766766676777777bb007000444444440000cc7000bbcc7044447670
00077000999999409999999907666670000000009566094044444444bb3bbbbb465656606666667677776767b3907000000000000000cc0000bbcc0000007670
00077000999999409999999907666070303330309656594044444444bbbbbbbb465656606667666777777777bb307000004444400000cc7000bbcc7000447670
00700700999999409999999907666070000000009566594042444424bbbbbb3b465656607666676676777677b3907000000000000000cc0000bbcc0000007670
00000000444444404444444407666670330333309956594044444444bb3bbbbb66666600676666767767767633007000000044440000cc7000bbcc7000007670
00000000000000000000000000000000000000009999994044444444bbbbbbbb0000000b6667666767776777b9b07000444400000000cc000000cc0044447770
30766630055555500000cc7033333333556556556665665631406000000000032222222270777070666440005555550030333030000000000044400000444000
076666600d6666d00000cc0033333133655555656656666631006000555555002222222200000000777000006665650099999999000000000000000000000000
766666664d6666d40088cc703333333356556555656666663300600025151550222221227770777077700000666565449aaaaaa9000000004444444444444444
666666660d6666d00088cc003313333355555565666656563140600025151550222222220000000077666664666565009aaaaaa9000000000000000000000000
555555550dddddd00088cc703333333355565556666666663310600025151550222222227077707007777740666565409aaaaaa9000000000044444000444440
00000000000000000088cc0033333313655556556566656631406000251515502122221200000000007770006665650099999999000000000000000000000000
33033330000044440088cc7033133333565555656656656511006000555555002222222277077770077777446665654433033330000000000000444400004444
05656550444400000000cc0033333333555655565666566634306000000000032222222200000000444400005555550000000000000000004444000044440000
bbbbbbbb33333333004440000044400000000000444444449999999966766766bbbbbbbb33333333007777000499999922222220022222220044c00070777070
bbbbb3bb33333133000000000000000000000000444444449999999955555576bbbbb3bb3333313307777770049999992e2e2220022e2e2e000ccc0000000000
bbbbbbbb33333333444444444444444400000000444444449999999944455566bbbbbbbb333333334cccccc404999999e2e2e2244222e2e244ccccc477707770
bb3bbbbb33133333000000000099999000000000444444449999999944455576bb3bbbbb3313333301111110049999992e2e2220022e2e2e0000700000000000
bbbbbbbb33333333004444400049494000000000444444449999999944455567bbbbbbbb333333330111111004999999e2e2e2200222e2e20044744070777070
bbb07b3b33306313000000000099099000000000444444449999999944455566bbbbbb3b33333313011111100499999900000220022000000000700005555550
bb307bbb33106333000044440090449400000000444444449999999955555576bb3bbbbb33133333011111140444444400004444000044440000744475565650
bbb07bbb33306333444400004444000000000000444444449999999966676667bbbbbbbb33333333441111000000000044440000444400004446660005555550
0044444000ffff000000000000000000000000000000000000aaaa004440000000444000000000000000000000000000000aa000000000000055550000000000
044fff4000f44f0000ffff00000707000007070000aaaa0000affa00f440000000f440000000000000044000000aa000000ff000005555000054450000000000
0477f770008888000ff44ff0000c7c70000c7c7000affa000aaffaa0ff4111f000ff41ff0004400000644600000fa000000ff000005445000554455000000000
047cf7c008888880888888880bbbbbb00bbbbbb00aaffaa00aa88aa0000011ff0000110f0064460005566550000ff00007733770055445500553355000000000
0fffffff0888888088888888000bbbbb00bbbbbb0aa88aa00008800000f1110f0ff111f005566550455665540773377007733770055335500003300000000000
0f74447f088888800888888000000bbb000bbbbb08888880008888000ff111000f0111004556655405566550077337700f7337f0033333300033330000000000
0ff777f000c00c0000c00c000bb088bb0000bbb00888888000888800000c0c00000c0c000556655000dddd000f7337f000111100033333300033330000000000
00f444f0011001100110011000bbbbb00000000000c00c0000c00c00008808800088088000d00d0000d00d00001001000010010000c00c0000c00c0000000000
00000000004444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444400004ff4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
004ff400004ff4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
004ff400004334000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00433400000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03333330003333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03333330003333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00c00c0000c00c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444447777777722222222dd222222222222dd77777777555555550000000000448a0055555555000000000000000000000000496666940000000000000000
4949494977dddd772cccccc2d22111122111122d42222224566666650050005009998a9056666665005000500070700000707000496cc6940000000000000000
494949497d7777d72cc7ccc2d21111122111112d431ebe84566666650000000049999994566666650000000007c7c00007c7c000496666940000000000000000
494949497d7777d72c7cccc2d21111122111112d4444444456666665000500500090090056666665000500500bbbbbb00bbbbbb0495555940000000000000000
494949497d7777d72cccc7c2d211111dd111112d422222245666666500000000094444905666666500000000bbbbbb00bbbbb000499999940000000000000000
494949497d7777d72ccc7cc2d211111dd111112d4ac839d45666666505000000000000005666666505000000bbbbb000bbb00000496696940000000000000000
4949494977dddd772cccccc2d21111122111112d4444444456666665000500500000444456666665000500500bbb0000bb880bb0444444440000000000000000
444444447777777722222222d21111122111112d777777775555555500000000444400005555555500000000000000000bbbbb00000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000002222222000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000020000222200000000000000000000000020000000000000000000220000000000000000000000000000000000000000000000000
00000000000000000000000020000000220000000000000000000000020000000000000000000222200000000000000000000000000000000000000000000000
00000000000000000000000020000000002000000000000000000000020000000000000000000200220000000000000000000000000000000000000000000000
00000000000000000000000020000000002200000000000000000000020000000000000000000200002000000000000000000000000000000000000000000000
00000000000000000000000020000000000200000000000000000000020000000000002222200200002000000000000000000000000000000000000000000000
00000000000000000000000020000000000020000002200000222000020000000020022000000200000000000000000000000000000000000000000000000000
00000000000000000000000020000000000020222222220222222000022000000020020000000200000000000000000000000000000000000000000000000000
00000000000000000000000020000000000020200000020200002220002000000020020000000220000000000000000000000000000000000000000000000000
00000000000000000000000020000000000020200000020200000022202200000020020000000022000000000000000000000000000000000000000000000000
00000000000000000000000020000000000020200000020200000000202222000022022220000002200000000000000000000000000000000000000000000000
00000000000000000000000002000000000020200000020020000002202002200002020000000000220000000000000000000000000000000000000000000000
00000000000000000000000002000000000020200000220020000022002200220002020000000000022000000000000000000000000000000000000000000000
00000000000000000000000002000000000020200002200020000020000200022002020000000000002000000000000000000000000000000000000000000000
00000000000000000000000000200000000220222222000022000220000200002002022222000000002000000000000000000000000000000000000000000000
00000000000000000000000000200000002200000000000002222200000222222000000000000000002200000000000000000000000000000000000000000000
00000000000000000000000002200002222000000000000000000000000200000000000000000000000200000000000000000000000000000000000000000000
00000000000000000000000222022220000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000
00000000000000000000000222220000000000000000000000000000000000000000000002000000002200000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000002200000002000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000220000002000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000022000022000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000002222220000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000004440099900000000220000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000004444094449900000000000000000000000000000000000000000000000000000000
0000000000000000000000007777777700000000000000000000000000000444a444742299000000000000000000000000000000000000000000000000000000
000000000000000000000000777777770000000000000000000000000000044aa442227449000000000000000000000000000000000000000000000000000000
000000000000000000000000770000770000000000000000000000000000044aaaa4224474400000000000000000000000000000000000000000000000000000
000000000000000000000000770000770000000777000000000000000000044994aa442227490000000000000000000000000000000000000000000000000000
0000000000000000000000007700007700007777777700007777000004000099944a442244279000000000000000000000000000000000000000000000000000
000000000000000000000000770000777000777777770007777777044440009999aa2242442aaaaaa00000000000000000000000000000000000000000000000
0000000000000000000000007700007770007700007700077700770444440099999aaaa224422aaaa00000000000000000000000000000000000000000000000
0000000000000000000000007700000770007700077700077000770444444779999944aaa442242aa00000000000000000000000000000000000000000000000
00000000000000000000000077000007700077700770000770007704444444447999444a4aaa42aa000000000000000000000000000000000000000000000000
00000000000000000000000077000777700077770770000770007700449442447799944a44a4a224900000000000000000000000000000000000000000000000
00000000000000000000000077777777000007777770000770077700999a42224479994a444aa224900000000000000000000000000000000000000000000000
00000000000000000000000077777770000000777770000777777700999aaa444479999aaaaaaa22790000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000007777777009999aa4442777999444aa222279000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000077009999aaa442a27999944a4224229000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000007770099999a4aaaa27099944a2222429000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000777009999999aaaa27799994aa222229000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000077770777700009999999aaaa27999994aaa4229000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000777777777000099999999aaa4479999944aa499000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000777777700000099999999aaa4447999994a4490000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000099999999aa422799999aaa400000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000999999999a42247999944aaaa000000000000000000000000000000000000000000000
00000000000000000000000000000770000000000000000000000000000999999999444279999444440000000000000000000000000000000000000000000000
00000000000000000000000770000770000000000000000000000000000999999999944247000444440000000000000000000000000000000000000000000000
00000000000000000000000770000770000000000000000000000000000099999999944427000044440000000000000000000000000000000000000000000000
00000000000000000000000770000770000000000000000000000000000000999999994447000000000000000000000000000000000000000000000000000000
00000000000000000000000770000770000000000000000000000000000000009999994444000000000000000000000000000000000000000000000000000000
00000000000000000000000770000770000000000000000000000000000000077779994444000000000000000000000000000000000000000000000000000000
00000000000000000000000770000770007770000770007700077777700007777770044444000000000000000000000000000000000000000000000000000000
00000000000000000000000770000770077770000770007700077777700007777770004444000000000000000000000000000000000000000000000000000000
00000000000000000000000777777770077777700770007700077777000077700777004400000000000000000000000000000000000000000000000000000000
00000000000000000000000777777770777077700770077700007777700077777777000000000000000000000000000000000000000000000000000000000000
00000000000000000000000770000770777007700770077700000077770077777777000000000000000000000000000000000000000000000000000000000000
00000000000000000000000770000770777707700777777000000077770077000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000770000770777777700777777007777777770077777000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000770007777700007777007777777000077777000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007700000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666600006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000660066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066660000006600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000660000666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006066000066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066006000660660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
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
00000000000000000000000000000000000022222220000000000000000000000000000200000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000200002222000000000000000000000000200000000000000000002200000000000000000000000000000000000
00000000000000000000000000000000000000200000002200000000000000000000000200000000000000000002222000000000000000000000000000000000
00000000000000000000000000000000000000200000000020000000000000000000000200000000000000000002002200000000000000000000000000000000
00000000000000000000000000000000000000200000000022000000000000000000000200000000000000000002000020000000000000000000000000000000
00000000000000000000000000000000000000200000000002000000000000000000000200000000000022222002000020000000000000000000000000000000
00000000000000000000000000000000000000200000000000200000022000002220000200000000200220000002000000000000000000000000000000000000
00000000000000000000000000000000000000200000000000202222222202222220000220000000200200000002000000000000000000000000000000000000
00000000000000000000000000000000000000200000000000202000000202000022200020000000200200000002200000000000000000000000000000000000
00000000000000000000000000000000000000200000000000202000000202000000222022000000200200000000220000000000000000000000000000000000
00000000000000000000000000000000000000200000000000202000000202000000002022220000220222200000022000000000000000000000000000000000
00000000000000000000000000000000000000020000000000202000000200200000022020022000020200000000002200000000000000000000000000000000
00000000000000000000000000000000000000020000000000202000002200200000220022002200020200000000000220000000000000000000000000000000
00000000000000000000000000000000000000020000000000202000022000200000200002000220020200000000000020000000000000000000000000000000
00000000000000000000000000000000000000002000000002202222220000220002200002000020020222220000000020000000000000000000000000000000
00000000000000000000000000000000000000002000000022000000000000022222000002222220000000000000000022000000000000000000000000000000
00000000000000000000000000000000000000022000022220000000000000000000000002000000000000000000000002000000000000000000000000000000
00000000000000000000000000000000000002220222200000000000000000000000000000000000000000000000000002000000000000000000000000000000
00000000000000000000000000000000000002222200000000000000000000000000000000000000000000020000000022000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000022000000020000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000002200000020000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000220000220000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022222200000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000044400999000000002200000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000044440944499000000000000000000000000000000000000000000
000000000000000000000000000000000000007777777700000000000000000000000000000444a4447422990000000000000000000000000000000000000000
00000000000000000000000000000000000000777777770000000000000000000000000000044aa4422274490000000000000000000000000000000000000000
00000000000000000000000000000000000000770000770000000000000000000000000000044aaaa42244744000000000000000000000000000000000000000
00000000000000000000000000000000000000770000770000000777000000000000000000044994aa4422274900000000000000000000000000000000000000
000000000000000000000000000000000000007700007700007777777700007777000004000099944a4422442790000000000000000000000000000000000000
00000000000000000000000000000000000000770000777000777777770007777777044440009999aa2242442aaaaaa000000000000000000000000000000000
000000000000000000000000000000000000007700007770007700007700077700770444440099999aaaa224422aaaa000000000000000000000000000000000
000000000000000000000000000000000000007700000770007700077700077000770444444779999944aaa442242aa000000000000000000000000000000000
0000000000000000000000000000000000000077000007700077700770000770007704444444447999444a4aaa42aa0000000000000000000000000000000000
0000000000000000000000000000000000000077000777700077770770000770007700449442447799944a44a4a2249000000000000000000000000000000000
0000000000000000000000000000000000000077777777000007777770000770077700999a42224479994a444aa2249000000000000000000000000000000000
0000000000000000000000000000000000000077777770000000777770000777777700999aaa444479999aaaaaaa227900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007777777009999aa4442777999444aa2222790000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000077009999aaa442a27999944a42242290000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000007770099999a4aaaa27099944a22224290000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000777009999999aaaa27799994aa2222290000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000077770777700009999999aaaa27999994aaa42290000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000777777777000099999999aaa4479999944aa4990000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000777777700000099999999aaa4447999994a44900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000099999999aa422799999aaa4000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000999999999a42247999944aaaa0000000000000000000000000000000
00000000000000000000000000000000000000000007700000000000000000000000000009999999994442799994444400000000000000000000000000000000
00000000000000000000000000000000000007700007700000000000000000000000000009999999999442470004444400000000000000000000000000000000
00000000000000000000000000000000000007700007700000000000000000000000000000999999999444270000444400000000000000000000000000000000
00000000000000000000000000000000000007700007700000000000000000000000000000009999999944470000000000000000000000000000000000000000
00000000000000000000000000000000000007700007700000000000000000000000000000000099999944440000000000000000000000000000000000000000
00000000000000000000000000000000000007700007700000000000000000000000000000000777799944440000000000000000000000000000000000000000
00000000000000000000000000000000000007700007700077700007700077000777777000077777700444440000000000000000000000000000000000000000
00000000000000000000000000000000000007700007700777700007700077000777777000077777700044440000000000000000000000000000000000000000
00000000000000000000000000000000000007777777700777777007700077000777770000777007770044000000000000000000000000000000000000000000
00000000000000000000000000000000000007777777707770777007700777000077777000777777770000000000000000000000000000000000000000000000
00000000000000000000000000000000000007700007707770077007700777000000777700777777770000000000000000000000000000000000000000000000
00000000000000000000000000000000000007700007707777077007777770000000777700770000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000007700007707777777007777770077777777700777770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007700077777000077770077777770000777770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000077000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000077707770777007707770777000000000777070007770777077707770777000000000000000000000000000000000
00000000000000000000000000000000000078787888788870787878777800000000787878007878787878787778787800000000000000000000000000000000
00000000000000000000000000000000000077087700770078787708787800000000777878007778770877787878777800000000000000000000000000000000
00000000000000000000000000000000000078707880788078787870787807000000787878007878787078787878787800000000000000000000000000000000
00000000000000000000000000000000000078787770780077087878787870800000787877707878777878787878787800000000000000000000000000000000
00000000000000000000000000000000000008080888080008800808080808000000080808880808088808080808080800000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007770707077007770000077707770770070700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000722727272707222000002727272072072720000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000720727272727700000077727272072077720000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000720727272727220000072227272072002720000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007720077272727770000077707772777000720000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000220002202020222000002220222022200020000000000000000000000000000000000000000000
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

__gff__
0001010001010000010000010001010001080100000001010001041001010204010120400000000001011001200001010000000000000000000000000000000000000000000000000000000000000000010001000001000080010100000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0707070707070707282828282828280b13131313131329292929292929292916252525252525252525252525252525250028282828282828092828282828282828002929292929292914292929292929292900505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000
0706060606060606060807070707070b13181818181818181817131313131316252626262626262626262626262626250028191919191907090707070707070728002919191919191314131313131313132900505151515151515151515151515151500000000000000000000000000000000000000000000000000000000000
0606202020202020202020070a09070b18182121212121212121211315141316252626262626262626262626262626250028190c2a2b19070909090909090909280029190c2a2b191314141414141414142900505155555551515555515155555551500000000000000000000000000000000000000000000000000000000000
04040410040404041c0419090909090b04040410040404041c04191414141416252626262626262626262626262626250028190c0c0c19070907070707070709280029190c0c0c191314131313131313142900505151515151515151515151515151500000000000000000000000000000000000000000000000000000000000
041a04110c0c230522580d090909090b041a04110c0c230522580d1414141416252626262626262626262626262626250028190c1919191903192f1919190709280029190c1919191903192f19191913142900505155555551515151515155555551500000000000000000000000000000000000000000000000000000000000
040c040c0c0202010c1e0e090a09090b040c040c0c0202010c0c0e1415141416252626262626262626262626262626250028190c2e2d2c5d0c0c11191a0d0709280029190c2e2d2c5d0c0c11191a0d13142900505151515151515151515151515151500000000000000000000000000000000000000000000000000000000000
041b0f0c0c0c0c0c0c0c0f09090a090b041b0f0c0c0c0c0c0c0c0f1414151416252626262626262626262626262626250028190c0c0c0c0c0c0c0c0f0c0d0709280029190c0c0c0c0c0c0c0c0f0c0d13142900505250525052505354505250525052500000000000000000000000000000000000000000000000000000000000
0404040404040404040419070909090b04040404040404040404191314141416252626262626262626262626262626250028191919191919191919191919070909002919191919191919191919191913141400565656565656565656565656565656590000000000000000000000000000000000000000000000000000000000
2807070707070707070707070709070b291313131313131313131313131413162526262626262626262626262626262500282828282828282828282828282828280029292929292929292929292929292929005757575757575757575757575757575a0000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d2526262626262626262626262626262500000000000000000000000000000000000000000000000000000000000000000000001d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d0000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d252626262626262626262626262626250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000252626262626262626262626262626250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000252626262626262626262626262626250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000252626262626262626262626262626250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000252525252525252525252525252525250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00020000110501c0501d00000000000000c300033000830002300063000230007300053000a3000f30014300153001f300293003030035300383003830032300263001d300143000c30003300003000030000300
001000000c01013010210101c010270103a010320103f0100f000180001b0001d0002100031000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001072017720207201b2202c720232202e2202f720252203702000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001755010550135500b5500755002550005001a500105000950001500005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003f5500255002550035500a550125501b5501e550115501e55017550085500055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f0000053500c350053500c350053500c350033500835002350063500235007350053500a3400f33014320153101f320293303033035330383303833032330263301d330143200c32003320003000030000300
