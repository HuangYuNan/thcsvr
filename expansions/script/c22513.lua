--夜与妖的连结✿露米娅
function c22513.initial_effect(c)
	--link summon
	Nef.AddLinkProcedureWithDesc(c,c22513.matfilter,2,2,nil,aux.Stringid(22513,0))
	c:EnableReviveLimit()
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(22513,1))
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22513.lkcon)
	e1:SetOperation(c22513.lkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c22513.mtcon)
	e2:SetOperation(c22513.mtop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c22513.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c22513.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN)
end
function c22513.lkfilter(c,lc)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsType(TYPE_EFFECT) and c:GetBaseAttack()<=1000 and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0
end
function c22513.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c22513.lkfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:GetCount()>0
end
function c22513.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c22513.lkfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local sg=mg:Select(tp,1,1,nil)
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+0xff0000)
	e2:SetValue(LINK_MARKER_BOTTOM)
	c:RegisterEffect(e2)
end
function c22513.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:GetCount()
	e:GetLabelObject():SetLabel(ct)
end
function c22513.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()>0
end
function c22513.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(ct*1000)
	c:RegisterEffect(e1)
end
