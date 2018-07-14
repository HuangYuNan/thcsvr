--星耀魔女✿帕秋莉·诺蕾姬
function c22240.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fus.AddFusionProcFunMulti(c,true,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),
	aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WIND))
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22240,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22240)
	e5:SetTarget(c22240.tg)
	e5:SetOperation(c22240.op)
	c:RegisterEffect(e5)   
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22240,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,22241)
	e4:SetCondition(c22240.condition)
	e4:SetTarget(c22240.settg)
	e4:SetOperation(c22240.setop)
	c:RegisterEffect(e4) 
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetCondition(c22240.immcon)
	e6:SetValue(c22240.efilter)
	c:RegisterEffect(e6)
end
function c22240.filter(c)
	return c:IsSetCard(0x185) and c:IsAbleToHand()
end
function c22240.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c22240.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22240.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22240.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22240.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c22240.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x183) and rc:IsType(TYPE_CONTINUOUS+TYPE_SPELL)
end
function c22240.ssfilter(c)
	return c:IsSetCard(0x184) and c:IsType(TYPE_CONTINUOUS+TYPE_SPELL) and c:IsSSetable()
end
function c22240.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.IsExistingMatchingCard(c22240.ssfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c22240.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22240.ssfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22240.immcon(e)
	return Duel.IsExistingMatchingCard(c22240.cfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c22240.cfilter(c)
	return c:IsSetCard(0x184) and c:IsFaceup() and c:IsType(TYPE_CONTINUOUS+TYPE_SPELL)
end
function c22240.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return te:IsActiveType(TYPE_MONSTER) and te:IsPosition(POS_DEFENSE) and te:GetOwner()~=e:GetOwner() end
end