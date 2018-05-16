--奇妙的魔女✿雾雨魔理沙
function c10350.initial_effect(c)
	--
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10350,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c10350.condition)
	e1:SetCost(c10350.cost)
	e1:SetTarget(c10350.target)
	e1:SetOperation(c10350.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c10350.val)
	c:RegisterEffect(e2) 
	--eqiup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10350,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c10350.cost1)
	e3:SetTarget(c10350.target1)
	e3:SetOperation(c10350.operation1)
	c:RegisterEffect(e3)
end
function c10350.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c10350.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10350.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetDecktopGroup(1-tp,1)
	if chk==0 then return sg:GetCount()>0 and sg:GetFirst():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function c10350.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end
function c10350.sfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c10350.val(e,c)
	local num1=Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_SPELL)*100
	local num2=c:GetOverlayCount()*200
	local num3=Duel.GetMatchingGroupCount(c10350.sfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())*300
	local num4=c:GetEquipCount()*400
	return num1+num2+num3+num4
end
function c10350.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c10350.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10350.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10350.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10350.tfilter1(c,mls)
	return (c:IsType(TYPE_MONSTER) and c:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetEquipTarget()~=mls
end
function c10350.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToChangeControler() end
	if chk==0 then
		local c=e:GetHandler() 
		return Duel.IsExistingTarget(c10350.tfilter1,tp,0,LOCATION_ONFIELD,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c10350.tfilter1,tp,0,LOCATION_ONFIELD,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c10350.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10350.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.Equip(tp,tc,c,false) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c10350.eqlimit)
			tc:RegisterEffect(e1)
			if tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP) then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetCode(EFFECT_CANNOT_TRIGGER)
				e2:SetRange(LOCATION_SZONE)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			end
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
