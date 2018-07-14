--魔废『深邃生态炸弹』
function c10380.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10380.op1)
	c:RegisterEffect(e1)
--
	if not c10380.gchk then
		c10380.gchk=true
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetOperation(c10380.op2)
		Duel.RegisterEffect(e2,0)
	end 
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,10380+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c10380.con3)
	e3:SetTarget(c10380.tg3)
	e3:SetOperation(c10380.op3)
	c:RegisterEffect(e3)
--
end
--
function c10380.ofilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsPreviousLocation(LOCATION_HAND)
end
function c10380.op2(e,tp,eg,ep,ev,re,r,rp)
	local rg=eg:Filter(c10380.ofilter2,nil)
	if rg:GetCount()<1 then return end
	local rc=rg:GetFirst()
	while rc do
		Duel.RegisterFlagEffect(rc:GetPreviousControler(),10380,RESET_PHASE+PHASE_END,0,1)
		rc=rg:GetNext()
	end
end
--
function c10380.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_PHASE+PHASE_END)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetCountLimit(1)
	e1_1:SetOperation(c10380.op1_1)
	Duel.RegisterEffect(e1_1,tp)
end
--
function c10380.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local num1=Duel.GetTurnCount()*2
	local num2=Duel.GetFlagEffect(tp,10380)
	local num=math.min(num1,num2)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	local sg1=g1:RandomSelect(tp,num)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_DECK,nil)
	local sg2=g2:RandomSelect(tp,num)
	Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	Duel.SendtoGrave(sg2,REASON_EFFECT)
end
--
function c10380.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_SPELLCASTER)
end
--
function c10380.tfilter3(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x200) and c:IsAbleToHand() 
end
function c10380.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10380.tfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c10380.op3(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10380.tfilter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
