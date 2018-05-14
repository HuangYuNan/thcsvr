--黑魔『黑洞边缘』
function c10377.initial_effect(c)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e5)
	 --destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c10377.reptg)
	e5:SetValue(c10377.repval)
	e5:SetOperation(c10377.op5)
	c:RegisterEffect(e5)  
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10377,1))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c10377.thcon)
	e7:SetTarget(c10377.thtg)
	e7:SetOperation(c10377.thop)
	c:RegisterEffect(e7)
--
end
function c10377.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x200) and not c:IsReason(REASON_REPLACE)
end
function c10377.tfilter5(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c10377.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c10377.repfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c10377.tfilter5,tp,LOCATION_SZONE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=Duel.SelectMatchingCard(tp,c10377.tfilter5,tp,LOCATION_SZONE,0,1,1,nil)
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c10377.repval(e,c)
	return c10377.repfilter(c,e:GetHandlerPlayer())
end
function c10377.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT+REASON_REPLACE)
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REPLACE)
end
--
function c10377.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_SPELLCASTER)
end
function c10377.thfilter(c)
	return c:IsSetCard(0x2023) and c:IsAbleToHand()
end
function c10377.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10377.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10377.thop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10377.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
