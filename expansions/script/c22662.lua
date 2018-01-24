--大恶魔召唤士·拉比丝
function c22662.initial_effect(c)
	c:SetUniqueOnField(1,0,22662)
	c:EnableUnsummonable()
	--fiend
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
		return se:GetHandler():IsSetCard(0x221) end)
	c:RegisterEffect(e1)
	--hyper magic resistance
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c22662.efilter)
	c:RegisterEffect(e3)
	--fiend summoner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c22662.condition)
	e4:SetOperation(c22662.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--fiend summon & awaken skill
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22662,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckLPCost(tp,700)
		else Duel.PayLPCost(tp,700) end
	end)
	e7:SetTarget(c22662.destg)
	e7:SetOperation(c22662.desop)
	c:RegisterEffect(e7)
	Nef.RegisterBigFiendEffect(c,e7)
end
function c22662.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c22662.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22662.tpfilter,1,nil,tp)
end
function c22662.tpfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c22662.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local dmg=300
	if e:GetHandler():GetFlagEffect(22662)>0 then dmg=300 end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-dmg)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-dmg)
end
function c22662.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22665,0x222,0x4011,1800,1100,7,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22662.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,22665,0x222,0x4011,1800,1100,7,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,22665)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
		--local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		-- for tc in aux.Next(g) do
		-- 	local atk=tc:GetTextAttack()*1.5-tc:GetAttack()
		-- 	if atk<=0 then atk=0 end
		-- 	local e1=Effect.CreateEffect(e:GetHandler())
		-- 	e1:SetType(EFFECT_TYPE_SINGLE)
		-- 	e1:SetCode(EFFECT_UPDATE_ATTACK)
		-- 	e1:SetValue(atk)
		-- 	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		-- 	tc:RegisterEffect(e1)
		-- end
		e:GetHandler():RegisterFlagEffect(22662,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
	end
end
