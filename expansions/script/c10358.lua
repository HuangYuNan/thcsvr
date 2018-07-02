--恋符『广域极限火花』
function c10358.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10358.con1)
	e1:SetTarget(c10358.target)
	e1:SetOperation(c10358.op1)
	c:RegisterEffect(e1)
	if not c10358.gchk then
		c10358.gchk=true
		c10358[0]=3
		c10358[1]=3
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetCondition(c10358.con2)
		e2:SetOperation(c10358.op2)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetCountLimit(1)
		e3:SetOperation(c10358.clear3)
		Duel.RegisterEffect(e3,0)
	end
end
function c10358.cfilter1(c)
	return c:IsSetCard(0x200) and c:IsFaceup()
end
function c10358.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10358)>0 and Duel.IsExistingMatchingCard(c10358.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c10358.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c10358.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	local g=Duel.Destroy(sg,REASON_EFFECT)
	if Duel.Damage(1-tp,g*200,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10358.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsPreviousLocation(LOCATION_HAND)
end
function c10358.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10358.cfilter,1,nil)
end
function c10358.op2(e,tp,eg,ep,ev,re,r,rp)
	local fg=eg:Filter(c10358.cfilter,nil)
	local rg=fg:Filter(Card.IsControler,nil,tp)
	if rg:GetCount()>1 then eg:Sub(rg) end
	local num1=rg:GetCount()
	local num2=fg:GetCount()
	while num1>0 do
		if c10358[tp]<=1 then 
			Duel.RegisterFlagEffect(tp,10358,RESET_PHASE+PHASE_END,0,1)
		else
			c10358[tp]=c10358[tp]-1
		end
		num1=num1-1
	end
	while num2>0 do
		if c10358[1-tp]<=1 then 
			Duel.RegisterFlagEffect(1-tp,10358,RESET_PHASE+PHASE_END,0,1)
		else
			c10358[1-tp]=c10358[1-tp]-1
		end
		num2=num2-1
	end
end
function c10358.clear3(e,tp,eg,ep,ev,re,r,rp)
	c10358[0]=3
	c10358[1]=3
end
