--女神大人-赫斯缇雅
function c70100.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c70100.matfilter,1,1)
	c:EnableReviveLimit()
	--ad+
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c70100.indtg)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--三倍linkcreeeeeeeam
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70100,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c70100.drcon)
	e4:SetTarget(c70100.target)
	e4:SetOperation(c70100.operation)
	c:RegisterEffect(e4)
end
function c70100.matfilter(c)
	return not c:IsLinkType(TYPE_LINK) and c:IsSetCard(0x149)
end
function c70100.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c70100.cfilter(c)
	return c:IsLinkType(TYPE_LINK) and not c:IsCode(70100)
end
function c70100.filter(c)
	return c:IsSetCard(0x149) and c:IsAbleToGrave()
end
function c70100.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and not Duel.IsExistingMatchingCard(c70100.cfilter,tp,LOCATION_EXTEA,0,1,nil)
end
function c70100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c70100.filter,tp,LOCATION_EXTRA,0,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c70100.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(c70100.filter,tp,LOCATION_EXTRA,0,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
		local sg=Duel.SelectMatchingCard(tp,c70100.filter,tp,LOCATION_EXTRA,0,1,2,nil)
		local ct=sg:GetCount()
		Duel.SendtoGrave(sg,REASON_EFFECT)
		if c:IsRelateToEffect(e) then
			if ct>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e2:SetRange(LOCATION_MZONE)
				e2:SetReset(RESET_EVENT+0xff0000)
				e2:SetValue(LINK_MARKER_BOTTOM_LEFT)
				c:RegisterEffect(e2)
			end
			if ct==2 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e2:SetRange(LOCATION_MZONE)
				e2:SetReset(RESET_EVENT+0xff0000)
				e2:SetValue(LINK_MARKER_BOTTOM_RIGHT)
				c:RegisterEffect(e2)
			end
		end
	end
end
