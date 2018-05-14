--结界『扩散结界』
function c10289.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10289)
	e2:SetCondition(c10289.con2)
	e2:SetTarget(c10289.tg2)
	e2:SetOperation(c10289.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(0)
	e3:SetCountLimit(1,10290)
	e3:SetCost(c10289.cost3)
	e3:SetTarget(c10289.tg3)
	e3:SetOperation(c10289.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(c10289.tg4)
	e4:SetValue(c10289.val4)
	e4:SetOperation(c10289.op4)
	c:RegisterEffect(e4)
--
end
--
function c10289.cfilter2(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsControler(tp)
end
function c10289.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10289.cfilter2,1,nil,tp)
end
--
function c10289.tfilter2(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c10289.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetCount()==1 and eg:IsExists(c10289.cfilter2,1,nil,tp) and Duel.IsExistingMatchingCard(c10289.tfilter2,tp,LOCATION_DECK,0,1,nil,eg:GetFirst():GetCode()) end
	Duel.SetTargetCard(eg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c10289.ofilter2(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c10289.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c10289.ofilter2,tp,LOCATION_DECK,0,1,1,nil,code)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
--
function c10289.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c10289.tfilter3_1(c,e,tp)
	return ((c:IsLocation(LOCATION_SZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x1014) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c10289.tfilter3_2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c10289.tfilter3_2(c,code)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x1014) and not c:IsCode(code)
end
function c10289.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10289.tfilter3_1,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10289.tfilter3_1,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c10289.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10289.tfilter3_2,tp,LOCATION_DECK,0,1,1,nil,code)
	if g:GetCount()<1 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
--
function c10289.tfilter4(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1014) and c:IsLocation(LOCATION_SZONE)
		and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function c10289.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c10289.tfilter4,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
--
function c10289.val4(e,c)
	return c10289.tfilter4(c,e:GetHandlerPlayer())
end
--
function c10289.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
--
