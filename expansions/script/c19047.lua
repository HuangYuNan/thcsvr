--旧地狱的鬼火巫女✿火焰猫燐
function c19047.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),aux.FilterBoolFunction(Card.IsFusionSetCard,0x115),true)  
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetLabel(0)
	e1:SetCountLimit(1,19047)
	e1:SetCost(c19047.cost1)
	e1:SetCondition(c19047.con1)
	e1:SetTarget(c19047.tg1)
	e1:SetOperation(c19047.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19048)
	e2:SetCondition(c19047.con2)
	e2:SetOperation(c19047.op2)
	c:RegisterEffect(e2)
end
c19047.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x115),
}
function c19047.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c19047.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c19047.con1(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c19047.cfilter1,nil)
	return sg:GetCount()==1
end
function c19047.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=eg:Filter(c19047.cfilter1,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and sg:GetCount()==1
			and sg:GetFirst():IsAbleToRemoveAsCost()
			and c~=sg:GetFirst()
	end
	e:SetLabel(0)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19047.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local sg=e:GetLabelObject()
	if sg and sg:GetCount()>0 then
		if sg:GetFirst():IsRace(RACE_ZOMBIE) then
			Duel.Damage(1-tp,1500,REASON_EFFECT)
		end
	end
end
function c19047.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
		and re 
		and re:IsActiveType(TYPE_MONSTER) 
		and re:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
		and re:GetHandler():IsControler(tp)
		and bit.band(r,REASON_EFFECT)~=0
		and Duel.GetCurrentPhase()==PHASE_END
		and re:IsHasType(EFFECT_TYPE_ACTIONS) 
		and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c19047.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,19047)
	Duel.Damage(1-tp,ev,REASON_EFFECT)
end