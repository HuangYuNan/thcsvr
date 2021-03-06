--昏暗洞窟中明亮的网
function c1156019.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156019.lkcheck,1,1)
--
	c:SetSPSummonOnce(1156019)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1156019.con1)
	e1:SetOperation(c1156019.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1156019.tg2)
	e2:SetOperation(c1156019.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1156019.tg3)
	c:RegisterEffect(e3)
--
end
--
function c1156019.lkcheck(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_DARK)
end
--
function c1156019.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsHasType(EFFECT_TYPE_FLIP) or re:IsHasType(EFFECT_TYPE_IGNITION) or re:IsHasType(EFFECT_TYPE_QUICK_F) or re:IsHasType(EFFECT_TYPE_QUICK_O) or re:IsHasType(EFFECT_TYPE_TRIGGER_F) or re:IsHasType(EFFECT_TYPE_TRIGGER_O)) and Duel.IsPlayerCanSpecialSummonMonster(tp,24063,0,0x4011,0,0,1,RACE_INSECT,ATTRIBUTE_DARK) and e:GetHandler():GetSequence()>=5 end
end
--
function c1156019.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1156019)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft1==0 and ft2==0 then return end
	local token=Duel.CreateToken(tp,24063)
	local s1=ft1>0 and token:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=ft2>0 and token:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(1156019,2),aux.Stringid(1156019,3))
	elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(1156019,2))
	elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(1156019,3))+1
	else op=2 end
	local num=0
	if op==0 then 
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then   
			local e2_1=Effect.CreateEffect(e:GetHandler())
			e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e2_1:SetValue(1)
			e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			token:RegisterEffect(e2_1,true)
			local e2_2=Effect.CreateEffect(e:GetHandler())
			e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2_2:SetType(EFFECT_TYPE_SINGLE)
			e2_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e2_2:SetValue(1)
			e2_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			token:RegisterEffect(e2_2,true) 
		end
	elseif op==1 then 
		if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)~=0 then   
			local e2_1=Effect.CreateEffect(e:GetHandler())
			e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e2_1:SetValue(1)
			e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			token:RegisterEffect(e2_1,true)
			local e2_2=Effect.CreateEffect(e:GetHandler())
			e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2_2:SetType(EFFECT_TYPE_SINGLE)
			e2_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e2_2:SetValue(1)
			e2_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			token:RegisterEffect(e2_2,true)
		end
	end
end
--
function c1156019.tfilter3_2(c)
	return c:IsFaceup() and c:IsCode(24063) and c:IsReleasable()
end
function c1156019.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1156019.tfilter3_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(1156019,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156019,1))
		local g=Duel.SelectMatchingCard(tp,c1156019.tfilter3_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_CARD,0,1156019)
			Duel.Release(g,REASON_EFFECT)
			return true
		end
	else
		return false
	end
end
--
function c1156019.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x164)
end
--
function c1156019.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1156019)
	local Lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,Lp-300)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_UPDATE_ATTACK)
		e1_1:SetValue(300)
		e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1_1)
	end
end
--
