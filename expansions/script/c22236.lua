--奥法魔女✿帕秋莉·诺蕾姬
function c22236.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fus.AddFusionProcFunMulti(c,true,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),
	c22236.mfilter1)	
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22236,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,22236)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c22236.tg1)
	e1:SetOperation(c22236.op1)
	c:RegisterEffect(e1)   
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22236,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c22236.condition)
	e4:SetTarget(c22236.tg2)
	e4:SetOperation(c22236.op2)
	c:RegisterEffect(e4) 
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetCondition(c22236.con2)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(400)
	c:RegisterEffect(e5)
end
function c22236.mfilter1(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c22236.thfilter1(c)
	return c:IsSetCard(0x185) and c:IsAbleToHand()
end
function c22236.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22236.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22236.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22236.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22236.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x181) and rc:IsType(TYPE_CONTINUOUS+TYPE_SPELL)
end
function c22236.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp end
end
function c22236.op2(e,tp,eg,ep,ev,re,r,rp)
	local at=e:GetHandler():GetDefense()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(at/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,3)
		c:RegisterEffect(e1)
	end
end
function c22236.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22236.cfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c22236.cfilter(c)
	return c:IsSetCard(0x182) and c:IsFaceup() and c:IsType(TYPE_CONTINUOUS+TYPE_SPELL)
end