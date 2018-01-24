--彼岸散华✿小町&亚玛萨那度
function c25504.initial_effect(c)
	--link summon
	Nef.AddLinkProcedureWithDesc(c,aux.FilterBoolFunction(Card.IsType,TYPE_LINK),2,6,nil,aux.Stringid(25504,0))
	c:EnableReviveLimit()
	--link summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetDescription(aux.Stringid(25504,1))
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c25504.lkcon)
	e0:SetOperation(c25504.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--linken effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c25504.tgtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c25504.tgtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--cannot activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c25504.con)
	e5:SetValue(c25504.actlimit)
	c:RegisterEffect(e5)
end
function c25504.lkfilter(c,lc)
	return c:IsSetCard(0x114) and c:GetLevel()==6 and c:IsAbleToRemove() and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0
end
function c25504.mdfilter(c)
	return c:IsSetCard(0x740) and c:IsAbleToRemove()
end
function c25504.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c25504.lkfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:GetCount()>0 and Duel.IsExistingMatchingCard(c25504.mdfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c25504.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c25504.lkfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=mg:Select(tp,1,1,nil)
	local g=Duel.SelectMatchingCard(tp,c25504.mdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	sg:Merge(g)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c25504.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c25504.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c25504.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c25504.actlimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER)
end
function c25504.splimit(e,c,tp,sumtp,sumpos)
	return c:GetType()==TYPE_LINK
end
