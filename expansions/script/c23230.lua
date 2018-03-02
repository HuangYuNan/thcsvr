--寒冬天狗✿犬走椛
function c23230.initial_effect(c)
	--xyz +
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23230,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,23230)
	e1:SetTarget(c23230.target)
	e1:SetOperation(c23230.operation)
	c:RegisterEffect(e1)
	--windbot
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23230,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,23231)
	e2:SetTarget(c23230.tg)
	e2:SetOperation(c23230.op)
	c:RegisterEffect(e2)
	--xyz +-
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetCondition(c23230.condition)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(500)
	e4:SetCondition(c23230.condition)
	c:RegisterEffect(e4)
end
function c23230.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_WINDBEAST+RACE_BEAST+RACE_BEASTWARRIOR)
end
function c23230.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c23230.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c23230.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c23230.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c23230.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	Duel.Overlay(tc,Group.FromCards(c))
end
function c23230.tgfilter(c)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR) and c:IsAbleToGrave()
end
function c23230.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23230.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c23230.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23230.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c23230.condition(e)
	return e:GetHandler():GetRace()==RACE_BEASTWARRIOR
end
