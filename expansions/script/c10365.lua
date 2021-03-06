--魔炮『究极火花』
function c10365.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10365.con1)
	e1:SetTarget(c10365.tg1)
	e1:SetOperation(c10365.op1)
	c:RegisterEffect(e1)
	--
	if not c10365.gchk then
		c10365.gchk=true
		c10365[0]=3
		c10365[1]=3
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetCondition(c10365.con2)
		e2:SetOperation(c10365.op2)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetCountLimit(1)
		e3:SetOperation(c10365.clear3)
		Duel.RegisterEffect(e3,0)
	end 
end
function c10365.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10366)>0
end
function c10365.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=c:GetColumnGroup()
	local sg=g:Filter(Card.IsControler,nil,1-tp)
		local num=sg:GetCount()*1000+2000
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,num)
end
function c10365.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	local sg=g:Filter(Card.IsControler,nil,1-tp)
	local ct=Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
		local num=ct*1000+2000
		if Duel.Damage(1-tp,num,REASON_EFFECT)<1 then return end
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD)
		e1_1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_1:SetTargetRange(0,1)
		e1_1:SetValue(1)
		e1_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
end
function c10365.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND)
end
function c10365.op2(e,tp,eg,ep,ev,re,r,rp)
	local rg=eg:Filter(Card.IsControler,nil,tp)
	if rg:GetCount()>1 then eg:Sub(rg) end
	local num1=rg:GetCount()
	local num2=eg:GetCount()
	while num1>0 do
		if c10365[tp]<=1 then 
			Duel.RegisterFlagEffect(tp,10366,RESET_PHASE+PHASE_END,0,1)
		else
			c10365[tp]=c10365[tp]-1
		end
		num1=num1-1
	end
	while num2>0 do
		if c10365[1-tp]<=1 then 
			Duel.RegisterFlagEffect(1-tp,10366,RESET_PHASE+PHASE_END,0,1)
		else
			c10365[1-tp]=c10365[1-tp]-1
		end
		num2=num2-1
	end
end
function c10365.clear3(e,tp,eg,ep,ev,re,r,rp)
	c10365[0]=3
	c10365[1]=3
end
