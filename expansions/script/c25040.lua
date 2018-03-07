--剧毒的身体✿梅蒂欣·梅兰可莉
function c25040.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c25040.thtg)
	e1:SetOperation(c25040.thop)
	c:RegisterEffect(e1)
	--poison
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25040,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c25040.condition)
	e3:SetTarget(c25040.destg)
	e3:SetOperation(c25040.desop)
	c:RegisterEffect(e3)
end
function c25040.ffilter(c)
	return c:IsSetCard(0x164) and c:IsAbleToGrave()
end
function c25040.tfilter(c)
	return (c:GetOriginalCode()==25059 or c:GetOriginalCode()==25060) and c:IsAbleToHand()
end
function c25040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25040.ffilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c25040.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c25040.ffilter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_EFFECT)>0 then
		if Duel.IsExistingMatchingCard(c25040.tfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(25040,1)) then
			local g=Duel.SelectMatchingCard(tp,c25040.tfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c25040.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE) and eg:IsExists(Card.IsSetCard,1,nil,0x164)
end
function c25040.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,25040)==0 end
	Duel.RegisterFlagEffect(tp,25040,RESET_CHAIN,0,1)
end
function c25040.desop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c25040.damcon)
	e2:SetOperation(c25040.damop)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,2)
		Duel.RegisterFlagEffect(tp,25041,RESET_PHASE+PHASE_END,0,1)
	else
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e2,tp)
end
function c25040.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFlagEffect(tp,25041)==0
end
function c25040.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,25040)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
