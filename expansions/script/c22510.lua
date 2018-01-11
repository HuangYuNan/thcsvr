--湖与冰的连结✿琪露诺
function c22510.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c22510.matfilter,1,1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22510)
	e1:SetTarget(c22510.thtg)
	e1:SetOperation(c22510.thop)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c22510.incon)
	e3:SetTarget(c22510.indtg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c22510.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN) and c:GetDefense()==900
end
function c22510.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
end
function c22510.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0x33,0x33,nil):RandomSelect(tp,5,false)
	if g:RandomSelect(tp,1,false):IsContains(g:GetFirst()) then
		Duel.Hint(11,0,aux.Stringid(22510,4))
	end
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetOperation(c22510.disop)
	c:RegisterEffect(e2)
end
function c22510.disop(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
	return dis1
end
function c22510.incon(e)
	local c=e:GetHandler()
	return c:IsLinkState()
end
function c22510.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) or c==e:GetHandler()
end
