--妖精☆的恶作剧
local M = c999517
local Mid = 999517
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, Mid*10+1)
	e1:SetCost(M.tgCost)
	e1:SetTarget(M.tgTarget)
	e1:SetOperation(M.tgOp)
	c:RegisterEffect(e1)

	-- to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1, Mid*10+2)
	e2:SetCondition(M.esCon)
	e2:SetTarget(M.esTg)
	e2:SetOperation(M.esOp)
	c:RegisterEffect(e2)
end

--
function M.tgCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(M.tgCostFilter, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler()) end
	local g = Duel.SelectMatchingCard(tp, M.tgCostFilter, tp, LOCATION_ONFIELD, 0, 1, 1, e:GetHandler())
	Duel.SendtoHand(g, tp, REASON_COST)
end
function M.tgCostFilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost()
end

function M.tgTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		return Duel.GetCurrentChain() > 0 
			and Duel.IsExistingTarget(M.tgTargetFilter, tp, 0, LOCATION_ONFIELD, 1, nil)
	end

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, M.tgTargetFilter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end
function M.tgTargetFilter(c)
	return c:IsStatus(STATUS_CHAINING) and c:IsDestructable()
end

function M.tgOp(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end

--
function M.esCon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) or e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end

function M.esTg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk == 0 then return Duel.IsPlayerCanSummon(tp) end
end

function M.esOp(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND, 0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(M.esOpFilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1, tp)
end
function M.esOpFilter(e, c)
	return c:GetDefense() == 900
end