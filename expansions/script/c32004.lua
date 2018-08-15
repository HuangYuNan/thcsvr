--跨越浮世门关的山姥✿坂田合欢乃
function c32004.initial_effect(c)
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c32004.tg1)
	e1:SetOperation(c32004.op1)
	c:RegisterEffect(e1)  
	--to defense
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32004,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c32004.con2)
	e2:SetTarget(c32004.tg2)
	e2:SetOperation(c32004.op2)
	c:RegisterEffect(e2) 
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(0x410)
	e3:SetCondition(c32004.con3)
	c:RegisterEffect(e3)
--  
end
--
function c32004.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c32004.tfilter1(c)
	return c:IsSetCard(0x410) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c32004.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32004.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c32004.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
--
function c32004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
--
function c32004.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAttackPos() then return end
	if Duel.ChangePosition(c,POS_FACEUP_DEFENSE)<1 then return end
--
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2_1:SetCode(EFFECT_UPDATE_DEFENSE)
	e2_1:SetValue(500)
	e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2_1)
--
end
--
function c32004.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)~=0
end
--
