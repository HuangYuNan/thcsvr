--彩符『彩光风铃』
local M = c999110
local Mid = 999110
function M.initial_effect(c)
	-- sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetCategory(CATEGORY_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(M.spcon)
	e1:SetTarget(M.sptg)
	e1:SetOperation(M.spop)
	c:RegisterEffect(e1)

	-- to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetCategory(CATEGORY_SPSUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(M.tdcon)
	e2:SetTarget(M.tdtg)
	e2:SetOperation(M.tdop)
	c:RegisterEffect(e2)

	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetDescription(aux.Stringid(Mid, 2))
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(M.protg)
	e3:SetValue(M.provalue)
	e3:SetOperation(M.proop)
	c:RegisterEffect(e3)
end
--
function M.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp ~= Duel.GetTurnPlayer() 
end

function M.spfilter(c, e, tp)
	return c:IsSetCard(0x810) and c:IsType(TYPE_MONSTER) 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP_ATTACK)
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk == 0 then 
		return Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil, e, tp) 
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, 0, 0)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, M.spfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
	if g:GetCount() == 0 then return end
	Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP_ATTACK)

	local tc = g:GetFirst()
	if not tc:IsOnField() then return end
	Duel.ChangeAttackTarget(tc)

	Duel.BreakEffect()
	local c = e:GetHandler()
	c:CancelToGrave()
	Duel.SendtoDeck(c, nil, 2, REASON_EFFECT)
end

--
function M.filter(c)
	return c:IsSetCard(0x810) and c:IsType(TYPE_MONSTER)
end

function M.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return tp == Duel.GetTurnPlayer() 
		and (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2)
end

function M.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk == 0 then 
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, 0, LOCATION_SZONE, 1, nil) 
	end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 0, 0)
end

function M.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, 0, LOCATION_SZONE, 1, nil) then
		local count = Duel.GetMatchingGroupCount(M.filter, tp, LOCATION_GRAVE, 0, nil) + 1
		local g = Duel.SelectMatchingCard(tp, Card.IsAbleToDeck, tp, 0, LOCATION_SZONE, 1, count, nil)
		Duel.SendtoDeck(g, nil, 1, REASON_EFFECT)
	end
end

--
function M.repfilter(c, tp)
	return c:IsFaceup() and c:IsSetCard(0x810) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end

function M.protg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		return e:GetHandler():IsAbleToRemove() 
			and eg:IsExists(M.repfilter, 1, nil, tp) 
	end
	return Duel.SelectEffectYesNo(tp, e:GetHandler(), aux.Stringid(Mid, 2))
end

function M.provalue(e,c)
	return M.repfilter(c, e:GetHandlerPlayer())
end

function M.proop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_EFFECT)
end