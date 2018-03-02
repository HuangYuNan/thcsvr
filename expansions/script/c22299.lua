--天使的捉弄✿琪露诺&大妖精☆
function c22299.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22299.spcon)
	e1:SetOperation(c22299.spop)
	e1:SetLabel(2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabel(3)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetLabel(4)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22299,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(c22299.target)
	e4:SetOperation(c22299.operation)
	c:RegisterEffect(e4)
end
function c22299.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x999) and c:IsAbleToRemoveAsCost()
end
function c22299.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=e:GetLabel()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-ct
		and Duel.GetMatchingGroup(c22299.spfilter1,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)>=ct
end
function c22299.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c22299.spfilter1,tp,LOCATION_MZONE,0,nil)
	local gn=Group.CreateGroup()
	local ct=e:GetLabel()
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:Select(tp,1,1,nil)
		gn:Merge(g1)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	end
	Duel.Remove(gn,POS_FACEUP,REASON_COST)
	local gnc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	for i=1,gnc do
		c:RegisterFlagEffect(22299,RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,0,1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetReset(RESET_EVENT+0xff0000)
	e2:SetValue(ct*900)
	c:RegisterEffect(e2)
end
function c22299.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetFlagEffect(22299)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_MZONE,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_MZONE,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c22299.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=g:GetCount()
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		local opc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		local gnc=ct-opc
		if gnc>0 then
			Duel.Draw(tp,gnc,REASON_EFFECT)
		end
	end
end
