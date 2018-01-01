--水边的幻想 濑笈叶
local M = c999013
local Mid = 999013
function M.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Nef.AddLinkProcedureWithDesc(c, aux.FilterBoolFunction(Card.IsRace, RACE_PLANT), 2, 2, nil, aux.Stringid(Mid, 2))

	--link summon custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1, Mid*10+1)
	e1:SetCondition(M.lkcon)
	e1:SetOperation(M.lkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)

	-- fusion
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, Mid*10+2)
	e2:SetCost(M.spcost)
	e2:SetTarget(M.sptg)
	e2:SetOperation(M.spop)
	c:RegisterEffect(e2)
end

function M.CheckMaterialSingle(c, fc, mc)
	local tp = fc:GetControler()
	if not c:IsCanBeFusionMaterial(fc) then return false end
	local t = fc.hana_mat
	if not t then return false end
	for i, f in pairs(t) do
		if f(c) then return true end
	end
	return false
end

function M.fmatcheck(c, fc)
	return c:IsAbleToGrave() and M.CheckMaterialSingle(c, fc)
end

function M.fmatcheck2(c, fc, mg)
	if not mg or mg:GetCount() == 0 then return false end
	return c:IsAbleToGrave() and M.CheckMaterialSingle(c, fc) 
		and mg:IsExists(M.gridcheck, 1, nil, fc, c)
end

function M.gridcheck(c, fc, c2)
	local tp = fc:GetControler()
	return Duel.GetLocationCountFromEx(tp, tp, Group.FromCards(c, c2), fc) > 0
end

function M.fusionfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PLANT) 
		and Duel.IsExistingMatchingCard(M.CheckMaterialSingle, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, 1, nil, c)
end

--[[
	fg:所有植物族融合怪兽
]] 
function M.matfilter1(c, fg)
	local g1 = Duel.GetMatchingGroup(M.fmatcheck, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, nil, c)
	return fg:IsExists(M.matfilter2, 1, c, g1, c:GetCode())
end

--[[
	g1:		第1只融合怪兽的所有可用素材组
	code：	第1只融合怪兽的卡密
]] 
function M.matfilter2(c, g1, code)
	if c:IsCode(code) then return false end
	local g2 = Duel.GetMatchingGroup(M.fmatcheck2, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, nil, c, g1)
	if g2:GetCount() == 0 then return false end
	g2:Merge(g1)
	return g2:GetCount() > 1
end

function M.samefilter(c, g)
	return g:IsContains(c)
end

function M.lkcon(e,c)
	if c == nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp = c:GetControler()
	local mg = Duel.GetMatchingGroup(M.fusionfilter, tp, LOCATION_EXTRA, 0, nil)
	return mg:IsExists(M.matfilter1, 1, nil, mg)
end

function M.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg = Duel.GetMatchingGroup(M.fusionfilter, tp, LOCATION_EXTRA, 0, nil)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)

	local fc1 = mg:FilterSelect(tp, M.matfilter1, 1, 1, nil, mg):GetFirst()
	local matg1 = Duel.GetMatchingGroup(M.fmatcheck, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, nil, fc1)

	local fc2 = mg:FilterSelect(tp, M.matfilter2, 1, 1, fc1, matg1, fc1:GetCode()):GetFirst()
	local matg2 = Duel.GetMatchingGroup(M.fmatcheck2, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, nil, fc2, matg1)

	Duel.ConfirmCards(1-tp, Group.FromCards(fc1, fc2))
	--

	-- 排除原先matg1中的不可用素材
	matg1 = Duel.GetMatchingGroup(M.fmatcheck2, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, nil, fc1, matg2)

	-- 对两组素材中共有的卡进行处理
	local same = matg1:Filter(M.samefilter, nil, matg2)
	if same:GetCount() == 1 then
		same = same:GetFirst()
		if matg2:GetCount() == 1 then
			matg1:RemoveCard(same)
		elseif matg1:GetCount() == 1 then
			matg2:RemoveCard(same)
		end
	end

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_LMATERIAL)
	local dis1 = matg1:Select(tp, 1, 1, nil)
	local dis2 = matg2:FilterSelect(tp, M.fmatcheck2, 1, 1, dis1:GetFirst(), fc2, dis1)
	--
	dis1:Merge(dis2)
	c:SetMaterial(dis1)
	Duel.SendtoGrave(dis1, REASON_MATERIAL+REASON_LINK)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	c:RegisterEffect(e1, true)
end

--
function M.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost, tp, LOCATION_HAND, 0, 1, nil) end
	Duel.DiscardHand(tp, Card.IsAbleToGraveAsCost, 1, 1, REASON_COST)
end

function M.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false) and c:CheckFusionMaterial(m, nil, chkf)
end

function M.spfilter2(c, e, tp, m, f, chkf, this_card)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PLANT) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false) and c:CheckFusionMaterial(m, this_card, chkf)
end

function M.mfilter1(c, e)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)
		and c:IsAbleToDeck() and not c:IsImmuneToEffect(e) and c:IsCanBeFusionMaterial()
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then
		local chkf = nil
		local mg = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD, 0, nil, TYPE_MONSTER)
		local mg1 = mg:Filter(M.mfilter1, nil, e)

		local res = Duel.IsExistingMatchingCard(M.spfilter1, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg1, nil, chkf)
		if res then return true end

		local c = e:GetHandler()
		local mg2 = Duel.GetMatchingGroup(M.mfilter1, tp, 0, LOCATION_GRAVE+LOCATION_ONFIELD, nil, e)
		mg2:AddCard(c)
		res = Duel.IsExistingMatchingCard(M.spfilter2, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg2, nil, chkf, c)

		if not res then
			local ce = Duel.GetChainMaterial(tp)
			if ce ~= nil then
				local fgroup = ce:GetTarget()
				local mg3 = fgroup(ce, e, tp)
				local mf = ce:GetValue()
				res = Duel.IsExistingMatchingCard(M.spfilter1, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg3, mf, chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf = nil
	local mg = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD, 0, nil, TYPE_MONSTER)
	local mg1 = mg:Filter(M.mfilter1, nil, e)
	local sg1 = Duel.GetMatchingGroup(M.spfilter1, tp, LOCATION_EXTRA, 0, nil, e, tp, mg1, nil, chkf)
	--
	local c = e:GetHandler()
	local mg2 = Duel.GetMatchingGroup(M.mfilter1, tp, 0, LOCATION_GRAVE+LOCATION_ONFIELD, nil, e)
	mg2:AddCard(c)
	local sg2 = Duel.GetMatchingGroup(M.spfilter2, tp, LOCATION_EXTRA, 0, nil, e, tp, mg2, nil, chkf, c)
	--
	sg1:Merge(sg2)
	--
	local mg3 = nil
	local sg3 = nil
	local ce = Duel.GetChainMaterial(tp)
	if ce ~= nil then
		local fgroup = ce:GetTarget()
		mg3 = fgroup(ce,e,tp)
		local mf = ce:GetValue()
		sg3 = Duel.GetMatchingGroup(M.spfilter1, tp, LOCATION_EXTRA, 0, nil, e, tp, mg3, mf, chkf)
	end

	if sg1:GetCount() > 0 or (sg3 ~= nil and sg3:GetCount() > 0) then
		local sg = sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local tg = sg:Select(tp, 1, 1, nil)
		local tc = tg:GetFirst()
		if sg1:IsContains(tc) and (sg3 == nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp, ce:GetDescription())) then
			if tc:IsRace(RACE_PLANT) and sg2:IsContains(tc) and Duel.SelectYesNo(tp, aux.Stringid(Mid, 3)) then
				local mat1 = Duel.SelectFusionMaterial(tp, tc, mg2, c, chkf)
				tc:SetMaterial(mat1)
				Duel.ConfirmCards(1-tp, mat1)
				Duel.SendtoDeck(mat1, nil, 2, REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			else
				local mat2 = Duel.SelectFusionMaterial(tp, tc, mg1, nil, chkf)
				tc:SetMaterial(mat2)
				Duel.ConfirmCards(1-tp, mat2)
				Duel.SendtoDeck(mat2, nil, 2, REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
		else
			local mat = Duel.SelectFusionMaterial(tp, tc, mg3, nil, chkf)
			local fop = ce:GetOperation()
			fop(ce, e, tp, tc, mat)
		end
		tc:CompleteProcedure()
	end
end