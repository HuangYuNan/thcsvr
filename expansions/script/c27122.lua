--番町！摔碟的尸解仙✿物部布都
function c27122.initial_effect(c)
--
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x119)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c27122.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27122,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c27122.cost2)
	e2:SetTarget(c27122.tg2)
	e2:SetOperation(c27122.op2)
	c:RegisterEffect(e2)	
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c27122.con3)
	e3:SetOperation(c27122.op3)
	c:RegisterEffect(e3)
--
end
--
function c27122.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1)<1 then return end
	local rc=re:GetHandler()
	if not (rc:IsType(TYPE_RITUAL) or rc:IsType(TYPE_FIELD)) then return end
	c:AddCounter(0x119,2)
end
--
function c27122.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x119,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x119,5,REASON_COST)
end
--
function c27122.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
--
function c27122.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Destroy(tc,REASON_EFFECT)
end
--
function c27122.cfilter3(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() 
		and c:GetCounter(0x119)>4
end
function c27122.con3(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c27122.cfilter3,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
--
function c27122.op3(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,c27122.cfilter3,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_COST)
end
--