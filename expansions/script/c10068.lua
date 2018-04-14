--梦符『梦想亚空穴』
function c10068.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(2,31051)
	e1:SetCost(c10068.cost1)
	e1:SetTarget(c10068.tg1)
	e1:SetOperation(c10068.op1)
	c:RegisterEffect(e1)
--
end
--
function c10068.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c10068.tfilter1(c)
	local code=c:GetOriginalCode()
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0x100) and Duel.IsExistingMatchingCard(c10068.tfilter1_1,tp,LOCATION_DECK,0,1,nil,code)
end
function c10068.tfilter1_1(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0x100) and not c:IsCode(code)
end
function c10068.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10068.tfilter1,tp,LOCATION_MZONE,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c10068.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoHand(tc,nil,REASON_COST)
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c10068.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not tc then return end
	local code=tc:GetOriginalCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10068.tfilter1_1,tp,LOCATION_DECK,0,1,1,nil,code)
	if g:GetCount()<1 then return end
	local sc=g:GetFirst()
	Duel.SendtoHand(sc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sc)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_PHASE+PHASE_END)
	e1_2:SetRange(LOCATION_HAND)
	e1_2:SetCountLimit(1)
	e1_2:SetOperation(c10068.op1_2)
	e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	sc:RegisterEffect(e1_2)
end
--
function c10068.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoGrave(c,REASON_EFFECT)
end
--
