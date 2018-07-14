--丰裕与成熟的象征✿八云蓝
function c19062.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc225),c19062.ffilter,true) 
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19062,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c19062.tg1)
	e1:SetOperation(c19062.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c19062.con2)
	e2:SetOperation(c19062.op2)
	c:RegisterEffect(e2)
--
end
--
function c19062.ffilter(c)
	return c:IsCode(23004,999302) 
		or (bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0 and c:IsRace(RACE_PLANT) and not c:IsType(TYPE_TUNER))
end
--
c19062.hana_mat={
c19062.ffilter,
aux.FilterBoolFunction(Card.IsFusionSetCard,0xc225),
}
--
function c19062.tfilter1(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c19062.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19062.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19062.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c19062.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
--
function c19062.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if not tc:IsLocation(LOCATION_MZONE) then return end 
	if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
--
function c19062.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
--
function c19062.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2_1:SetType(EFFECT_TYPE_QUICK_O)
	e2_1:SetCode(EVENT_CHAINING)
	e2_1:SetRange(LOCATION_GRAVE)
	e2_1:SetCondition(c19062.con2_1)
	e2_1:SetCost(c19062.cost2_1)
	e2_1:SetTarget(c19062.tg2_1)
	e2_1:SetOperation(c19062.op2_1)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2_1)
end
--
function c19062.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) 
		and (re:IsHasCategory(CATEGORY_DAMAGE)
			or re:IsHasCategory(CATEGORY_DRAW))
end
--
function c19062.cost2_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
--
function c19062.tg2_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
--
function c19062.op2_1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--