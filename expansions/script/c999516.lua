--妖精☆的呼朋引伴
local M = c999516
local Mid = 999516
function M.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, Mid)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then
		local g = Duel.GetMatchingGroup(M.thfilter, tp, LOCATION_DECK, 0, nil)
		return g:GetClassCount(Card.GetCode) > 2
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 2, tp, nil)
end
function M.thfilter(c)
	return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(M.thfilter, tp, LOCATION_DECK, 0, nil)
	if g:GetClassCount(Card.GetCode) < 3 then return end
	
	local sg = Group.CreateGroup()
	for i = 1, 3 do
		local tc = g:RandomSelect(tp, 1):GetFirst()
		g:Remove(Card.IsCode, nil, tc:GetCode())
		sg:AddCard(tc)
	end
	Duel.SendtoHand(sg, tp, REASON_EFFECT)
	Duel.ConfirmCards(1-tp, sg)

	Duel.BreakEffect()

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local tg = Duel.SelectMatchingCard(tp, M.tgfilter, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, 2, 2, e:GetHandler())
	Duel.SendtoGrave(tg, REASON_EFFECT)

	local e3 = Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetTargetRange(LOCATION_MZONE, 0)
	e3:SetTarget(M.limitTg)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3, tp)
end

function M.tgfilter(c)
	return c:IsSetCard(0x999) and not c:IsCode(Mid)
end

function M.limitTg(e, c)
	if not c then return false end
	local loc = c:GetPreviousLocation()
	return loc == LOCATION_EXTRA or loc == LOCATION_GRAVE
end
