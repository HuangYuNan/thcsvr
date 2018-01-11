--崭新的山彦✿幽谷响子
function c27504.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c27504.matfilter,1)
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27504,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c27504.xyzcon)
	e3:SetOperation(c27504.xyzop)
	c:RegisterEffect(e3)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27504,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c27504.target)
	e2:SetOperation(c27504.operation)
	c:RegisterEffect(e2)
end
function c27504.matfilter(c)
	return c:IsType(TYPE_EFFECT) and (c:GetLevel()==2 or c:GetRank()==2)
end
function c27504.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsType(TYPE_XYZ)
end
function c27504.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c27504.cfilter,nil,tp)==1
end
function c27504.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(c27504.cfilter,nil,tp):GetFirst()
	if tc then
		Duel.Overlay(tc,Group.FromCards(e:GetHandler()))
	end
end
function c27504.thfilter(c)
	return (c:IsSetCard(0x527a) or c:IsSetCard(0x527b)) and c:IsAbleToHand()
end
function c27504.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27504.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27504.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27504.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27504.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetTarget(c27504.splimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c27504.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
