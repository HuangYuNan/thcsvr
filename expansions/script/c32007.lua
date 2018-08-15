--四季隐星-守护兽✿高丽野阿吽
function c32007.initial_effect(c)
--
	aux.EnablePendulumAttribute(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c32007.con1)
	e1:SetTarget(c32007.tg1)
	e1:SetOperation(c32007.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(32007)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32007,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c32007.tg3)
	e3:SetOperation(c32007.op3)
	c:RegisterEffect(e3) 
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32007,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,32007)
	e4:SetCost(c32007.cost4)
	e4:SetTarget(c32007.tg4)
	e4:SetOperation(c32007.op4)
	c:RegisterEffect(e4)
--
end
--
function c32007.cfilter1(c,tp)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_PENDULUM)  and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c32007.con1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c32007.cfilter1,1,nil,tp)
end
--
function c32007.tfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--
function c32007.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32007.tfilter1,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_SZONE)
end
--
function c32007.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c32007.tfilter1,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
--
function c32007.tfilter3(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
--
function c32007.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c32007.tfilter3(chkc) end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingTarget(c32007.tfilter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(32007,1))
	Duel.SelectTarget(tp,c32007.tfilter3,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c32007.op3(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--
function c32007.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
--
function c32007.tfilter4(c)
	return c:IsRace(RACE_ROCK) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c32007.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32007.tfilter4,tp,LOCATION_DECK,0,1,nil) end
end
--
function c32007.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32007.tfilter4,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
