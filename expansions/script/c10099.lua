--命运的相遇✿灵梦&魔理沙
function c10099.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c10099.con1)
	e1:SetOperation(c10099.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10099,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c10099.tg2)
	e2:SetOperation(c10099.op2)
	c:RegisterEffect(e2)
--
end
--
function c10099.cfilter1(c,tp)
	return (c:IsFaceup() and c:IsSetCard(0x100) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10099.cfilter1_1,tp,LOCATION_MZONE,0,1,c))
		or (c:IsFaceup() and c:IsSetCard(0x200) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10099.cfilter1_2,tp,LOCATION_MZONE,0,1,c))
end
function c10099.cfilter1_1(c)
	return c:IsFaceup() and c:IsSetCard(0x200) and c:IsAbleToRemoveAsCost()
end
function c10099.cfilter1_2(c)
	return c:IsFaceup() and c:IsSetCard(0x100) and c:IsAbleToRemoveAsCost()
end
function c10099.cfilter1_3(c)
	return c:IsFaceup() and (c:IsSetCard(0x100) or c:IsSetCard(0x200)) and c:IsAbleToRemoveAsCost()
end
function c10099.mzfilter(c)
	return c:GetSequence()<5
end
function c10099.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=Duel.GetMatchingGroup(c10099.cfilter1,tp,LOCATION_MZONE,0,nil,tp)
	return ft>-2 and mg:GetCount()>0 and (ft>0 or mg:IsExists(c10099.mzfilter,1,nil))
end
--
function c10099.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c10099.cfilter1,tp,LOCATION_MZONE,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=mg:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		if tc:IsSetCard(0x100) and not tc:IsSetCard(0x200) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,c10099.cfilter1_1,tp,LOCATION_MZONE,0,1,1,nil)
			g:Merge(sg)
		end
		if tc:IsSetCard(0x200) and not tc:IsSetCard(0x100) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,c10099.cfilter1_2,tp,LOCATION_MZONE,0,1,1,nil)
			g:Merge(sg)
		end
		if tc:IsSetCard(0x200) and tc:IsSetCard(0x100) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,c10099.cfilter1_3,tp,LOCATION_MZONE,0,1,1,nil)
			g:Merge(sg)
		end
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=mg:FilterSelect(tp,c10099.mzfilter,1,1,nil)
		if tc:IsSetCard(0x100) and not tc:IsSetCard(0x200) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,c10099.cfilter1_1,tp,LOCATION_MZONE,0,1,1,nil)
			g:Merge(sg)
		end
		if tc:IsSetCard(0x200) and not tc:IsSetCard(0x100) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,c10099.cfilter1_2,tp,LOCATION_MZONE,0,1,1,nil)
			g:Merge(sg)
		end
		if tc:IsSetCard(0x200) and tc:IsSetCard(0x100) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,c10099.cfilter1_3,tp,LOCATION_MZONE,0,1,1,nil)
			g:Merge(sg)
		end
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1_4=Effect.CreateEffect(c)
	e1_4:SetType(EFFECT_TYPE_SINGLE)
	e1_4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_4:SetRange(LOCATION_MZONE)
	e1_4:SetReset(RESET_EVENT+0xff0000)
	e1_4:SetCode(EFFECT_SET_BASE_ATTACK)
	e1_4:SetValue(2000)
	c:RegisterEffect(e1_4)
	local e1_5=Effect.CreateEffect(c)
	e1_5:SetType(EFFECT_TYPE_SINGLE)
	e1_5:SetCode(EFFECT_UPDATE_ATTACK)
	e1_5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_5:SetRange(LOCATION_MZONE)
	e1_5:SetValue(c10099.val1_5)
	c:RegisterEffect(e1_5)
	local e1_6=Effect.CreateEffect(c)
	e1_6:SetType(EFFECT_TYPE_SINGLE)
	e1_6:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e1_6:SetValue(LOCATION_HAND)
	c:RegisterEffect(e1_6)
end
--
function c10099.val1_5(e,c)
	return (Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)+Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_HAND))*200
end
--
function c10099.tfilter2(c)
	return c:IsAbleToHand() and not c:IsCode(10099)
end
function c10099.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10099.tfilter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10099.tfilter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
--
function c10099.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=g:GetCount()
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		local opc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		local gnc=ct-opc
		if gnc>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

