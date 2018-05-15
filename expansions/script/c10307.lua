--雾雨的魔法使✿雾雨魔理沙
function c10307.initial_effect(c)
	 --handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10307,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c10307.condition)
	e1:SetTarget(c10307.target)
	e1:SetOperation(c10307.operation)
	c:RegisterEffect(e1)   
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10307)
	e4:SetCondition(c10307.con4)
	e4:SetTarget(c10307.tgtg)
	e4:SetOperation(c10307.opop)
	c:RegisterEffect(e4)
end
function c10307.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c10307.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetDecktopGroup(1-tp,1)
	if chk==0 then return sg:GetCount()>0 and sg:GetFirst():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function c10307.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end
function c10307.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c10307.sfilter(c)
	return  c:IsSetCard(0x2023) and c:IsAbleToHand()
end
function c10307.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10307.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10307.opop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10307.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end