--疏与密的连接✿伊吹萃香
local M = c999721
local Mid = 999721
function M.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c, aux.FilterBoolFunction(Card.IsSetCard, 0xaa5), 2, 2)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1, Mid*10+1)
	e1:SetCondition(M.spcon)
	e1:SetTarget(M.sptg)
	e1:SetOperation(M.spop)
	c:RegisterEffect(e1)

	-- spilt & concat
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, Mid*10+2)
	e2:SetTarget(M.mvtg)
	e2:SetOperation(M.mvop)
	c:RegisterEffect(e2)
end

--
function M.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function M.filter(c,e,tp)
	return c:IsSetCard(0xaa5) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP_DEFENSE)
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 1
		and Duel.IsExistingTarget(M.filter, tp, LOCATION_GRAVE, 0, 2, nil, e, tp) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, M.filter, tp, LOCATION_GRAVE, 0, 2, 2, nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 2, 0, 0)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return end
	local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	local sg = g:Filter(Card.IsRelateToEffect, nil, e)
	Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP_DEFENSE)

	local c = e:GetHandler()
	local tc = sg:GetFirst()
	while tc do
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		tc:RegisterEffect(e1, true)
		tc = sg:GetNext()
	end

	local e2 = Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1, 0)
	e2:SetTarget(M.splimit)
	Duel.RegisterEffect(e2, tp)
end

function M.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_LINK)
end

-- 
function M.isInMainMzone(c)
	return c:GetSequence() < 5
end

function M.movefilter(c)
	local tp = c:GetControler()
	local seq = c:GetSequence()
	local isAbleToLeft = seq > 0 and Duel.CheckLocation(tp, LOCATION_MZONE, seq-1)
	local isAbleToRight = seq < 4 and Duel.CheckLocation(tp, LOCATION_MZONE, seq+1)
	return seq < 5 and (isAbleToLeft or isAbleToRight)
end

function M.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then 
		return chkc:IsLocation(LOCATION_MZONE) and M.isInMainMzone(chkc) 
	end

	local g1 = Duel.GetMatchingGroup(M.isInMainMzone, tp, LOCATION_MZONE, 0, nil)
	local g2 = Duel.GetMatchingGroup(M.isInMainMzone, tp, 0, LOCATION_MZONE, nil)

	local flag1 = g1:GetCount() > 1 and Duel.IsExistingTarget(M.movefilter, tp, LOCATION_MZONE, 0, 1, nil) 
	local flag2 = g2:GetCount() > 1 and Duel.IsExistingTarget(M.movefilter, tp, 0, LOCATION_MZONE, 1, nil) 
	
	if chk == 0 then return flag1 or flag2 end

	local loc1 = flag1 and LOCATION_MZONE or 0
	local loc2 = flag2 and LOCATION_MZONE or 0

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, M.movefilter, tp, loc1, loc2, 1, 1, nil)
end

function M.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end

	local p = tc:GetControler()
	local seq = tc:GetSequence()
	if seq > 4 then return end

	local isAbleToLeft = seq > 0 and Duel.CheckLocation(p, LOCATION_MZONE, seq-1)
	local isAbleToRight = seq < 4 and Duel.CheckLocation(p, LOCATION_MZONE, seq+1)
	if isAbleToLeft or isAbleToRight then
		local flag = 0

		if isAbleToLeft then 
			flag = flag | (1 << (seq-1))
		end
		if isAbleToRight then 
			flag = flag | (1 << (seq+1))
		end

		flag = flag ~ 0xff

		local s = 0

		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
		if tc:IsControler(tp) then
			s = Duel.SelectDisableField(tp, 1, LOCATION_MZONE, 0, flag)
		else
			flag = flag * 0x10000
			s = Duel.SelectDisableField(tp, 1, 0, LOCATION_MZONE, flag) / 0x10000
		end
		
		local nseq = 0
		while s > 1 do
			s = s >> 1
			nseq = nseq + 1
		end

		Duel.MoveSequence(tc, nseq)
		--
		Duel.BreakEffect()
		--
		local isHasCardOnLeft = nseq > 0 and not Duel.CheckLocation(p, LOCATION_MZONE, nseq-1) 
		local isHasCardOnRight = nseq < 4 and not Duel.CheckLocation(p, LOCATION_MZONE, nseq+1)
		if isHasCardOnLeft or isHasCardOnRight then
			Duel.Draw(tp, 1, REASON_EFFECT)
		else
			Duel.Destroy(tc, REASON_EFFECT)
		end
	end
end