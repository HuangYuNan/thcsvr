--八卦炉
function c10330.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10330.target)
	e1:SetOperation(c10330.operation)
	c:RegisterEffect(e1)
	--dmg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(c10330.con)
	e2:SetOperation(c10330.op)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c10330.eqlimit)
	c:RegisterEffect(e3)
	--Atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(100)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_ONFIELD)
	e5:SetCondition(c10330.dcon)
	e5:SetTarget(c10330.disable)
	e5:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e5)
end
function c10330.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x200)
end
function c10330.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10330.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10330.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10330.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10330.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c10330.con(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_EFFECT and ep~=tp and re:GetHandler():IsSetCard(0x2022)
end
function c10330.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10330)
	Duel.Damage(1-tp,800,REASON_EFFECT)
end
function c10330.eqlimit(e,c)
	return c:IsSetCard(0x200)
end
function c10330.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2022)
end
function c10330.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10330.cfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c10330.disable(e,c)
	return not c:IsType(TYPE_NORMAL)
end
