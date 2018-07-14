--秘法德鲁伊✿帕秋莉·诺蕾姬
function c22234.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fus.AddFusionProcFunMulti(c,true,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),
	c22234.mfilter1)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22234,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22234)
	e5:SetTarget(c22234.target)
	e5:SetOperation(c22234.operation)
	c:RegisterEffect(e5)   
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22234,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,22235)
	e4:SetCost(c22234.cost)
	e4:SetCondition(c22234.condition)
	e4:SetTarget(c22234.targets)
	e4:SetOperation(c22234.op)
	c:RegisterEffect(e4) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22234,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c22234.con2)
	e2:SetTarget(c22234.tg2)
	e2:SetOperation(c22234.op2)
	c:RegisterEffect(e2)
end
function c22234.mfilter1(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c22234.filter(c)
	return c:IsSetCard(0x185) and c:IsAbleToHand()
end
function c22234.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c22234.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22234.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22234.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22234.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c22234.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x180) and rc:IsType(TYPE_CONTINUOUS+TYPE_SPELL)
end
function c22234.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsDiscardable() end,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,function(c) return c:IsDiscardable() end,1,1,REASON_COST+REASON_DISCARD)
end
function c22234.targets(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end
function c22234.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c22234.filters(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c22234.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22234.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c22234.cfilter(c)
	return (c:IsSetCard(0x183) or c:IsSetCard(0x179) or c:IsSetCard(0x180)or c:IsSetCard(0x181) or c:IsSetCard(0x182)) 
	and c:IsFaceup() and c:IsType(TYPE_CONTINUOUS+TYPE_SPELL)
end
function c22234.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c22234.filters,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22234.filters,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22234.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end