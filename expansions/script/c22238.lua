--风暴魔女✿帕秋莉·诺蕾姬
function c22238.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fus.AddFusionProcFunMulti(c,true,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WATER),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),
	aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WIND))
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22238,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22238)
	e2:SetTarget(c22238.tg2)
	e2:SetOperation(c22238.op2)
	c:RegisterEffect(e2)   
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22239)
	e5:SetCondition(c22238.condition)
	e5:SetTarget(c22238.target)
	e5:SetOperation(c22238.operation)
	c:RegisterEffect(e5) 
	--ind
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c22238.condition1)
	e5:SetOperation(c22238.operation1)
	c:RegisterEffect(e5) 
end
function c22238.filters(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c22238.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c22238.filters,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22238.filters,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22238.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function c22238.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x179) and rc:IsType(TYPE_CONTINUOUS+TYPE_SPELL)
end
function c22238.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22238.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c22238.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22238.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c22238.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22238.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
function c22238.condition1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x178) and re:IsActiveType(TYPE_CONTINUOUS+TYPE_SPELL)
end
function c22238.pfilter(c)
	return  c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22238.operation1(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,22238)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(c22238.indtg)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end
function c22238.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end