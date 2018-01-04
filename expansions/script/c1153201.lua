--暗符『月的阴暗面』
function c1153201.initial_effect(c)
--
	c:SetUniqueOnField(1,1,1153201)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(c1153201.con1)
	c:RegisterEffect(e1)  
--  
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c1153201.tg2)
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+1153201)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c1153201.tg4)
	e4:SetOperation(c1153201.op4)
	c:RegisterEffect(e4)
--
	if not c1153201.gchk then
		c1153201.gchk=true
		c1153201[0]=3
		c1153201[1]=3
		c1153201[2]=3
		local e5=Effect.GlobalEffect()
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_SPSUMMON_SUCCESS)
		e5:SetCondition(c1153201.con5)
		e5:SetOperation(c1153201.op5)
		Duel.RegisterEffect(e5,0)
	end
--
end
--
function c1153201.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x110) and c:IsType(TYPE_MONSTER)
end
function c1153201.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
--
function c1153201.tg2(e,c)
	return c:IsSetCard(0x110) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
--
c1153201.count_available=1153201
--
function c1153201.f(c)
	return c.count_available==1153201 and c:IsFaceup()
end
function c1153201.con5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1153201.f,rp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
--
function c1153201.op5(e,tp,eg,ep,ev,re,r,rp)
	if c1153201[rp]<=1 then
		c1153201[rp]=3
		Duel.RaiseEvent(eg,EVENT_CUSTOM+1153201,re,r,rp,ep,ev)
	else
		c1153201[rp]=c1153201[rp]-1
	end
end
--
function c1153201.filter4(c)
	return c:IsFaceup()
end
function c1153201.tfilter4(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c1153201.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1153201.filter4,1,nil) end
	local g=eg:Filter(c1153201.filter4,nil)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
--
function c1153201.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c1153201.tfilter4,nil,e)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		local tc=g:GetFirst()
		while tc do
			if tc:IsFaceup() then
				local e2_1=Effect.CreateEffect(e:GetHandler())
				e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_1:SetType(EFFECT_TYPE_SINGLE)
				e2_1:SetCode(EFFECT_CANNOT_TRIGGER)
				e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_1)
				local e2_2=Effect.CreateEffect(e:GetHandler())
				e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_2:SetType(EFFECT_TYPE_SINGLE)
				e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2_2:SetCode(EFFECT_DISABLE)
				e2_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_2)
				local e2_3=Effect.CreateEffect(e:GetHandler())
				e2_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_3:SetType(EFFECT_TYPE_SINGLE)
				e2_3:SetCode(EFFECT_DISABLE_EFFECT)
				e2_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_3)
				local e2_4=Effect.CreateEffect(e:GetHandler())
				e2_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_4:SetType(EFFECT_TYPE_SINGLE)
				e2_4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e2_4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_4)
				local e2_5=Effect.CreateEffect(e:GetHandler())
				e2_5:SetType(EFFECT_TYPE_SINGLE)
				e2_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_5:SetCode(EFFECT_CANNOT_ATTACK)
				e2_5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_5)
				local e2_6=Effect.CreateEffect(e:GetHandler())
				e2_6:SetType(EFFECT_TYPE_SINGLE)
				e2_6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				e2_6:SetValue(1)
				e2_6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_6)   
				local e2_7=Effect.CreateEffect(e:GetHandler())
				e2_7:SetType(EFFECT_TYPE_SINGLE)
				e2_7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				e2_7:SetValue(1)
				e2_7:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_7)
				local e2_8=Effect.CreateEffect(e:GetHandler())
				e2_8:SetType(EFFECT_TYPE_SINGLE)
				e2_8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				e2_8:SetValue(1)
				e2_8:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_8)
				local e2_9=Effect.CreateEffect(e:GetHandler())
				e2_9:SetType(EFFECT_TYPE_SINGLE)
				e2_9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_9:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				e2_9:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_9) 
				local e2_10=Effect.CreateEffect(e:GetHandler())
				e2_10:SetType(EFFECT_TYPE_SINGLE)
				e2_10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e2_10:SetValue(1)
				e2_10:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
				tc:RegisterEffect(e2_10)
			end
			tc=g:GetNext()
		end
		local Lp=Duel.GetLP(tp)
		Duel.SetLP(tp,Lp-1000)
	end
end
--