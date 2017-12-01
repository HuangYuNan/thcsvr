--神与佛的连结✿圣白莲
function c26504.initial_effect(c)
	c:SetUniqueOnField(1,0,26504)
	--link summon
	aux.AddLinkProcedure(c,c26504.matfilter,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26504.condition)
	e1:SetOperation(c26504.operation)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetOperation(c26504.lvop)
	c:RegisterEffect(e3)
end
function c26504.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN) and c:IsSetCard(0x208)
end
function c26504.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c26504.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0x33,0x33,nil):RandomSelect(tp,4)
	if g:GetFirst()==g:RandomSelect(tp,1):GetFirst() then
		Duel.Hint(11,0,aux.Stringid(26504,4))
	end
	if Duel.GetFlagEffect(tp,26504)==0 then
		Duel.Hint(HINT_CARD,0,26504)
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(1,26504)
		e1:SetCondition(c26504.gscon)
		e1:SetOperation(c26504.gsop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.RegisterFlagEffect(tp,26504,0,0,1)
end
function c26504.filter(c,e,tp)
	return c:IsLevelBelow(2) and c:GetAttack()<=1000 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26504.gscon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x252) and ep==tp
end
function c26504.gsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=ag:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=ag:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	if sg:GetCount()>0 then
		sg:GetFirst():AddCounter(0x28d,2)
	end
	Duel.Recover(tp,500,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26504.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26504.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetLocation()~=LOCATION_EXTRA then return end
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetTarget(c26504.tg)
	e4:SetOperation(c26504.op)
	c:RegisterEffect(e4)
end
function c26504.shfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:GetLevel()%2==0
end
function c26504.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26504.shfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26504.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26504.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
