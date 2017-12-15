--铃兰与甜美的交织✿梅蒂欣
function c1156013.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
--
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_SPSUMMON_PROC)
	e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e11:SetRange(LOCATION_EXTRA)
	e11:SetCondition(c1156013.lkcon)
	e11:SetOperation(c1156013.lkop)
	e11:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e11)
--
	local e2=Effect.CreateEffect(c)
--  e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
--  e2:SetDescription(aux.Stringid(1156013,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c1156013.op2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c1156013.tg1)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e1)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c1156013.val5)
	c:RegisterEffect(e5)
--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c1156013.val5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e6:SetTarget(c1156013.tg6)
	e6:SetLabelObject(e7)
	c:RegisterEffect(e6)
--
end
--
function c1156013.lkcheck(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsRace(RACE_PLANT) 
end
--
--
function c1156013.lkfilter(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsControler(tp)
	if c:IsType(TYPE_TOKEN) then
		return flag and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_WIND)
	else
		return flag and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsRace(RACE_PLANT)
	end
end
function c1156013.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1 
	end
end
--
function c1156013.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c1156013.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c1156013.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c1156013.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c1156013.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1156013.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1156013.lkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=2
	local maxc=2
	if ct>maxc then return false end
	return c1156013.lcheck(tp,sg,c,minc,ct) or mg:IsExists(c1156013.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
--
function c1156013.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c1156013.lkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=2
	local maxc=2
	for i=ct,maxc-1 do
		local cg=mg:Filter(c1156013.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c1156013.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
--
function c1156013.tg1(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsSetCard(0x165) and not (c:IsRace(RACE_PLANT) and c:IsType(TYPE_TOKEN))
end
--
function c1156013.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x1151,1)
	local num=c:GetCounter(0x1151)
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_UPDATE_ATTACK)
	e2_1:SetValue(-num*300)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2_1)
	Duel.BreakEffect()
	if c:GetAttack()==0 then
		Duel.NegateRelatedChain(c,RESET_TURN_SET)
		local e2_2=Effect.CreateEffect(c)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetCode(EFFECT_DISABLE)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2_2)
		local e2_3=Effect.CreateEffect(c)
		e2_3:SetType(EFFECT_TYPE_SINGLE)
		e2_3:SetCode(EFFECT_DISABLE_EFFECT)
		e2_3:SetValue(RESET_TURN_SET)
		e2_3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2_3)
		if Duel.Destroy(c,REASON_EFFECT)~=0 then
			Duel.Recover(c:GetOwner(),c:GetBaseAttack(),REASON_EFFECT)
		end
	end
end
--
function c1156013.val5(e,c)
	return not (c:IsImmuneToEffect(e) or c:IsSetCard(0x165))
end
--
function c1156013.tg6(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
--
