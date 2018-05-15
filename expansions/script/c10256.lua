--妖器『无慈悲的驱魔棒』
function c10256.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10256.tg1)
	e1:SetOperation(c10256.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10256,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10256.tg3)
	e3:SetOperation(c10256.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10256,1))
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c10256.cost4)
	e4:SetTarget(c10256.tg4)
	e4:SetOperation(c10256.op4)
	c:RegisterEffect(e4)
--
end
--
function c10256.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
--
function c10256.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if not tc:IsFaceup() then return end
	Duel.Equip(tp,c,tc)
end
--
function c10256.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if chk==0 then return tc and tc:GetLevel()>0 end
end
--
function c10256.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if tc then
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1:SetCode(EFFECT_UPDATE_LEVEL)
		e3_1:SetValue(1)
		e3_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_1)
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2:SetCode(EFFECT_UPDATE_ATTACK)
		e3_2:SetValue(100)
		e3_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_2)
	end
end
--
function c10256.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
--
function c10256.tfilter(c)
	return c:GetLevel()>0 and c:GetLevel()<3 and c:IsFaceup()
end
function c10256.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c10256.tfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
--
function c10256.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local sg=Duel.GetMatchingGroup(c10256.tfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	g:Sub(sg)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local e4_1=Effect.CreateEffect(c)
		e4_1:SetType(EFFECT_TYPE_SINGLE)
		e4_1:SetCode(EFFECT_UPDATE_DEFENSE)
		e4_1:SetValue(-500)
		e4_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4_1)
		local e4_2=Effect.CreateEffect(c)
		e4_2:SetType(EFFECT_TYPE_SINGLE)
		e4_2:SetCode(EFFECT_UPDATE_ATTACK)
		e4_2:SetValue(-500)
		e4_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4_2)
		tc=g:GetNext()
	end
end
--



