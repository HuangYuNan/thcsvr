--摩的
function c26145.initial_effect(c)
	--pendulum summon
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,99,aux.TRUE,argTable,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c26145.condition)
	e1:SetOperation(c26145.activate)
	c:RegisterEffect(e1)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26145,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,26145+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c26145.retcon)
	e4:SetCost(c26145.cost)
	e4:SetTarget(c26145.rettg)
	e4:SetOperation(c26145.retop)
	c:RegisterEffect(e4)
end
function c26145.condition(e,tp,eg,ep,ev,re,r,rp)
	local t1=Duel.IsExistingMatchingCard(c26145.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local t2=Duel.IsExistingMatchingCard(c26145.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c26145.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	return t1 or t2
end
function c26145.cfilter(c)
	return (c:IsSetCard(0x252) or c:IsSetCard(0x251)) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c26145.filter(c,e,tp)
	return c:IsSetCard(0x252a) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP) and c:IsType(TYPE_MONSTER)
end
function c26145.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(12,0,aux.Stringid(26145,4))
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c26145.filter,tp,LOCATION_HAND,0,1,nil,e,tp) then t[p]=aux.Stringid(26145,1) p=p+1 end
	if Duel.IsExistingMatchingCard(c26145.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c26145.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then t[p]=aux.Stringid(26145,2) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26145,3))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(26145,0)
	local sg=Group.CreateGroup()
	if opt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=Duel.SelectMatchingCard(tp,c26145.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)==0 then return end
	elseif opt==2 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c26145.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=Duel.SelectMatchingCard(tp,c26145.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SendtoGrave(g,REASON_EFFECT)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	else return end
	local tc=sg:GetFirst()
	Duel.Equip(tp,c,tc)
	--Add Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c26145.reqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--destroy sub
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
end
function c26145.reqlimit(e,c)
	return e:GetLabelObject()==c
end
function c26145.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsReason(REASON_DESTROY)
end
function c26145.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.Hint(12,0,aux.Stringid(26145,5))
end
function c26145.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	e:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c26145.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
