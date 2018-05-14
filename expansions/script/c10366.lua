--魔炮『超究极火花』
function c10366.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10366.con1)
	e1:SetTarget(c10366.tg1)
	e1:SetOperation(c10366.op1)
	c:RegisterEffect(e1)
	--
	if not c10366.gchk then
		c10366.gchk=true
		c10366[0]=4
		c10366[1]=4
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetCondition(c10366.con2)
		e2:SetOperation(c10366.op2)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetCountLimit(1)
		e3:SetOperation(c10366.clear3)
		Duel.RegisterEffect(e3,0)
	end 
end
function c10366.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x200)
end
function c10366.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10366)>0 and Duel.IsExistingMatchingCard(c10366.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c10366.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=c:GetColumnGroup()
	local sg=g:Filter(Card.IsControler,nil,1-tp)
		local num=sg:GetCount()*2000+3000
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,num)
end
function c10366.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	local sg=g:Filter(Card.IsControler,nil,1-tp)
	local ct=Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
		local num=ct*2000+3000
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
function c10366.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND)
end
function c10366.op2(e,tp,eg,ep,ev,re,r,rp)
	local rg=eg:Filter(Card.IsControler,nil,tp)
	if rg:GetCount()>1 then eg:Sub(rg) end
	local num1=rg:GetCount()
	local num2=eg:GetCount()
	while num1>0 do
		if c10366[tp]<=1 then 
			Duel.RegisterFlagEffect(tp,10366,RESET_PHASE+PHASE_END,0,1)
		else
			c10366[tp]=c10366[tp]-1
		end
		num1=num1-1
	end
	while num2>0 do
		if c10366[1-tp]<=1 then 
			Duel.RegisterFlagEffect(1-tp,10366,RESET_PHASE+PHASE_END,0,1)
		else
			c10366[1-tp]=c10366[1-tp]-1
		end
		num2=num2-1
	end
end
function c10366.clear3(e,tp,eg,ep,ev,re,r,rp)
	c10366[0]=4
	c10366[1]=4
end

