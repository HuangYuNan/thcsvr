--光击『射月』
function c10382.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10382.tg1)
	e1:SetOperation(c10382.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10382)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10382.tg2)
	e2:SetOperation(c10382.op2)
	c:RegisterEffect(e2)
--
end
--
function c10382.tfilter1(c)
	return (c:IsSetCard(0x2024) or c:IsSetCard(0x2022)) and c:IsAbleToGrave()
end
function c10382.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10382.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
--
function c10382.ofilter1(c,sc)
	return c:IsCode(sc:GetCode()) and not c:IsPublic()
end
function c10382.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c10382.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()<1 then return end
	if Duel.SendtoGrave(sg,REASON_EFFECT)<1 then return end
	local sc=sg:GetFirst()
	if sc:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c10382.ofilter1,tp,LOCATION_HAND,0,1,nil,sc) and Duel.SelectYesNo(tp,aux.Stringid(10382,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tg=Duel.SelectMatchingCard(tp,c10382.ofilter1,tp,LOCATION_HAND,0,1,1,nil,sc)
		if tg:GetCount()<1 then return end
		Duel.ConfirmCards(1-tp,tg)
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
--
function c10382.tfilter2(c)
	return c:IsAbleToGrave()
end
function c10382.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10382.tfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
--
function c10382.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c10382.tfilter2,tp,LOCATION_HAND,0,1,1,nil)
	if sg:GetCount()<1 then return end
	if Duel.SendtoGrave(sg,REASON_EFFECT)<1 then return end
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
--
