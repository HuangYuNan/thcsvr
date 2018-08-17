--四季隐星-魔法地藏✿矢田寺成美
function c32012.initial_effect(c)
--
	aux.EnablePendulumAttribute(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32012,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c32012.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_PZONE,0)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTarget(c32012.tg2)
	e2:SetValue(c32012.val2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetOperation(c32012.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32012,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c32012.con4)
	e4:SetTarget(c32012.tg4)
	e4:SetOperation(c32012.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(32012,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,32012)
	e5:SetCondition(c32012.con5)
	e5:SetTarget(c32012.tg5)
	e5:SetOperation(c32012.op5)
	c:RegisterEffect(e5)
--
end
--
function c32012.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetLeftScale()<1 and c:GetRightScale()<1 then return end
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_UPDATE_LSCALE)
	e1_1:SetValue(-3)
	e1_1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1_1)
	local e1_2=e1_1:Clone()
	e1_2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e1_2)
--
end
--
function c32012.tg2(e,c)
	return c~=e:GetHandler()
end
--
function c32012.val2(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--
function c32012.chain3(e,rp,tp)
	return tp==rp
end
function c32012.op3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ep~=tp then return end
	if not re:IsHasCategory(32035) then return end
	Duel.SetChainLimit(c32012.chain3)
end
--
function c32012.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
--
function c32012.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_MZONE)
end
--
function c32012.op4(e,tp,eg,ep,ev,re,r,rp)
--
	if not Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) then return end
	if not Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil) then return end
--
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local sg2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,1-tp,LOCATION_MZONE,0,1,1,nil)
	if sg1:GetCount()<1 then return end
	if sg2:GetCount()<1 then return end
	local sg=Group.CreateGroup()
	sg:Merge(sg1)
	sg:Merge(sg2)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
--
end
--
function c32012.con5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
--
function c32012.tfilter5(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsSetCard(0x410) and c:IsType(TYPE_MONSTER)
end
function c32012.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32012.tfilter5,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c32012.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c32012.tfilter5,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
--
