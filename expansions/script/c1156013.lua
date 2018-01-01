--铃兰与甜美的交织✿梅蒂欣
function c1156013.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156013.lkcheck,2,2)
--
--	local e11=Effect.CreateEffect(c)
--	e11:SetType(EFFECT_TYPE_FIELD)
--	e11:SetCode(EFFECT_SPSUMMON_PROC)
--	e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
--	e11:SetRange(LOCATION_EXTRA)
--	e11:SetCondition(c1156013.lkcon)
--	e11:SetOperation(c1156013.lkop)
--	e11:SetValue(SUMMON_TYPE_LINK)
--	c:RegisterEffect(e11)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c1156013.tg1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1156013.tg2)
	e2:SetOperation(c1156013.op2)
	c:RegisterEffect(e2)
--

--
	if not c1156013.global_check then
		c1156013.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e4:SetCode(EVENT_SSET)
		e4:SetOperation(c1156013.op4)
		Duel.RegisterEffect(e4,0)
	end
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c1156013.con5)
	e5:SetValue(1)
	c:RegisterEffect(e5)
--

--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c1156013.tg7)
	e7:SetOperation(c1156013.op3)
	c:RegisterEffect(e7)
--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAINING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c1156013.tg8)
	e8:SetOperation(c1156013.op3)
	c:RegisterEffect(e8)
--
end
--
function c1156013.lkcheck(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT) and ((c:GetAttack()-c:GetDefense()==200) or (c:GetDefense()-c:GetAttack()==200))
end
--
--function c1156013.lkfilter(c,lc,tp)
--	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsControler(tp)
--	if c:IsType(TYPE_TOKEN) then
--		return flag and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_WIND)
--	else
--		return flag and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsRace(RACE_PLANT)
--	end
--end
--function c1156013.lvfilter(c)
--	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
--		return 1+0x10000*c:GetLink()
--	else 
--		return 1 
--	end
--end
--
--function c1156013.lcheck(tp,sg,lc,minc,ct)
--	return ct>=minc and sg:CheckWithSumEqual(c1156013.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
--end
--function c1156013.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
--	sg:AddCard(c)
--	ct=ct+1
--	local res=c1156013.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c1156013.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
--	sg:RemoveCard(c)
--	ct=ct-1
--	return res
--end
--
--function c1156013.lkcon(e,c)
--	if c==nil then return true end
--	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
--	local tp=c:GetControler()
--	local mg=Duel.GetMatchingGroup(c1156013.lkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
--	local sg=Group.CreateGroup()
--	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
--		local pc=pe:GetHandler()
--		if not mg:IsContains(pc) then return false end
--		sg:AddCard(pc)
--	end
--	local ct=sg:GetCount()
--	local minc=2
--	local maxc=2
--	if ct>maxc then return false end
--	return c1156013.lcheck(tp,sg,c,minc,ct) or mg:IsExists(c1156013.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)
--end
--
--function c1156013.lkop(e,tp,eg,ep,ev,re,r,rp,c)
--	local mg=Duel.GetMatchingGroup(c1156013.lkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
--	local sg=Group.CreateGroup()
--	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
--		sg:AddCard(pe:GetHandler())
--	end
--	local ct=sg:GetCount()
--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
--	sg:Select(tp,ct,ct,nil)
--	local minc=2
--	local maxc=2
--	for i=ct,maxc-1 do
--		local cg=mg:Filter(c1156013.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
--		if cg:GetCount()==0 then break end
--		local minct=1
--		if c1156013.lcheck(tp,sg,c,minc,i) then
--			if not Duel.SelectYesNo(tp,210) then break end
--			minct=0
--		end
--		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
--	   local g=cg:Select(tp,minct,1,nil)
--		if g:GetCount()==0 then break end
--		sg:Merge(g)
--	end
--	c:SetMaterial(sg)
--	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
--end
--
function c1156013.tg1(e,c)
	local tc=e:GetHandler()
	if c:IsSetCard(0x164) then
		local seq=c:GetSequence()
		local eseq=tc:GetSequence()
		if eseq>4 then return false end
		if tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) and eseq>0 and seq==eseq-1 then return true end
		if tc:IsLinkMarker(LINK_MARKER_BOTTOM) and seq==eseq then return true end
		if tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) and eseq<4 and seq==eseq+1 then return true end
		return false
	end
end
--
function c1156013.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	local seq=tc:GetSequence()
	local eseq=c:GetSequence()
	if chk==0 then 
		if eseq>4 then return false end
		if ep~=tp then return false end
		if not ((c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) and eseq>0 and seq==eseq-1) or (c:IsLinkMarker(LINK_MARKER_BOTTOM) and seq==eseq) or (c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) and eseq<4 and seq==eseq+1)) then return false end
		if not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x164) and re:GetHandler():GetFlagEffect(1156013)>0) then return false end
		return true
	end
end
--
function c1156013.op2(e,tp,eg,ep,ev,re,r,rp)
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e2_1:SetTargetRange(1,0)
	e2_1:SetValue(1)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_1,tp)
end
--


--
function c1156013.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(1156013,0)) then
		Duel.RegisterFlagEffect(tp,1156013,RESET_PHASE+PHASE_END,0,1)
		local c=e:GetHandler() 
		if Duel.IsPlayerCanSpecialSummonMonster(tp,25013,0,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_WIND) and Duel.GetMZoneCount(tp)>0 and not c:IsControler(1-tp) then
			Duel.Hint(HINT_SELECTMSG,tp,571)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,nil)
			local nseq=0
			if s==1 then nseq=0
			elseif s==2 then nseq=1
			elseif s==4 then nseq=2
			elseif s==8 then nseq=3
			else nseq=4 end
			Duel.MoveSequence(c,nseq)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ft>0 then
				local token=Duel.CreateToken(tp,25013)
				local s=ft>0 and token:IsCanBeSpecialSummoned(e,0,tp,false,false)
				if s then
					Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
--
function c1156013.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(1156013)==0 then
			tc:RegisterFlagEffect(1156013,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
--
function c1156013.cfilter5(c,tc,eseq)
	local seq=c:GetSequence()
	return (tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) and eseq>0 and seq==eseq-1) or (tc:IsLinkMarker(LINK_MARKER_BOTTOM) and seq==eseq) or (tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) and eseq<4 and seq==eseq+1) and not c:IsLocation(LOCATION_FZONE)
end
function c1156013.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eseq=c:GetSequence()
	if eseq>4 then 
		return false
	else
		return Duel.IsExistingMatchingCard(c1156013.cfilter5,tp,LOCATION_SZONE,0,1,nil,c,eseq)
	end
end
--

--
function c1156013.tg7(e,tp,eg,ep,ev,re,r,rp,chk)
	local secq=e:GetHandler():GetSequence()
	local scount=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return (re:GetHandler():GetOriginalCode()==25059 or re:GetHandler():GetOriginalCode()==25060) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and ((secq>4 and scount>1) or (secq<5 and scount>0)) and Duel.IsPlayerCanSpecialSummonMonster(tp,25013,0,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_WIND) and Duel.GetFlagEffect(tp,1156013)==0 end
end
--
function c1156013.tg8(e,tp,eg,ep,ev,re,r,rp,chk)
	local secq=e:GetHandler():GetSequence()
	local scount=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return re:GetHandler():IsSetCard(0x164) and ((secq>4 and scount>1) or (secq<5 and scount>0)) and rp==tp and Duel.IsPlayerCanSpecialSummonMonster(tp,25013,0,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_WIND) and Duel.GetFlagEffect(tp,1156013)==0 end
end
--