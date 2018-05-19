--宝具『梦符·彩』
function c10260.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,31051)
	e1:SetTarget(c10260.tg1)
	e1:SetOperation(c10260.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
-- 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10260,0))
	e3:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10260.tg3)
	e3:SetOperation(c10260.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10260,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c10260.tg4)
	e4:SetOperation(c10260.op4)
	c:RegisterEffect(e4)
--
end
function c10260.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
--
function c10260.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if not tc:IsFaceup() then return end
	Duel.Equip(tp,c,tc)
end
--
function c10260.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if chk==0 then return tc and tc:GetLevel()>0 end
end
--
function c10260.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if tc then
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1:SetCode(EFFECT_UPDATE_LEVEL)
		e3_1:SetValue(1)
		e3_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_1)
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2:SetCode(EFFECT_UPDATE_DEFENSE)
		e3_2:SetValue(100)
		e3_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_2)
	end
end
--
function c10260.tfilter4_1(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x1013) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c10260.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if chk==0 then
		if Duel.GetLocationCountFromEx(tp,tp,tc)<1 then return false end
		if not c:IsCanBeFusionMaterial() then return false end
		if not c:IsAbleToGrave() then return false end
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsSetCard,nil,0x100)
		if not tc then return false end
		if not mg:IsContains(tc) then return false end
		local mg1=Group.CreateGroup()
		mg1:AddCard(tc)
		local res=Duel.IsExistingMatchingCard(c10260.tfilter4_1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--
function c10260.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=c:GetEquipTarget()
	if Duel.GetLocationCountFromEx(tp,tp,sc)<1 then return end
	if not c:IsAbleToGrave() then return end
	if not c:IsCanBeFusionMaterial() then return end
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsSetCard,nil,0x100)
	if not sc then return end
	if not mg:IsContains(sc) then return end
	local mg1=Group.CreateGroup()
	mg1:AddCard(sc)
	local sg1=Duel.GetMatchingGroup(c10260.tfilter4_1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local sg2=nil
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if not sg1:IsContains(tc) then return end
		if (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Group.CreateGroup()
			mat1:AddCard(c)
			mat1:AddCard(sc)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		end
		tc:CompleteProcedure()
		local ug=Duel.GetMatchingGroup(aux.TRUE,tp,0x33,0x33,nil):RandomSelect(tp,3,true)
		if ug:RandomSelect(tp,1,true):IsContains(ug:GetFirst()) then
			Duel.Hint(11,0,aux.Stringid(10260,4))
		end
	end
end
--