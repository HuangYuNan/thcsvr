--龙鱼『龙宫使的游泳弹』
local M = c999109
local Mid = 999109
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK, 0x11e0)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)

	-- sp
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(M.spcost)
	e4:SetTarget(M.sptg)
	e4:SetOperation(M.spop)
	c:RegisterEffect(e4)
end
--
function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, e:GetHandler()) 
	end
	Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST+REASON_DISCARD)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsType(TYPE_MONSTER) and chkc:IsOnField() and chkc ~= e:GetHandler() end
	if chk == 0 then return Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, e:GetHandler())
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g = nil
		if tc:IsType(TYPE_LINK) then
			g = Nef.GetLinkArrowGroup(tc)
		end
		if Duel.Destroy(tc, REASON_EFFECT) > 0 and g and g:GetCount() > 0 then
			local dg = g:Filter(Card.IsDestructable, tc)
			if dg:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(Mid, 1)) then
				local sg = dg:Select(tp, 1, 1, tc)
				Duel.Destroy(sg, REASON_EFFECT)
			end
		end
	end
end

--
function M.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, e:GetHandler()) 
			and e:GetHandler():IsAbleToRemoveAsCost()
	end
	Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST+REASON_DISCARD)
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function M.spfilter(c, e, tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x190)
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON, nil, 1, 0, 0)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil, e, tp) then
		local sc = Duel.SelectMatchingCard(tp, M.spfilter, tp, LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
		Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP)
	end
end