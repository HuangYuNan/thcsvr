--✿少女秘封俱乐部✿
function c28050.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c28050.cost1)
	e1:SetTarget(c28050.tg1)
	e1:SetOperation(c28050.op1)
	c:RegisterEffect(e1)
--
end
--
function c28050.cfilter1_1(c)
	return c:IsSetCard(0xc211) and Duel.CheckReleaseGroup(tp,c28050.cfilter1_2,1,c)
end
function c28050.cfilter1_2(c)
	return c:IsSetCard(0xa211)
end
function c28050.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c28050.cfilter1_1,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectReleaseGroup(tp,c28050.cfilter1_1,1,1,nil)
	local tc=g1:GetFirst()
	local g2=Duel.SelectReleaseGroup(tp,c28050.cfilter1_2,1,1,tc)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
--
function c28050.tfilter1(c)
	return c:IsAbleToRemove()
end
function c28050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.IsExistingMatchingCard(c28050.tfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c28050.tfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
--
function c28050.ofilter1(c)
	return c:IsLocation(LOCATION_REMOVED)
end
function c28050.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
		local g=Duel.GetMatchingGroup(c28050.tfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,c)
		if g:GetCount()<=0 then return end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		local fid=c:GetFieldID()
		local tc=g:GetFirst()
		while tc do
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetDescription(aux.Stringid(28050,1))
			e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1_1:SetCode(EVENT_PHASE+PHASE_END)
			e1_1:SetCountLimit(1)
			e1_1:SetLabel(fid)
			e1_1:SetLabelObject(tc)
			e1_1:SetCondition(c28050.con1_1)
			e1_1:SetOperation(c28050.op1_1)
			e1_1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1_1,tp)
			tc:RegisterFlagEffect(28050,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
			tc=g:GetNext()
		end
		local num=g:FilterCount(c28050.ofilter1,nil)
		if num<=0 then return end
		if c:IsFaceup() then
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_UPDATE_ATTACK)
			e1_2:SetReset(RESET_EVENT+0x1fe0000)
			e1_2:SetValue(num*100)
			c:RegisterEffect(e1_2)
		end
	end
end
--
function c28050.con1_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(28050)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c28050.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
--

