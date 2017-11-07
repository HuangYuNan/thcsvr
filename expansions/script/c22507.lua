--魔法使与恶魔的连结✿小恶魔
function c22507.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c22507.matfilter,1,1)
	--tohand
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c22507.descon)
	e0:SetTarget(c22507.tg)
	e0:SetOperation(c22507.op)
	c:RegisterEffect(e0)
	--attack up/cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c22507.tgtg)
	e1:SetValue(400)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e2)
end
function c22507.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN) and c:IsSetCard(0x813)
end
function c22507.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function c22507.filter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToDeck()
end
function c22507.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22507.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22507.filter,tp,LOCATION_GRAVE,0,2,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c22507.filter,tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22507.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==2 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c22507.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) or (c:IsRace(RACE_FIEND) and c:GetPreviousLocation()==LOCATION_DECK)
end
