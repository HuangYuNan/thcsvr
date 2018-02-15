--白狼与天狗的连结✿犬走椛
function c23507.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c23507.matfilter,2,2)
	c:EnableReviveLimit()
	--sm
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetCondition(c23507.condition)
	e3:SetTarget(c23507.target)
	e3:SetOperation(c23507.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23507,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,23507)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c23507.cost)
	e1:SetTarget(c23507.sptg)
	e1:SetOperation(c23507.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c23507.incon)
	e2:SetTarget(c23507.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c23507.matfilter(c)
	return c:GetLevel()==4 and c:IsSetCard(0x208)
end
function c23507.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function c23507.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(23507,RESET_EVENT+0x1fe0000,0,0)
end
function c23507.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,23507)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(c23507.filter))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,23507,RESET_PHASE+PHASE_END,0,1)
end
function c23507.filter(c)
	return c:IsRace(RACE_BEAST+RACE_WINDBEAST+RACE_BEASTWARRIOR)
end
function c23507.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c23507.spfilter(c,e,tp)
	return c:IsRace(RACE_BEAST+RACE_WINDBEAST+RACE_BEASTWARRIOR) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c23507.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c23507.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c23507.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c23507.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(23508,RESET_EVENT+0x1fe0000,0,0)
end
function c23507.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c23507.incon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(23507)>0 and c:GetFlagEffect(23508)>0
end
function c23507.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) or c==e:GetHandler()
end
